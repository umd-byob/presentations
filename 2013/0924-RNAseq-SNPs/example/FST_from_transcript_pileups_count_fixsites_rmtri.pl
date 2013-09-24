#!/usr/bin/perl

unless (@ARGV) {
	print "<infile1> <infile2> <min. coverage(int)> <# chromosomes in pop 1> <# chromosomes in pop 2> <out.raw.txt (opt)> > <out.summary.txt>\n";
	exit;
}

open IN, $ARGV[0];
open IN2, $ARGV[1];

my $mincov = $ARGV[2];
my $n1 = $ARGV[3];
my $n2 = $ARGV[4];
my $nt = $n1 + $n2;
open OUT, ">$ARGV[5]"; 

print "@ARGV\n";
#exit;
#get first line of data
$line = <IN>;
chomp $line;
@lineA = split "\t", $line;

$currname = $lineA[0];
$name = $currname;
$pos = $lineA[1];
$seq1q = $lineA[4];
$qual1 = $lineA[5];

$line2 = <IN2>;
chomp $line2;
@lineA2 = split "\t", $line2;

$name2 = $lineA2[0];
$pos2 = $lineA2[1];
$seq2q = $lineA2[4];
$qual2 = $lineA2[5];

$seq1q =~ s/[^ATCGatcg]//gi;
$seq2q =~ s/[^ATCGatcg]//gi;

%hash = ();
%hash2 = ();

print OUT "namef\tposf\tseq1\tseq2\tptseq\tpit\tpiw\tfst\ttype\n";
print "name\tcnt\ttotcnt\tmean\tmedian\tstdev\tfixdiffs\tfixdiffs2\tpoly1\tpoly2\tboth\n";

