<!---
	Name         : addressverification.cfc
	Author       : Raymond Camden 
	Created      : December 12, 2006
	Last Updated : 
	History      : 
	Purpose		 : Address Verification

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
<cfcomponent output="false" extends="base" displayName="Address Verification" hint="Handles address verification.">

<!--- environment variables. These MUST exist. --->
<cfset variables.TEST_URL = "https://wwwcie.ups.com/ups.app/xml/AV">
<cfset variables.LIVE_URL = "https://www.ups.com/ups.app/xml/AV">

<cffunction name="addressVerification" access="public" output="false" returnType="query">
	<cfargument name="city" type="string" required="false" default="">
	<cfargument name="state" type="string" required="false" default="">
	<cfargument name="postalcode" type="string" required="false" default="">
	<cfset var header = generateVerificationXML()>
	<cfset var reqxml = "">
	<cfset var xmlResult = "">
	<cfset var results = queryNew("rank,quality,city,state,postalcodelow,postalcodehigh")>
	<cfset var data = structNew()>
	<cfset var x = "">
	<cfset var node = "">
	<cfset var key = "">
	<cfset var result = "">

	<!--- Rules based on UPS Doc:
	The Address Validation request must contain one of the following input combinations:
	* City, State, and Postal Code
	* City
	* Postal Code
	* City and State
	* City and Postal Code
	* State and Postal Code
	
	I'm taking the easy way out now and simply doing:
	Don't allow just State
	--->
	<cfif not len(trim(arguments.city)) and not len(trim(arguments.postalcode))>
		<cfthrow message="UPS Address Verification Error: State may not be used alone.">
	</cfif>
	
	<cfif len(trim(arguments.postalcode)) and not isValid("zipcode", arguments.postalcode)>
		<cfthrow message="UPS Address Verification Error: #arguments.postalcode# is not a valid postal code.">
	</cfif>
	
	<!--- create req xml --->
	<cfsavecontent variable="reqxml">
	<cfoutput>
<?xml version="1.0"?>
<AddressValidationRequest xml:lang="en-US">
<Request>
<TransactionReference>
<CustomerContext>CFUPS Package</CustomerContext>
<XpciVersion>1.0001</XpciVersion>
</TransactionReference>
<RequestAction>AV</RequestAction>
</Request>
<Address>
<cfif len(arguments.city)><City>#arguments.city#</City></cfif>
<cfif len(arguments.state)><StateProvinceCode>#arguments.state#</StateProvinceCode></cfif>
<cfif len(arguments.postalcode)><PostalCode>#arguments.postalcode#</PostalCode></cfif>
</Address>
</AddressValidationRequest>
	</cfoutput>
	</cfsavecontent>

	<cfhttp url="#getURL()#" method="post" result="result">
		<cfhttpparam type="xml" name="data" value="#header##reqxml#">
	</cfhttp>

	<cfset xmlResult = result.filecontent>
	<cfset xmlResult = xmlParse(xmlResult)>

	<cfif structKeyExists(xmlResult, "AddressValidationResponse")>
	
		<cfif structKeyExists(xmlResult.AddressValidationResponse.Response, "Error")>
			<cfthrow message="UPS Address Verification Error: #xmlResult.AddressValidationResponse.Response.Error.ErrorDescription#">
		<cfelse>
			<cfloop index="x" from="1" to="#arrayLen(xmlResult.AddressValidationResponse.AddressValidationResult)#">
				<cfset node = xmlResult.AddressValidationResponse.AddressValidationResult[x]>
				<cfset data = structNew()>
				<cfset data.rank = node.rank.xmlText>
				<cfset data.quality = node.quality.xmlText>
				<cfset data.postalcodelow = node.postalcodelowend.xmltext>
				<cfset data.postalcodehigh = node.postalcodehighend.xmltext>
				<cfset data.city = node.address.city.xmltext>
				<cfset data.state = node.address.stateprovincecode.xmltext>
				
				<cfset queryAddRow(results)>
				<cfloop item="key" collection="#data#">
					<cfset querySetCell(results, key, data[key])>
				</cfloop>
	
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn results>	
</cffunction>


<cffunction name="getDisclaimer" access="public" returnType="string" output="false"
			hint="UPS requires you to return this 'from time to time'. Just output it next to your results.">
	<cfset var msg = "">
	<cfsavecontent variable="msg">
