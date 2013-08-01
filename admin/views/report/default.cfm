<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfset salesReport = $.slatwall.getBean("SalesReport") />

<cfoutput>
	<div class="row-fluid">
		<div class="span2">
			<div class="well">
				<ul class="nav">
					<li><a href="##SalesReport">Sales Report</a></li>
				</ul>
			</div>
		</div>
		<div class="span10">
			<div class="well">
				<div id="report-chart" style="width:100%; height:400px; margin-bottom:10px;"></div>
				<div class="padding-top:10px;">
					<div class="btn-group" style="vertical-align:top;">
						<a href="" class="btn active">Line</a>
						<a href="" class="btn">Bar</a>
					</div>
					<div class="pull-right">
						<div class="btn-group" style="vertical-align:top;">
							<a href="" class="btn active">Day</a>
							<a href="" class="btn">Week</a>
							<a href="" class="btn">Month</a>
						</div>
						<input type="text" name="reportStartDateTime" class="datepicker" style="width:100px;" value="#$.slatwall.formatValue(now()-30, 'date')#" /> - <input type="text" name="reportEndDateTime" class="datepicker" style="width:100px;" value="#$.slatwall.formatValue(now(), 'date')#" />
					</div>
				</div>
			</div>
			
			<!--- Table --->
			<table class="table table-condensed table-bordered">
				<tr>
					<th>
						Product
					</th>
					<th>
						Product Revenue
					</th>
				</tr>
				<cfset tableData = salesReport.getTableDataQuery() /> 
				<cfloop query="tableData">
					<tr>
						<td>#tableData.productName#</td>
						<td>#dollarFormat(tableData.series1)#</td>
					</tr>
				</cfloop>
			</table>
		</div>
	</div>
	<!--- Chart --->
	<script src="http://code.highcharts.com/highcharts.js"></script>
	<script type="text/javascript">
		jQuery(document).ready(function() {
			var data = {
				reportName: 'SalesReport'
			};
			
			jQuery.ajax({
				url: jQuery(this).attr('href'),
				method: 'post',
				data: data,
				dataType: 'json',
				beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
				error: function( r ) {
					console.log(r);
				},
				success: function( r ) {
					console.log(r.report.chartData);
					jQuery('##report-chart').highcharts(r.report.chartData);
				}
			});
			
		    
		});
	</script>
	<!---jQuery('##report-chart').highcharts(#salesReport.getChartData()#);--->
</cfoutput>