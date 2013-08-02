<cfcomponent accessors="true" persistent="false" output="false" extends="HibachiTransient">
	
	<!--- Title Information --->
	<cfproperty name="reportTitle" />
	
	<!--- Date / Time Properties --->
	<cfproperty name="reportStartDateTime" />
	<cfproperty name="reportEndDateTime" />
	<cfproperty name="reportDateTimeGroupBy" />
	
	<!--- Definition Properties --->
	<cfproperty name="metricDefinitions" />
	<cfproperty name="dimensionDefinitions" />
	
	<!--- Metric / Dimension States --->
	<cfproperty name="metrics" />
	<cfproperty name="dimensions" />
	
	<!--- Data Properties & Queries ---> 
	<cfproperty name="data" />
	<cfproperty name="chartDataQuery" />
	<cfproperty name="chartData" />
	<cfproperty name="tableDataQuery" />
	
	<!--- Rendered Data Properties --->
	<cfproperty name="reportDataTable" />
	
	<!--- Title Methods --->
	<cffunction name="getReportTitle">
		<cfreturn rbKey('report.#getClassName()#') />
	</cffunction>
	
	<cffunction name="getMetricTitle">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var metricDefinition = {} />
		
		<cfloop array="#getMetricDefinitions()#" index="metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias and structKeyExists(metricDefinition, 'title')>
				<cfreturn metricDefinition.title />
			</cfif>
		</cfloop>
		
		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>
	
	<cffunction name="getDimensionTitle">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var dimensionDefinition = {} />
		
		<cfloop array="#getDimensionDefinitions()#" index="dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias and structKeyExists(dimensionDefinition, 'title')>
		 		<cfreturn dimensionDefinition.title />
			</cfif>
		</cfloop>
		
		<cfreturn rbKey('report.#getClassName()#.#alias#') />
	</cffunction>
	
	<!--- Date / Time Defaults --->
	<cffunction name="getReportStartDateTime">
		<cfif not structKeyExists(variables, "reportStartDateTime")>
			<cfset variables.reportStartDateTime = dateFormat(now() - 30, "yyyy-mm-dd") />
		</cfif>
		<cfreturn variables.reportStartDateTime />
	</cffunction>
	
	<cffunction name="getReportEndDateTime">
		<cfif not structKeyExists(variables, "reportEndDateTime")>
			<cfset variables.reportEndDateTime = dateFormat(now(), "yyyy-mm-dd") />
		</cfif>
		<cfreturn variables.reportEndDateTime />
	</cffunction>
	
	<cffunction name="getReportDateTimeGroupBy">
		<cfif not structKeyExists(variables, "reportDateTimeGroupBy")>
			<cfset variables.reportDateTimeGroupBy = "day" />
		</cfif>
		<cfreturn variables.reportDateTimeGroupBy />
	</cffunction>
	
	<!--- Date / Time Helpers --->
	<cffunction name="getReportDateTimeSelect">
		<cfargument name="column" />
		
		<cfset var reportDateTimeSelect="" />
		<cfsavecontent variable="reportDateTimeSelect">
			<cfoutput>
				<cfif getApplicationValue('databaseType') eq "MySQL">
					YEAR( #arguments.column# ) as reportDateTimeYear,
					MONTH( #arguments.column# ) as reportDateTimeMonth,
					WEEK( #arguments.column# ) as reportDateTimeWeek,
					DAY( #arguments.column# ) as reportDateTimeDay,
					HOUR( #arguments.column# ) as reportDateTimeHour
				<cfelse>
					DATEPART( year, #arguments.column# ) as reportDateTimeYear,
					DATEPART( month, #arguments.column# ) as reportDateTimeMonth,
					DATEPART( week, #arguments.column# ) as reportDateTimeWeek,
					DATEPART( day, #arguments.column# ) as reportDateTimeDay,
					DATEPART( hour, #arguments.column# ) as reportDateTimeHour  
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn reportDateTimeSelect />
	</cffunction>
	
	<!--- Definition Defaults --->
	<cffunction name="getMetricDefinitions">
		<cfreturn [] />
	</cffunction>
	
	<cffunction name="getDimensionDefinitions">
		<cfreturn [] />
	</cffunction>
	
	<!--- Definition Helper Methods --->
	<cffunction name="getMetricDefinition">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var metricDefinition = structNew() />
		
		<cfloop array="#getMetricDefinitions()#" index="metricDefinition">
			<cfif metricDefinition.alias eq arguments.alias>
				<cfreturn metricDefinition />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getDimensionDefinition">
		<cfargument name="alias" type="string" required="true" />
		
		<cfset var dimensionDefinition = structNew() />
		
		<cfloop array="#getDimensionDefinitions()#" index="dimensionDefinition">
			<cfif dimensionDefinition.alias eq arguments.alias>
				<cfreturn dimensionDefinition />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- Metric / Dimension State Defaults --->
	<cffunction name="getMetrics">
		<cfif not structKeyExists(variables, "metrics")>
			<cfset variables.metrics = getMetricDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.metrics />
	</cffunction>
	
	<cffunction name="getDimensions">
		<cfif not structKeyExists(variables, "dimensions")>
			<cfset variables.dimensions = getDimensionDefinitions()[1].alias />
		</cfif>
		<cfreturn variables.dimensions />
	</cffunction>
	
	<!--- Data / Query Methods --->
	<cffunction name="getChartDataQuery">
		<cfif not structKeyExists(variables, "chartDataQuery")>
			
			<cfset var m = 1 />
			<cfset var data = getData() />
			
			<cfquery name="variables.chartDataQuery" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
				FROM
					data
				GROUP BY
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
				ORDER BY
					<cfif listFindNoCase('year,month,week,day,hour', getReportDateTimeGroupBy())>
						data.reportDateTimeYear
					</cfif>
					<cfif listFindNoCase('month,week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeMonth
					</cfif>
					<cfif listFindNoCase('week,day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeWeek
					</cfif>
					<cfif listFindNoCase('day,hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeDay
					</cfif>
					<cfif listFindNoCase('hour', getReportDateTimeGroupBy())>
						,data.reportDateTimeHour
					</cfif>
			</cfquery>
		</cfif>
		
		<cfreturn variables.chartDataQuery />
	</cffunction>
	
	<cffunction name="getChartData">
		<cfif not structKeyExists(variables, "chartData")>
			
			<cfset var chartDataQuery = getChartDataQuery() />
			<cfset var chartDataStruct = structNew() />
			
			<cfset var thisDate = "" />
			<cfset var m = 1 />
			<cfset var loopdatepart = "d" />
			
			<cfif getReportDateTimeGroupBy() eq 'year'>
				<cfset loopdatepart = "yyyy" />
			<cfelseif getReportDateTimeGroupBy() eq 'month'>
				<cfset loopdatepart = "m" />
			<cfelseif getReportDateTimeGroupBy() eq 'week'>
				<cfset loopdatepart = "ww" />
			<cfelseif getReportDateTimeGroupBy() eq 'hour'>
				<cfset loopdatepart = "h" />	
			</cfif>
			
			<cfset variables.chartData = {} />
			<cfset variables.chartData["chart"] = {} />
			<cfset variables.chartData["chart"]["type"] = "line" />
			<cfset variables.chartData["legend"] = {} />
			<cfset variables.chartData["legend"]["enabled"] = false />
			<cfset variables.chartData["title"] = {} />
			<cfset variables.chartData["title"]["text"] = getReportTitle() />
			<cfset variables.chartData["xAxis"] = {} />
			<cfset variables.chartData["xAxis"]["type"] = "datetime" />
			<cfset variables.chartData["yAxis"] = {} />
			<cfset variables.chartData["yAxis"]["title"] = {} />
			<cfset variables.chartData["yAxis"]["title"]["text"] = '' />
			<cfset variables.chartData["series"] = [] />
			
			<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
				<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
				
				<cfset arrayAppend(variables.chartData["series"], {})>
				<cfset variables.chartData["series"][m]["name"] = getMetricTitle(metricDefinition.alias) />
				<cfset variables.chartData["series"][m]["data"] = [] />
				
				<cfset var chartRow = 1 />
				
				<cf_HibachiDateLoop index="thisDate" from="#getReportStartDateTime()#" to="#getReportEndDateTime()#" datepart="#loopdatepart#">
					<cfset var thisData = [] />
					<cfset arrayAppend(thisData, dateDiff("s", createdatetime( '1970','01','01','00','00','00' ), dateAdd("h", 1, thisDate))*1000) />
					<cfif year(thisDate) eq chartDataQuery['reportDateTimeYear'][chartRow] and 
							(!listFindNoCase('month,day,hour', getReportDateTimeGroupBy()) or month(thisDate) eq chartDataQuery['reportDateTimeMonth'][chartRow]) and
							(!listFindNoCase('day,hour', getReportDateTimeGroupBy()) or day(thisDate) eq chartDataQuery['reportDateTimeDay'][chartRow]) and
							(!listFindNoCase('hour', getReportDateTimeGroupBy()) or hour(thisDate) eq chartDataQuery['reportDateTimeHour'][chartRow])>
						<cfset arrayAppend(thisData, chartDataQuery[ metricDefinition.alias ][ chartRow ]) />
						<cfset chartRow ++ />
					<cfelse>
						<cfset arrayAppend(thisData, 0) />
					</cfif>
					<cfset arrayAppend(variables.chartData["series"][m]["data"], thisData) />
				</cf_HibachiDateLoop>
			</cfloop>
		</cfif>
		
		<cfreturn variables.chartData />
	</cffunction>
	
	<cffunction name="getTableDataQuery">
		<cfif not structKeyExists(variables, "tableDataQuery")>
			
			<cfset var data = getData() />
			<cfset var unsortedData = "" />
			<cfset var m = 1 />
			<cfset var d = 1 />
			
			<cfquery name="unsortedData" dbtype="query">
				SELECT
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>
						<cfif structKeyExists(metricDefinition, "calculation")>
							#metricDefinition.calculation# as #metricDefinition.alias#
						<cfelse>
							#metricDefinition.function#(#metricDefinition.alias#) as #metricDefinition.alias#
						</cfif>
					</cfloop>
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						,#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
				FROM
					data
				GROUP BY
					<cfloop from="1" to="#listLen(getDimensions())#" step="1" index="d">
						<cfset var dimensionDefinition = getDimensionDefinition( listGetAt(getDimensions(), d) ) />
						<cfif d gt 1>,</cfif>
						#dimensionDefinition.alias#
						<cfif structKeyExists(dimensionDefinition, "filterAlias")>
							,#dimensionDefinition.filterAlias#
						</cfif>
					</cfloop>
			</cfquery>
			
			<cfquery name="variables.tableDataQuery" dbtype="query">
				SELECT
					*
				FROM
					unsortedData
				ORDER BY
					<cfloop from="1" to="#listLen(getMetrics())#" step="1" index="m">
						<cfset var metricDefinition = getMetricDefinition( listGetAt(getMetrics(), m) ) />
						<cfif m gt 1>,</cfif>#metricDefinition.alias#
					</cfloop>
			</cfquery>
		</cfif>
		
		<cfreturn variables.tableDataQuery />
	</cffunction>
	
	<cffunction name="getReportDataTable">
		<cfif(!structKeyExists(variables, "reportDataTable"))>
			<cfsavecontent variable="variables.reportDataTable">
				<cf_HibachiReportDataTable report="#this#">
			</cfsavecontent>
		</cfif>
		
		<cfreturn variables.reportDataTable />
	</cffunction>
</cfcomponent>