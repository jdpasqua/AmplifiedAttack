display.setStatusBar( display.HiddenStatusBar )

--====================================================================--
-- PORTO ALEGRE
--====================================================================--

--[[

 - Version: 1.0
 - Made by Ricardo Rauber Pereira @ 2011
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - An app for my home town: Porto Alegre, Rio Grande do Sul - Brasil.

--]]

--====================================================================--
-- GLOBALS
--====================================================================--

_W = display.contentWidth
_H = display.contentHeight

--====================================================================--
-- IMPORTS
--====================================================================--

local director = require( "director" )

--====================================================================--
-- PAGES
--====================================================================--

------------------
-- PAGE LIST
------------------
-- page: name of the scene
-- params: parameters to send to the scene
------------------
		
pageList = {
	{ page = "pages", params = { image = "pordosol.jpg", 			name = "pordosol" } },
	{ page = "pages", params = { image = "lacador.jpg", 			name = "lacador" } },
	{ page = "pages", params = { image = "redencao.jpg", 			name = "redencao" } },
	{ page = "pages", params = { image = "mercado.jpg", 			name = "mercado" } },
	{ page = "pages", params = { image = "piratini.jpg", 			name = "piratini" } },
	{ page = "pages", params = { image = "centro_admin.jpg", 		name = "centro_admin" } },
	{ page = "pages", params = { image = "receita_federal.jpg", 	name = "receita_federal" } },
	{ page = "pages", params = { image = "ministerio_publico.jpg", 	name = "ministerio_publico" } },
	{ page = "pages", params = { image = "tribunal_regional.jpg", 	name = "tribunal_regional" } },
	{ page = "pages", params = { image = "sheraton.jpg", 			name = "sheraton" } },
	{ page = "pages", params = { image = "ibere.jpg", 				name = "ibere" } },
	{ page = "pages", params = { image = "business.jpg", 			name = "business" } },
}

--====================================================================--
-- BEGIN
--====================================================================--

------------------
-- Go to intro
------------------

director:changeScene ( "intro" )