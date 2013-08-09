<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<div class="row-fluid">
			<div class="span7">
				<dl class="dl-horizontal">
					<dt style="width:100px;"><strong>Metrics</strong></dt>
					<dd style="margin-left:100px;">
						<cfloop list="#attributes.report.getMetrics()#" index="metric">
							<span class="label label-warning">#attributes.report.getMetricTitle(metric)#</span>
						</cfloop>
						<span class="label label-info">+</span>
					</dd>
					<dt style="width:100px;"><strong>Dimensions</strong></dt>
					<dd style="margin-left:100px;">
						<cfloop list="#attributes.report.getDimensions()#" index="dimension">
							<span class="label label-warning">#attributes.report.getDimensionTitle(dimension)#</span>
						</cfloop>
						<span class="label label-info">+</span>		
					</dd>
				</dl>
			</div>
			<div class="span5">
				<div class="btn-group-vertical pull-right" style="vertical-align:top; margin-bottom:5px;">
					<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'hour'> active</cfif>" data-groupby="hour">Hour</a>
					<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'day'> active</cfif>" data-groupby="day">Day</a>
					<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'week'> active</cfif>" data-groupby="week">Week</a>
					<a href="" class="hibachi-report-date-group btn btn-mini<cfif attributes.report.getReportDateTimeGroupBy() eq 'month'> active</cfif>" data-groupby="month">Month</a>
				</div>
				<div class="pull-right" style="margin-right:10px;">
					<div style="margin-bottom:-5px;">
						<select name="reportDateTime" class="hibachi-report-date" style="width:192px;">
							<cfloop array="#attributes.report.getReportDateTimeDefinitions()#" index="dateTimeAlias">
								<option value="#dateTimeAlias['alias']#" <cfif dateTimeAlias['alias'] eq attributes.report.getReportDateTime()>selected="selected"</cfif>>#dateTimeAlias['title']#</option>
							</cfloop>
						</select>
					</div>
					<div style="margin-bottom:-5px;">
						<span style="display:block;font-size:11px;font-weight:bold;">Start - End: <a href="##" id="hibachi-report-enable-compare" class="pull-right<cfif attributes.report.getReportCompareFlag()> hide</cfif>">+Compare</a></span>
						<input type="text" name="reportStartDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportStartDateTime')#" /> - <input type="text" name="reportEndDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportEndDateTime')#" />
						<input type="hidden" name="reportCompareFlag" value="#attributes.report.getReportCompareFlag()#" />
					</div>
					<div id="hibachi-report-compare-date" <cfif not attributes.report.getReportCompareFlag()>class="hide"</cfif>>
						<span style="display:block;font-size:11px;font-weight:bold;">Compare Start - End:<a href="" id="hibachi-report-disable-compare" class="pull-right">-Remove</a></span>
						<input type="text" name="reportCompareStartDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportCompareStartDateTime')#" /> - <input type="text" name="reportCompareEndDateTime" class="datepicker hibachi-report-date" style="width:80px;" value="#attributes.report.getFormattedValue('reportCompareEndDateTime')#" />
					</div>
				</div>
			</div>
		</div>
	</cfoutput>
</cfif>