until (eof IN) {
	# read in from the first file, the first transcript from start to finish
	while ($name eq $currname) {
		#remove extraneous info
		$seq1q =~ s/[^ATCGatcg]//gi;
		$covg = length $seq1q;
		
		$hash{$pos} = $name . "\t" . $pos  . "\t" . $covg . "\t" . $seq1q;
		
		++$count;
		$covgsum += $covg;

		
		#read in next line;
		$lastpos = $pos;
		$line = <IN>;
		chomp $line;
		@lineA = split "\t", $line;
		$name = $lineA[0];
		$pos = $lineA[1];
		$seq1q = $lineA[4];
		$qual = $lineA[5];
	}
	# read in the first transcript data from the second file
	while ($name2 eq $currname) {
		#remove extraneous info
		
		$seq2q =~ s/[^ATCGatcg]//gi;
		#remove low quality bases
	
#		$seq2q = &QUAL($seq2,$qual2,0); 
		$covg2 = length $seq2q;

		$hash2{$pos2} = $name2 . "\t" . $pos2  . "\t" . $covg2 . "\t" . $seq2q;
		++$count;
		$covgsum += $covg;
		
		#read in next line;
		$line2 = <IN2>;
		chomp $line2;
	#	print $line2 . "\t";
		@lineA2 = split "\t", $line2;

		$name2 = $lineA2[0];
		$pos2 = $lineA2[1];
		$seq2q = $lineA2[4];
		$qual2 = $lineA2[5];
	}
	# sort the stored data by key
	@sort = sort {$a <=> $b} keys %hash;
	
	my $cnt = 0;
	my $totcnt = 0;
	my @fstA = ();
	my $fixdiffs = 0;
	my $fixdiffs2 = 0;
	my $poly1 = 0; 
	my $poly2 = 0;
	my $both = 0;

	# read in each position in the transcript in order (first to last)  
	foreach $key (@sort) {
	#print $key . "!\n";
	
		# process the position only if it also exists in the second file
		if (exists $hash2{$key}) {
			@array1 = split /\t/, $hash{$key};
			@array2 = split /\t/, $hash2{$key};
			my $fst = "hmm";
			$namef = $array1[0];
			$posf = $array1[1];
			my $covg1 = $array1[2];
			my $covg2 = $array2[2];
			my $seq1 = $array1[3];
			my $seq2 = $array2[3];
			
			# create a single string which has the sequence from both populations
			$ptseq = $seq1 . $seq2;
			
			# count the total nubmer of each base in this string
			$totbases[0] = () = $ptseq =~ /A/ig;	
			$totbases[1] = () = $ptseq =~ /T/ig;
			$totbases[2] = () = $ptseq =~ /C/ig;
			$totbases[3] = () = $ptseq =~ /G/ig;
			@totsorted = sort {$b <=> $a} @totbases;
			
			#determine the major and minor allele (first and second most cmmon)
			$ptmaj = $totsorted[0];
			$ptmin = $totsorted[1];

			if ($totsorted[2] == 1) {
				#Look for cases where the minor allele is > 1 but the triallele (3rd most common base) is 1
				# later, if triallele is > 1, the position will not be used.  
				# identify which basepair is the triallele
				if ($totsorted[1] == 1) {
					#no need to replace triallele, as this will be called a singleton/novar anyway.
					$sing = "SING";
					#print "SINGLETON!\n";
				} else { # determine the identity of the singleton triallele
					if ($totbases[0] == 1) {
						$repbase = "A";
					} elsif ($totbases[1] == 1) {
						$repbase = "T";
					} elsif ($totbases[2] == 1) {
						$repbase = "C";
					} elsif ($totbases[3] == 1) {
						$repbase = "G";
					}
					#remove the triallele from all 3 seqs, then proceed
					$seq1 =~ s/$repbase//gi;
					$seq2 =~ s/$repbase//gi;
					$ptseq =~ s/$repbase//gi;	
					#print "AFTERS " . $seq1 . "\t" . $seq2 . "\t" . $ptseq . "\n";
				}
			}
			# filter site based on a number of criteria
			if ($covg1 < $mincov or $covg2 < $mincov) { # test if the coverage of either sample is too low, if so NA
				$pit = 0;
				$piw = 0;
				$fst = "NA";
				$type = "CVG";				
			} elsif ($ptmin == 0) { # test whether the site carries no variation (FST = 0)
				#print "no variation\n";
				$pit = 0;
				$piw = 0;
				$fst = 0;
				$type = "NV";				
				++$totcnt;
			} elsif ($ptmin == 1) { # test whether the site is a singleton, if so treat as a site with no variation (FST = 0)
				#print "singleton\n";
				$pit = 0;
				$piw = 0;
				$fst = 0;
				$type = "SING";				
				++$totcnt;
			} elsif ($totsorted[2] > 1) { # determine if there is a problematic triallele, if so NA
				$pit = 0;
				$piw = 0;
				$fst = "NA";
				print OUT $namef . "\t" . $key . "\t" . $seq1 . "\t" . $seq2 . "\t" . $ptseq  . "\t" . $pit  . "\t" . $piw  . "\t" . $fst . "\t" . $type . "\n";
				$type = "TRI";
			} else {
				# if position passes all the above filters, it is a variant site and we are ready to calculate FST!
				++$totcnt;
				$type = "VAR";
				# calculate the heterozygosity using the CALCHET subroutine for each group, and the total heterozygosity.  Also pass
				# to the subroutine "n" aka the pool size (number of individuals)
				
				$Hp1 = &CALCHET($seq1,$n1);
				$Hp2 = &CALCHET($seq2,$n2);
				$Htot = &CALCHET($ptseq,$nt);
				$pit = $Htot; 
				
				# use formula Kolazchowski et al 2011 to calculate pi within
				$piw = (((length $seq1) * $Hp1) + ((length $seq2) * $Hp2)) / (length $ptseq);
				
				# calculate FST
				if ($pit > 0) {
					$fst = ($pit - $piw) / $pit;
				} else {
					print "pit = 0??\n";
				}
				# if this was an example where we removed a 
				if ($totsorted[2] == 1) {
					$tris = "yes";
				} else {
					$tris = "no";
				}
				
				# FST should be one for all fixed differences
				if ($fst == 1) {
					++$fixdiffs;
					$type = "FIX";
				}
				
				# also, neither of the two populations should have heterozygosity if this is a variant site that is fixed.
				if ($Hp1 == 0 and $Hp2 == 0) {
					++$fixdiffs2;
					$type = "FIX";
					print OUT $namef . "\t" . $key . "\t" . $seq1 . "\t" . $seq2 . "\t" . $ptseq  . "\t" . $Hp1 . "\t" . $Hp2 . "\t" . $pit  . "\t" . $piw  . "\t" . $fst . "\t" . $type . "\t" . $tris .  "\t" . $fixdiffs . "\t" . $fixdiffs2 . "\t" . $poly1 .  "\t" . $poly2 . "\t" . $both . "\n";
					#(thankfully, "fixdiffs2" and "fixdiffs" always end up being the same...)
				} elsif ($Hp1 > 0 and $Hp2 > 0) {
					$type = "BOTH";  # a "both" site has the minor allele in both populations
					print OUT $namef . "\t" . $key . "\t" . $seq1 . "\t" . $seq2 . "\t" . $ptseq  . "\t" . $Hp1 . "\t" . $Hp2 . "\t" . $pit  . "\t" . $piw  . "\t" . $fst . "\t" . $type . "\t" . $tris .  "\t" . $fixdiffs . "\t" . $fixdiffs2 . "\t" . $poly1 .  "\t" . $poly2 . "\t" . $both . "\n";
					++$both;
				} elsif ($Hp1 > 0) {
					$type = "POLY1"; # a "poly1" site has the minor allele in the first population only
					print OUT $namef . "\t" . $key . "\t" . $seq1 . "\t" . $seq2 . "\t" . $ptseq  . "\t" . $Hp1 . "\t" . $Hp2 . "\t" . $pit  . "\t" . $piw  . "\t" . $fst . "\t" . $type . "\t" . $tris .  "\t" . $fixdiffs . "\t" . $fixdiffs2 . "\t" . $poly1 .  "\t" . $poly2 . "\t" . $both . "\n";
					++$poly1;

				} elsif ($Hp2 > 0) {
					$type = "POLY2"; # a "poly2" site has the minor allele in the second population only
					print OUT $namef . "\t" . $key . "\t" . $seq1 . "\t" . $seq2 . "\t" . $ptseq  . "\t" . $Hp1 . "\t" . $Hp2 . "\t" . $pit  . "\t" . $piw  . "\t" . $fst . "\t" . $type . "\t" . $tris .  "\t" . $fixdiffs . "\t" . $fixdiffs2 . "\t" . $poly1 .  "\t" . $poly2 . "\t" . $both . "\n";
					++$poly2;
				}
				
				if ($fst < 0) {
					$type = "NEG";  # the FST estimator sometimes gives a negative value for FST.  In this case, set to 0.  
					$fst = 0;
				}
				unless ($fst == 0 or $fst eq "NA") {
					$fstA[$cnt] = $fst;  # if FST > 0 add the FST value to be averaged across the transcript
					++$cnt;
				}
			}
		}
	}

	$currname = $name;
	%hash = ();
	%hash2 = ();
	my $mean = "NA";
	my $stdev = "NA";
	my $median = "NA";
	# calculate the mean FST for this sequence/transcript
	unless ((scalar @fstA) < 2) {
		$mean = &MEAN(\@fstA);
		$stdev = &STDEV($mean,\@fstA);
		$median = &MEDIAN(\@fstA);
	}
	# If there's only one varying site, then we can't calculate stdev 

	if ((scalar @fstA) == 1) {
		$mean = $fstA[0];
		$median = $fstA[0];
		$stdev = "NA";
	}
	# print out the summary stats for the transcript
	unless ($totcnt < 1) {
		print $namef . "\t" . $cnt . "\t" . $totcnt . "\t" . $mean . "\t" . $median . "\t" . $stdev . "\t" . $fixdiffs . "\t" . $fixdiffs2 . "\t" . $poly1 .  "\t" . $poly2 . "\t" . $both . "\n";
	}
}

