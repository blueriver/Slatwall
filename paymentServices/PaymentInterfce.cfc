<cfinterface>
	
	<cffunction name="init" access="public" returntype="any">
	</cffunction>
	
	<cffunction name="AuthorizeOnly" access="public" returntype="Slatwall.com.utility.shipping.AuthorizeOnlyResponseBean">
		<cfargument name="orderPayment" type="Slatwall.com.entity.OrderPayment" required="true" />
	
	</cffunction>
	
	<cffunction name="AuthorizeAndCharge" access="public" returntype="Slatwall.com.utility.shipping.AuthorizeAndChargeResponseBean">
		<cfargument name="orderPayment" type="Slatwall.com.entity.OrderPayment" required="true" />
	
	</cffunction>
	
	<cffunction name="ChargeOnly" access="public" returntype="Slatwall.com.utility.shipping.AuthorizeAndChargeResponseBean">
		<cfargument name="orderPayment" type="Slatwall.com.entity.OrderPayment" required="true" />
	
	</cffunction>
	
	
</cfinterface>