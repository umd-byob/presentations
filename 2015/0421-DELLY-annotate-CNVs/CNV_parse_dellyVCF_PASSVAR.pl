#!/usr/bin/perl

# filters through VCF files from Delly, looks for the cases where 1 sample has a variant
# call and the other 2 don't.   

# col 6 - pass filter
# col 9 - sample 1
# col 10 - sample 2
# col 11 - sample 3
# etc...

open IN, $ARGV[0];
open OUT, ">$ARGV[1]";

$header = <IN>;
$first = 0;
$second = 0;
$third = 0;
$firstandsecond = 0;
$firstandthird = 0;
$secondandthird = 0;

until (eof IN) {
	$line = <IN>;
	chomp $line;
	@lineA = split /\t/, $line;
	$passfail = $lineA[6];
	$sam1 = $lineA[9];
	$sam2 = $lineA[10];
	$sam3 = $lineA[11];
	if ($line =~ /^#/) {
		print OUT $line . "\n";
		next;
	}
	
	if ($sam1 =~ /^1\/1/) {
		if ($sam2 =~ /^0\/0/ and $sam3 =~ /^0\/0/) {
			if ($sam1 =~ /PASS/) {
				print OUT $line . "\tfirst" . "\n";
				++$first;
			}
		} elsif ($sam2 =~ /^0\/0/ and $sam3 =~ /^1\/1/) {
			if ($sam1 =~ /PASS/ and $sam3 =~ /PASS/) {
				print OUT $line . "\t1stand3rd" . "\n";
				++$firstandthird;
			}
		} elsif ($sam3 =~ /^0\/0/ and $sam2 =~ /^1\/1/) {
			if ($sam1 =~ /PASS/ and $sam2 =~ /PASS/) {
				print OUT $line . "\t1stand2nd" . "\n";
				++$firstandsecond;
			}
		}
	} elsif ($sam2 =~ /^1\/1/) {
		if ($sam3 =~ /^0\/0/ and $sam1 =~ /^0\/0/) {
			if ($sam2 =~ /PASS/) {
				print OUT $line . "\t2nd" . "\n";
				++$second;
			}
		} elsif ($sam1 =~ /^0\/0/ and $sam3 =~ /^1\/1/) {
			if ($sam2 =~ /PASS/ and $sam3 =~ /PASS/) {
				print OUT $line . "\t2ndand3rd" . "\n";
				++$secondandthird;
			}
		}
	} elsif ($sam3 =~ /^1\/1/) {
		if ($sam1 =~ /^0\/0/ and $sam2 =~ /^0\/0/) {
			if ($sam3 =~ /PASS/) {
				print OUT $line . "\t3rd" . "\n";
				++$third;
			}
		}
	}
}	
print "first\tsecond\tthird\tfirstandsecond\tfirstandthird\tsecondandthird\n";
print $first . "\t" . $second . "\t" . $third ."\t" . $firstandsecond . "\t" . $firstandthird . "\t" . $secondandthird . "\n";
