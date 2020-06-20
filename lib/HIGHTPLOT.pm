package HIGHTPLOT;
use strict;
use warnings;

	sub output {
		my $jubing = shift;
		
		######################################
		# print javascript for highlightplot #
		######################################
		my $javascript = <<SCRIPT;
	<div id="main-plots" class="section level1">
	<h3 style="font-weight: bold;">Main plots</h3>
		<p><br></p>
		<div id="Purity-ploidy-tmb" class="section level2">
		<h4 style="font-weight: bold;">Purity and ploidy per sample</h4>
		<div id="PurityPloidy" style="width: 1000px; height: 500px; margin: 0 auto"></div>
		</div>
		<p><br><br></p>
		<div id="Contamination-tmb" class="section level2">
		<h4 style="font-weight: bold;">Contamination estimate per sample</h4>
		<div id="Contamination" style="width: 1000px; height: 500px; margin: 0 auto"></div>
		</div>
		<p><br><br></p>
		<div id="Coverage-tmb" class="section level2">
		<h4 style="font-weight: bold;">Read coverage per sample</h4>
		<div id="Coverage" style="width: 1000px; height: 500px; margin: 0 auto"></div>
		</div>
		<p><br><br></p>
		<div id="Alignment-tmb" class="section level2">
		<h4 style="font-weight: bold;">Duplicates marked per sample</h4>
		<div id="Read" style="width: 1000px; height: 500px; margin: 0 auto"></div>
		</div>
		<p><br><br></p>
		<div id="Insertsize-tmb" class="section level2">
		<h4 style="font-weight: bold;">Distribution of insert size</h4>
		<div id="Insert" style="width: 1000px; height: 500px; margin: 0 auto"></div>
		</div>
		<p><br></p>
	</div>

	<div id="documentation" class="section level1">
	<h3 style="font-weight: bold;">Documentation</h3>
		<div id="software-resources" class="section level2">
		<h4 style="font-weight: bold;">Software resources</h4>
		<p>The summary of quliaty control report is based on the following tools:</p>
		<ul>
		<li><a href="http://www.bioinformatics.babraham.ac.uk/projects/fastqc">FASTQC</a> - A quality control tool for high throught sequence data</li>
		<li><a href="http://software.broadinstitute.org/gatk">GATK</a> - Genome Analysis Toolkit</li>
		<li><a href="http://broadinstitute.github.io/picard">Picard</a> - A tool for manipulating NGS data and formats (now integrated into GATK)</li>
		<li><a href="http://github.com/mskcc/facets">FACETS</a> - A tool for fraction and allele specific copy number estimate Tumor/Normal tumor</li>
		<li><a href="http://github.com/nygenome/Conpair">Conpair</a> - A tool for concordance and contamination estimator for Tumor-Normal pairs <br></li>
		</ul>
		</div>

		<div id="reference-resources" class="section level2">
		<h4 style="font-weight: bold;">References</h4>
		<ol style="list-style-type: decimal">
		<li>DePristo, M. A. et al. A framework for variation discovery and genotyping using next-generation DNA sequencing data. Nature Genet. 43 (2011).</li>
		<li>R. Shen, V.E. Seshan. FACETS: allele-specific copy number and clonal heterogeneity analysis tool for high-throughput DNA sequencing. Nucleic Acids Res., 44 (2016).</li>
		<li>E.A. Bergmann, et al. Conpair: concordance and contamination estimator for matched tumor-normal pairs. Bioinformatics, 32 (2016), pp. 3196-3198.</li>
		<li>Ewels, P., Magnusson, M., Lundin, S. & Käller, M. MultiQC: summarize analysis results for multiple tools and samples in a single report. Bioinformatics 32, 30478 (2016).<br></li>
		</ol>
		</div>

		<div id="support-acknowledgement" class="section level2">
		<h4 style="font-weight: bold;">Supports</h4>
		<p>This report uses HighChart, jQuery, jQuery UI, Bootstrap and DataTable javascripts.<br>If you have any issues and bug reports, pelase email t.cytotoxic\@gmail.com</p>
		</div>
		
	</div>
</div>
</div>
</div>	

	<script type="text/javascript" language="javascript">
	let draw = false;
	
	/**FUNCTIONS**/
	\$(document).ready(function() {
		var table = \$('#general_stats_table').DataTable(); // initialize DataTables
		const tableData = getTableData(table); // get table data
		createHighcharts(tableData); // create Highcharts
		setTableEvents(table); // table events
	});
	function getTableData(table) {
		const dataArray = [],
		sampleArray = [],
		purityfArray = [], ploidyfArray = [],
		congatkArray = [], conconpairArray = [],
		covmedianArray = [], cov30xArray = [], cov60xArray = [], cov100xArray = [],
		readnumArray = [], gatknumArray = [], gatkuniqArray = [], gatkduplicateArray = [], readfilterArray = [],
		insertsizeArray = [],
		duplicatesArray = [];
		// loop table rows
		table.rows({ search: "applied" }).every(function() {
			const data = this.data();
			sampleArray.push(data[0]);
			purityfArray.push(parseFloat(data[6].replace(/\,/g, ""))); // tumor purity
			ploidyfArray.push(parseFloat(data[7].replace(/\,/g, ""))); // tumor ploidy
			congatkArray.push(parseFloat(data[8].replace(/\,/g, ""))); // GATK contamination
			conconpairArray.push(parseFloat(data[9].replace(/\,/g, ""))); // CONPAIR contamination
			covmedianArray.push(parseInt(data[32].replace(/\,/g, ""))); // sequencing depth
			cov30xArray.push(parseFloat(data[33].replace(/\,/g, ""))); // sequencing depth
			cov60xArray.push(parseFloat(data[34].replace(/\,/g, ""))); // sequencing depth
			cov100xArray.push(parseFloat(data[35].replace(/\,/g, ""))); // sequencing depth
			readnumArray.push(parseInt(data[5].replace(/\,/g, ""))); // read filtering
			gatknumArray.push(parseInt(data[22].replace(/\,/g, ""))); // read filtering
			gatkuniqArray.push(parseInt(data[30].replace(/\,/g, ""))); // read filtering
			insertsizeArray.push(parseInt(data[15].replace(/\,/g, "")));
		});
		// log transformation of contamination
		for ( var i in congatkArray ) { congatkArray[i] = 0 - Math.log(congatkArray[i])/Math.log(10); }
		for ( var i in conconpairArray ) { conconpairArray[i] = 0 - Math.log(conconpairArray[i])/Math.log(10); }
		// read filtering
		for ( var i in readnumArray ) {
			readfilterArray[i] = readnumArray[i] - gatknumArray[i];
			gatkduplicateArray[i] = gatknumArray[i] - gatkuniqArray[i];
		}
		// store all data in dataArray
		dataArray.push(sampleArray, purityfArray, ploidyfArray, covmedianArray, cov30xArray, cov60xArray, cov100xArray, congatkArray, conconpairArray, readnumArray, readfilterArray, gatkuniqArray, gatkduplicateArray, insertsizeArray);
		return dataArray;
	}
	function createHighcharts(data) {
		Highcharts.setOptions({ lang: { thousandsSep: "," } });
		
		var chart1 = new Highcharts.chart("PurityPloidy", {
			title: { text: "Quality Control Plot -- Tumor purity and ploidy" },
			subtitle: { text: "The distribution of purity and ploidy across samples" },
			xAxis: [{ categories: data[0], labels: { rotation: -90, style: {fontSize: "8px"} } }],
			yAxis: [{ allowDecimals: true, title: { text: "Purity (fraction)" }, max: 1, min: 0 },
				{ allowDecimals: true, title: { text: "Ploidy level" }, min: 0, opposite: true }],
			series: [{ name: "Tumor cellular purity", color: "#0071A7", type: "column", data: data[1] },
				{ name: "Tumor cellular ploidy", color: "#FF404E", type: "line", data: data[2], marker: {enabled: true, radius: 2}, yAxis: 1 }],
			tooltip: { shared: true, valueDecimals: 4 },
			legend: { backgroundColor: "#ececec", shadow: true },
			credits: { enabled: false },
			noData: { style: { fontSize: "8px" }}
		});
		var chart2 = new Highcharts.chart("Contamination", {
			title: { text: "Quality Control Plot -- Estimate of sample cross-contamination" },
			subtitle: { text: "The distribution of contamination level across samples" },
			xAxis: [{ categories: data[0], labels: { rotation: -90, style: {fontSize: "8px"} } }],
			yAxis: [{ allowDecimals: true, title: { text: "Contamination level (-log10 transformation)" }, max: 8, min: 0 }],
			series: [{ name: "log10(Contamination) [source: GATK]", type: "line", data: data[7], tooltip: {valueDecimals: 2}, marker: {enabled: true, radius: 2} },
				{ name: "log10(Contamination) [source: CONPAIR]", type: "line", data: data[8], tooltip: {valueDecimals: 2}, marker: {enabled: true, radius: 2} }],
			tooltip: { shared: true, valueDecimals: 2 },
			legend: { backgroundColor: "#ececec", shadow: true },
			credits: { enabled: false },
			noData: { style: { fontSize: "8px" }}
		});
		var chart3 = new Highcharts.chart("Coverage", {
			title: { text: "Quality Control Plot -- Sequencing coverage of target regions [Exome-seq]/ whole genome [WGS-seq]" },
			subtitle: { text: "The distribution of median coverage value and fraction of target region bases [>30x, 60x and 100x] across samples" },
			xAxis: [{ categories: data[0], labels: { rotation: -90, style: {fontSize: "8px"} } }],
			yAxis: [{ title: { text: "Median sequencing coverage value" }},
				{ title: { text: "Fraction of target region bases [> a certain criterion]" }, min: 0, max: 1, opposite: true }],
			series: [{ name: "Median coverage value", color: "#0071A7", type: "column", data: data[3] },
				{ name: "Frac_30x_coverage", type: "line", data: data[4], yAxis: 1, tooltip: {valueDecimals: 3}, marker: {enabled: true, radius: 2} },
				{ name: "Frac_60x_coverage", type: "line", data: data[5], yAxis: 1, tooltip: {valueDecimals: 3}, marker: {enabled: true, radius: 2} },
				{ name: "Frac_100x_coverage", type: "line", data: data[6], yAxis: 1, tooltip: {valueDecimals: 3}, marker: {enabled: true, radius: 2} }],
			tooltip: { shared: true },
			legend: { backgroundColor: "#ececec", shadow: true },
			credits: { enabled: false },
			noData: { style: { fontSize: "8px" }}
		});
		var chart4 = new Highcharts.chart("Read", {
			title: { text: "Quality Control Plot -- Read duplication level" },
			subtitle: { text: "Summary of read duplication status after GATK fitering" },
			xAxis: [{ categories: data[0], labels: { rotation: -90, style: {fontSize: "8px"} } }],
			yAxis: [{ title: { text: "Read percentage (%)" },  min: 0, max: 100 }],
			plotOptions: { column: { stacking: 'percent'} },
			series: [{ name: "Filtered reads", type: "column", data: data[10], tooltip: {pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>'} },
				{ name: "Unique reads [GATK filtering]", type: "column", data: data[11], tooltip: {pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>'} },
				{ name: "Duplicate reads [GATK filtering]", type: "column", data: data[12], tooltip: {pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>'} }],
			tooltip: { shared: true },
			legend: { backgroundColor: "#ececec", shadow: true },
			credits: { enabled: false },
			noData: { style: { fontSize: "8px" }}
		});
		var chart5 = new Highcharts.chart("Insert", {
			title: { text: "Quality Control Plot -- Density of insert size" },
			subtitle: { text: "The distribution of insert size across samples" },
			xAxis: [{ title: { text: "Data" }, alignTicks: false },
				{ title: { text: "Insert size (bp)" }, alignTicks: false, opposite: true }],
			yAxis: [{ title: { text: "Insert size (bp)"} },
				{ title: { text: "Density curve (Percent %)"}, opposite: true }],
			series: [{ name: "Density curve", type: "bellcurve", xAxis: 1, yAxis: 1, baseSeries: 1, zIndex: -1 },
				{ name: "Insert size (bp)", type: "scatter", data: data[13], marker: {radius: 1.5} }]
		});
	}
	function setTableEvents(table) {
		// listen for page clicks
		table.on("page", function() { draw = true; });
		// listen for updates and adjust the chart accordingly
		table.on("draw", function() {
			if (draw) {
				draw = false;
			} else {
				const tableData = getTableData(table);
				createHighcharts(tableData);
			}
		});
	}
	</script>
SCRIPT

	print $jubing $javascript;
	}
1;
