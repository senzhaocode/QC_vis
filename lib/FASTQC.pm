package FASTQC;
use strict;
use warnings;

	sub module {
		my ($path, $score_ref, $gc_ref) = @_; my $num; my $length;
		my $path_tmp = (split /\//, $path)[-1]; $path_tmp =~s/\.zip//g;
	
		my $i = 0; # initilize quality score value: 0..40
		while ( $i <= 40 ) { $score_ref->{$i} = 0; $i++; }
		$i = 0; # initilize GC content value: 0..100 
		while ( $i <= 100 ) { $gc_ref->{$i} = 0; $i++; }
			
		$/ = ">>"; # set read line sep
		open (FA, "unzip -c $path $path_tmp/fastqc_data.txt |") || die "Read $path, $path_tmp not correct:$!\n";
		while ( <FA> ) {
			chomp $_; my $line = $_;
			if ( $line =~/Total\sSequences\t([\d\.Ee]+)/ ) { # sub total read number
				$num = $1 + 0;
			}

			if ( $line =~/Sequence\slength\t([\d\.Ee]+)/ ) { # sub read length
				$length = $1 + 0;
			}

			if ( $line =~/Per\ssequence\squality\sscores/ ) { # sub module quality scores load
				while ( $line =~/([\d]+)\t([\d\.Ee]+)/gs ) {
					$score_ref->{$1} = $2; #print "score_ref: $1\t$2\n";
				}
			}

			if ( $line =~/Per\ssequence\sGC\scontent/ ) { # sub module GC content load
				while ( $line =~/([\d]+)\t([\d\.Ee]+)/gs ) {
					$gc_ref->{$1} = $2; #print "gc_ref: $1\t$2\n";
				}
			}
		}
		close FA;
		$/ = "\n"; #print "$num\t$length\n";
		return($num, $length);
	}

1;
