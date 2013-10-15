#!/usr/bin/env perl
use strict;
use warnings;
use POSIX;
use Bio::Seq;
use Bio::SearchIO::blast;
use Bio::SeqIO;
use autodie;

#my $searchio = new Bio::SearchIO(-format => 'fasta', -file => 'compare_trinity_to_clbrener.out', -best => 1,);
my $searchio = new Bio::SearchIO(-format => 'blast', -file => $ARGV[0], -best => 1,);
print "QUERYNAME\tChromosome\tStart\tEnd\t%ID\tScore\tSig\tCompLength\tHit_Ident\n";
RESULT: while(my $result = $searchio->next_result()) {
    my $hit_count = 0;
    while(my $hit = $result->next_hit) {
	$hit_count++;
	my $query_name = $result->query_name();
	my $query_length = $result->query_length();
	my $accession = $hit->accession();
	my $acc2 = $hit->name();
	my $acc3 = $hit->description();
	my $length = $hit->length();
	my $score = $hit->raw_score();
	my $sig = $hit->significance();
	my $ident = ($hit->frac_identical() * 100);
	my ($start, $end, $hsp_identical, $hsp_cons);

	HSP: while (my $hsp = $hit->next_hsp) {
	    $start = $hsp->start('subject');
	    ## Maybe want $hsp->start('subject');
	    $end = $hsp->end('subject');
	    $hsp_identical = $hsp->frac_identical('total');
	    $hsp_identical = sprintf("%.4f", $hsp_identical);
	    ## $fun = sprintf("%2d %", $something, $somethingelse);
	    $hsp_identical = $hsp_identical * 100;

#	    $hsp_cons = $hsp->frac_cons('total');
	    last HSP;  ## The 'HSP: ' is a label given to a logical loop
	    ## If you then say next HSP; it will immediately stop processing the loop and move to the next iteration of the loop
	    ## If instead you say last HSP; it will immediately break out of the loop.  
	}
	
	## This prints %identity with respect to the overlap of the component
	## Then the score of the hit, its Evalue, and the component length.
	print STDOUT "${query_name}\t${acc2}\t${acc3}\t${start}\t${end}\t${ident}\t${score}\t${sig}\t${query_length}\t${hsp_identical}\t\n";
	next RESULT;
    } ## End each hit for a single result
#    print "$result had $hit_count hits\n";

} ## Finish looking at each sequence
