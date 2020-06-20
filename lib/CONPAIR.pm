package CONPAIR;
use strict;
use warnings;

	sub module {
		my ($path, $ref) = @_;
		my $header = `grep 'Tumor sample contamination level' $path`; chomp $header; #print "$header\n";

		if ( defined($header) ) { # CONPAIR module output format correct
			open (MD, "grep 'Tumor sample contamination level' $path |") || die "CONPAIR contamination module $path not correct:$!\n";
			while ( <MD> ) {
				chomp $_; my $line = $_; #
				if ( $line =~/Tumor[\s]+sample[\s]+contamination[\s]+level\:[\s]+([\d\.Ee]+)\%/ ) {
					my $conpair_con_value = $1 + 0; $conpair_con_value = $conpair_con_value/100;
					if ( defined($conpair_con_value) ) {
						$ref->{'CONTAMINATION'}{'CONPAIR'} = $conpair_con_value;
					} else {
						$ref->{'CONTAMINATION'}{'CONPAIR'} = "";
					}
				}
			}
			close MD;
		} else {
			print "CONPAIR Contamination output header does not match [$path], no info load from GATK\n";
		}
	}
1;
