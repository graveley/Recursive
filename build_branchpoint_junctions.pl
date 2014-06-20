#!/usr/bin/perl
#
# build_branchpoint_junctions.pl 
# graveley 8/25/13


#This program creates "splice junctions" that would be observed at the 5' splice site:lariat intron junctions. 

#[Exon 1]->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->A->->->->->->->[Exon 2]
#       |-----1-----|------2----|-----3-----|-----4-----|-----5-----|-----6-----|-----7-----|

#		|->->->->A->->->->->->->|->->->->->->->
#		|-----6-----|-----7-----||-----1------|

#Steps

#	1. Extract sequence from first 100 nt of intron and last 200 nt of intron
#
#	2. For each 100 nt window, take 1ast 100 nt of intron and fuse to first 100 nt of the intron. Then redo moving window 1 nt upstream for the downstream portion of the intron. 


use strict;
use FileHandle;

my $FILE = $ARGV[0]; #Junction Half Sequences
my $OUT = new FileHandle ">$FILE".".FASTA"; #Branchpoint junction sequences in fasta format

my $line; 
my $header;
my $intron;
my $first_half;
my $second_half;
my $interval_1;
my $interval_2;
my $new_header;

open(FASTA, "$FILE") or die("can't open $FILE"); #INPUT FILE: FASTA file containing introns to be processed

printf("Processing $FILE \n");

  while ($line = <FASTA>){        #read fasta header
        chomp($line);
        $header = $line;
        $line = <FASTA>;
        chomp($line);
        $intron = $line;
        $first_half = substr($intron,0,94);
        for(my $i = 0; $i < 100; $i++ ){
        $interval_1 = -94 - $i;
        $interval_2 = 94;
        $second_half = substr($intron,$interval_1,$interval_2);
        $new_header = "$header"."_$interval_1"."_$interval_2";      
        $OUT -> print("$new_header\n$second_half"."$first_half\n");
		}
}
