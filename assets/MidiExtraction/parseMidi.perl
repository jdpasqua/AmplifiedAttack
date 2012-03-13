#!/usr/bin/perl

open (MYFILE, 'topGearMidi.txt');

open (f0, '>>track1.txt');
open (f1, '>>track2.txt');
open (f2, '>>track3.txt');
open (f3, '>>track4.txt');
open (f4, '>>track5.txt');
open (f5, '>>track6.txt');
open (f6, '>>track7.txt');
open (f7, '>>track8.txt');
open (f8, '>>track9.txt');
open (f9, '>>track10.txt');
open (f10, '>>track11.txt');
open (f11, '>>track12.txt');

while (<MYFILE>) {

	$temp = $_;

	if ($temp =~ /TR\s+(\d+)/) {
		
		if ($1 == 0) {
			print f0 $temp;
		} elsif ($1 == 1) {
			print f1 $temp;
		} elsif ($1 == 2) {
                        print f2 $temp;
                } elsif ($1 == 3) {
                        print f3 $temp;
                } elsif ($1 == 4) {
                        print f4 $temp;
                } elsif ($1 == 5) {
                        print f5 $temp;
                } elsif ($1 == 6) {
                        print f6 $temp;
                } elsif ($1 == 7) {
                        print f7 $temp;
                } elsif ($1 == 8) {
                        print f8 $temp;
                } elsif ($1 == 9) {
                        print f9 $temp;
                } elsif ($1 == 10) {
                        print f10 $temp;
                } elsif ($1 == 11) {
                        print f11 $temp;
                }
	}


}


close (MYFILE);
close (f0);
close (f1);
close (f2);
close (f3);
close (f4);
close (f5);
close (f6);
close (f7);
close (f8);
close (f9);
close (f10);
close (f11);
