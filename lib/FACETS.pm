package FACETS;
use strict;
use warnings;

	sub module {
		my ($path, $ref) = @_; #print "$path\n";
		my $purity = `grep -P 'Purity:' $path`; chomp $purity;	
		my $ploidy = `grep -P 'Ploidy:' $path`; chomp $ploidy;

		if ( defined($purity) ) { # FACETS module output format correct
			if ( defined($ploidy) ) { # FACETS module output format correct
				if ( $purity =~/Purity\:[\s]+([\w\.]+)/ ) {
					my $facets_purity = $1; 
					if ( $facets_purity =~/^[\.\d]+$/) { $facets_purity = sprintf("%.6f", $facets_purity); $facets_purity =~s/[0]+$//g; }
					$ref->{'PURITY'}{'FACETS'} = $facets_purity; 
				} else {
					$ref->{'PURITY'}{'FACETS'} = "";
				}

				if ( $ploidy =~/Ploidy\:[\s]+([\w\.]+)/ ) {
					$ref->{'PLOIDY'}{'FACETS'} = $1 + 0; #print "Ploidy: $1\n";
				} else {
					$ref->{'PLOIDY'}{'FACETS'} = "";
				}
			} else {
				if ( $purity =~/Purity\:[\s]+([\w\.]+)/ ) {
					my $facets_purity = $1;
					if ( $facets_purity =~/^[\.\d]+$/) { $facets_purity = sprintf("%.6f", $facets_purity); $facets_purity =~s/[0]+$//g; }
					$ref->{'PURITY'}{'FACETS'} = $facets_purity;
				} else {
					$ref->{'PURITY'}{'FACETS'} = "";
				}
				$ref->{'PLOIDY'}{'FACETS'} = "";
			}
		} else {
			if ( defined($ploidy) ) { # FACETS module output format correct
				if ( $ploidy =~/Ploidy\:[\s]+([\w\.]+)/ ) {
					$ref->{'PLOIDY'}{'FACETS'} = $1 + 0; #print "Ploidy: $1\n";
				} else {
					$ref->{'PLOIDY'}{'FACETS'} = "";
				}
				$ref->{'PURITY'}{'FACETS'} = "";
			} else {
				$ref->{'PURITY'}{'FACETS'} = "";
				$ref->{'PLOIDY'}{'FACETS'} = "";
			}
		}
	}
1;

