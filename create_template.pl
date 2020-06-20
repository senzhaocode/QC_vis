#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use Getopt::Long;
use File::Basename;
use File::Spec;
use FASTQC;
use PICARD;
use GATK;
use CONPAIR;
use FACETS;
use HEADER;
use TEMPLATE;
use HIGHTPLOT;

	# setup option parameter in the script command line
	my @usage;
	push @usage, "Usage: ".basename($0)." [options]\n";
	push @usage, "Create interactive html to visualize quality control report [QC] of Exome-seq/WGS-seq.\n";
	push @usage, "	--help		display information of all parameter\n";
	push @usage, "	--fastqc	path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of FASTQC ouputs\n";
	push @usage, "	--picard	path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of PICARD ouputs\n";
	push @usage, "	--gatk		path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of GATK ouputs\n";
	push @usage, "	--conpair	path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of CONPAIR ouputs\n";
	push @usage, "	--facets	path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of FACETS ouputs\n";
	push @usage, "	--control	if users would like to report a subset of all samples, please use it for sample control [sample names separated by coma, e.g. name1, name2, name3], \n\t\t\tand user can also list sample names in a file for controlling\n";
	push @usage, "	--template	HTML template path (including css and javascript files)\n";
	push @usage, "	--output	Output file name\n";

	my $help;
	my $fastqc;
	my $picard;
	my $gatk;
	my $conpair;
	my $facets;
	my $output;
	my $control;
	my $template;
	my %data; # main datastructure

	GetOptions
	(
		'help'		=> \$help,
		'fastqc=s'	=> \$fastqc,
		'picard=s'	=> \$picard,
		'gatk=s'	=> \$gatk,
		'conpair=s'	=> \$conpair,
		'facets=s'	=> \$facets,
		'control=s'	=> \$control,
		'template=s'	=> \$template,
		'output=s'	=> \$output
	);
	not defined $help or die @usage;
	if (! defined($fastqc) && ! defined($picard) && ! defined($gatk) && ! defined($conpair) && ! defined($facets) && ! defined($output) ) { die @usage; }
	defined $output or die @usage;
	defined $template or die @usage; if ( ! -e "$template" ) { print "The input path of HTML template incorrect\n\n"; exit; }

