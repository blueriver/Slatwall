<cfcomponent output="false" name="shippingManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="shippingFedEx" type="any" required="yes"/>
		<cfargument name="shippingUPS" type="any" required="yes"/>
		<cfargument name="shippingUSPS" type="any" required="yes"/>
		
		<cfset variables.shippingFedEx=arguments.shippingFedEx />
		<cfset variables.shippingUPS=arguments.shippingUPS />
		<cfset variables.shippingUSPS=arguments.shippingUSPS />

		<cfreturn this />
	</cffunction>

	<cffunction name="getShippingRates" access="public" returntype="any">
		<cfargument name="CartShippingAddressID" required="true" />
		
		<cfset var TotalShipmentWeight = application.slat.cartManager.getCartTotalShipmentWeight(arguments.CartShippingAddressID) />
		
		<cfset var AllRates = structNew() />
		<cfset AllRates.Request = structNew() />
		<cfset AllRates.Request.StreetAddress = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].StreetAddress# />
		<cfset AllRates.Request.Locality = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Locality# />
		<cfset AllRates.Request.City = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].City# />
		<cfset AllRates.Request.State = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].State# />
		<cfset AllRates.Request.Postal = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].PostalCode# />
		<cfset AllRates.Request.Country = #Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Country# />
		<cfset AllRates.Errors = arraynew(1) />
		<cfset AllRates.FedEx = arraynew(1) />
		<cfset AllRates.UPS = arraynew(1) />
		<cfset AllRates.USPS = arraynew(1) />
		<cfset AllRates.Promotional = arraynew(1) />
		
		<cfset FedExRates = variables.shippingFedEx.getFedExRates(
			shipperAddress1 = '1054 2ND STREET',
			shipperCity = 'ENCINITAS',
			shipperState = 'CA',
			shipperZip = '92024',
			shipToAddress1 = '',
			shipToAddress2 = '',
			shipToCity = '#Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].City#',
			shipToState = '#getFedExFriendlyStateCode(Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].State,Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Country)#',
			shipToZip = '#Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].PostalCode#',
			shipToCountry = '#Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Country#',
			pkgWeight = "#TotalShipmentWeight#",
			pkgValue = "100"
			) 
			/>
		
		<cfif structKeyExists(FedExRates, "Rate")> 
			<cfset AllRates.FedEx = FedExRates.Rate />
		<cfelse>
			<cfset AllRates.Errors = FedExRates.Response />
		</cfif>
		
		<cfreturn AllRates />
	</cffunction>
	
	<cffunction name="getFriendlyShipMethodName" access="public" returntype="string" output="false">
		<cfargument name="ShippingMethod" required="true">
			
		<cfif arguments.ShippingMethod eq "FIRST_OVERNIGHT">
			<cfset arguments.ShippingMethod = "FedEx First Overnight" />
		<cfelseif arguments.ShippingMethod eq "PRIORITY_OVERNIGHT">
			<cfset arguments.ShippingMethod = "FedEx Priority Overnight" />
		<cfelseif arguments.ShippingMethod eq "STANDARD_OVERNIGHT">
			<cfset arguments.ShippingMethod = "FedEx Standard Overnight" />
		<cfelseif arguments.ShippingMethod eq "FEDEX_2_DAY">
			<cfset arguments.ShippingMethod = "FedEx 2 Day" />
		<cfelseif arguments.ShippingMethod eq "FEDEX_EXPRESS_SAVER">
			<cfset arguments.ShippingMethod = "FedEx Express Saver" />
		<cfelseif arguments.ShippingMethod eq "FEDEX_GROUND">
			<cfset arguments.ShippingMethod = "FedEx Ground" />
		<cfelseif arguments.ShippingMethod eq "INTERNATIONAL_ECONOMY">
			<cfset arguments.ShippingMethod = "FedEx International Economy" />
		<cfelseif arguments.ShippingMethod eq "INTERNATIONAL_PRIORITY">
			<cfset arguments.ShippingMethod = "FedEx International Priority" />
		</cfif>
		
		<cfreturn arguments.ShippingMethod />
	</cffunction>
	
	<cffunction name="getFedExFriendlyStateCode" access="public" returntype="string" output="false">
		<cfargument name="StateCode" required="true">
		<cfargument name="CountryCode" required="true">
			
		<cfset var rs = querynew('empty') />
			
		<cfif len(arguments.StateCode) gt 2>
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				SELECT
					FedExState as 'FedExState'
				FROM
					tslatstates
				WHERE
					countrycode = '#arguments.CountryCode#'
				  and
				  	statecode = '#arguments.StateCode#'
			</cfquery>
			<cfif rs.recordcount gt 0>
				<cfset arguments.StateCode = rs.FedExState />
			<cfelse>
				<cfset arguments.StateCode = Left(arguments.StateCode,2) />
			</cfif>
		</cfif>
		
		<cfreturn arguments.StateCode />
	</cffunction>
	
	<cffunction name="isShippingDate" access="public" returntype="numeric">
		<cfargument name="Date" required="true" />
		
		<cfset return = 1>
		
		<cfif DayOfWeek(arguments.Date) eq 1 or DayOfWeek(arguments.Date) eq 7>
			<cfset return = 0>
		</cfif>
		
		<cfreturn return>
	</cffunction>
</cfcomponent>