<cfinterface>
	
	<cffunction name="init" access="public" returntype="any">
	</cffunction>
	
	<cffunction name="getRates" access="public" returntype="Slatwall.com.utility.shipping.RatesResponseBean" output="false">
		<cfargument name="orderShipping" required="true" />
	
	</cffunction>
	
</cfinterface>