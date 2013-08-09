<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<!---
		<div class="row">
			<div class="span4">
				<strong>Dimensions</strong><br />
				<cfloop array="#attributes.report.getDimensionDefinitions()#" index="dimensionDefinition">
					<input type="checkbox" name="dimensions" value="#dimensionDefinition.alias#" <cfif listFindNoCase(attributes.report.getDimensions(), dimensionDefinition.alias)>checked="checked"</cfif>/> #attributes.report.getDimensionTitle( dimensionDefinition.alias )#<br />
				</cfloop>
			</div>
			<div class="span4">
				<strong>Metrics</strong><br />
				<cfloop array="#attributes.report.getMetricDefinitions()#" index="metricDefinition">
					<input type="checkbox" name="metrics" value="#metricDefinition.alias#" <cfif listFindNoCase(attributes.report.getMetrics(), metricDefinition.alias)>checked="checked"</cfif>/> #attributes.report.getMetricTitle( metricDefinition.alias )#<br />
				</cfloop>
			</div>
		</div>
		--->
		<table class="table table-condensed table-bordered">
			
			<!--- Headers --->
			<tr>
				<cfloop from="1" to="#listLen(attributes.report.getDimensions())#" step="1" index="d">
					<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(attributes.report.getDimensions(), d) ) />
					<th>#attributes.report.getDimensionTitle( dimensionDefinition.alias )#</th>
				</cfloop>
				<cfloop from="1" to="#listLen(attributes.report.getMetrics())#" step="1" index="m">
					<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(attributes.report.getMetrics(), m) ) />
					<th>#attributes.report.getMetricTitle( metricDefinition.alias )#</th>
				</cfloop>
			</tr>
			
			<!--- Data --->
			<cfset tableData = attributes.report.getTableDataQuery() /> 
			<cfloop query="tableData">
				<tr>
					<cfloop from="1" to="#listLen(attributes.report.getDimensions())#" step="1" index="d">
						<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(attributes.report.getDimensions(), d) ) />
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							<td><a href="" class="datafilter" data-filteralias="#dimensionDefinition.filterAlias#" data-filtervalue="tableData[ dimensionDefinition.filterAlias ][ tableData.currentRow ]">#tableData[ dimensionDefinition.alias ][ tableData.currentRow ]#</a>
						<cfelse>
							<td>#tableData[ dimensionDefinition.alias ][ tableData.currentRow ]#</td>
						</cfif>
					</cfloop>
					<cfloop from="1" to="#listLen(attributes.report.getMetrics())#" step="1" index="m">
						<cfset metricDefinition = attributes.report.getMetricDefinition( listGetAt(attributes.report.getMetrics(), m) ) />
						<td>#tableData[metricDefinition.alias][ tableData.currentRow ]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
		
	</cfoutput>
</cfif>
