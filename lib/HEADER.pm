package HEADER;
use strict;
use warnings;

	sub output {
		my ($path, $jubing) = @_;
		
		#########################
		# Loading font template #
		#########################
		my $eot_path = "$path/fonts/glyphicons-halflings-regular.eot.base64.txt";
		my $svg_path = "$path/fonts/glyphicons-halflings-regular.svg.base64.txt";
		my $ttf_path = "$path/fonts/glyphicons-halflings-regular.ttf.base64.txt";
		my $woff_path = "$path/fonts/glyphicons-halflings-regular.woff.base64.txt";
		my $woff2_path = "$path/fonts/glyphicons-halflings-regular.woff2.base64.txt";
		open my $font, '<', $eot_path or die "error for loading eot font:$!\n";
		my $eot = do { local $/ = undef; <$font> }; chomp $eot; $eot =~s/\n//gs;
		open $font, '<', $svg_path or die "error for loading svg font:$!\n";
		my $svg = do { local $/ = undef; <$font> }; chomp $svg; $svg =~s/\n//gs;
		open $font, '<', $ttf_path or die "error for loading ttf font:$!\n";
		my $ttf = do { local $/ = undef; <$font> }; chomp $ttf; $ttf =~s/\n//gs;
		open $font, '<', $woff_path or die "error for loading woff font:$!\n";
		my $woff = do { local $/ = undef; <$font> }; chomp $woff; $woff =~s/\n//gs;
		open $font, '<', $woff2_path or die "error for loading woff2 font:$!\n";
		my $woff2 = do { local $/ = undef; <$font> }; chomp $woff2; $woff2 =~s/\n//gs;

		########################
		# Loading css template #
		########################
		my $bootstrap_css_path = "$path/css/bootstrap.min.css";
		my $table_bootstrap_css_path = "$path/css/dataTables.bootstrap.min.css";
		my $jquery_css_path = "$path/css/jquery-ui.min.css";
		my $button_bootstrap_css_path = "$path/css/buttons.bootstrap.min.css";
		my $fixcol_bootstrap_css_path = "$path/css/fixedColumns.bootstrap.min.css";
		my $select_bootstrap_css_path = "$path/css/select.bootstrap.min.css";
		my $yadcf_css_path = "$path/css/jquery.dataTables.yadcf.css";
		my $tocify_css_path = "$path/css/jquery.tocify.css";
		open my $css, '<', $bootstrap_css_path or die "error for loading css bootstrap:$!\n";
		my $bootstrap_css = do { local $/ = undef; <$css> }; chomp $bootstrap_css;
		open $css, '<', $table_bootstrap_css_path or die "error for loading css table bootstrap:$!\n";
		my $table_bootstrap_css = do { local $/ = undef; <$css> }; chomp $table_bootstrap_css;
		open $css, '<', $button_bootstrap_css_path or die "error for loading css button bootstrap:$!\n";
		my $button_bootstrap_css = do { local $/ = undef; <$css> }; chomp $button_bootstrap_css;
		open $css, '<', $fixcol_bootstrap_css_path or die "error for loading css fixcol bootstrap:$!\n";
		my $fixcol_bootstrap_css = do { local $/ = undef; <$css> }; chomp $fixcol_bootstrap_css;
		open $css, '<', $select_bootstrap_css_path or die "error for loading css select bootstrap:$!\n";
		my $select_bootstrap_css = do { local $/ = undef; <$css> }; chomp $select_bootstrap_css;
		open $css, '<', $jquery_css_path or die "error for loading css jquery:$!\n";
		my $jquery_css = do { local $/ = undef; <$css> }; chomp $jquery_css;
		open $css, '<', $yadcf_css_path or die "error for loading css yadcf:$!\n";
		my $yadcf_css = do { local $/ = undef; <$css> }; chomp $yadcf_css;
		open $css, '<', $tocify_css_path or die "error for loading css tocify:$!\n";
		my $tocify_css = do { local $/ = undef; <$css> }; chomp $tocify_css;

		######################
		# Loading javascript #
		######################
		my $jquery_js_path = "$path/js/jquery-3.3.1.min.js";
		my $jquery_table_js_path = "$path/js/jquery.dataTables.min.js";
		my $bootstrap_table_js_path = "$path/js/dataTables.bootstrap.min.js";
		my $jquery_ui_js_path = "$path/js/jquery-ui-1.11.4.min.js";
		my $button_table_js_path = "$path/js/dataTables.buttons.min.js";
		my $button_bootstrap_js_path = "$path/js/buttons.bootstrap.min.js";
		my $button_html5_js_path = "$path/js/buttons.html5.min.js";
		my $colvis_table_js_path = "$path/js/buttons.colVis.revised.min.js";
		my $zip_js_path = "$path/js/jszip.min.js";
		my $fixcol_table_js_path = "$path/js/dataTables.fixedColumns.min.js";
		my $select_table_js_path = "$path/js/dataTables.select.min.js";
		my $highcharts_js_path = "$path/js/highcharts.js";
		my $display_js_path = "$path/js/no-data-to-display.js";
		my $exporting_js_path = "$path/js/exporting.js";
		my $yadcf_js_path = "$path/js/jquery.dataTables.yadcf.min.js";
		my $histogram_js_path = "$path/js/histogram-bellcurve.js";
		my $tocify_js_path = "$path/js/jquery.tocify.min.js";

		open my $in, '<', $jquery_js_path or die "error for loading jquery javascript:$!\n";
		my $jquery_js = do { local $/ = undef; <$in> }; chomp $jquery_js;
		open $in, '<', $jquery_table_js_path or die "error for loading jquery table javascript:$!\n";
		my $jquery_table_js = do { local $/ = undef; <$in> }; chomp $jquery_table_js;
		open $in, '<', $bootstrap_table_js_path or die "error for loading bootstrap table javascript:$!\n";
		my $bootstrap_table_js = do { local $/ = undef; <$in> }; chomp $bootstrap_table_js;
		open $in, '<', $button_table_js_path or die "error for loading button table javascript:$!\n";
		my $button_table_js = do { local $/ = undef; <$in> }; chomp $button_table_js;
		open $in, '<', $button_bootstrap_js_path or die "error for loading button bootstrap javascript:$!\n";
		my $button_bootstrap_js = do { local $/ = undef; <$in> }; chomp $button_bootstrap_js;
		open $in, '<', $button_html5_js_path or die "error for loading button html5 javascript:$!\n";
		my $button_html5_js = do { local $/ = undef; <$in> }; chomp $button_html5_js;
		open $in, '<', $colvis_table_js_path or die "error for loading table visual selected column javascript:$!\n";
		my $colvis_table_js = do { local $/ = undef; <$in> }; chomp $colvis_table_js;
		open $in, '<', $zip_js_path or die "error for loading export data and compressing module javascript:$!\n";
		my $zip_js = do { local $/ = undef; <$in> }; chomp $zip_js;
		open $in, '<', $fixcol_table_js_path or die "error for loading table fix column javascript:$!\n";
		my $fixcol_table_js = do { local $/ = undef; <$in> }; chomp $fixcol_table_js;
		open $in, '<', $select_table_js_path or die "error for loading table select column javascript:$!\n";
		my $select_table_js = do { local $/ = undef; <$in> }; chomp $select_table_js;
		open $in, '<', $jquery_ui_js_path or die "error for loading table jquery ui javascript:$!\n";
		my $jquery_ui_js = do { local $/ = undef; <$in> }; chomp $jquery_ui_js;
		open $in, '<', $highcharts_js_path or die "error for loading table highcharts javascript:$!\n";
		my $highcharts_js = do { local $/ = undef; <$in> }; chomp $highcharts_js;
		open $in, '<', $display_js_path or die "error for loading table display javascript:$!\n";
		my $display_js = do { local $/ = undef; <$in> }; chomp $display_js;
		open $in, '<', $exporting_js_path or die "error for loading table exporting javascript:$!\n";
		my $exporting_js = do { local $/ = undef; <$in> }; chomp $exporting_js;
		open $in, '<', $yadcf_js_path or die "error for loading table yadcf javascript:$!\n";
		my $yadcf_js = do { local $/ = undef; <$in> }; chomp $yadcf_js;
		open $in, '<', $histogram_js_path or die "error for loading table histogram plot javascript:$!\n";
		my $histogram_js = do { local $/ = undef; <$in> }; chomp $histogram_js;
		open $in, '<', $tocify_js_path or die "error for loading navigation tocify bar javascript:$!\n";
		my $tocify_js = do { local $/ = undef; <$in> }; chomp $tocify_js;

		###########################
		# print final html header #
		###########################
		my $script = <<SCRIPT;
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="description" content="NCGC Prostate Cancer Exom-seq samples">
	<title>Quality Control Report</title>

	<!-- Include CSS -->
	<style type="text/css">
	\@font-face{
		font-family:'Glyphicons Halflings';
		src:url(data:font/eot;base64,$eot);
		src:url(data:font/eot;base64,$eot) format('embedded-opentype'),
		    url(data:x-font-woff/woff2;base64,$woff2) format('woff2'),
		    url(data:x-font-woff/woff;base64,$woff) format('woff'),
		    url(data:font/ttf;base64,$ttf) format('truetype'),
		    url(data:image/svg;base64,$svg) format('svg');
	}
	</style>
	<style type="text/css" class="init">
	$bootstrap_css
	$table_bootstrap_css
	$button_bootstrap_css
	$fixcol_bootstrap_css
	$select_bootstrap_css
	$jquery_css
	$yadcf_css
	$tocify_css
	</style>
	
	<style type="text/css" class="init">
	/* Personal setting for css -- users need to change based their own requirements */
	/* Ensure that the demo table scrolls */
	.dropdown-menu { font-size: 11px; }
	th, td { white-space: nowrap; }
	thead th { text-align: center; min-width: 120px; }
	thead tr { height: 49px; }
	div.dataTables_wrapper { width: 1000px; margin: 0 auto; }

	/* Highlight columns and rows */
	table { overflow: hidden; }
	td, th { padding: 10px; position: relative; outline: 0; }
	body:not(.nohover) tbody tr:hover { background-color: whitesmoke; }
	tbody td:hover::after, tbody th:not(:empty):hover::after, tbody td:focus::after, tbody th:not(:empty):focus::after {
		content:''; height: 10000px; left: 0; position: absolute; top: -5000px; width: 100%; z-index: -1; }

	tbody td:hover::after, tbody th:hover::after { background-color: whitesmoke; }
	tbody td:focus::after, tbody th:focus::after { background-color: lightblue; }
	tbody td:focus::before, tbody th:focus::before {
		background-color: lightblue; content: ''; height: 100%; top: 0; left: -5000px; position: absolute; width: 10000px; z-index: -1; }
	
	/* Set column filtering - yadcf */
	th input { width: 100%; font-size: 9px; }
	.yadcf-filter-range-number { width: 50px; }
	.yadcf-filter { padding-right: 1px; padding-left: 1px; padding-bottom: 2px; padding-top: 2px; }
	.yadcf-filter-range-number-seperator { margin-left: 1px; margin-right: 1px; }
	.yadcf-filter-wrapper { display: inline; margin-left: 0; }
	.yadcf-filter-wrapper-inner { display: inline; }
	</style>

	<style type="text/css">
	body { padding-top: 20px; }
	p { font-size: 16px; }
	a { font-size: 14px; }
	li { font-size: 14px; }
	.headerDoc { color: #005580; }

	\@media (max-width: 767px) {
		#TOC { position: relative; width: 100%; margin: 25px 0px 20px 0px; }
	}
	</style>

	<!-- Include javascript files -->
	<script type="text/javascript" language="javascript">$jquery_js</script>
	<script type="text/javascript" language="javascript">$jquery_table_js</script>
	<script type="text/javascript" language="javascript">$bootstrap_table_js</script>
	<script type="text/javascript" language="javascript">$button_table_js</script>
	<script type="text/javascript" language="javascript">$button_bootstrap_js</script>
	<script type="text/javascript" language="javascript">$button_html5_js</script>
	<script type="text/javascript" language="javascript">$colvis_table_js</script>
	<script type="text/javascript" language="javascript">$zip_js</script>
	<script type="text/javascript" language="javascript">$fixcol_table_js</script>
	<script type="text/javascript" language="javascript">$select_table_js</script>
	<script type="text/javascript" language="javascript">$jquery_ui_js</script>
	<script type="text/javascript" language="javascript">$highcharts_js</script>
	<script type="text/javascript" language="javascript">$display_js</script>
	<script type="text/javascript" language="javascript">$exporting_js</script>
	<script type="text/javascript" language="javascript">$yadcf_js</script>
	<script type="text/javascript" language="javascript">$histogram_js</script>
	<script type="text/javascript" language="javascript">$tocify_js</script>

	<script type="text/javascript" language="javascript">
	// Personal setting for javascript -- users need to change based their own requirements
	\$(document).ready(function() {
		'use strict';
		var table = \$('#general_stats_table').DataTable({
			orderCellsTop: true,
			scrollY: 400, scrollX: true, scrollCollapse: true, paging: false, fixedColumns: true, lengthChange: false,
			language: { buttons: { colvisRestore: "BACK TO DEFAULT" }},
			select: { style: 'os', blurable: true },
			buttons: [
				{ extend: 'colvis', text: 'Column configuration', collectionLayout: 'two-column', postfixButtons: [ "colvisRestore" ] },
				{ extend: 'csvHtml5', text: 'TSV', feldSeparator: '\\t', extension: '.tsv', title: 'Quality_Control_Report', exportOptions: {columns: ':visible'} },
				{ extend: 'excelHtml5', title: 'Quality_Control_Report', exportOptions: {columns: ':visible'} },
				{ text: 'JSON', action: function (e, dt, button, config) {
					var data = dt.buttons.exportData( {columns: ':visible'} ); // only export visible columns
					\$.fn.dataTable.fileSave(new Blob( [JSON.stringify( data )]), 'Quality_control_report.json'); } // define output as json
				}
			],
			columnDefs: [{ targets: [2, 3, 14, 27], visible: false }]
		});
		yadcf.init(table, [
			{column_number : 1, filter_type: "text", filter_container_id:"id1", filter_reset_button_text: false },
			{column_number : 2, filter_type: "range_number", filter_container_id:"id2", filter_reset_button_text: false },
			{column_number : 3, filter_type: "range_number", filter_container_id:"id3", filter_reset_button_text: false },
			{column_number : 4, filter_type: "range_number", filter_container_id:"id4", filter_reset_button_text: false },
			{column_number : 5, filter_type: "range_number", filter_container_id:"id5", filter_reset_button_text: false },
			{column_number : 6, filter_type: "range_number", filter_container_id:"id6", filter_reset_button_text: false },
			{column_number : 7, filter_type: "range_number", filter_container_id:"id7", filter_reset_button_text: false },
			{column_number : 8, filter_type: "range_number", filter_container_id:"id8", filter_reset_button_text: false },
			{column_number : 9, filter_type: "range_number", filter_container_id:"id9", filter_reset_button_text: false },
			{column_number : 10, filter_type: "range_number", filter_container_id:"id10", filter_reset_button_text: false },
			{column_number : 11, filter_type: "range_number", filter_container_id:"id11", filter_reset_button_text: false },
			{column_number : 12, filter_type: "range_number", filter_container_id:"id12", filter_reset_button_text: false },
			{column_number : 13, filter_type: "range_number", filter_container_id:"id13", filter_reset_button_text: false },
			{column_number : 14, filter_type: "range_number", filter_container_id:"id14", filter_reset_button_text: false },
			{column_number : 15, filter_type: "range_number", filter_container_id:"id15", filter_reset_button_text: false },
			{column_number : 16, filter_type: "range_number", filter_container_id:"id16", filter_reset_button_text: false },
			{column_number : 17, filter_type: "range_number", filter_container_id:"id17", filter_reset_button_text: false },
			{column_number : 18, filter_type: "range_number", filter_container_id:"id18", filter_reset_button_text: false },
			{column_number : 19, filter_type: "range_number", filter_container_id:"id19", filter_reset_button_text: false },
			{column_number : 20, filter_type: "range_number", filter_container_id:"id20", filter_reset_button_text: false },
			{column_number : 21, filter_type: "range_number", filter_container_id:"id21", filter_reset_button_text: false },
			{column_number : 22, filter_type: "range_number", filter_container_id:"id22", filter_reset_button_text: false },
			{column_number : 23, filter_type: "range_number", filter_container_id:"id23", filter_reset_button_text: false },
			{column_number : 24, filter_type: "range_number", filter_container_id:"id24", filter_reset_button_text: false },
			{column_number : 25, filter_type: "range_number", filter_container_id:"id25", filter_reset_button_text: false },
			{column_number : 26, filter_type: "range_number", filter_container_id:"id26", filter_reset_button_text: false },
			{column_number : 27, filter_type: "range_number", filter_container_id:"id27", filter_reset_button_text: false },
			{column_number : 28, filter_type: "range_number", filter_container_id:"id28", filter_reset_button_text: false },
			{column_number : 29, filter_type: "range_number", filter_container_id:"id29", filter_reset_button_text: false },
			{column_number : 30, filter_type: "range_number", filter_container_id:"id30", filter_reset_button_text: false },
			{column_number : 31, filter_type: "range_number", filter_container_id:"id31", filter_reset_button_text: false },
			{column_number : 32, filter_type: "range_number", filter_container_id:"id32", filter_reset_button_text: false },
			{column_number : 33, filter_type: "range_number", filter_container_id:"id33", filter_reset_button_text: false },
			{column_number : 34, filter_type: "range_number", filter_container_id:"id34", filter_reset_button_text: false },
			{column_number : 35, filter_type: "range_number", filter_container_id:"id35", filter_reset_button_text: false }
		]);
		
		\$('#general_stats_table tbody')
			.on( 'mouseenter', 'td', function () {
			var colIdx = table.cell(this).index().column;
			\$( table.cells().nodes() ).removeClass( 'highlight' );
			\$( table.column( colIdx ).nodes() ).addClass( 'highlight' );
		});
		table.buttons().container()
			.appendTo( '#general_stats_table_wrapper .col-sm-6:eq(0)' ); // set the position of control panel
	});
	</script>

	<script>
	// javascript for navigation bar manual 
	\$(function() {
	// move toc-ignore selector from section div to header
	\$('div.section.toc-ignore')
		.removeClass('toc-ignore')
		.children('h1,h2,h3,h4,h5').addClass('toc-ignore');

	// establish options
	var options = {
		selectors: "h3,h4,h5",
		context: '.toc-content',
		ignoreSelector: ".toc-ignore",
		hashGenerator: function (text) {
			return text.replace(/[.\\\\/?&!#<>]/g, '').replace(/\\s/g, '_').toLowerCase();
		},
		scrollTo: 0
	};
	options.showAndHide = true;
	options.smoothScroll = true;

	// tocify manual bar
	var toc = \$("#TOC").tocify(options).data("toc-tocify");
	});
	</script>
SCRIPT

	print $jubing $script;
	}
1;
