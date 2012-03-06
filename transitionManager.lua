-- Pausable timers and transitions with speed adjustment
-- Author: Lerg
-- Release date: 2011-08-05
-- Version: 1.1.2
-- License: MIT
-- Web: http://developer.anscamobile.com/code/pausable-timers-and-transitions-speed-adjustment
--
-- USAGE:
--  Import this module with a desired name, for example:
--      tnt = require('awesome_timers_and_transitions_manager_from_lerg')
--  Then you create timers and transitions with the same logic as before:
--      timer1 = tnt:newTimer(1000, function () print('tick') end, 1, 'Tick Timer', {data = 'User data'})
--      trans1 = tnt:newTransition(object, {time = 1000, x = 480}, 'Slide Transition', {data = 'User data'})
--  Name and userData arguments are optional. userData can be anything.
--  Every instance has pause(), resume() and cancel() methods.
--  You can manage all timers and transitions with function like tnt:pauseAllTimers(), tnt:resumeAllTransitions() etc.
--  For speed adjustment first pause all timers and transitions, then modify tnt.speed to say 0.5, which means 2 times faster
--  and lastly resume all paused instances.
--
-- LIMITATIONS:
--  Doesn't work with delta transitions. Easings will start over after each pausing, it can be fixed, but I don't need it at the moment,
--  so didn't implemented. Fix would be to set up custom easings and pass elapsed time to each easing function.
--
-- CONTRIBUTORS:
--  CluelessIdeas (www.cluelessideas.com), TMApps (www.timemachineapps.com/blog)
--
-- CHANGELIST:
-- 1.1.2:
--  [Bug] Transitions are wrongfully decided to be already ended.
--  [Feature] Added name and userData params for transtitions just like for timers.
--  [Feature] Added LuaDoc.
--  [Feature] Added default value for the count argument.
-- 1.1.1:
--  [Bug] Quick bugfix on remainingTime calculations.
-- 1.1:
--  [Bug] onComplete function is not getting called for transitions when pausing right before the event.
--  [Bug] Timers are not counting resting time from resuming till next pausing (before next tick).
--  [Feature] Added userData and name to actual timers instances, they are accessible through event callback function argument, like event.userData and event.name.
--  [Feature] Added cleanTimersAndTransitions() function which frees the memory on demand (you can call it every couple of seconds)
--
-- I can be found on the corona IRC channel.
 
-- Module table
local _M = {}
 
-- Game speed: 1 - normal, 0.5 - fast, 2 - slow
_M.speed = 1
 
-- Every instance is hold here
local allTimers = {}
local allTransitions = {}
 
-- Cache
local tInsert = table.insert
local tRemove = table.remove
 
-- Pausable timers
-- @param duration number Tick duration.
-- @param callback function Function to be called on the each tick.
-- @param count number How many times to tick, 0 - unlimited. Default is 1.
-- @param name string The name for the timer. Available in the callback. Optional.
-- @param userData table Any user data. Available in the callback. Optional.
function _M:newTimer (duration, callback, count, name, userData)
    -- Timer handler
    local tH = {}
    tH.speed = self.speed
    tH.start = system.getTimer()
    tH.duration = duration
    tH.callback = callback
    tH.count = count or 1
    tH.counter = 0
    tH.isInfinite = (count == 0)
    tH.name = name
    tH.shouldRemove = false
    tH.paused = false
    tH.intervalStartTime = tH.start
    tH.remainingTime = duration
 
    -- Internal function which fires up the actual callback function
    -- @param event Corona's timer event
    local function callbackWrapper (event)
        if tH.callback then
            event.userData = userData
            event.name = name
            tH.callback(event)
            if not tH.isInfinite then
                tH.counter = tH.counter + 1
                if tH.counter >= tH.count then
                    tH:cancel()
                end
            end
            tH.remainingTime = duration
            tH.intervalStartTime = system.getTimer()
        else
            tH:cancel()
        end
    end
 
    tH.t = timer.performWithDelay(duration * self.speed, callbackWrapper, tH.count)
 
    -- Cancels running timer and prepares for the resuming
    function tH:pause ()
        if self.t then
            timer.cancel(self.t)
        end
        if not self.paused then
            self.paused = true
            self.pausingTime = system.getTimer()
            self.remainingTime = self.remainingTime - (self.pausingTime - self.intervalStartTime)
            if self.remainingTime < 0 then
                self.remainingTime = 0
            end
        end
    end
 
    -- Initiates a fresh timer if paused
    function tH:resume ()
        if self.paused then
            self.paused = false
            if not self.isInfinite then
                -- Timer elapsed
                if self.counter >= self.count then
                    self:cancel()
                else
                    local function callbackDoubleWrapper (event)
                        callbackWrapper(event)
                        local ticksRemains = self.count - self.counter
                        if ticksRemains > 0 then
                            self.t = timer.performWithDelay(self.duration * _M.speed, callbackWrapper, ticksRemains)
                            self.speed = _M.speed
                        else
                            self:cancel()
                        end
                    end
                    self.intervalStartTime = system.getTimer()
                    self.t = timer.performWithDelay(self.remainingTime * _M.speed, callbackDoubleWrapper, 1)
                    self.speed = _M.speed
                end
            else
                local function callbackDoubleWrapper (event)
                    callbackWrapper(event)
                    self.t = timer.performWithDelay(self.duration * _M.speed, callbackWrapper, 0)
                end
                self.intervalStartTime = system.getTimer()
                self.t = timer.performWithDelay(self.remainingTime * _M.speed, callbackDoubleWrapper, 1)
                self.speed = _M.speed
            end
        end
    end
 
    -- Cancels actual timer instance and marks this handler to be removed
    function tH:cancel ()
        if self.t then
            timer.cancel(self.t)
        end
        self.shouldRemove = true
        self.callback = nil
    end
 
    tInsert(allTimers, tH)
    return tH
