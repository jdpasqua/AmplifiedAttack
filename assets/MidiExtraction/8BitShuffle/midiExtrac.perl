\#!/usr/bin/perl

open (MYFILE, '8BitShuffleMidi.txt');

$printTo = 0;

while (<MYFILE>) {

  $temp = $_;

  if ($temp =~ /TR\s+(\d+)/) {
    $printTo = $1;
  
    $tempo = ">>track" . $printTo . "_tempo.txt";
    $notes = ">>track" . $printTo . "_notes.txt";

    open (FILE1, $tempo);
    open (FILE2, $notes);

    if ($temp =~ /BA\s+(\d+)\s+CR\s+(\S+).*\s+NT\s*(\S+)/) {
      $bar = int($1);

      $qn = eval($2);
      $qn = $qn/4;
      $qn = $bar + $qn;

      $note = $3; 

      #Print to Files
      print FILE1 $qn."\n";
      print FILE2 $note."\n";
    }

    close(FILE1);
    close(FILE2);

  }
}