#######################################
# set the parameters of fastqc module #
#######################################
# Data Structure for FASTQC module
# $data{'sample_id'}{'FASTQC_R1'} = ['READ_NUM', 'READ_LENGTH', \%score, \%gc];  $score{'QUALITY_SCARE'}='COUNT'; $gc{'GC_CONTENT'}='COUNT'
# $data{'sample_id'}{'FASTQC_R2'} = ['READ_NUM', 'READ_LENGTH', \%score, \%gc];  $score{'QUALITY_SCARE'}='COUNT'; $gc{'GC_CONTENT'}='COUNT'
if ( defined($fastqc) ) {
	if ( $fastqc =~/\,/ ) { # if there are more than one paths.
		my @input = (split /\,/, $fastqc);
		foreach my $id ( @input ) {
			$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g;
			open (IN, "find $id -not -name '*.bam' -not -name '*.bai' -name '*.zip' |") || die "The input path $id for fastqc modules does not exist:$!\n";
			while ( <IN> ) {
				chomp $_; my $path = $_;

				# Obtain sample name from fastqc.zip -- currecnt code match for NCGC project, and need to be modified in further #
				my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
				if (! exists($data{$sample_id}) ) { $data{$sample_id} = undef; }

				my %score_1; my %gc_1; my $num_1; my $length_1; my %score_2; my %gc_2; my $num_2; my $length_2;
				if ( $path =~/1_fastqc\.zip$/ ) { # match the first end
					($num_1, $length_1) = FASTQC::module($path, \%score_1, \%gc_1);
					push @{$data{$sample_id}{'FASTQC_R1'}}, [$num_1, $length_1, \%score_1, \%gc_1];
				}
				if ( $path =~/2_fastqc\.zip$/ ) { # match the second end
					($num_2, $length_2) = FASTQC::module($path, \%score_2, \%gc_2);
					push @{$data{$sample_id}{'FASTQC_R2'}}, [$num_2, $length_2, \%score_2, \%gc_2];
				}
			}
			close IN;
		}
	} else {
		$fastqc =~s/\"//g; $fastqc =~s/\'//g; $fastqc =~s/^[\s]+//g; $fastqc =~s/[\s]+$//g; #print "$fastqc\n";
		open (IN, "find $fastqc -not -name '*.bam' -not -name '*.bai' -name '*.zip' |") || die "The input path $fastqc for fastqc modules does not exist:$!\n";
		while ( <IN> ) {
			chomp $_; my $path = $_; #print "$path\n";
			
			# Obtain sample name from *_fastqc.zip -- current code match for NCGC project, and need to be modified in further#
			my $sample_id = (split /_/, (split /\//, $path)[-1])[0]; #print "$sample_id\n";
			if (! exists($data{$sample_id}) ) { $data{$sample_id} = undef; }

			my %score_1; my %gc_1; my $num_1; my $length_1; my %score_2; my %gc_2; my $num_2; my $length_2;
			if ( $path =~/1_fastqc\.zip$/ ) { # match the first end
				($num_1, $length_1) = FASTQC::module($path, \%score_1, \%gc_1);
				push @{$data{$sample_id}{'FASTQC_R1'}}, [$num_1, $length_1, \%score_1, \%gc_1]; #print "$sample_id\t$num_1\t$length_1\n";
			}
			if ( $path =~/2_fastqc\.zip$/ ) { # match the first end
				($num_2, $length_2) = FASTQC::module($path, \%score_2, \%gc_2);
				push @{$data{$sample_id}{'FASTQC_R2'}}, [$num_2, $length_2, \%score_2, \%gc_2]; #print "$sample_id\t$num_2\t$length_2\n";
			}
		}
		close IN;
	}
}

########################################
# set the parameters of picard modules #
########################################
# Data Structure for PICARD module
# $data{'sample_id'}{'DuplicationMetric'} = ['READ_PAIRS_EXAMINED'=>,'UNPAIRED_READS_EXAMINED'=>,'UNMAPPED_READS'=>,'PERCENT_DUPLICATION'=>];
# $data{'sample_id'}{'AlignmentSummaryMetric'} = ['TOTAL_READS'=>,'PF_READS_ALIGNED'=>,'PCT_PF_READS_ALIGNED'=>,'PF_HQ_ALIGNED_READS'=>,'PCT_PF_HQ_ALIGNED_READS'=>,'PF_MISMATCH_RATE'=>,'PF_INDEL_RATE'=>,'STRAND_BALANCE'=>,'PCT_CHIMERAS'=>]
# $data{'sample_id'}{'HsMetrics'} = ['PF_UNIQUE_READS'=>,'PF_UQ_READS_ALIGNED'=>,'PCT_SELECTED_BASES'=>,'ON_BAIT_VS_SELECTED'=>,'AT_DROPOUT'=>,'GC_DROPOUT'=>]
# $data{'sample_id'}{'HsMetrics'} = ['MEDIAN_INSERT_SIZE'=>,'MEDIAN_ABSOLUTE_DEVIATION'=>,'DISTRIBUTION'=>\%hash]; $hash{'insert_size'} = 'count_num' 
if ( defined($picard) ) {
	if ( $picard =~/\,/ ) { # if there are more than one paths.
		my @input = (split /\,/, $picard);
		foreach my $id ( @input ) {
			$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g; #print "$id\n";
			open (IN, "find $id -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'InsertSize|HsMetric|DuplicationMetric|AlignmentSummaryMetric' {} \\; |") || die "The input path $id for picard modules does not exists:$!\n"; # list all the module paths
			while ( <IN> ) {
				chomp $_; my $path = $_; #print "$path\n";

				# Obtain sample name from *_module.metric -- current code match for NCGC project, and need to be modified in further#
				my $sample_id = (split /_/, (split /\//, $path)[-1])[0]; 
				if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }

				# match to Picard module (MarkDuplicate, AlignmentSummary, InsertSize and HsSummary)
				PICARD::module($path, $data{$sample_id});
			}
			close IN;
		}
	} else { # if there is only one path
		$picard =~s/\"//g; $picard =~s/\'//g; $picard =~s/^[\s]+//g; $picard =~s/[\s]+$//g;
		open (IN, "find $picard -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'InsertSize|HsMetric|DuplicationMetric|AlignmentSummaryMetric' {} \\; |") || die "The input path $picard for picard modules does not exists:$!\n"; # list all the module paths
		while ( <IN> ) {
			chomp $_; my $path = $_; #print "$path\n";

			# Obtain sample name from *_module.metric -- only specific for NCGC project, and need to be modified in further
			my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
			if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }

			# match to Picard module (MarkDuplicate, AlignmentSummary, InsertSize and HsSummary)
			PICARD::module($path, $data{$sample_id});
		}
		close IN;
	}
}

######################################
# set the parameters of gatk modules #
######################################
# Data Structure for GATK module
# $data{'sample_id'}{'COVERAGE'} = ['MEAN'=>,'MEDIAN'=>,'30x'=>,'60x'=>,'100x'=>]
# $data{'sample_id'}{'CONTAMINATION'} = ['GATK'=>]
if ( defined($gatk) ) {
	if ( $gatk =~/\,/ ) { # if there are more than one paths.
		my @input = (split /\,/, $gatk);
		foreach my $id ( @input ) {
			$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g;
			open (IN, "find $id -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'contamination|bases_above' {} \\; |") || die "The input path $id for gatk coverage modules does not exist:$!\n";
			while ( <IN> ) {
				chomp $_; my $path = $_; next if ( $path =~/250bp/); # this filtering only works on NCGC project
				
				# Obtain sample name from gatk -- current code match for NCGC project, and need to be modified in further#
				my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
				if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }
 
				if ( $path =~/\.sample_summary$/ ) {
					# match to GATK module (DepathCoverage)
					GATK::coverage($path, $data{$sample_id});
				} else {
					# match to GATK module (Contamination)
					GATK::contamination($path, $data{$sample_id});
				}
			}
			close IN;
		}
	} else { # if there is only one path
		$gatk =~s/\"//g; $gatk =~s/\'//g; $gatk =~s/^[\s]+//g; $gatk =~s/[\s]+$//g;
		open (IN, "find $gatk -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'contamination|bases_above' {} \\; |") || die "The input path $gatk for GATK modules does not exist:$!\n";
		while ( <IN> ) {
			chomp $_; my $path = $_; next if ( $path =~/250bp/); #print "# $gatk\n";# this filtering only works on NCGC project

			# Obtain sample name from gatk -- current code match for NCGC project, and need to be modified in further#
			my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
			if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }

			if ( $path =~/\.sample_summary$/ ) {
				# match to GATK module (DepathCoverage)
				GATK::coverage($path, $data{$sample_id});
			} else {
				# match to GATK module (Contamination)
				GATK::contamination($path, $data{$sample_id});
			}
		}
		close IN;
	}
}

