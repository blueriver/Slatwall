<!---
	Name         : rateservice.cfc
	Author       : Raymond Camden 
	Created      : December 21, 2006
	Last Updated : January 5, 2007
	History      : Handle warnings that aren't true errors. Copy then to new responsewarning field. (rkc 1/5/07)
	Purpose		 : Rate and Service Info

Ray's Docs to help me keep things straight:

Package XML:
<Package>
	<PackagingType>
		<Code>package type</Code>
	</PackagingType>
	<Dimensions (optional)>
		<UnitOfMeasurement (optional)>
			<Code>IN</Code>
		</UnitOfMeasurement>
		<Length>between 1 and 108 applies to all 3</Length>
		<Width>..</Width>
		<Height>..</Height>
	</Dimensions>
	<DimensionalWeight (optional)>
		<UnitOfMeasurement>
			<Code>LBS or KGS</Code>
		</UnitOfMeasurement>
	</DimensionalWeight>
	<PackageWeight (optional)>
		<UnitOfMeasurement>
			<Code>LBS or KGS</Code>
		</UnitOfMeasurement>
		<Weight>0 if package is a letter, else 0.1-150.0</Weight>
	</PackageWeight>
	<OversizePackage (optional)>1=oversize1,2=oversize2,3=oversize3</OversizePackage>
	<PackageServiceOptions (optional)>
		<COD>
		<CODFundsCode>0=check,8=money order</CODFundsCode>
		<CODCode>3=tagless, wtf is that?</CODECode>
		<CODAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</CODAmount>
		</COD>
		<DeliveryConfirmation>
			<DCISType>1, no sig - 2, sig - 3, adult sig</DCISType>
		</DeliveryConfirmation>		
		<InsuredAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</InsuredAmount>
	</PackageServiceOptions>
	<AdditionalHandling (optional, flag) />
</Package>
	
PackageTypeCodes
	01=UPS Letter/UPS Express Envelope
	02=Package
	03=UPS Tube
	04=UPS Pak
	21=UPS Express Box
	24=UPS 25Kg Box
	25=UPS 10Kg Box
	
LICENSE 
Copyright 2006 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfcomponent output="false" extends="base" displayName="Rate and Service" hint="Lets you find rate and service information.">

<!--- environment variables. These MUST exist. --->
<cfset variables.TEST_URL = "https://wwwcie.ups.com/ups.app/xml/Rate">
<cfset variables.LIVE_URL = "https://www.ups.com/ups.app/xml/Rate">

