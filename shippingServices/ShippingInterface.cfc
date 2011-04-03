<cfinterface>
	
	<cffunction name="init" access="public" returntype="any">
	</cffunction>
	
	<cffunction name="getRates" access="public" returntype="Slatwall.com.utility.shipping.RatesResponseBean">
		<cfargument name="orderShipping" type="any" required="true" />
		
		<!---
			This method should take in a given order shipment and based
			upon the items in that shipment as well as the address, it
			should calculate shipping rates for each of	the methods that
			are available from this provider 
		--->
	</cffunction>
	
	<cffunction name="getTracking" access="public" returntype="Slatwall.com.utility.shipping.TrackingResponseBean">
		<cfargument name="trackingNumber" type="string" required="true" />
		
		<!---
			This method takes a tracking number and passes back a
			tracking response bean that has the details reguarding
			a specific shipment.
		--->
	</cffunction>
	
	<cffunction name="createShipment" access="public" returntype="Slatwall.com.utility.shipping.ShipmentResponseBean">
		<cfargument name="orderShipment" type="any" required="true" />
		
		<!---
			This method should take an order shipment object, and pass
			the necessary information with the service provider to generate
			a lable and create a shipment
		--->
	</cffunction> 
	
	<cffunction name="getShippingMethods" access="public" returntype="Struct">
		
		<!--- 
			This method should return a struct where the Key
			is the method ID, and the value is the legible name.
			
			For Example:
			var methods = {GRND="UPS Ground",2DAY="2nd Day Express"}
			
			The keys that are provided by this function should match the keys used for
			getting rates as well as creating shipments.
		--->
	</cffunction> 
</cfinterface>