$cnt = 0;

# this subroutine will remove bases based on their quality.  I didn't end up using it
sub QUAL {
	my $seq = shift;
	my $qual = shift;
	my $cutoff = shift;
	my @seqA = split "", $seq;
	my @qualA = split "", $qual;
	my $outseq = "";
	my $cnt = 0;
	foreach $base (@seqA) {
		if ((ord $qualA[$cnt]) >= (33 + $cutoff)) {
			$outseq .= $base;
		}
		$cnt++;
	}
	return $outseq;
}

# calculates heterozygosity by the method in Kolazchowski et al 2011
sub CALCHET {
	#formula:
	#H(P) = 2p(1-p)*[n/(n-1)]*[m/(m-1)]
	
	my $seq = shift;
	my $n = shift;
	my $m = length $seq;
	my @bases = ();
	my $p = 0;
	my $het = 0;
	$bases[0] = () = $seq =~ /A/ig;	
	$bases[1] = () = $seq =~ /T/ig;
	$bases[2] = () = $seq =~ /C/ig;
	$bases[3] = () = $seq =~ /G/ig;
	@sorted = sort {$b <=> $a} @bases;
#	print "@sorted <-sorted\n";
#	print $seq . "<- seq\n";
	if ($sorted[2] < 2) {
		$p = $sorted[1] /( $sorted[0] + $sorted[1] );
		$het = (2*$p * (1-$p)) * ($n / ($n-1)) * ($m / ($m-1));
	} else {
		$het = "triallele";
	}
	
	return $het;
}

# calcualtes means of a passed array
sub MEAN {
	my @list = @{shift @_};
	my $sum = 0;
	my $n = scalar @list;
	foreach my $num (@list) {
		$sum += $num;
	}
	my $mean = $sum / $n;
	return($mean);
}

# calcualtes stdev of a passed array
sub STDEV {
	my $mean = shift @_;
	my @list = @{shift @_};
	my $n = scalar @list;
	my $diffsum = 0;
	#print $n . "<n\n";
	foreach my $num (@list) {
		my $diffsq = ($mean - $num) * ($mean - $num);
		$diffsum += $diffsq;
	}
	$n--;
	my $s = sqrt($diffsum / $n);
	return $s;
}

# calcualtes median of a passed array
sub MEDIAN {
	my @list = @{shift @_};
	my @sort = sort {$a <=> $b} @list;
#	print "@sort\n";
	my $n = scalar @list;
	my $med = 0;
	my $mid = $n/2;
	my $less = 0;
	
	if ($n%2==1) {
#		print "odd\n";
		$less = sprintf ("%.0f", $mid);
		$med = $sort[$less];
	} else {
#		print "even\n";
		$med = ($sort[$n/2 - 1] + $sort[$n/2]) / 2;
	}
	return $med;
}
