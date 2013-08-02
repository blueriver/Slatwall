<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	
	<cfoutput>
		<table class="table table-condensed table-bordered">
			
			<!--- Headers --->
			<tr>
				<cfloop from="1" to="#listLen(attributes.report.getDimensions())#" step="1" index="d">
					<cfset dimensionDefinition = attributes.report.getDimensionDefinition( listGetAt(attributes.report.getDimensions(), d) ) />
					<th>#dimensionDefinition.alias#</th>
				</cfloop>
				<cfloop from="1" to="#arrayLen(attributes.report.getMetricDefinitions())#" step="1" index="m">
					<cfset metricDefinition = attributes.report.getMetricDefinitions()[m] />
					<th>#metricDefinition.alias#</th>
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
					<cfloop from="1" to="#arrayLen(attributes.report.getMetricDefinitions())#" step="1" index="m">
						<cfset metricDefinition = attributes.report.getMetricDefinitions()[m] />
						<td>#tableData[metricDefinition.alias][ tableData.currentRow ]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
		
	</cfoutput>
</cfif>
