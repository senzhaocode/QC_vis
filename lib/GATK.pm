package GATK;
use strict;
use warnings;

	sub coverage {
		my ($path, $ref) = @_;
		my $header = `grep 'bases_above' $path`; chomp $header; #print "$header\n";

		if ( defined($header) ) { # GATK module output format correct
			open (MD, "grep -A 1 'bases_above' $path |") || die "GATK Coverage module $path not correct:$!\n";
			while ( <MD> ) {
				chomp $_; my $line = $_; next if ( $line =~/bases_above/ ); # remove header
				my ($coverage_mean, $coverage_median, $coverage_30x, $coverage_60x, $coverage_100x) = (split /\t/, $line)[2, 4, 11, 17, 25];
				if ( defined($coverage_mean) ) {
					$ref->{'COVERAGE'}{'MEAN'} = $coverage_mean;
				} else {
					$ref->{'COVERAGE'}{'MEAN'} = "";
				}
				if ( defined($coverage_median) ) {
					$ref->{'COVERAGE'}{'MEDIAN'} = $coverage_median;
				} else {
					$ref->{'COVERAGE'}{'MEDIAN'} = "";
				}
				if ( defined($coverage_30x) ) {
					$ref->{'COVERAGE'}{'30x'} = $coverage_30x/100;
				} else {
					$ref->{'COVERAGE'}{'30x'} = "";
				}
				if ( defined($coverage_60x) ) {
					$ref->{'COVERAGE'}{'60x'} = $coverage_60x/100;
				} else {
					$ref->{'COVERAGE'}{'60x'} = "";
				}
				if ( defined($coverage_100x) ) {
					$ref->{'COVERAGE'}{'100x'} = $coverage_100x/100;
				} else {
					$ref->{'COVERAGE'}{'100x'} = "";
				}
			}
			close MD;
		} else {
			print "GATK Coverage output header does not match [$path], no info load from GATK\n";
		}
	}

	sub contamination {
		my ($path, $ref) = @_;
		my $header = `grep 'contamination' $path`; chomp $header; #print "$header\n";

		if ( defined($header) ) { # GATK module output format correct
			open (MD, "grep -A 1 'contamination' $path |") || die "GATK contamination module $path not correct:$!\n";
			while ( <MD> ) {
				chomp $_; my $line = $_; next if ( $line =~/contamination/ ); # remove header
				my ($gatk_con_value, $gatk_con_error) = (split /\t/, $line)[1, 2];
				$gatk_con_value = sprintf("%.6f", $gatk_con_value);
				if ( defined($gatk_con_value) ) {
					$ref->{'CONTAMINATION'}{'GATK'} = $gatk_con_value; #print "CONTAMINATION-GATK: $gatk_con_value\n";
				} else {
					$ref->{'CONTAMINATION'}{'GATK'} = "";
				}
			}
			close MD;
		} else {
			print "GATK Contamination output header does not match [$path], no info load from GATK\n";
		}
	}
1;

