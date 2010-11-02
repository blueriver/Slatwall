<cfcomponent output="false" name="orderManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="orderDAO" type="any" required="yes"/>
		<cfargument name="orderGateway" type="any" required="yes"/>
	
		<cfset variables.DAO=arguments.orderDAO />
		<cfset variables.Gateway=arguments.orderGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="OrderID" type="String" />
	
		<cfreturn variables.DAO.read(arguments.OrderID) />
	</cffunction>
	
	<cffunction name="getAllOrdersQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllOrdersQuery() />
	</cffunction>
	
	<cffunction name="getOpenOrdersQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getOpenOrdersQuery() />
	</cffunction>
	
	<cffunction name="getAllOpenOrderItemsQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllOpenOrderItemsQuery() />
	</cffunction>
	
	<cffunction name="getAllOrderAlertsQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllOrderAlertsQuery() />
	</cffunction>
	
	<cffunction name="getOrderAlertsQuery" access="public" returntype="query" output="false">
		<cfargument name="OrderID" type="string" />
		<cfreturn variables.Gateway.getOrderAlertsQuery(OrderID=arguments.OrderID) />
	</cffunction> 
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('OrderID',3) />
		<cfset QueryOrganizer.addKeywordColumn('CustomerName',6) />
		<cfreturn QueryOrganizer />
	</cffunction>
	
	<cffunction name="getOrderIterator" access="public" output="false" returntype="any">
		<cfargument name="OrderQuery" type="query" required="true">
		
		<cfset var orderIterator=createObject("component","orderIterator").init() />
		<cfset orderIterator.setQuery(arguments.OrderQuery, 100) />
		<cfreturn orderIterator />
	</cffunction>
	
	<cffunction name="getOrderItemsQuery" access="public" output="false" returntype="query">
		<cfargument name="OrderID" type="string" required="true" />
		<cfreturn variables.Gateway.getOrderItemsQuery(OrderID=arguments.OrderID) />
	</cffunction>
	
	<cffunction name="getOrderItemIterator" access="public" output="false" returntype="any">
		<cfargument name="OrderItemQuery" type="query" required="true" />
		
		<cfset var orderItemIterator=createObject("component","orderItemIterator").init() />
		<cfset orderItemIterator.setQuery(arguments.OrderItemQuery) />
		<cfreturn orderItemIterator />
	</cffunction>
	
	
</cfcomponent>
