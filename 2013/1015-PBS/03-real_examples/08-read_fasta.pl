#!/usr/bin/env perl
use strict;
use warnings;
use POSIX;
use Bio::Seq;
use Bio::SearchIO::fasta;
use Bio::SeqIO;
use autodie;

my %sequences = ();
Make_Seq();
sub Make_Seq {
    my $assembly = new Bio::SeqIO(-format => 'fasta', -file => $ARGV[1]);
    while (my $query_seq = $assembly->next_seq()) {
	my $id = $query_seq->id;
	my $desc = $query_seq->desc;
	my $sequence = $query_seq->seq;
	$sequences{$id} = $sequence;
    }
}


#my $searchio = new Bio::SearchIO(-format => 'fasta', -file => 'compare_trinity_to_clbrener.out', -best => 1,);
my $searchio = new Bio::SearchIO(-format => 'fasta', -file => $ARGV[0], -best => 1,);
print "QUERYNAME\tChromosome\tStart\tEnd\t%ID\tScore\tSig\tCompLength\tHit_Ident\n";

my %handles = ();
my @pcts = (50,55,60,65,70,75,80,85,90,95,100);
for my $pct (@pcts) {
    my $filename = "${pct}_hits.txt";
    open(my $tmp, ">$filename");
    my $handle = $tmp;
    $handles{$pct} = $handle;
}


my @histogram = ();
foreach my $c (0 .. 100) {
    $histogram[$c] = 0;
}
RESULT: while(my $result = $searchio->next_result()) {
    my $hit_count = 0;
    while(my $hit = $result->next_hit) {
	$hit_count++;
	my $query_name = $result->query_name();
	my $query_length = $result->query_length();
	my $accession = $hit->accession();
	my $acc2 = $hit->name();
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

	    ## The following 6 lines define the histogram of how many components are x% identical to the genome.
	    my $hsp_hist = floor($hsp_identical);
	    if (defined($histogram[$hsp_hist])) {
		$histogram[$hsp_hist] = $histogram[$hsp_hist] + 1;
	    } else {
		$histogram[$hsp_hist] = 1;
	    }
		
#	    $hsp_cons = $hsp->frac_cons('total');
	    last HSP;  ## The 'HSP: ' is a label given to a logical loop
	    ## If you then say next HSP; it will immediately stop processing the loop and move to the next iteration of the loop
	    ## If instead you say last HSP; it will immediately break out of the loop.  
	}
	
	## This prints %identity with respect to the overlap of the component
	## Then the score of the hit, its Evalue, and the component length.
	print STDOUT "${query_name}\t${acc2}\t${start}\t${end}\t${ident}\t${score}\t${sig}\t${query_length}\t${hsp_identical}\t\n";
	PCT: for my $pct (@pcts) {
	    if ($hsp_identical <= $pct) {
		select $handles{$pct};
		print ">$query_name matches $acc2 at $start $end with ${ident}% identity
$sequences{$query_name}
";
		next RESULT;
	    }
	}
    } ## End each hit for a single result
#    print "$result had $hit_count hits\n";

} ## Finish looking at each sequence

open(HIST, ">hist.txt");
foreach my $c (0 .. $#histogram) {
    print HIST "$c $histogram[$c]\n";
}
close(HIST);
