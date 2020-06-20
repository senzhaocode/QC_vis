package PICARD;
use strict;
use warnings;

	 sub module {
		my ($path, $ref) = @_;
		my $header = `grep '## METRICS CLASS' $path`; chomp $header; #print "$header\n";

		if ( defined($header) ) { # PICARD module output format correct
			if ( $header =~/DuplicationMetric/ ) { # match MarkDuplicate module
				open (MD, "grep -A 2 '## METRICS CLASS' $path |") || die "MarkDuplicate module $path not correct:$!\n";
				while ( <MD> ) {
					chomp $_; my $line = $_; next if ( $line =~/UNPAIRED_READS_EXAMINED/ ); # remove header
					next if ( $line =~/METRICS[\s]+CLASS/ ); # remove tag
					my ($sample_id, $UNPAIRED_READS_EXAMINED, $READ_PAIRS_EXAMINED, $UNMAPPED_READS, $UNPAIRED_READ_DUPLICATES, $READ_PAIR_DUPLICATES, $READ_PAIR_OPTICAL_DUPLICATES, $PERCENT_DUPLICATION, $ESTIMATED_LIBRARY_SIZE) = (split /\t/, $line)[0, 1, 2, 3, 4, 5, 6, 7, 8];
					if ( defined($READ_PAIRS_EXAMINED) ) {
						$ref->{'MarkDuplicate'}{'READ_PAIRS_EXAMINED'} = $READ_PAIRS_EXAMINED;
					} else {
						$ref->{'MarkDuplicate'}{'READ_PAIRS_EXAMINED'} = "";
					}
					if ( defined($UNPAIRED_READS_EXAMINED) ) {
						$ref->{'MarkDuplicate'}{'UNPAIRED_READS_EXAMINED'} = $UNPAIRED_READS_EXAMINED;
					} else {
						$ref->{'MarkDuplicate'}{'UNPAIRED_READS_EXAMINED'} = "";
					}
					if ( defined($UNMAPPED_READS) ) {
						$ref->{'MarkDuplicate'}{'UNMAPPED_READS'} = $UNMAPPED_READS;
					} else {
						$ref->{'MarkDuplicate'}{'UNMAPPED_READS'} = "";
					}
					if ( defined($PERCENT_DUPLICATION) ) {
						$ref->{'MarkDuplicate'}{'PERCENT_DUPLICATION'} = $PERCENT_DUPLICATION;
					} else {
						$ref->{'MarkDuplicate'}{'PERCENT_DUPLICATION'} = "";
					}
				}
				close MD;
			} elsif ( $header =~/AlignmentSummaryMetric/ ) { # match AlignmentSummary module
				open (MD, "grep -A 4 '## METRICS CLASS' $path |") || die "AlignmentSummary module $path not correct:$!\n";
				while ( <MD> ) {
					chomp $_; my $line = $_;
					if ( $line =~/^PAIR\t/ ) {
						my ($TOTAL_READS, $PF_READS_ALIGNED, $PCT_PF_READS_ALIGNED, $PF_HQ_ALIGNED_READS, $PF_MISMATCH_RATE, $PF_INDEL_RATE, $STRAND_BALANCE, $PCT_CHIMERAS) = (split /\t/, $line)[1, 5, 6, 8, 12, 14, 19, 20];
						if ( defined($TOTAL_READS) ) {
							$ref->{'AlignmentSummaryMetrics'}{'TOTAL_READS'} = $TOTAL_READS;
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'TOTAL_READS'} = "";
						}
						if ( defined($PF_READS_ALIGNED) and defined($PCT_PF_READS_ALIGNED) ) {
							$ref->{'AlignmentSummaryMetrics'}{'PF_READS_ALIGNED'} = $PF_READS_ALIGNED;
							$ref->{'AlignmentSummaryMetrics'}{'PCT_PF_READS_ALIGNED'} = $PCT_PF_READS_ALIGNED;
							if ( defined($PF_HQ_ALIGNED_READS) ) {
								my $percet = $PF_HQ_ALIGNED_READS/$PF_READS_ALIGNED;
								$percet = sprintf("%.6f", $percet);
								$ref->{'AlignmentSummaryMetrics'}{'PF_HQ_ALIGNED_READS'} = $PF_HQ_ALIGNED_READS;
								$ref->{'AlignmentSummaryMetrics'}{'PCT_PF_HQ_ALIGNED_READS'} = $percet;
							} else {
								$ref->{'AlignmentSummaryMetrics'}{'PF_HQ_ALIGNED_READS'} = "";
								$ref->{'AlignmentSummaryMetrics'}{'PCT_PF_HQ_ALIGNED_READS'} = "";
							}
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'PF_READS_ALIGNED'} = "";
							$ref->{'AlignmentSummaryMetrics'}{'PCT_PF_READS_ALIGNED'} = "";
							$ref->{'AlignmentSummaryMetrics'}{'PF_HQ_ALIGNED_READS'} = "";
							$ref->{'AlignmentSummaryMetrics'}{'PCT_PF_HQ_ALIGNED_READS'} = "";
						}
						if ( defined($PF_MISMATCH_RATE) ) {
							$ref->{'AlignmentSummaryMetrics'}{'PF_MISMATCH_RATE'} = $PF_MISMATCH_RATE;
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'PF_MISMATCH_RATE'} = "";
						}
						if ( defined($PF_INDEL_RATE) ) {
							$ref->{'AlignmentSummaryMetrics'}{'PF_INDEL_RATE'} = $PF_INDEL_RATE;
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'PF_INDEL_RATE'} = "";
						}
						if ( defined($STRAND_BALANCE) ) {
							$ref->{'AlignmentSummaryMetrics'}{'STRAND_BALANCE'} = $STRAND_BALANCE;
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'STRAND_BALANCE'} = "";
						}
						if ( defined($PCT_CHIMERAS) ) {
							$ref->{'AlignmentSummaryMetrics'}{'PCT_CHIMERAS'} = $PCT_CHIMERAS;
						} else {
							$ref->{'AlignmentSummaryMetrics'}{'PCT_CHIMERAS'} = "";
						}
					}
				}
				close MD;
			} elsif ( $header =~/HsMetric/ ) { # match Hs module
				open (MD, "grep -A 2 '## METRICS CLASS' $path |") || die "HS module $path not correct:$!\n";
				while ( <MD> ) {
					chomp $_; my $line = $_; next if ( $line =~/METRICS[\s]+CLASS/ );
					next if ( $line =~/BAIT_SET/ );
					my ($PF_UNIQUE_READS, $PF_UQ_READS_ALIGNED, $PCT_SELECTED_BASES, $ON_BAIT_VS_SELECTED, $AT_DROPOUT, $GC_DROPOUT) = (split /\t/, $line)[7, 10, 18, 20, 49, 50];
					if ( defined($PF_UNIQUE_READS) ) {
						$ref->{'HsMetrics'}{'PF_UNIQUE_READS'} = $PF_UNIQUE_READS;
					} else {
						$ref->{'HsMetrics'}{'PF_UNIQUE_READS'} = "";
					}
					if ( defined($PF_UQ_READS_ALIGNED) ) {
						$ref->{'HsMetrics'}{'PF_UQ_READS_ALIGNED'} = $PF_UQ_READS_ALIGNED;
					} else {
						$ref->{'HsMetrics'}{'PF_UQ_READS_ALIGNED'} = "";
					}
					if ( defined($PCT_SELECTED_BASES) ) {
						$ref->{'HsMetrics'}{'PCT_SELECTED_BASES'} = $PCT_SELECTED_BASES;
					} else {
						$ref->{'HsMetrics'}{'PCT_SELECTED_BASES'} = "";
					}
					if ( defined($ON_BAIT_VS_SELECTED) ) {
						$ref->{'HsMetrics'}{'ON_BAIT_VS_SELECTED'} = $ON_BAIT_VS_SELECTED;
					} else {
						$ref->{'HsMetrics'}{'ON_BAIT_VS_SELECTED'} = "";
					}
					if ( defined($AT_DROPOUT) ) {
						$ref->{'HsMetrics'}{'AT_DROPOUT'} = $AT_DROPOUT;
					} else {
						$ref->{'HsMetrics'}{'AT_DROPOUT'} = "";
					}
					if ( defined($GC_DROPOUT) ) {
						$ref->{'HsMetrics'}{'GC_DROPOUT'} = $GC_DROPOUT;
					} else {
						$ref->{'HsMetrics'}{'GC_DROPOUT'} = "";
					}
				}
				close MD;
			} elsif ( $header =~/InsertSizeMetric/ ) { # match Hs module
				open (MD, "grep -A 2 '## METRICS CLASS' $path |") || die "InsertSize module $path not correct:$!\n";
				while ( <MD> ) {
					chomp $_; my $line = $_; next if ( $line =~/METRICS[\s]+CLASS/ );
					next if ( $line =~/MEDIAN_INSERT_SIZE/ );
					my ($MEDIAN_INSERT_SIZE, $MEDIAN_ABSOLUTE_DEVIATION) = (split /\t/, $line)[0, 1];
					if ( defined($MEDIAN_INSERT_SIZE) ) {
						$ref->{'InsertSize'}{'MEDIAN_INSERT_SIZE'} = $MEDIAN_INSERT_SIZE;
					} else {
						$ref->{'InsertSize'}{'MEDIAN_INSERT_SIZE'} = "";
					}
					if ( defined($MEDIAN_ABSOLUTE_DEVIATION) ) {
						$ref->{'InsertSize'}{'MEDIAN_ABSOLUTE_DEVIATION'} = $MEDIAN_ABSOLUTE_DEVIATION;
					} else {
						$ref->{'InsertSize'}{'MEDIAN_ABSOLUTE_DEVIATION'} = "";
					}
				}
				close MD;
				$/ = "##"; my %hash; # the hash structure
				$ref->{'InsertSize'}{'DISTRIBUTION'} = undef;
				open (MD, $path) || die "InsertSize distribution module $path not correct:$!\n";
				while ( <MD> ) {
					if ( $_ =~/##[\d]+HISTOGRAM/ ) { # match to HISTOGRAM section
						while ( $_ =~/([\d]+)\t([\d\.Ee]+)/gs ) { $hash{$1} = $2 + 0; }
					}
				}
				close MD;
				$/ = "\n"; $ref->{'InsertSize'}{'DISTRIBUTION'} = \%hash;
			} else {
				print "PICARD module output format is not correct [$path], skip....\n";
			}
		} else {
			print "PICARD output header does not match [$path], no info load from PICARD\n";
		}
	}
1;