<cffunction name="init" access="public"	output="false" returntype="rateservice">
	<cfargument name="key" type="string" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" required="true">
	<cfargument name="developmentmode" type="boolean" required="false">

	<cfset variables.serviceCodes = loadServiceCodes()>
	<cfset super.init(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>
			
<cffunction name="isValidPackageType" access="private" output="false" returnType="boolean"
			hint="Returns if the value is a valid package type.">
	<cfargument name="packagetype" type="string" required="true">
	
	<cfreturn structKeyExists(getValidPackageTypes(), arguments.packageType)>
</cffunction>	

<cffunction name="getRateInformation" access="public" output="false" returnType="query">
	<cfargument name="service" type="string" required="false" hint="Service to return data for.">
	<cfargument name="pickuptype" type="string" required="false" hint="What type of pickup is being used.">
	<cfargument name="customerclassification" type="string" required="false" hint="Customer classification. Only valid if shipping from US">
	<cfargument name="saturdaydelivery" type="boolean" required="false" default="false">
	<cfargument name="saturdaypickup" type="boolean" required="false" default="false">
	<cfargument name="pickupday" type="string" required="false" default="same">
	<cfargument name="schedulemethod" type="string" required="false" default="internet">
	
	<cfargument name="handlingchargeamount" type="numeric" required="false">
	<cfargument name="handlingchargepercentage" type="string" required="false">
	<cfargument name="handlingchargecurrencycode" type="string" required="false">
	
	<!--- shipper number is required if desiring negotiated rates --->
	<cfargument name="shippernumber" type="string" required="false" default="">
	<cfargument name="shippercity" type="string" required="false" default="">
	<cfargument name="shipperstatecode" type="string" required="false" default="">
	<cfargument name="shipperpostalcode" type="string" required="false" default="">
	<cfargument name="shippercountrycode" type="string" required="false" default="US">

	<cfargument name="shiptocity" type="string" required="false" default="">
	<cfargument name="shiptostatecode" type="string" required="false" default="">
	<cfargument name="shiptopostalcode" type="string" required="false" default="">
	<cfargument name="shiptocountrycode" type="string" required="false" default="US">
	<cfargument name="shiptoIsResidential" type="boolean" required="false" default="false">

	<cfargument name="shipfromcity" type="string" required="false">
	<cfargument name="shipfromstatecode" type="string" required="false">
	<cfargument name="shipfrompostalcode" type="string" required="false">
	<cfargument name="shipfromcountrycode" type="string" required="false" default="US">
	
	<cfargument name="weight" type="string" required="false">
	<cfargument name="weightunit" type="string" required="false">

	<cfargument name="packages" type="any" required="true">
	
	<cfset var header = generateVerificationXML()>

	<cfset var validPickupTypes = "01,03,06,07,11,19,20">
	<cfset var validCustomerClasses = "01,03,04">
	<cfset var validWeightUnits = "LBS,KGS,00,01">
	<cfset var validPickupDays = "same,future">
	<cfset var validScheduleMethods = "internet,phone">
	
	<cfset var tmpArr = "">
	<cfset var packageXML = "">
	<cfset var reqxml = "">
	<cfset var ratedshipment = "">
	<cfset var xmlResult = "">
	<cfset var x = "">

	<cfset var results = queryNew("service,servicecode,warning,billingweight,billingweightunit,transportationcharges,transportationchargesunit,serviceoptionscharges,serviceoptionschargesunit,totalcharges,discountedcharges,totalchargesunit,guaranteeddaystodelivery,scheduleddeliverytime,packages,responsewarning,negotiatedrates")>
	<cfset var data = "">
	<cfset var key = "">
		
	<cfset var package = "">
	<cfset var y = "">
	<cfset var packageNode = "">
	
	<cfset var responsewarning = "">
	<cfset var discountnode = "">
	<cfset var z = "">
	<cfset var result = "">
	
	<cfif arguments.shipperpostalcode is "" and arguments.shippercity is "">
		<cfthrow message="UPS Rate/Service Error: Shipper City may not be blank if postal code is blank.">
	</cfif>

	<cfif arguments.shiptopostalcode is "" and arguments.shiptocity is "">
		<cfthrow message="UPS Rate/Service Error: Ship To City may not be blank if postal code is blank.">
	</cfif>
	
	<!--- Packages can either be an array of structs or one struct --->
	<cfif not isArray(arguments.packages) and not isStruct(arguments.packages)>
		<cfthrow message="UPS Rate/Service Error: Packages argument must be a struct or an array.">
	</cfif>
	
	<cfif not isArray(arguments.packages)>
		<cfset tmpArr = arrayNew(1)>
		<cfset tmpArr[1] = arguments.packages>
		<cfset arguments.packages = tmpArr>
	</cfif>
	
	<cfset packageXML = getPackageXML(arguments.packages)>
	
	<cfif structKeyExists(arguments, "pickuptype") and not listFindNoCase(validPickupTypes,arguments.pickuptype)>
		<cfthrow message="UPS Rate/Service Error: Invalid pickuptype (#arguments.pickuptype#). Must be one of #validPickupTypes#.">
	</cfif>

	<cfif structKeyExists(arguments, "customerclassification") and not listFindNoCase(validCustomerClasses,arguments.customerclassification)>
		<cfthrow message="UPS Rate/Service Error: Invalid customer classification (#arguments.customerclassification#). Must be one of #validCustomerClasses#.">
	</cfif>

	<cfif structKeyExists(arguments, "weightunit") and not listFindNoCase(validWeightUnits,arguments.weightunit)>
		<cfthrow message="UPS Rate/Service Error: Invalid weight unit (#arguments.weightunit#). Must be one of #validWeightUnits#.">
	</cfif>

	<cfif not listFindNoCase(validPickupDays,arguments.pickupday)>
		<cfthrow message="UPS Rate/Service Error: Invalid pickupday (#arguments.pickupday#). Must be one of #validPickupDays#.">
	</cfif>

	<cfif not listFindNoCase(validScheduleMethods,arguments.schedulemethod)>
		<cfthrow message="UPS Rate/Service Error: Invalid schedulemethod (#arguments.schedulemethod#). Must be one of #validScheduleMethods#.">
	</cfif>
	
	<!--- create req xml --->
	<cfsavecontent variable="reqxml">
	<cfoutput>
<?xml version="1.0"?>
<RatingServiceSelectionRequest xml:lang="en-US">
	<Request>
		<TransactionReference>
			<CustomerContext>CFUPS Package</CustomerContext>
			<XpciVersion>1.0001</XpciVersion>
		</TransactionReference>
		<RequestAction>Rate</RequestAction>
		<RequestOption><cfif structKeyExists(arguments,"service")>rate<cfelse>shop</cfif></RequestOption>
	</Request>
	<cfif structKeyExists(arguments, "pickuptype")>
	<PickupType>
		<Code>#arguments.pickuptype#</Code>
	</PickupType>
	</cfif>
	<cfif structKeyExists(arguments, "customerclassification")>
	<CustomerClassification>
		<Code>#arguments.customerclassification#</Code>
	</CustomerClassification>
	</cfif>
	<Shipment>
		<Shipper>
			<cfif structKeyExists(arguments, "shippernumber")>
			<ShipperNumber>#arguments.shippernumber#</ShipperNumber>
			</cfif>
			<Address>
				<City>#arguments.shippercity#</City>
				<StateProvinceCode>#arguments.shipperstatecode#</StateProvinceCode>
				<PostalCode>#arguments.shipperpostalcode#</PostalCode>
				<CountryCode>#arguments.shippercountrycode#</CountryCode>
			</Address>
		</Shipper>
		
		<ShipTo>
			<Address>
				<City>#arguments.shiptocity#</City>
				<StateProvinceCode>#arguments.shiptostatecode#</StateProvinceCode>
				<PostalCode>#arguments.shiptopostalcode#</PostalCode>
				<CountryCode>#arguments.shiptocountrycode#</CountryCode>
				<cfif arguments.shipToIsResidential>
				<ResidentialAddressIndicator />
				</cfif>
			</Address>
		</ShipTo>
		
		<cfif structKeyExists(arguments, "shipfromcity") or structKeyExists(arguments, "shipfromstatecode") or structKeyExists(arguments, "shipfrompostalcode")>
		<ShipFrom>
			<Address>
				<City>#arguments.shipfromcity#</City>
				<StateProvinceCode>#arguments.shipfromstatecode#</StateProvinceCode>
				<PostalCode>#arguments.shipfrompostalcode#</PostalCode>
				<CountryCode>#arguments.shipfromcountrycode#</CountryCode>
			</Address>
		</ShipFrom>
		</cfif>
		
		<cfif structKeyExists(arguments, "weight")>
		<ShipmentWeight>
			<Weight>#arguments.weight#</Weight>
			<cfif structKeyExists(arguments, "weightunit")>
			<UnitOfMeasurement><Code>#arguments.weightunit#</Code></UnitOfMeasurement>
			</cfif>
		</ShipmentWeight>
		</cfif>
		
		<cfif structKeyExists(arguments, "service")>
		<Service><Code>#arguments.service#</Code></Service>
		</cfif>
		
		#packageXML#

		<ShipmentServiceOptions>
			<cfif arguments.saturdayPickup><SaturdayPickupIndicator /></cfif>
			<cfif arguments.saturdayDelivery><SaturdayDeliveryIndicator /></cfif>
			
			<OnCallAir>
				<Schedule>
					<PickupDay><cfif arguments.pickupday is "same">01<cfelse>02</cfif></PickupDay>
					<Method><cfif arguments.schedulemethod is "internet">01<cfelse>02</cfif></Method>
				</Schedule>
			</OnCallAir>
			
			<!--- Skipping COD TODO, someone remind me--->
		</ShipmentServiceOptions>

		<HandlingCharge>
			<FlatRate>
			<cfif structKeyExists(arguments, "handlingChargeAmount")>
			<MonetaryValue>#arguments.handlingChargeAmount#</MonetaryValue>
			</cfif>
			<cfif structKeyExists(arguments, "handlingChargeCurrencyCode")>
			<CurrencyCode>#arguments.handlingChargeCurrencyCode#</CurrencyCode>
			</cfif>
			</FlatRate>
			<cfif structKeyExists(arguments, "handlingchargepercentage")>
			<Percentage>#arguments.handlingchargepercentage#</Percentage>			
			</cfif>
		</HandlingCharge>

		<!--- TODO, rateinfo/negotiated --->
        <!--- Added By Aaron S. Passing an empty NegotiatedRatesIndicator tells the API to validate the shipper number and return discounted rates. Test server returns a 1% Discount --->
        <RateInformation>
        	<NegotiatedRatesIndicator></NegotiatedRatesIndicator>
        </RateInformation>
	</Shipment>
</RatingServiceSelectionRequest>
	</cfoutput>
	</cfsavecontent>

<cfif not isXML(reqxml) and 0>
<cfoutput>
<pre>
#htmleditformat(reqxml)#
</pre>
</cfoutput>
<cfabort>
</cfif>

	<cfhttp url="#getURL()#" method="post" result="result">
		<cfhttpparam type="xml" name="data" value="#header##reqxml#">
	</cfhttp>

	<cfset xmlResult = result.filecontent>
	<cfset xmlResult = xmlParse(xmlResult)>

	
<!--- <cfdump var="#xmlResult#"><cfabort> --->



	<cfif structKeyExists(xmlResult, "RatingServiceSelectionResponse")>
	
		<cfif structKeyExists(xmlResult.RatingServiceSelectionResponse.Response, "ResponseStatusDescription") and xmlResult.RatingServiceSelectionResponse.Response.ResponseStatusDescription.xmlText is "Failure">
			<cfthrow message="UPS Rate/Service Error: #xmlResult.RatingServiceSelectionResponse.Response.Error.ErrorDescription#">
		<cfelse>
		
			<!--- handle a high level warning and set to response warning --->
			<cfif structKeyExists(xmlResult.RatingServiceSelectionResponse.Response, "Error") and xmlResult.RatingServiceSelectionResponse.Response.Error.ErrorSeverity.xmlText is "Warning">
				<cfset responsewarning = xmlResult.RatingServiceSelectionResponse.Response.Error.ErrorDescription.xmlText>
			</cfif>
			
			<cfloop index="x" from="1" to="#arrayLen(xmlResult.RatingServiceSelectionResponse.RatedShipment)#">
				<cfset ratedshipment = xmlResult.RatingServiceSelectionResponse.RatedShipment[x]>
				<cfset data = structNew()>
				
				<cfset data.responsewarning = responsewarning>
				
				<cfset data.servicecode = ratedshipment.service.code.xmltext>
				<cfset data.service = getServiceLabel(data.servicecode)>
				
				<cfif structKeyExists(ratedshipment, "RatedShipmentWarning")>
					<cfset data.warning = ratedShipment.ratedshipmentwarning.xmltext>
				</cfif>
				
				<cfset data.billingweight = ratedshipment.billingweight.weight.xmltext>
				<cfset data.billingweightunit = ratedshipment.billingweight.unitofmeasurement.code.xmltext>

				<cfset data.transportationcharges = ratedshipment.transportationcharges.monetaryvalue.xmltext>
				<cfset data.transportationchargesunit = ratedshipment.transportationcharges.currencycode.xmltext>

				<cfset data.serviceoptionscharges = ratedshipment.serviceoptionscharges.monetaryvalue.xmltext>				
				<cfset data.serviceoptionschargesunit = ratedshipment.serviceoptionscharges.currencycode.xmltext>

				<cfset data.totalcharges = ratedshipment.totalcharges.monetaryvalue.xmltext>
				<cfset data.totalchargesunit = ratedshipment.totalcharges.currencycode.xmltext>

				<cfset data.guaranteeddaystodelivery = ratedshipment.guaranteeddaystodelivery.xmltext>
				
				<cfset data.scheduleddeliverytime = ratedshipment.scheduleddeliverytime.xmltext>
				
				<!--- packages will be an array of structs --->	
				<cfset data.packages = arrayNew(1)>			
				<cfloop index="y" from="1" to="#arrayLen(ratedshipment.ratedpackage)#">
					<cfset packageNode = ratedshipment.ratedpackage[y]>
					<cfset package = structNew()>
					<cfset package.transportationcharges = packageNode.transportationcharges.monetaryvalue.xmltext>
					<cfset package.serviceoptionscharges = packageNode.serviceoptionscharges.monetaryvalue.xmltext>
					<cfset package.totalcharges = packageNode.totalcharges.monetaryvalue.xmltext>
					<cfset package.billingweight = packageNode.billingweight.weight.xmltext>
					<cfset arrayAppend(data.packages, package)>
				</cfloop>
                
                <!--- add in negotiated rates --->
				<cfset data.NegotiatedRates=arrayNew(1)>
				<cfif isDefined("ratedshipment.NegotiatedRates") and isArray(ratedshipment.NegotiatedRates)>
	                <cfloop index="z" from="1" to="#arrayLen(ratedshipment.NegotiatedRates)#">
	                	<cfset discountNode = ratedshipment.negotiatedrates[z]>
	                	<cfset package=structNew()>
	                    <cfset package.totalcharges = discountNode.NetSummaryCharges.GrandTotal.MonetaryValue.xmltext>
	                    <cfset package.currencycode = discountNode.NetSummaryCharges.GrandTotal.CurrencyCode.xmltext>
	                	<cfset arrayAppend(data.NegotiatedRates, package)>
	                    <cfset data.DiscountedCharges = package.totalcharges>
	                </cfloop>
				</cfif>

				<!--- copy to query --->
				<cfset queryAddRow(results)>
				<cfloop item="key" collection="#data#">
					<cfset querySetCell(results, key, data[key])>
				</cfloop>
								
			</cfloop>

		</cfif>
	</cfif>
	
	<cfreturn results>	
</cffunction>

<cffunction name="getPackageStruct" access="public" returnType="struct" output="false"
			hint="A utility function to return a 'proper' package struct.">
	<cfargument name="packagetype" type="string" required="true">
	<cfargument name="length" type="numeric" required="false">
	<cfargument name="width" type="numeric" required="false">
	<cfargument name="height" type="numeric" required="false">
	<cfargument name="weight" type="numeric" required="false">
	<cfargument name="weightunit" type="string" required="false">
	<cfargument name="oversizeflag" type="numeric" required="false" hint="Valid values are 1,2,3">
	<cfargument name="deliveryconfirmation" type="numeric" required="false" hint="Valid values are 1 (no signature), 2 (signature), 3 (adult signature)">
	<cfargument name="declaredvalue" type="numeric" required="false">

	<cfset var r = structNew()>
	
	<cfif not isValidPackageType(arguments.packagetype)>
		<cfthrow message="UPS Rate/Service Error: #arguments.packagetype# is not a valid package type.">
	<cfelse>
		<cfset r.packagetype = arguments.packagetype>	
	</cfif>

	<cfif structKeyExists(arguments, "length")>
		<cfif arguments.length lte 0 or arguments.length gte 109>
			<cfthrow message="UPS Rate/Service Error: Package length must be between 1 and 108.">
		<cfelse>
			<cfset r.length = arguments.length>	
		</cfif>
	</cfif>
	
	<cfif structKeyExists(arguments, "width")>
		<cfif arguments.width lte 0 or arguments.width gte 109>
			<cfthrow message="UPS Rate/Service Error: Package width must be between 1 and 108.">
		<cfelse>
			<cfset r.width = arguments.width>	
		</cfif>
	</cfif>
	
	<cfif structKeyExists(arguments, "height")>
		<cfif arguments.height lte 0 or arguments.height gte 109>
			<cfthrow message="UPS Rate/Service Error: Package height must be between 1 and 108.">
		<cfelse>
			<cfset r.height = arguments.height>	
		</cfif>
	</cfif>
	
	<cfif structKeyExists(arguments, "weight")>
		<cfif arguments.weight lt 0 or arguments.weight gte 151>
			<cfthrow message="UPS Rate/Service Error: Package weight must be between 0 and 150.">
		<cfelse>
			<cfset r.weight = arguments.weight>	
		</cfif>
	</cfif>
			
	<!--- TODO, find other values, docs didnt have it --->
	<cfset r.sizeunit = "IN">
	
	<!--- TODO, why dimensionweight? it has not value, just a U of M --->
	
	<cfif structKeyExists(arguments, "weightunit")>
		<cfif not listFindNoCase("LBS,KGS", arguments.weightunit)>
			<cfthrow message="UPS Rate/Service Error: Package weight unit may be LBS or KGS.">
		<cfelse>
			<cfset r.weightunit = arguments.weightunit>
		</cfif>
	</cfif>

	<cfif structKeyExists(arguments, "oversizeflag")>
		<cfif not listFindNoCase("1,2,3", arguments.oversizeflag)>
			<cfthrow message="UPS Rate/Service Error: Package oversize flag may only be 1, 2, or 3.">
		<cfelse>
			<cfset r.oversizepackage = arguments.oversizeflag>
		</cfif>
	</cfif>

	<!---
	TODO, COD options
		<COD>
		<CODFundsCode>0=check,8=money order</CODFundsCode>
		<CODCode>3=tagless, wtf is that?</CODECode>
		<CODAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</CODAmount>
		</COD>
	--->
		
	<cfif structKeyExists(arguments, "deliveryconfirmation")>
		<cfif not listFindNoCase("1,2,3", arguments.deliveryconfirmation)>
			<cfthrow message="UPS Rate/Service Error: Package delivery confirmation may only be 1, 2, or 3.">
		<cfelse>
			<cfset r.deliveryconfirmation = arguments.deliveryconfirmation>
		</cfif>
	</cfif>
	
	<cfif structKeyExists(arguments, "declaredvalue")>
		<cfset r.declaredvalue = arguments.declaredvalue>
	</cfif>
	
	<!--- More TODO options
	<PackageServiceOptions (optional)>
		<InsuredAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</InsuredAmount>
	</PackageServiceOptions>
	<AdditionalHandling (optional, flag) />
	--->	
	<cfreturn r>
</cffunction>

<cffunction name="getPackageXML" access="private" returnType="string" output="false"
			hint="I turn an array of packages into XML.">
	<cfargument name="packages" type="array" required="true">
	<cfset var x = 1>
	<cfset var result = "">
	<cfset var p = "">
	<cfset var package = "">
	
	<cfloop index="x" from="1" to="#arrayLen(arguments.packages)#">
		<cfset package = arguments.packages[x]>
		
		<cfsavecontent variable="p">
		<cfoutput>
<Package>
	<PackagingType>
		<Code>#package.packagetype#</Code>
	</PackagingType>

	<cfif structKeyExists(package, "length") or structKeyExists(package, "width") or structKeyExists(package, "height")>
	<Dimensions>
		<UnitOfMeasurement>
			<Code>IN</Code>
		</UnitOfMeasurement>
		<cfif structKeyExists(package, "length")><Length>#package.length#</Length></cfif>
		<cfif structKeyExists(package, "width")><Width>#package.width#</Width></cfif>
		<cfif structKeyExists(package, "height")><Height>#package.height#</Height></cfif>
	</Dimensions>
	</cfif>

	<!---
	<DimensionalWeight (optional)>
		<UnitOfMeasurement>
			<Code>LBS or KGS</Code>
		</UnitOfMeasurement>
	</DimensionalWeight>
	--->
	<PackageWeight>
		<cfif structKeyExists(package, "weightunit")>
		<UnitOfMeasurement>
			<Code>#package.weightunit#</Code>
		</UnitOfMeasurement>
		</cfif>
		<cfif structKeyExists(package, "weight")>
		<Weight>#package.weight#</Weight>
		</cfif>
	</PackageWeight>
	<cfif structKeyExists(package, "oversizepackage")>
	<OversizePackage>#package.oversizepackage#</OversizePackage>
	</cfif>
	<!---
	<PackageServiceOptions (optional)>
		<COD>
		<CODFundsCode>0=check,8=money order</CODFundsCode>
		<CODCode>3=tagless, wtf is that?</CODECode>
		<CODAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</CODAmount>
		</COD>
		<DeliveryConfirmation>
			<DCISType>1, no sig - 2, sig - 3, adult sig</DCISType>
		</DeliveryConfirmation>		
		<InsuredAmount>
			<CurrencyCode></CurrencyCode>
			<MonetaryValue>0.01-50,000</MonetaryValue>
		</InsuredAmount>
	</PackageServiceOptions>
	<AdditionalHandling (optional, flag) />
	--->
	
	<PackageServiceOptions>
		<cfif structKeyExists(package, "declaredvalue")>
		<InsuredValue>
			<MonetaryValue>#package.declaredvalue#</MonetaryValue>
		</InsuredValue>
		</cfif>
	</PackageServiceOptions>
			
</Package>
		</cfoutput>
		</cfsavecontent>

		<cfset result = result & p>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="getServiceLabel" access="public" returnType="string" output="false"
			hint="Return a label for a code">
	<cfargument name="code" type="string" required="true">
	<cfargument name="country" type="string" required="false" default="us">
	
	<cfif structKeyExists(variables.servicecodes, arguments.country) and structKeyExists(variables.servicecodes[arguments.country], arguments.code)>
		<cfreturn variables.servicecodes[arguments.country][arguments.code]>
	<cfelse>
		<cfreturn "n/a">
	</cfif>
</cffunction>

<cffunction name="getValidPackageTypes" access="public" returnType="struct" output="false"
			hint="Utility function to return valid package types.">
			
	<cfset var r = structNew()>
	<cfset r["01"] = "UPS Letter/UPS Express Envelope">
	<cfset r["02"] = "Package">
	<cfset r["03"] = "UPS Tube">
	<cfset r["04"] = "UPS Pak">
	<cfset r["21"] = "UPS Express Box">
	<cfset r["24"] = "UPS 25Kg Box">
	<cfset r["25"] = "UPS 10Kg Box">

	<cfreturn r>
</cffunction>

<cffunction name="loadServiceCodes" access="private" returnType="struct" output="false"
			hint="Lord forbid UPS provide a nice label for their service codes. This function loads a handmade xml file.">
	<cfset var xmlfile = getDirectoryFromPath(getCurrentTemplatePath()) & "/servicecodes.xml">
	<cfset var xmlString = "">
	<cfset var xmlData = "">
	<cfset var country = "">
	<cfset var results = structNew()>
	<cfset var x = "">
	
	<cfif fileExists(xmlFile)>
		<cffile action="read" file="#xmlFile#" variable="xmlString">
		<cfset xmlData = xmlParse(xmlString)>		
		<cfloop item="country" collection="#xmlData.servicecodes#">
			<cfset results[country] = structNew()>
			<cfloop index="x" from="1" to="#arrayLen(xmlData.servicecodes[country].code)#">
				<cfset results[country][xmlData.servicecodes[country].code[x].xmlAttributes.value] = xmlData.servicecodes[country].code[x].xmlAttributes.label>
			</cfloop>
		</cfloop>		
	<cfelse>
		<cfthrow message="UPS Rate/Service Error: Couldn't load servicecode xml at #xmlFile#.">
	</cfif>
	
	<cfreturn results>	
</cffunction>

</cfcomponent>