#########################################
# set the parameters of CONPAIR modules #
#########################################
# Data Structure for CONPAIR module 
# $data{'sample_id'}{'CONTAMINATION'} = ['CONPAIR'=>]
if ( defined($conpair) ) {
	if ( $conpair =~/\,/ ) { # if there are more than one paths.
		my @input = (split /\,/, $conpair);
		foreach my $id ( @input ) {
			$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g;
			open (IN, "find $id -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'contamination' {} \\; |") || die "The input path $id for conpair modules does not exist:$!\n";
			while ( <IN> ) {
				chomp $_; my $path = $_; # this filtering only works on NCGC project
				
				# Obtain sample name from conpair -- current code match for NCGC project, and need to be modified in further#
				my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
				if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }
				
				# match to CONPAIR module (Contamination)
				CONPAIR::module($path, $data{$sample_id});
			}
			close IN;
		}
	} else {
		$conpair =~s/\"//g; $conpair =~s/\'//g; $conpair =~s/^[\s]+//g; $conpair =~s/[\s]+$//g;
		open (IN, "find $conpair -not -name '*.bam' -not -name '*.bai' -type f -exec grep -l -P 'contamination' {} \\; |") || die "The input path $conpair for conpair modules does not exist:$!\n";
		while ( <IN> ) {
			chomp $_; my $path = $_; # this filtering only works on NCGC project

			# Obtain sample name from conpair -- current code match for NCGC project, and need to be modified in further#
			my $sample_id = (split /_/, (split /\//, $path)[-1])[0];
			if (! exists($data{$sample_id}) ) { my %tmp; $data{$sample_id} = \%tmp; }

			# match to CONPAIR module (Contamination)
			CONPAIR::module($path, $data{$sample_id});
		}
		close IN;
	}
}
########################################
# set the parameters of FACETS modules #
########################################
# Data Structure for CONPAIR module
# $data{'sample_id'}{'PURITY'} = ['FACETS'=>]
# $data{'sample_id'}{'PLOIDY'} = ['FACETS'=>]
if ( defined($facets) ) {
	if ( $facets =~/\,/ ) { # if there are more than one paths.
		my @input = (split /\,/, $facets);
		foreach my $id ( @input ) {
			$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g;
			open (IN, "find $id -not -name '*.bam' -not -name '*.bai' -not -name '*coverage.snpmat' -not -name '*snp_values.tsv' -type f -exec grep -l -P '^Flags:' {} \\; |") || die "The input path $id for facets modules does not exist:$!\n";
			while ( <IN> ) {
				chomp $_; my $path = $_; # this filtering only works on NCGC project

				# Obtain sample name from facets -- current code match for NCGC project, and need to be modified in further#
				my ($sample_id1, $sample_id2) = (split /_/, (split /\//, $path)[-1])[0, 1];
				if ( defined($sample_id1) and defined($sample_id2) ) {
					if (! exists($data{$sample_id2}) ) { my %tmp; $data{$sample_id2} = \%tmp; }
				} else {
					next;
				}

				# match to FACETS module (purity and ploidy)
				FACETS::module($path, $data{$sample_id2});
			}
			close IN;
		}
	} else {
		$facets =~s/\"//g; $facets =~s/\'//g; $facets =~s/^[\s]+//g; $facets =~s/[\s]+$//g;
		open (IN, "find $facets -not -name '*.bam' -not -name '*.bai' -not -name '*coverage.snpmat' -not -name '*snp_values.tsv' -type f -exec grep -l -P '^Flags:' {} \\; |") || die "The input path $facets for facets modules does not exist:$!\n";
		while ( <IN> ) {
			chomp $_; my $path = $_; # this filtering only works on NCGC project

			# Obtain sample name from facets -- current code match for NCGC project, and need to be modified in further#
			my ($sample_id1, $sample_id2) = (split /_/, (split /\//, $path)[-1])[0, 1];
			if ( defined($sample_id1) and defined($sample_id2) ) {
				if (! exists($data{$sample_id2}) ) { my %tmp; $data{$sample_id2} = \%tmp; }
			} else {
				next;
			}

			# match to FACETS module (purity and ploidy)
			FACETS::module($path, $data{$sample_id2});
		}
		close IN;
	}
}

############################################
# control sample names if --control active #
############################################
my %select;
if ( defined($control) ) {
	if ( -e "$control" ) {
		open (IN, "$control") || die "The input path of sample names for controlling does not exist:$!\n";
		while ( <IN> ) {
			chomp $_; my $name = $_; $select{$name} = 1;
		}
		close IN;
	} else {
		if ( $control =~/\,/ ) {
			my @input = (split /\,/, $control);
			foreach my $id ( @input ) {
				$id =~s/\"//g; $id =~s/\'//g; $id =~s/[\s]+$//g; $id =~s/^[\s]+//g;
				$select{$id} = 1;
			}
		} else {
			print "The given samples name for controlling are invalid, please set the correct path or names\n"; exit;
		}
	}
}

#########################################################
# Standard output quality control report in html format #
#########################################################
	open(TEM, ">$output") || die "cannot open this output $output path:$!\n";
	print TEM qq(<!DOCTYPE html>\n);
	print TEM qq(<html>\n);
	print TEM qq(<head>\n);
	HEADER::output($template, \*TEM); # input header css and javascript
	print TEM qq(</head>\n);

	print TEM qq(<body>\n);
	TEMPLATE::output($template, \%select, \%data, \*TEM); # input the main table body
	HIGHTPLOT::output(\*TEM); # input javascript for plot
	print TEM qq(</body>\n);
	print TEM qq(</html>\n);
	close TEM;

