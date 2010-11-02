<cfcomponent output="false" name="orderItemBean" extends="slat.lib.sku.skuBean" hint="Container Object For Core Order Item Information">
	
	<cfset variables.instance.OrderItemID = "" />
	<cfset variables.instance.OrderQuantity = 0 />
	<cfset variables.instance.OrderOriginalQuantity = 0 />
	<cfset variables.instance.OrderQuantityShipped = 0 />
	<cfset variables.instance.TotalTaxCharge = 0 />
	<cfset variables.instance.TotalTaxRate = 0 />
	<cfset variables.instance.ExpectedShipDate = "" />
	<cfset variables.instance.Notes = "" />
	
	<cffunction name="getOrderItemID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderItemID />
    </cffunction>
    <cffunction name="setOrderItemID" access="private" output="false" hint="">
    	<cfargument name="OrderItemID" type="string" required="true" />
    	<cfset variables.instance.OrderItemID = trim(arguments.OrderItemID) />
    </cffunction>
    
	<cffunction name="getOrderQuantity" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderQuantity />
    </cffunction>
    <cffunction name="setOrderQuantity" access="private" output="false" hint="">
    	<cfargument name="OrderQuantity" type="numeric" required="true" />
    	<cfset variables.instance.OrderQuantity = trim(arguments.OrderQuantity) />
    </cffunction>
	
	<cffunction name="getOrderOriginalQuantity" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderOriginalQuantity />
    </cffunction>
    <cffunction name="setOrderOriginalQuantity" access="private" output="false" hint="">
    	<cfargument name="OrderOriginalQuantity" type="numeric" required="true" />
    	<cfset variables.instance.OrderOriginalQuantity = trim(arguments.OrderOriginalQuantity) />
    </cffunction>
	
	<cffunction name="getOrderQuantityShipped" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OrderQuantityShipped />
    </cffunction>
    <cffunction name="setOrderQuantityShipped" access="private" output="false" hint="">
    	<cfargument name="OrderQuantityShipped" type="numeric" required="true" />
    	<cfset variables.instance.OrderQuantityShipped = trim(arguments.OrderQuantityShipped) />
    </cffunction>
    
    <cffunction name="getTotalTaxCharge" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.TotalTaxCharge />
    </cffunction>
    <cffunction name="setTotalTaxCharge" access="private" output="false" hint="">
    	<cfargument name="TotalTaxCharge" type="numeric" required="true" />
    	<cfset variables.instance.TotalTaxCharge = trim(arguments.TotalTaxCharge) />
    </cffunction>
    
    <cffunction name="getTotalTaxRate" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.TotalTaxRate />
    </cffunction>
    <cffunction name="setTotalTaxRate" access="private" output="false" hint="">
    	<cfargument name="TotalTaxRate" type="numeric" required="true" />
    	<cfset variables.instance.TotalTaxRate = trim(arguments.TotalTaxRate) />
    </cffunction>
    
	<cffunction name="getExpectedShipDate" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.ExpectedShipDate />
    </cffunction>
    <cffunction name="setExpectedShipDate" access="private" output="false" hint="">
    	<cfargument name="ExpectedShipDate" type="string" required="true" />
    	<cfset variables.instance.ExpectedShipDate = trim(arguments.ExpectedShipDate) />
    </cffunction>
	
	<cffunction name="getNotes" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Notes />
    </cffunction>
    <cffunction name="setNotes" access="private" output="false" hint="">
    	<cfargument name="Notes" type="string" required="true" />
    	<cfset variables.instance.Notes = trim(arguments.Notes) />
    </cffunction>    
    
</cfcomponent>