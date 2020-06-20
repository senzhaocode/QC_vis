## QC_vis
QC_vis is a tool for quality control report of multiple samples on whole-genome and whole-exome sequencing. It summarises outputs from common bioinformatics tools (e.g. FastQC, Picard, GATK) and produces interactive HTML reports for sequencing data interpretation for BigMed project.


### Example reports
* [Report for 114 primary postate cancer samples (Lørf et al. Eur Urol, 75 (3), 498-505)](http://folk.uio.no/senz/Quality_control_report_example.html)


### User manual

#### STEP 1: Install dependencies

    PERL5LIB="$PERL5LIB:/where_is_path/QC_vis/lib"
    export PERL5LIB
    NOTE: we recommend that users add the path of perl libraries to .bashrc, then "source .bashrc"
    
#### STEP 2: Input standardization

The QC_vis currently accepts outputs from following tools/modules:
  * FastQC (output from multiple lanes are accepted, and users do not need to merge all lanes for running FastQC) 
  * Picard (InsertSize, HsMetric, DuplicationMetric and AlignmentSummaryMetric modules)
  * GATK (contamination and coverage estimate modules)
  * CONPAIR
  * FACETS

Users __MUST__ use sample id/name to define the output file name of tools/modules above

### Contact

t.cytotoxic AT gmail.com
