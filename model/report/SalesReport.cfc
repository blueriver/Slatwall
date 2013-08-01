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
<cfcomponent extends="Slatwall.org.Hibachi.HibachiReport">
	
	<cfproperty name="reportDateTimeStart" />
	<cfproperty name="reportDateTimeEnd" />
	<cfproperty name="data" />
	
	<cffunction name="getData" returnType="Query">
		
		<cfif not structKeyExists(variables, "data")>
			<cfquery name="variables.data">
				SELECT
					SlatwallSku.skuID,
					SlatwallSku.skuCode,
					SlatwallProduct.productID,
					SlatwallProduct.productName,
					(SlatwallOrderItem.price * SlatwallOrderItem.quantity) as extendedPrice,
					#getReportDateTimeSelect('SlatwallOrder.orderOpenDateTime')#
				FROM
					SlatwallOrderItem
				  INNER JOIN
				  	SlatwallOrderFulfillment on SlatwallOrderItem.orderFulfillmentID = SlatwallOrderFulfillment.orderFulfillmentID
				  INNER JOIN
				  	SlatwallOrder on SlatwallOrderFulfillment.orderID = SlatwallOrder.orderID
				  INNER JOIN
				  	SlatwallAccount on SlatwallOrder.accountID = SlatwallAccount.accountID
				  INNER JOIN
				  	SlatwallSku on SlatwallOrderItem.skuID = SlatwallSku.skuID
				  INNER JOIN
				  	SlatwallProduct on SlatwallSku.productID = SlatwallProduct.productID
				  INNER JOIN
				  	SlatwallProductType on SlatwallProduct.productTypeID = SlatwallProductType.productTypeID
				WHERE
					SlatwallOrder.orderOpenDateTime is not null
			</cfquery>
		</cfif>
		
		<cfreturn variables.data />
	</cffunction>
	
	<cffunction name="getReportDateTimeSelect">
		<cfargument name="column" />
		
		<cfset var reportDateTimeSelect="" />
		<cfsavecontent variable="reportDateTimeSelect">
			<cfoutput>
				<cfif getApplicationValue('databaseType') eq "MySQL">
					YEAR( #arguments.column# ) as reportDateTimeYear,
					MONTH( #arguments.column# ) as reportDateTimeMonth,
					DAY( #arguments.column# ) as reportDateTimeDay,
					HOUR( #arguments.column# ) as reportDateTimeHour
				<cfelse>
					DATEPART( year, #arguments.column# ) as reportDateTimeYear,
					DATEPART( month, #arguments.column# ) as reportDateTimeMonth,
					DATEPART( day, #arguments.column# ) as reportDateTimeDay,
					DATEPART( hour, #arguments.column# ) as reportDateTimeHour  
				</cfif>
			</cfoutput>
		</cfsavecontent>
		<cfreturn reportDateTimeSelect />
	</cffunction>
	
	<cffunction name="getChartData">
		<cfif not structKeyExists(variables, "chartData")>
			
			<cfset var data = getData() />
			<cfset var chartDataQuery = "" />
			<cfset var chartDataStruct = structNew() />
			
			<cfquery name="chartDataQuery" dbtype="query">
				SELECT
					SUM(data.extendedPrice) as series1,
					data.reportDateTimeYear,
					data.reportDateTimeMonth,
					data.reportDateTimeDay
				FROM
					data
				GROUP BY
					data.reportDateTimeYear, data.reportDateTimeMonth, data.reportDateTimeDay
				ORDER BY
					data.reportDateTimeYear,
					data.reportDateTimeMonth,
					data.reportDateTimeDay
			</cfquery>
			
			<cfset chartDataStruct = {} />
			<cfset chartDataStruct["chart"] = {} />
			<cfset chartDataStruct["chart"]["type"] = "line" />
			<cfset chartDataStruct["title"] = {} />
			<cfset chartDataStruct["title"]["text"] = "Sales Report" />
			<cfset chartDataStruct["xAxis"] = {} />
			<cfset chartDataStruct["xAxis"]["categories"] = [] />
			<cfset chartDataStruct["yAxis"] = {} />
			<cfset chartDataStruct["yAxis"]["title"] = {} />
			<cfset chartDataStruct["yAxis"]["title"]["text"] = "Total Sales" />
			<cfset chartDataStruct["series"] = [] />
			<cfset arrayAppend(chartDataStruct["series"], {}) />
			<cfset chartDataStruct["series"][1]["name"] = "Product Revenue" />
			<cfset chartDataStruct["series"][1]["data"] = [] />
			
			<cfset var thisDate = "" />
			<cfset var firstDateTime = createDateTime(chartDataQuery['reportDateTimeYear'][1], chartDataQuery['reportDateTimeMonth'][1], chartDataQuery['reportDateTimeDay'][1], 0, 0, 0) />
			<cfset var lastDateTime = createDateTime(chartDataQuery['reportDateTimeYear'][chartDataQuery.recordCount], chartDataQuery['reportDateTimeMonth'][chartDataQuery.recordCount], chartDataQuery['reportDateTimeDay'][chartDataQuery.recordCount], 0, 0, 0) />
			<cfset var chartRow = 1 />
			<cfloop index="thisDate" from="#firstDateTime#" to="#lastDateTime#" step="#CreateTimeSpan( 1, 0, 0, 0 )#">
				<cfset arrayAppend(chartDataStruct["xAxis"]["categories"], dateFormat( thisDate, "mm/dd/yyyy" )) />
				<cfif year(thisDate) eq chartDataQuery['reportDateTimeYear'][chartRow] and month(thisDate) eq chartDataQuery['reportDateTimeMonth'][chartRow] and day(thisDate) eq chartDataQuery['reportDateTimeDay'][chartRow]>
					<cfset arrayAppend(chartDataStruct["series"][1]["data"], chartDataQuery['series1'][chartRow]) />
					<cfset chartRow ++ />
				<cfelse>
					<cfset arrayAppend(chartDataStruct["series"][1]["data"], 0) />
				</cfif>
			</cfloop>
			
			<cfset variables.chartData = serializeJSON(chartDataStruct) />
		</cfif>
		
		<cfreturn variables.chartData />
	</cffunction>
	
	<cffunction name="getTableData">
		<cfif not structKeyExists(variables, "tableData")>
			
			<cfset var data = getData() />
			<cfset var unsortedData = "" />
			
			<cfquery name="unsortedData" dbtype="query">
				SELECT
					SUM(data.extendedPrice) as series1,
					data.productID,
					data.productName
				FROM
					data
				GROUP BY
					data.productID, data.productName
			</cfquery>
			
			<cfquery name="variables.tableData" dbtype="query">
				SELECT
					*
				FROM
					unsortedData
				ORDER BY
					series1
			</cfquery>
		</cfif>
		
		<cfreturn variables.tableData />
	</cffunction>
</cfcomponent>