end
 
-- Pauses everything in the allTimers table
function _M:pauseAllTimers()
    local i
    local allTimersCount = #allTimers
    if allTimersCount > 0 then
        for i = allTimersCount, 1, -1 do
            local child = allTimers[i]
            if child.shouldRemove then
                tRemove(allTimers, i)
            else
                child:pause()
            end
        end
    end
end
 
-- Resumes everything in the allTimers table
function _M:resumeAllTimers()
    local i
    local allTimersCount = #allTimers
    if allTimersCount > 0 then
        for i = allTimersCount, 1, -1 do
            local child = allTimers[i]
            if child.shouldRemove then
                tRemove(allTimers, i)
            else
                child:resume()
            end
        end
    end
end
 
-- Cancels everything in the allTimers table
function _M:cancelAllTimers()
    local i
    local allTimersCount = #allTimers
    if allTimersCount > 0 then
        for i = allTimersCount, 1, -1 do
            local child = allTimers[i]
            child:cancel()
            tRemove(allTimers, i)
        end
    end
end
 
-- Pausable transitions
-- @param object table An object for which transition is applied.
-- @param params table Transition parameters.
-- @param name string The name for the transition. Available in the onComplete function. Optional.
-- @param userData table Any user data. Available in the onComplete function. Optional.
function _M:newTransition(object, params, name, userData)
    -- Transition handler
    local tH = {}
    local elapsed, elapsedCount, currentCountRemains
    tH.originalTime = params.time
    local onComplete = params.onComplete
 
    -- This function is called for each completed transition to mark it's handler for removal
    -- @param event Corona's transition event
    local function callbackWrapper (event)
        if onComplete then
            --event.userData = userData
            --event.name = name
            onComplete(event)
        end
        tH:cancel()
    end
 
    tH.params = {}
    -- Make a shallow copy of the user's params so they are not messed up in the user's space
    for k, v in pairs(params) do tH.params[k] = v end
    tH.params.onComplete = callbackWrapper
    tH.params.time = tH.originalTime * self.speed
    tH.t = transition.to(object, tH.params)
    tH.start = system.getTimer()
    tH.speed = self.speed
 
    --  Stops current transiton and prepares for the resuming
    function tH:pause()
        if self.t then
            self.elapsed = (system.getTimer() - self.start) / self.speed
            transition.cancel(self.t)
        else
            self:cancel()
        end
    end
    -- Initiates a fresh transition if paused
    function tH:resume()
        if self.elapsed and not self.shouldRemove then
            -- Current speed
            local s = _M.speed
            self.params.time = (self.originalTime - self.elapsed) * s
            self.t = transition.to(object, self.params)
            self.start = system.getTimer() - self.elapsed * s
            self.speed = s
            self.elapsed = nil
        end
    end
    -- Cancels actual transition instance and marks this handler to be removed
    function tH:cancel()
        if self.t then
            transition.cancel(self.t)
        end
        self.shouldRemove = true
    end
 
    tInsert(allTransitions, tH)
    return tH
end
 
-- Pauses everything in the allTransitions table
function _M:pauseAllTransitions()
    local i
    local allTransitionsCount = #allTransitions
    if allTransitionsCount > 0 then
        for i = allTransitionsCount, 1, -1 do
            local child = allTransitions[i]
            if child.shouldRemove then
                tRemove(allTransitions, i)
            else
                child:pause()
            end
        end
    end
end
 
-- Resumes everything in the allTransitions table
function _M:resumeAllTransitions()
    local i
    local allTransitionsCount = #allTransitions
    if allTransitionsCount > 0 then
        for i = allTransitionsCount, 1, -1 do
            local child = allTransitions[i]
            if child.shouldRemove then
                tRemove(allTransitions, i)
            else
                child:resume()
            end
        end
    end
end
 
-- Cancels everything in the allTransitions table
function _M:cancelAllTransitions()
    local i
    local allTransitionsCount = #allTransitions
    if allTransitionsCount > 0 then
        for i = allTransitionsCount, 1, -1 do
            local child = allTransitions[i]
            child:cancel()
            tRemove(allTransitions, i)
        end
    end
end
 
-- Deletes unused instances (frees memory)
function _M:cleanTimersAndTransitions()
    local i
    local allTimersCount = #allTimers
    if allTimersCount > 0 then
        for i = allTimersCount, 1, -1 do
            local child = allTimers[i]
            if child.shouldRemove then
                tRemove(allTimers, i)
            end
        end
    end
    local allTransitionsCount = #allTransitions
    if allTransitionsCount > 0 then
        for i = allTransitionsCount, 1, -1 do
            local child = allTransitions[i]
            if child.shouldRemove then
                tRemove(allTransitions, i)
            end
        end
    end
end
 
return _M