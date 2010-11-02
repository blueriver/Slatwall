<cfcomponent output="false" name="orderGateway" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllOrdersQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getOrderQuery() />
	</cffunction>
	
	<cffunction name="getOpenOrdersQuery" access="package" output="false" retruntype="query">
		<cfreturn application.Slat.integrationManager.getOrderQuery(IsOpen=1) />
	</cffunction>
	
	<cffunction name="getOrderItemsQuery" access="package" output="false" retruntype="query">
		<cfargument name="OrderID" required="true">
		
		<cfreturn application.Slat.integrationManager.getOrderItemsQuery(OrderID=arguments.OrderID) />
	</cffunction>
	
	<cffunction name="getAllOpenOrderItemsQuery" access="package" output="false" retruntype="query">
		<cfif not isDefined('request.slat.AllOpenOrderItemsQuery')>
			<cfset request.slat.AllOpenOrderItemsQuery = application.Slat.integrationManager.getOrderItemsQuery(IsOpen=1) />
		</cfif>
		<cfreturn request.slat.AllOpenOrderItemsQuery />
	</cffunction>
	
	<cffunction name="getAllOrderAlertsQuery" access="package" output="false" retruntype="query">
		<cfset var AllOpenOrderItems = querynew('empty') />
		<cfset var CheckA = querynew('empty') />
		<cfset var CheckB = querynew('empty') />
		<cfset var CheckC = querynew('empty') />
		
		<cfif not isDefined('request.slat.AllOrderAlertsQuery')>
			<cfset AllOpenOrderItems = getAllOpenOrderItemsQuery() />
			
			<cfquery dbtype="query" name="CheckA">
				SELECT
					OrderID,
					SkuCode,
					'Not on an Open PO' as Alert
				FROM
					AllOpenOrderItems
				WHERE
					QC > (QOO + QOH)
				  AND
				  	NonInventoryItem = '0'
			</cfquery>
			
			<cfquery dbtype="query" name="CheckB">
				SELECT
					OrderID,
					SkuCode,
					'QOH is Less than 0' as Alert
				FROM
					AllOpenOrderItems
				WHERE
					QOH < 0
			  UNION
				SELECT
					OrderID,
					SkuCode,
					Alert
				FROM
					CheckA
			</cfquery>
			
			<cfquery dbtype="query" name="CheckC">
				SELECT
					OrderID,
					SkuCode,
					'Past the Expected Ship Date' as Alert
				FROM
					AllOpenOrderItems
				WHERE
					OrderQuantityShipped < OrderQuantity
				  AND
				  	ExpectedShipDate < <cfqueryparam value="#DateFormat(now(),"MM/DD/YYYY")#" cfsqltype="varchar" />

			  UNION
				SELECT
					OrderID,
					SkuCode,
					Alert
				FROM
					CheckB
			</cfquery>
			
			<cfset request.slat.AllOrderAlertsQuery = CheckC />
		</cfif>
		
		<cfreturn request.slat.AllOrderAlertsQuery />
	</cffunction>
	
	<cffunction name="getOrderAlertsQuery" access="package" output="false" retruntype="query">
		<cfargument name="OrderID" type="string">
		<cfset var OrderAlerts = querynew('empty') />
		<cfset var AllOrderAlertsQuery = getAllOrderAlertsQuery() />
		
		<cfquery dbtype="query" name="OrderAlerts">
			Select
				Alert,
				Count(OrderID) as AlertCount
			From
				AllOrderAlertsQuery
			Where
				OrderID = <cfqueryparam value="#arguments.OrderID#" cfsqltype="varchar" />
			Group By
				Alert
		</cfquery>
		
		<cfreturn OrderAlerts />
	</cffunction>
	
</cfcomponent>
