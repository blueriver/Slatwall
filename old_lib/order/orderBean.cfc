<cfcomponent output="false" name="orderBean" extends="slat.lib.coreBean" hint="Container Object For Core Order Information">
	
	<cfset variables.instance.OrderID = "" />
	<cfset variables.instance.DatePlaced = "" />
	<cfset variables.instance.DateLastUpdated = "" />
	<cfset variables.instance.IsOpen = 1 />
	<cfset variables.instance.OrderTotal = 0 />
	<cfset variables.instance.TotalShipping = 0 />
	<cfset variables.instance.TotalTax = 0 />
	<cfset variables.instance.TotalSavings = 0 />
	<cfset variables.instance.TotalAuthorized = 0 />
	<cfset variables.instance.TotalCharged = 0 />
	<cfset variables.instance.TerminalID = "" />
	<cfset variables.instance.WarehouseID = "" />
	<cfset variables.instance.OrderType = "" />
	<cfset variables.instance.OrderStatus = "" />
	<cfset variables.instance.CustomerName = "" />
	<cfset variables.instance.CustomerID = "" />
	<cfset variables.instance.Notes = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<!--- START OBJECT GETTER / SETTERS --->
	
	<cffunction name="getOrderID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderID />
    </cffunction>
    <cffunction name="setOrderID" access="private" output="false" hint="">
    	<cfargument name="OrderID" type="string" required="true" />
    	<cfset variables.instance.OrderID = trim(arguments.OrderID) />
    </cffunction>
    
	<cffunction name="getDatePlaced" returntype="string" access="public" output="false" hint="">
    	<cfreturn DateFormat(variables.instance.DatePlaced, "MM/DD/YYYY") />
    </cffunction>
    <cffunction name="setDatePlaced" access="private" output="false" hint="">
    	<cfargument name="DatePlaced" type="string" required="true" />
    	<cfset variables.instance.DatePlaced = trim(arguments.DatePlaced) />
    </cffunction>
	
	<cffunction name="getDateLastUpdated" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.DateLastUpdated />
    </cffunction>
    <cffunction name="setDateLastUpdated" access="private" output="false" hint="">
    	<cfargument name="DateLastUpdated" type="string" required="true" />
    	<cfset variables.instance.DateLastUpdated = trim(arguments.DateLastUpdated) />
    </cffunction>
	
	<cffunction name="getIsOpen" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.IsOpen />
    </cffunction>
    <cffunction name="setIsOpen" access="private" output="false" hint="">
    	<cfargument name="IsOpen" type="numeric" required="true" />
    	<cfset variables.instance.IsOpen = trim(arguments.IsOpen) />
    </cffunction>
    
	<cffunction name="getOrderTotal" returntype="any" access="public" output="false" hint="">
		<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.OrderTotal) />
		<cfelse>
			<cfreturn variables.instance.OrderTotal />
		</cfif>
    </cffunction>
    <cffunction name="setOrderTotal" access="private" output="false" hint="">
    	<cfargument name="OrderTotal" type="numeric" required="true" />
    	<cfset variables.instance.OrderTotal = trim(arguments.OrderTotal) />
    </cffunction>
    
	<cffunction name="getTotalShipping" returntype="any" access="public" output="false" hint="">
    	<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.TotalShipping) />
		<cfelse>
			<cfreturn variables.instance.TotalShipping />
		</cfif>
    </cffunction>
    <cffunction name="setTotalShipping" access="private" output="false" hint="">
    	<cfargument name="TotalShipping" type="numeric" required="true" />
    	<cfset variables.instance.TotalShipping = trim(arguments.TotalShipping) />
    </cffunction>
	
	<cffunction name="getTotalTax" returntype="any" access="public" output="false" hint="">
    	<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.TotalTax) />
		<cfelse>
			<cfreturn variables.instance.TotalTax />
		</cfif>
    </cffunction>
    <cffunction name="setTotalTax" access="private" output="false" hint="">
    	<cfargument name="TotalTax" type="numeric" required="true" />
    	<cfset variables.instance.TotalTax = trim(arguments.TotalTax) />
    </cffunction>
	
	<cffunction name="getTotalSavings" returntype="any" access="public" output="false" hint="">
    	<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.TotalSavings) />
		<cfelse>
			<cfreturn variables.instance.TotalSavings />
		</cfif>
    </cffunction>
    <cffunction name="setTotalSavings" access="private" output="false" hint="">
    	<cfargument name="TotalSavings" type="numeric" required="true" />
    	<cfset variables.instance.TotalSavings = trim(arguments.TotalSavings) />
    </cffunction>
    
    <cffunction name="getTotalAuthorized" returntype="any" access="public" output="false" hint="">
    	<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.TotalAuthorized) />
		<cfelse>
			<cfreturn variables.instance.TotalAuthorized />
		</cfif>
    </cffunction>
    <cffunction name="setTotalAuthorized" access="private" output="false" hint="">
    	<cfargument name="TotalAuthorized" type="numeric" required="true" />
    	<cfset variables.instance.TotalAuthorized = trim(arguments.TotalAuthorized) />
    </cffunction>
	
	<cffunction name="getTotalCharged" returntype="any" access="public" output="false" hint="">
    	<cfargument name="format" default="$" />
		<cfif arguments.format eq '$'>
    		<cfreturn DollarFormat(variables.instance.TotalCharged) />
		<cfelse>
			<cfreturn variables.instance.TotalCharged />
		</cfif>
    </cffunction>
    <cffunction name="setTotalCharged" access="private" output="false" hint="">
    	<cfargument name="TotalCharged" type="numeric" required="true" />
    	<cfset variables.instance.TotalCharged = trim(arguments.TotalCharged) />
    </cffunction>
	
	<cffunction name="getTerminalID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.TerminalID />
    </cffunction>
    <cffunction name="setTerminalID" access="private" output="false" hint="">
    	<cfargument name="TerminalID" type="string" required="true" />
    	<cfset variables.instance.TerminalID = trim(arguments.TerminalID) />
    </cffunction>
	
	<cffunction name="getWarehouseID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.WarehouseID />
    </cffunction>
    <cffunction name="setWarehouseID" access="private" output="false" hint="">
    	<cfargument name="WarehouseID" type="string" required="true" />
    	<cfset variables.instance.WarehouseID = trim(arguments.WarehouseID) />
    </cffunction>
	
	<cffunction name="getOrderType" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderType />
    </cffunction>
    <cffunction name="setOrderType" access="private" output="false" hint="">
    	<cfargument name="OrderType" type="string" required="true" />
    	<cfset variables.instance.OrderType = trim(arguments.OrderType) />
    </cffunction>
    
	<cffunction name="getOrderStatus" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderStatus />
    </cffunction>
    <cffunction name="setOrderStatus" access="private" output="false" hint="">
    	<cfargument name="OrderStatus" type="string" required="true" />
    	<cfset variables.instance.OrderStatus = trim(arguments.OrderStatus) />
    </cffunction>
    
    <cffunction name="getCustomerName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CustomerName />
    </cffunction>
    <cffunction name="setCustomerName" access="private" output="false" hint="">
    	<cfargument name="CustomerName" type="string" required="true" />
    	<cfset variables.instance.CustomerName = trim(arguments.CustomerName) />
    </cffunction>
	
	<cffunction name="getCustomerID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CustomerID />
    </cffunction>
    <cffunction name="setCustomerID" access="private" output="false" hint="">
    	<cfargument name="CustomerID" type="string" required="true" />
    	<cfset variables.instance.CustomerID = trim(arguments.CustomerID) />
    </cffunction>
	
	<cffunction name="getNotes" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Notes />
    </cffunction>
    <cffunction name="setNotes" access="private" output="false" hint="">
    	<cfargument name="Notes" type="string" required="true" />
    	<cfset variables.instance.Notes = trim(arguments.Notes) />
    </cffunction>
	
	<!--- END OBJECT GETTER / SETTERS --->
	<!--- START OBJECT CALCULATIONS --->
	
	<cffunction name="getTotalDue" returntype="any" access="public" output="false" hint="">
		<cfargument name="format" default="$" />
		<cfif arguments.format eq '$' >
    		<cfreturn DollarFormat(variables.instance.OrderTotal - variables.instance.TotalCharged) />
		<cfelse>
			<cfreturn variables.instance.OrderTotal - variables.instance.TotalCharged />
		</cfif>
    </cffunction>
	
	<!--- END OBJECT CALCULATIONS --->
	<!--- START RELATED OBJECTS --->
	
	<cffunction name="getOrderItemsQuery" returnType="query" output="false" access="public">
		<cfif not isDefined('variables.instance.OrderItemsQuery')>
			<cfset variables.instance.OrderItemsQuery = application.slat.orderManager.getOrderItemsQuery(OrderID=variables.instance.OrderID) />
		</cfif>
		<cfreturn variables.instance.OrderItemsQuery />
	</cffunction>
	
	<cffunction name="getOrderItemIterator" returnType="any" output="false" access="public">
		<cfreturn application.slat.orderManager.getOrderItemIterator(getOrderItemsQuery()) />
	</cffunction>
	
	<cffunction name="getOrderAlertsQuery" returnType="any" output="false" access="public">
		<cfreturn application.slat.orderManager.getOrderAlertsQuery(OrderID=variables.instance.OrderID) />
	</cffunction>

	<!--- END RELATED OBJECTS --->
	
</cfcomponent>