NOTICE: UPS assumes no liability for the information provided by the address validation functionality. The
address validation functionality does not support the identification or verification of occupants at an address.
	</cfsavecontent>
	
	<cfreturn msg>				
</cffunction>

<cffunction name="streetAddressVerification" access="public" returntype="query">
	<cfargument name="address" type="string" required="true">
	<cfargument name="city" type="string" required="false" default="">
	<cfargument name="state" type="string" required="false" default="">
	<cfargument name="postalcode" type="string" required="false" default="">
    <cfargument name="returnFormat" type="string" required="false" default="XML">
	<cfset var header = generateVerificationXML()>
	<cfset var reqxml = "">
    <cfset var reqAddress = "">
	<cfset var xmlResult = "">
	<cfset var results = queryNew("address,city,state,postalcodelow,postalcodehigh")>
	<cfset var data = structNew()>
	<cfset var x = "">
	<cfset var node = "">
	<cfset var key = "">
	<cfset var result = "">
	
    <cfset var AV_TEST_URL = "https://wwwcie.ups.com/ups.app/xml/XAV">
	<cfset var AV_LIVE_URL = "https://www.ups.com/ups.app/xml/XAV">
    <cfset var theURL = "">
	
	<cfif not len(trim(arguments.city)) and not len(trim(arguments.postalcode))>
		<cfthrow message="UPS Address Verification Error: State may not be used alone.">
	</cfif>
	
	<cfif len(trim(arguments.postalcode)) and not isValid("zipcode", arguments.postalcode)>
		<cfthrow message="UPS Address Verification Error: #arguments.postalcode# is not a valid postal code.">
	</cfif>
	
	<cfsavecontent variable="reqAddress">
	<cfoutput>
	<AddressKeyFormat>
        <AddressLine>#arguments.address#</AddressLine>	
		<PoliticalDivision2>#arguments.city#</PoliticalDivision2>
		<PoliticalDivision1>#arguments.state#</PoliticalDivision1>
		<PostcodePrimaryLow>#arguments.postalcode#</PostcodePrimaryLow>
        <CountryCode>US</CountryCode>		
	</AddressKeyFormat>
	</cfoutput>
    </cfsavecontent>
        
	<cfsavecontent variable="reqxml">
	<cfoutput>
<?xml version="1.0"?>
<AddressValidationRequest xml:lang="en-US">
  <Request>
    <TransactionReference>
      <CustomerContext>UPS Address Validation</CustomerContext>
      <XpciVersion>1.0</XpciVersion>
    </TransactionReference>
    <RequestAction>XAV</RequestAction>
    <RequestOption>3</RequestOption>
  </Request>  
  #reqAddress#
</AddressValidationRequest>
	</cfoutput>
	</cfsavecontent>
    
	<cfif getDevelopmentMode()>
		<cfset theURL = AV_TEST_URL>
	<cfelse>
		<cfset theURL = AV_LIVE_URL>
	</cfif>
	
	<cfhttp url="#theURL#" method="post" result="result">
		<cfhttpparam type="xml" name="data" value="#header##reqxml#">
	</cfhttp>

	<cfset xmlResult = result.filecontent>
	<cfset xmlResult = xmlParse(xmlResult)>	
    
	<cfif structKeyExists(xmlResult, "AddressValidationResponse")>
    
        <cfif structKeyExists(xmlResult.AddressValidationResponse.Response, "Error")>
            <cfthrow message="UPS Address Verification Error: #xmlResult.AddressValidationResponse.Response.Error.ErrorDescription#">
        <cfelse>
            <cfloop index="x" from="1" to="#arrayLen(xmlResult.AddressValidationResponse.AddressKeyFormat)#">
                <cfset node = xmlResult.AddressValidationResponse.AddressKeyFormat[x]>
                <cfset data = structNew()>
                <cfset data.postalcodelow = node.PostcodePrimaryLow.xmltext>
                <cfset data.postalcodehigh = node.PostcodeExtendedLow.xmltext>
                <cfset data.city = node.PoliticalDivision2.xmltext>
                <cfset data.state = node.PoliticalDivision1.xmltext>
                <cfset data.address = node.AddressLine.xmltext>
                
                <cfset queryAddRow(results)>
                <cfloop item="key" collection="#data#">
                    <cfset querySetCell(results, key, data[key])>
                </cfloop>
    
            </cfloop>
        </cfif>
    
	</cfif>

	<cfreturn results>
    
</cffunction>
</cfcomponent>
