package TEMPLATE;
use strict;
use warnings;

	sub output {
		my ($path, $select_ref, $data_ref, $jubing) = @_;
		
		###################################
		# Load the log image (png format) #
		###################################
		my $logo_path = "$path/fonts/logo.base64.txt";
		open my $font, '<', $logo_path or die "error for loading logo image:$!\n";
		my $logo = do { local $/ = undef; <$font> }; chomp $logo; $logo =~s/\n//gs;

		my $date = `date`; chomp $date;	
		print $jubing qq(\t<div class="container-fluid main-container">\n\n);
		print $jubing qq(\t<div class="row-fluid">\n);
		print $jubing qq(\t<div class="col-xs-12 col-sm-4 col-md-3">\n);
		print $jubing qq(\t<div id="TOC" class="tocify"></div>\n</div>\n\n);
		print $jubing qq(\t<div class="toc-content col-xs-12 col-sm-8 col-md-9">\n\n);

		print $jubing qq(\t\t<div class="fluid-row" id="header">\n);
		print $jubing qq(\t\t\t<h2 class="title toc-ignore">Quality control report of Whole-genome/Targeted-exome sequencing across multiple samples</h2>\n);
		print $jubing qq(\t\t\t<h4 class="date">$date</h4>\n);
		print $jubing qq(\t\t</div>\n);
		print $jubing qq(\t\t<p><img src="data:image/png;base64,$logo" height="100" width="150" style="position:absolute;top:60px;right:0px;" /><br></p>\n\n);

		print $jubing qq(\t\t<div id="report-query-settings" class="section level1">\n);
		print $jubing qq(\t\t\t<h3 style="font-weight: bold;">Report feature settings</h3>\n);
		print $jubing qq(\t\t\t<p>This report is generated based on the application of following parameters:</p>\n);
		print $jubing qq(\t\t\t<ul>\n);
		print $jubing qq(\t\t\t\t<li>Read feature summary: <strong>Read length, number, quality score...</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Insert fragment size summary: <strong>Insert size distribution</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Duplicates marked summary: <strong>Duplicates level (%) in mapped reads</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Read alignment summary: <strong>Fraction (%) mapped reads, mismatch rate, indel rate, chimeras rate...</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Sequencing coverage summary: <strong>An ingredient distribution</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Contamination summary: <strong>Cross-sample contamination level</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Sample ploid: <strong>Thu number of chromosome sets</strong></li>\n);
		print $jubing qq(\t\t\t\t<li>Sample (Tumor) purity: <strong>Fraction of cancer cell in tumor samples</strong><br></li>\n);
		print $jubing qq(\t\t\t</ul>\n);
		print $jubing qq(\t\t</div>\n\n);

		print $jubing qq(\t\t<div class="main-table" class="section level1">\n);
		print $jubing qq(\t\t<h3 style="font-weight: bold;">Quality Report General Statistics</h3>\n);
		print $jubing qq(\t\t\t<table id="general_stats_table" class="table table-bordered table-condensed mqc_table hover" style="width:100%">\n);

		###################################
		# Print final table header (html) #
		###################################
		print $jubing qq(\t\t\t<thead>\n);
		# First column of header
		print $jubing qq(\t\t\t\t<tr><th class="rowheader" rowspan="2"><span title="cancer patient id" class=" ">Sample</span></th><th colspan="5">FASTQC(FQ)</th><th colspan="2">PURITY_PLOIDY(PP)</th><th colspan="2">CONTAMINATION(CN)</th><th colspan="4">Picard_MarkDuplicates(PM)</th><th colspan="2">Picard_InsertSize(PI)</th><th colspan="9">Picard_AlignmentSummary(PA)</th><th colspan="6">Picard_HsMetrics(PH)</th><th colspan="5">GATK_COVERAGE(CV)</th></tr>\n);
		# Second column of header -- FASTQC module
		print $jubing qq(\t\t\t\t<tr><th id="header_BASE_QC_TAG" data-dmax="" data-dmin=""><span title="Per base sequence quality control - FASTQC default filtering setting" class="FQ :">BASE_QC_TAG</span></th>);
		print $jubing qq(<th id="header_PCT_BAD_BASE_R1" data-dmax="" data-dmin=""><span title="Fraction of base fails quality control of FASTQC for R1" class="FQ :">PCT_BAD_BASE_R1</span></th>);
		print $jubing qq(<th id="header_PCT_BAD_BASE_R2" data-dmax="" data-dmin=""><span title="Fraction of base fails quality control of FASTQC for R2" class="FQ :">PCT_BAD_BASE_R2</span></th>);
		print $jubing qq(<th id="header_READ_LENGTH" data-dmax="" data-dmin=""><span title="Read length of sequencing end" class="FQ :">READ_LENGTH</span></th>);
		print $jubing qq(<th id="header_READ_NUM" data-dmax="" data-dmin=""><span title="Total read number of two ends" class="FQ :">READ_NUM</span></th>);
		# Second column of header -- FACETS module
		print $jubing qq(<th id="header_PURITY_FACETS" data-dmax="" data-dmin=""><span title="Fraction of cancer cells in the tumor sample [sourece: FACETS]" class="PP :">PURITY_FACETS</span></th>);
		print $jubing qq(<th id="header_PLOIDY_FACETS" data-dmax="" data-dmin=""><span title="The number of complete sets of chromosomes in cancer cells [sourece: FACETS]" class="PP :">PLOIDY_FACETS</span></th>);
		# Second column of header -- CONTAMINATION module
		print $jubing qq(<th id="header_CONTAMINATION_GATK" data-dmax="" data-dmin=""><span title="Fraction of reads coming from sample-cross contamination [sourece: GATK]" class="CN :">CONTAMINATION_GATK</span></th>);
		print $jubing qq(<th id="header_CONTAMINATION_CONPAIR" data-dmax="" data-dmin=""><span title="Fraction of cross-individual contamination level [sourece: CONPAIR]" class="CN :">CONTAMINATION_CONPAIR</span></th>);
		# Second column of header -- PICARD module
		print $jubing qq(<th id="header_PERCENT_DUPLICATION" data-dmax="" data-dmin=""><span title="Proportion of mapped sequences marked as duplicates" class="PM :">PERCENT_DUPLICATION</span></th>);
		print $jubing qq(<th id="header_READ_PAIRS_EXAMINED" data-dmax="" data-dmin=""><span title="Num of mapped read pairs from BWA" class="PM :">READ_PAIRS_EXAMINED</span></th>);
		print $jubing qq(<th id="header_UNMAPPED_READS" data-dmax="" data-dmin=""><span title="Num of unmapped reads from BWA" class="PM :">UNMAPPED_READS</span></th>);
		print $jubing qq(<th id="header_UNPAIRED_READS_EXAMINED" data-dmax="" data-dmin=""><span title="Num of mapped reads without a mate pair from BWA" class="PM :">UNPAIRED_READS_EXAMINED</span></th>);
		print $jubing qq(<th id="header_MEDIAN_ABSOLUTE_DEVIATION" data-dmax="" data-dmin=""><span title="Median standard deviation of insert size the distribution" class="PI :">MEDIAN_ABSOLUTE_DEVIATION</span></th>);
		print $jubing qq(<th id="header_MEDIAN_INSERT_SIZE" data-dmax="" data-dmin=""><span title="Median insert size of all paired end reads where both ends mapped to the same chromosome" class="PI :">MEDIAN_INSERT_SIZE</span></th>);
		print $jubing qq(<th id="header_PCT_CHIMERAS" data-dmax="" data-dmin=""><span title="Fraction of reads show wrong insert size [larger than 100kb, discordant], after GATK processing" class="PA :">PCT_CHIMERAS</span></th>);
		print $jubing qq(<th id="header_PCT_PF_HQ_ALIGNED_READS" data-dmax="" data-dmin=""><span title="Fraction of aligned reads that show well mapping quality [larger than Q20] : PF_HQ_ALIGNED_READS / PCT_PF_READS_ALIGNED, after GATK processing" class="PA :">PCT_PF_HQ_ALIGNED_READS</span></th>);
		print $jubing qq(<th id="header_PCT_PF_READS_ALIGNED" data-dmax="" data-dmin=""><span title="Fraction of reads aligned to reference: PF_READS_ALIGNED / TOTAL_READS, after GATK processing" class="PA :">PCT_PF_READS_ALIGNED</span></th>);
		print $jubing qq(<th id="header_PF_HQ_ALIGNED_READS" data-dmax="" data-dmin=""><span title="Num of reads well aligned to reference [larger than mapping quality Q20], after GATK processing" class="PA :">PF_HQ_ALIGNED_READS</span></th>);
		print $jubing qq(<th id="header_PF_INDEL_RATE" data-dmax="" data-dmin=""><span title="Indel events per 100 aligned bases, after GATK processing" class="PA :">PF_INDEL_RATE</span></th>);
		print $jubing qq(<th id="header_PF_MISMATCH_RATE" data-dmax="" data-dmin=""><span title="Rate of bases mismatching reference for all bases aligned to references, after GATK processing" class="PA :">PF_MISMATCH_RATE</span></th>);
		print $jubing qq(<th id="header_PF_READS_ALIGNED" data-dmax="" data-dmin=""><span title="Num of reads aligned to reference, after GATK processing" class="PA :">PF_READS_ALIGNED</span></th>);
		print $jubing qq(<th id="header_STRAND_BALANCE" data-dmax="" data-dmin=""><span title="Num of reads aligned to the positive of the genome divided by the num of reads aligned to the genome, after GATK processing" class="PA :">STRAND_BALANCE</span></th>);
		print $jubing qq(<th id="header_TOTAL_READS_GATK" data-dmax="" data-dmin=""><span title="Num of reads, after GATK processing" class="PA :">TOTAL_READS_GATK</span></th>);
		print $jubing qq(<th id="header_AT_DROPOUT" data-dmax="" data-dmin=""><span title="Value implies that X percet. of total reads that should have mapped to GC larger than 50% regions mapped elsewhere" class="PH :">AT_DROPOUT</span></th>);
		print $jubing qq(<th id="header_GC_DROPOUT" data-dmax="" data-dmin=""><span title="Value implies that X percet. of total reads that should have mapped to GC smaller than 50% regions mapped elsewhere" class="PH :">GC_DROPOUT</span></th>);
		print $jubing qq(<th id="header_ON_BAIT_VS_SELECTED" data-dmax="" data-dmin=""><span title="Fraction of read bases on baits that are covered by baits" class="PH :">ON_BAIT_VS_SELECTED</span></th>);
		print $jubing qq(<th id="header_PCT_SELECTED_BASES" data-dmax="" data-dmin=""><span title="Fraction of read bases located on/near a baited region" class="PH :">PCT_SELECTED_BASES</span></th>);
		print $jubing qq(<th id="header_PF_UNIQUE_READS" data-dmax="" data-dmin=""><span title="Num of reads not marked as duplicates, after GATK processing" class="PH :">PF_UNIQUE_READS</span></th>);
		print $jubing qq(<th id="header_PF_UQ_READS_ALIGNED" data-dmax="" data-dmin=""><span title="Num of PF_UNIQUE_READS aligned to reference with MQA larger than 0" class="PH :">PF_UQ_READS_ALIGNED</span></th>);
		# Second column of header -- GATK module
		print $jubing qq(<th id="header_COVERAGE_MEAN_GATK" data-dmax="" data-dmin=""><span title="The mean coverage value of bases within the target regions" class="CV :">MEAN_VALUE</span></th>);
		print $jubing qq(<th id="header_COVERAGE_MEDIAN_GATK" data-dmax="" data-dmin=""><span title="The median coverage value of bases within the target regions" class="CV :">MEDIAN_VALUE</span></th>);
		print $jubing qq(<th id="header_COVERAGE_30X_GATK" data-dmax="" data-dmin=""><span title="Fraction of target region bases with coverage larger than 30 reads" class="CV :">FRACT_30X</span></th>);
		print $jubing qq(<th id="header_COVERAGE_60X_GATK" data-dmax="" data-dmin=""><span title="Fraction of target region bases with coverage larger than 60 reads" class="CV :">FRACT_60X</span></th>);
		print $jubing qq(<th id="header_COVERAGE_100X_GATK" data-dmax="" data-dmin=""><span title="Fraction of target region bases with coverage larger than 100 reads" class="CV :">FRACT_100X</span></th></tr>\n);
		# Third column of header -- filtering setting
		print $jubing qq(\t\t\t\t<tr><th id="id0"></th><th id="id1"></th><th id="id2"></th><th id="id3"></th><th id="id4"></th><th id="id5"></th><th id="id6"></th><th id="id7"></th><th id="id8"></th><th id="id9"></th><th id="id10"></th><th id="id11"></th><th id="id12"></th><th id="id13"></th><th id="id14"></th><th id="id15"></th><th id="id16"></th><th id="id17"></th><th id="id18"></th><th id="id19"></th><th id="id20"></th><th id="id21"></th><th id="id22"></th><th id="id23"></th><th id="id24"></th><th id="id25"></th><th id="id26"></th><th id="id27"></th><th id="id28"></th><th id="id29"></th><th id="id30"></th><th id="id31"></th><th id="id32"></th><th id="id33"></th><th id="id34"></th><th id="id35"></th></tr>\n);
		print $jubing qq(\t\t\t</thead>\n);

		#################################
		# print final table body (html) #
		#################################
		if ( %{$select_ref} ) { # Whether %select data structure present
			foreach my $id ( keys %{$data_ref} ) {
				if (! exists($select_ref->{$id}) ) { 
					delete($data_ref->{$id}); # remove sample names not present in %{$select_ref}
				}
			}
		}
		print $jubing qq(\t\t\t<tbody>\n\t\t\t\t);
		foreach my $id ( sort {$a cmp $b} keys %{$data_ref} ) {
			#----- Additional filtering for NCGC projects -----#
			next if ( $id =~/PRO\-1104\-/ ); # remove these two samples duo sample-mixed problems

			print $jubing qq(<tr><th class="rowheader">$id</th>);
			# FASTQC module TRUE
			if ( exists($data_ref->{$id}{'FASTQC_R1'}) ) {
				my $total_num_r1 = 0; my %qc_r1; my %gc_r1;
				foreach my $ref ( @{$data_ref->{$id}{'FASTQC_R1'}} ) {
					$total_num_r1 = $total_num_r1 + $ref->[0];
					foreach my $score ( sort {$a <=> $b} keys %{$ref->[2]} ) { # count QC histogram
						if (! exists($qc_r1{$score}) ) { 
							$qc_r1{$score} = $ref->[2]{$score}; 
						} else { 
							$qc_r1{$score} = $qc_r1{$score} + $ref->[2]{$score};
						}
					}
				}
				my $total_num_r2 = 0; my %qc_r2; my %gc_r2;
				foreach my $ref ( @{$data_ref->{$id}{'FASTQC_R2'}} ) {
					$total_num_r2 = $total_num_r2 + $ref->[0];
					foreach my $score ( sort {$a <=> $b} keys %{$ref->[2]} ) { # count QC histogram
						if (! exists($qc_r2{$score}) ) {
							$qc_r2{$score} = $ref->[2]{$score};
						} else {
							$qc_r2{$score} = $qc_r2{$score} + $ref->[2]{$score};
						}
					}
				}
				my $qc_20_r1 = 0; my $qc_40_r1 = 0; my $qc_percet_r1 = 0;
				foreach my $score ( sort {$a <=> $b} keys %qc_r1 ) {
					if ( $score <= 20 ) { $qc_20_r1 = $qc_20_r1 + $qc_r1{$score}; }
					$qc_40_r1 = $qc_40_r1 + $qc_r1{$score};
				}
				$qc_percet_r1 = $qc_20_r1/$qc_40_r1; $qc_percet_r1 = sprintf("%.6f", $qc_percet_r1);
				my $qc_20_r2 = 0; my $qc_40_r2 = 0; my $qc_percet_r2 = 0;
				foreach my $score ( sort {$a <=> $b} keys %qc_r2 ) {
					if ( $score <= 20 ) { $qc_20_r2 = $qc_20_r2 + $qc_r2{$score}; }
					$qc_40_r2 = $qc_40_r2 + $qc_r2{$score};
				}
				$qc_percet_r2 = $qc_20_r2/$qc_40_r2; $qc_percet_r2 = sprintf("%.6f", $qc_percet_r2);

				my $fastqc_tag = "PASS"; my $total_num = $total_num_r1 + $total_num_r2;
				if ( $qc_percet_r1 > 0.05 or $qc_percet_r2 > 0.05 ) { $fastqc_tag = "FAIL"; }
				if ( $total_num_r1 != $total_num_r2 ) { $fastqc_tag = "FAIL"; }
				if ( $fastqc_tag eq 'FAIL' ) {
					print $jubing qq(<td bgcolor="#ff9999">$fastqc_tag</td>);
				} else {
					print $jubing qq(<td bgcolor="#bbf0c2">$fastqc_tag</td>);
				}
				print $jubing qq(<td>$qc_percet_r1</td>);
				print $jubing qq(<td>$qc_percet_r2</td>);
				print $jubing qq(<td>$data_ref->{$id}{'FASTQC_R1'}[0][1]</td>);
				print $jubing qq(<td>$total_num</td>);
			} else { # FASTQC module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# FACETS module TRUE
			if ( exists($data_ref->{$id}{'PURITY'}) ) {
				if ( $data_ref->{$id}{'PURITY'}{'FACETS'} eq 'NA' ) {
					print $jubing qq(<td></td>);
				} else {
					print $jubing qq(<td>$data_ref->{$id}{'PURITY'}{'FACETS'}</td>);
				}
				print $jubing qq(<td>$data_ref->{$id}{'PLOIDY'}{'FACETS'}</td>);
			} else { # FACETS module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# CONTAMINATION module TRUE
			if ( exists($data_ref->{$id}{'CONTAMINATION'}) ) {
				if ( exists($data_ref->{$id}{'CONTAMINATION'}{'GATK'}) ) {
					print $jubing qq(<td>$data_ref->{$id}{'CONTAMINATION'}{'GATK'}</td>);
				} else {
					print $jubing qq(<td></td>);
				}
				if ( exists($data_ref->{$id}{'CONTAMINATION'}{'CONPAIR'}) ) {
					print $jubing qq(<td>$data_ref->{$id}{'CONTAMINATION'}{'CONPAIR'}</td>);
				} else {
					print $jubing qq(<td></td>);
				}
			} else {
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# PICARD - MarkDuplicate module TRUE
			if ( exists($data_ref->{$id}{'MarkDuplicate'}) ) {
				foreach my $key ( sort {$a cmp $b} keys %{$data_ref->{$id}{'MarkDuplicate'}} ) {
					print $jubing qq(<td>$data_ref->{$id}{'MarkDuplicate'}{$key}</td>); 
				}
			} else { # PICARD - MarkDuplicate module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# PICARD - InsertSize module TRUE
			if ( exists($data_ref->{$id}{'InsertSize'}) ) {
				print $jubing qq(<td>$data_ref->{$id}{'InsertSize'}{'MEDIAN_ABSOLUTE_DEVIATION'}</td>);
				print $jubing qq(<td>$data_ref->{$id}{'InsertSize'}{'MEDIAN_INSERT_SIZE'}</td>);
			} else { # PICARD - InsertSize module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# PICARD - AlignmentSummaryMetrics module TRUE
			if ( exists($data_ref->{$id}{'AlignmentSummaryMetrics'}) ) {
				foreach my $key ( sort {$a cmp $b} keys %{$data_ref->{$id}{'AlignmentSummaryMetrics'}} ) {
					print $jubing qq(<td>$data_ref->{$id}{'AlignmentSummaryMetrics'}{$key}</td>);
				}
			} else { # PICARD - AlignmentSummaryMetrics module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# PICARD - HsMetrics module TRUE
			if ( exists($data_ref->{$id}{'HsMetrics'}) ) {
				foreach my $key ( sort {$a cmp $b} keys %{$data_ref->{$id}{'HsMetrics'}} ) {
					print $jubing qq(<td>$data_ref->{$id}{'HsMetrics'}{$key}</td>);
				}
			} else { # PICARD - HsMetrics module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			# GATK - Coverage module TRUE
			if ( exists($data_ref->{$id}{'COVERAGE'}) ) {
				print $jubing qq(<td>$data_ref->{$id}{'COVERAGE'}{'MEAN'}</td>);
				print $jubing qq(<td>$data_ref->{$id}{'COVERAGE'}{'MEDIAN'}</td>);
				print $jubing qq(<td>$data_ref->{$id}{'COVERAGE'}{'30x'}</td>);
				print $jubing qq(<td>$data_ref->{$id}{'COVERAGE'}{'60x'}</td>);
				print $jubing qq(<td>$data_ref->{$id}{'COVERAGE'}{'100x'}</td>);
			} else { # GATK - Coverage module FALSE
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
				print $jubing qq(<td></td>);
			}
			print $jubing qq(</tr>);
		}
		print $jubing qq(\n\t\t\t</tbody>\n);
		print $jubing qq(\t\t\t</table>\n);
		print $jubing qq(\t\t\t<p><br></p>\n);
		print $jubing qq(\t\t</div>\n);
	}
1;

