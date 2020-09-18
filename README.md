## QC_vis
QC_vis is a tool for quality control report of multiple samples on whole-genome and whole-exome sequencing. It summarises outputs from bioinformatics tools (e.g. FastQC, Picard, GATK) and produces interactive HTML reports for sequencing data interpretation for BigMed project.


### Example reports
* [Report for 114 primary postate cancer samples (Lørf et al. Eur Urol, 75 (3), 498-505)](https://github.com/senzhaocode/QC_vis/blob/master/Quality_control_report_example.html)


### User manual

#### STEP 1: Install dependencies

    PERL5LIB="$PERL5LIB:/where_is_path/QC_vis/lib"
    export PERL5LIB
    NOTE: we recommend that users add the path of perl libraries to .bashrc, then "source .bashrc"
    
#### STEP 2: Input standardization

QC_vis currently accepts outputs from following tools/modules:
  * FastQC (outputs from multiple lanes are accepted, and users do not need to merge all lanes per sample before running FastQC) 
  * Picard (InsertSize, HsMetric, DuplicationMetric and AlignmentSummaryMetric modules)
  * GATK (contamination and coverage estimate modules)
  * CONPAIR
  * FACETS

Users __MUST__ use sample id/name to define the file name of outputs from tools/modules above

#### STEP 3: Run example
Report is generated by running the Perl script __create_template.pl__, which takes the following arguments and options:

    usage: create_template.pl --help [options]
    --fastqc    path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of FASTQC ouputs
    --picard    path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of PICARD ouputs
    --gatk      path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of GATK ouputs
    --conpair   path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of CONPAIR ouputs
    --facets    path/direcotory [separated by coma, e.g. path1, path2, path3 if multiple paths available] of FACETS ouputs
    --control   if users would like to report a subset of all samples, please use it for sample control [sample names separated by coma, e.g. name1, name2, name3], and users can also list sample names for controlling in a file
    --template  directionary of css and javascript used for HTML report
    --output    output file name
        
### Contact

t.cytotoxic AT gmail.com
