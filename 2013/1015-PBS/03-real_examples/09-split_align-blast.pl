#!/bin/env perl
use strict;
use warnings;
use autodie;
use Getopt::Long;
use Bio::SeqIO;
use POSIX;
use Pod::Usage;

my %conf = (
    number => 200,
    input => undef,
    lib => undef,
);

my %options = (
    'num|n:s' => \$conf{number},
    'input|i:s' => \$conf{input},
    'lib|l:s' => \$conf{lib},
    );
my $argv_result = GetOptions(%options);

pod2usage({-message => q{Mandatory argument '--input or -i' is missing, containing the input fasta},
	   -exitval => 1,
	   -verbose => 1,}
    ) unless $conf{input};
pod2usage({-message => q{Mandatory argument '--lib or -l' is missing, containing the fasta library},
	   -exitval => 1,
	   -verbose => 1,}
    ) unless $conf{lib};


## Number entries 23119
## Thus 116 entries in each fasta

##  To arrive at this number, I just rounded up (/ 23119 200)
## However, we can count the number of fasta entries in the input file
my $num_per_split = Get_Split();
print "Going to make $conf{num} directories with $num_per_split files each.\n";
Make_Directories($num_per_split);
Make_Align();

sub Get_Split {
    my $input = $conf{input};
    my $splits = $conf{number};
    my $in = new Bio::SeqIO(-file => $input,);
    my $seqs = 0;
    while (my $in_seq = $in->next_seq()) {
	$seqs++;
    }
    my $ret = ceil($seqs / $splits);
    return($ret);
}

sub Make_Directories {
    my $num_per_split = shift;
    my $splits = $conf{number};
    ## I am choosing to make directories starting at 1000
    ## This way I don't have to think about the difference from
    ## 99 to 100 (2 characters to 3) as long as no one splits more than 9000 ways...
    my $dir = 1000;

    for my $c ($dir .. ($dir + $splits)) {
	print "Making directory: split/$c\n";
	system("mkdir -p split/$c");
    }

    my $in = new Bio::SeqIO(-file => $conf{input},);
    my $count = 0;
    while (my $in_seq = $in->next_seq()) {
	my $id = $in_seq->id();
	my $seq = $in_seq->seq();
	open(OUT, ">>split/$dir/in.fasta");
	print OUT ">$id
$seq
";
	close(OUT);
	$count++;
	if ($count >= $num_per_split) {
	    $count = 0;
	    $dir++;
	    my $last = $dir;
	    $last--;
	    print "Wrote $num_per_split entries to $last\n";
	} ## End for each iteration of $num_per_split files
    } ## End while reading the fasta
}

sub Make_Align {
    my $array_end = 1000 + $conf{number};
    my $array_string = qq"1000-${array_end}";
    my $string = qq?
cat <<"EOF" | qsub -t ${array_string} -V -S /cbcb/lab/nelsayed/local/bin/bash -q throughput -l walltime=18:00:00,mem=8Gb -j eo -e ibissub00.umiacs.umd.edu:/cbcbhomes/abelew/outputs/pbs.out -m n
source /cbcb/lab/nelsayed/scripts/dotbashrc
CMD="blastall -e 1000 -p blastx -d nr \
-i $ENV{PWD}/split/\${PBS_ARRAYID}/in.fasta"
echo \$CMD
eval \$CMD
EOF
?;
    print "TESTME:
$string\n";

    open(CMD, "$string |");
    while(my $line = <CMD>) {
	chomp $line;
	print "$line\n";
    }
    close(CMD);
    print "Submission finished.\n";
}

