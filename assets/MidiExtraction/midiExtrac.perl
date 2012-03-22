#!/usr/bin/perl

open (MYFILE, 'topGear.txt');

$printTo = 0;

while (<MYFILE>) {

  $temp = $_;

  if ($temp =~ /TR\s+(\d+)/) {
    print f0 $temp;
    $printTo = $1;
  
    $tempo = ">>track" . $printTo . "_tempo.txt";
    $notes = ">>track" . $printTo . "_notes.txt";

    open (FILE1, $tempo);
    open (FILE2, $notes);

    if ($temp =~ /CR\s+(\S+).*\s+NT\s*(\S+)/) {
      $bar = int($1);

      $qn = eval($1);
 
      $note = $2; 

      #Print to Files
      print FILE1 $qn."\n";
      print FILE2 $note."\n";
    }

    close(FILE1);
    close(FILE2);

  }
}

