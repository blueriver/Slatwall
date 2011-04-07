<!---
	Name         : timetransitservice.cfc
	Author       : Kurt Bonnet
	Created      : February 17, 2007
	Last Updated : June 20, 2007
	History      : Bug fix to pickupdate/time (rkc 7/20/07)
	Purpose		 : Obtain "Time in Transit" Info for various Service Levels

Docs to help me keep things straight:

Request XML:
<TimeInTransitRequest xml:lang="en-US">
   <Request>
      <TransactionReference>
         <CustomerContext>TNT_D Origin Country Code</CustomerContext>  <!-- optional, unique string used to synchronize requests and responses, can be up to 512 chars long -->
         <XpciVersion>1.0002</XpciVersion> <!-- requied, version of "time in transit" XML interface being used -->
      </TransactionReference>
      <RequestAction>TimeInTransit</RequestAction> <!-- required, don't touch this, it must stay like this -->
   </Request>
   <TransitFrom> <!-- shipment origin address info -->
      <AddressArtifactFormat>
         <PoliticalDivision3>(Not sure of an example)</PoliticalDivision3> <!-- optional, TOWN, used outsided US typically, up to 30 chars -->
		 <PoliticalDivision2>LONDON</PoliticalDivision2> <!-- required (only if outside the US, and postal code is not used in origin country), CITY, up to 30 chars -->
         <PoliticalDivision1>CITY OF LONDON</PoliticalDivision1> <!-- optional, STATE/PROVINCE, up to 30 chars -->
         <CountryCode>GB</CountryCode> <!-- required, 2 letter COUNTRY CODE -->
         <PostcodePrimaryLow>EC03</PostcodePrimaryLow> <!-- required (ony for countries that use postal codes), POSTAL CODE, up to 10 chars -->
      </AddressArtifactFormat>
   </TransitFrom>
   <TransitTo> <!-- shipment destination address info -->
      <AddressArtifactFormat>
         <PoliticalDivision3>(Not sure of an example)</PoliticalDivision3> <!-- optional, TOWN, used outsided US typically, up to 30 chars -->
		 <PoliticalDivision2>Nassau</PoliticalDivision2> <!-- required (only if outside the US, and postal code is not used in origin country), CITY, up to 30 chars -->
         <PoliticalDivision1></PoliticalDivision1> <!-- optional, STATE/PROVINCE, up to 30 chars -->
         <CountryCode>BS</CountryCode> <!-- required, 2 letter COUNTRY CODE -->
         <PostcodePrimaryLow></PostcodePrimaryLow> <!-- required (ony for countries that use postal codes), POSTAL CODE, up to 10 chars -->
		 <ResidentialAddressIndicator/> <!-- optional, the PRESENCE of this node indicates that the shipment is to a residential adddress, if not provided "commercial" is assumed -->
      </AddressArtifactFormat>
   </TransitTo>
   <ShipmentWeight> <!-- required for non-document shipments inside the US and ANY shipments outside the US, package configuration -->
      <UnitOfMeasurement>
         <Code>KGS</Code> <!-- required, unit the package weight that is provide is in (LBS or KGS) -->
         <Description>Kilograms</Description> <!-- optional, text description of unit -->
      </UnitOfMeasurement>
      <Weight>23</Weight> <!-- required, weight of package, only one decimal point is allowed. Can NOT exceed 150lbs for US, 68KGS for Canada, 70KGS anywhere else. -->
   </ShipmentWeight>
   <InvoiceLineTotal> <!-- required ONLY for non-document shipments outside the US or Document shipments when the Origin or Destination is Canada -->
      <CurrencyCode>USD</CurrencyCode> <!-- required, unit of currency the invoice line total is in. Must be a standard ISO code -->
      <MonetaryValue>250.00</MonetaryValue> <!-- required, value of the package's contents, can not exceed 9 whole numbers and 2 decimal places -->
   </InvoiceLineTotal>
   <PickupDate>20010608</PickupDate> <!-- required, date of shipment in YYYYMMDD format.  The date can be no further than 60 days into the future or 35 days in the past -->
   <TotalPackagesInShipment></TotalPackagesInShipment> <!-- optionl, the total number of packages in the shipment, numeric -->
   <DocumentsOnlyIndicator/> <!-- if this indicator is PRESENT, then the shipment will be considered a "Document" shipment, if absent it will be considered an non-document shipment -->
   <MaximumListSize>1-50</MaximumListSize> <!-- optional, Allows the user to specify the maximum # of candidates they wish to receive, 35 is the default. Valid values are 1-50. -->
</TimeInTransitRequest>


Response XML
<TimeInTransitResponse>
   <Response>
      <TransactionReference>
         <CustomerContext>TNT_D Origin Country Code</CustomerContext> <!-- optional, echos back the value for this node that was specified in the request (if one is specified) -->
         <XpciVersion>1.0002</XpciVersion>
      </TransactionReference>
      <ResponseStatusCode>1</ResponseStatusCode> <!-- Indicates if the inquiry was successful.  1=Successful, 2=Failed -->
      <ResponseStatusDescription>Success</ResponseStatusDescription> <!-- Text description for ResponseStatusCode - success or failure -->
	  <Error> <!-- only present if an error actually occured -->
	  	 <ErrorSeverity>TransientError,HardError,Warning</ErrorSeverity> <!-- Describes the severity of the error. HardError means customer data is bad, any other errors mean re-try  -->
		 <ErrorCode>1...x</ErrorCode> <!-- A numeric code that matches up with a description in the Time in Transit ERRORs table  -->
		 <ErrorDescription></ErrorDescription> <!-- Not always preseent, Describes the error code -->
		 <MinimumRetrySeconds></MinimumRetrySeconds> <!--  Not always present, Number of seconds to wait until trying again -->
		 <ErrorLocation> <!-- Not always present, and MULTIPLES may exist -->
		 	<ErrorLocationElementName><ErrorLocationElementName> <!-- Not always present, XPATH name of the node that had the error  -->
			<ErrorLocationAttributeName><ErrorLocationAttributeName> <!-- Not always present, name of th attribute in the XPATH node that had the error  -->
			<ErrorDigest></ErrorDigest> <!-- Not always present, and MANY of these may exist, contains the contents of the element that had the error -->
		 </ErrorLocation>		 
	  </Error>
   </Response>
   <TransitResponse> <!-- technically, you can have multiples of this node -->
   	  <!-- ECHOS back lots of the data we sent in the resposne -->
      <PickupDate>2001-06-08</PickupDate>
      <TransitFrom>
         <AddressArtifactFormat>
            <PoliticalDivision2>LONDON</PoliticalDivision2>
            <PoliticalDivision1>CITY OF LONDON</PoliticalDivision1>
            <Country>UNITED KINGDOM</Country>
            <CountryCode>GB</CountryCode>
            <PostcodePrimaryLow>EC03</PostcodePrimaryLow>
         </AddressArtifactFormat>
      </TransitFrom>
      <TransitTo>
         <AddressArtifactFormat>
            <PoliticalDivision2>NASSAU</PoliticalDivision2>
            <Country>BAHAMAS</Country>
            <CountryCode>BS</CountryCode>
         </AddressArtifactFormat>
      </TransitTo>

	  
	  <!-- NEW NODE, not in request -->
      <AutoDutyCode>02</AutoDutyCode> <!-- Will be specified for requests outside the US, A duty is automatically calculated for non-document shipments -->
	  
      
	  <ShipmentWeight>
         <UnitOfMeasurement>
            <Code>KGS</Code>
         </UnitOfMeasurement>
         <Weight>23.0</Weight>
      </ShipmentWeight>
      <InvoiceLineTotal>
         <CurrencyCode>USD</CurrencyCode>
         <MonetaryValue>250.00</MonetaryValue>
      </InvoiceLineTotal>

	  <!-- END OF ECHOED CONTENT -->
	  	
      <Disclaimer>Services listed as guaranteed..</Disclaimer> <!-- Not always present, appears if a disclaimer needs to be made regarding the validity of the guarantee on any guaranteed services -->
      <ServiceSummary> <!-- multiple service summary nodes will exist -->
         <Service>
            <Code>01</Code> <!-- the code for the UPS service level -->
            <Description>UPS Worldwide Express</Description> <!-- Not always present, text description of the service level this estimate is for -->
         </Service>
         <Guaranteed> <!-- Not always present -->
            <Code>Y</Code> <!-- Y or N  (yes/no) -->
			<Description></Description> <!-- Not always present, text value of Yes or No -->
         </Guaranteed>
         <EstimatedArrival>
            <BusinessTransitDays>1</BusinessTransitDays> <!-- The number of busines days it takes to transport from origin to destination -->
            <Time>23:30:00</Time> <!-- Estimated time of scheduled delivery (Local to destination) -->
            <PickupDate>2001-06-08</PickupDate> <!-- Date UPS will pickup the package to ship it (Local to origin) -->
            <PickupTime>19:00:00</PickupTime> <!-- Time UPS will pickup the package to ship it (Local to origin) -->
            <HolidayCount>0</HolidayCount> <!-- Not always present, the Number of national holidays spanned durring the shipment period -->
            <DelayCount>0</DelayCount> <!-- Not always present, the Number of days delayed at customs -->
            <Date>2001-06-11</Date> <!-- Estimated date of delivery (Local to destination) -->
            <DayOfWeek>MON</DayOfWeek> <!-- 3 letter day of week the pacakge will arrive on -->
            <TotalTransitDays>2</TotalTransitDays> <!-- Not always present, the TOTAL number of days it takes to transport from origin to destination -->
            <CustomerCenterCutoff>18:30:00</CustomerCenterCutoff> <!-- Not always present, customer service all time, not sure where local to) -->
            <RestDays>1</RestDays> <!-- Not always present, The number of days of non-movement -->
         </EstimatedArrival>
      </ServiceSummary>
	  
	  <!-- There's jut too much info right now to process, and this info isn't really necesary to retreive delivery estimates,
	       so if you want to program this CFC to handle the values in the nodes below, be my guest. -->
	 	<TransitFromList>
			<Candidate>
		
			</Candidate>
		<TransitFromList>
	  -->
   </TransitResponse>
</TimeInTransitResponse>


	
LICENSE 
Copyright 2007 Kurt Bonnet

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
<cfcomponent output="false" extends="base" displayName="Rate and Service" hint="Lets you find time in transit information.">

<!--- environment variables. These MUST exist. --->
<cfset variables.TEST_URL = "https://wwwcie.ups.com/ups.app/xml/TimeInTransit">
<cfset variables.LIVE_URL = "https://www.ups.com/ups.app/xml/TimeInTransit">

<cfset variables.lbAsKg = 0.45359237 > <!--- 1LB = 0.45359237 KG --->

<cffunction name="init" access="public"	output="false" returntype="timeintransitservice">
	<cfargument name="key" type="string" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" required="true">
	<cfargument name="developmentmode" type="boolean" required="false">

	<cfset super.init(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>
			
<cffunction name="getTimeInTransitInformation" access="public" output="false" returnType="query">
	<cfargument name="pickupday" type="date" required="true" hint="The day UPS will be given the package to ship" >

	<cfargument name="shiptocity" type="string" required="false" default="">
	<cfargument name="shiptostatecode" type="string" required="false" default="">
	<cfargument name="shiptopostalcode" type="string" required="false" default="">
	<cfargument name="shiptocountrycode" type="string" required="false" default="US">
	<cfargument name="shiptoIsResidential" type="boolean" required="false" default="false">

	<cfargument name="shipfromcity" type="string" required="false" default="">
	<cfargument name="shipfromstatecode" type="string" required="false" default="">
	<cfargument name="shipfrompostalcode" type="string" required="false" default="">
	<cfargument name="shipfromcountrycode" type="string" required="false" default="US" >
	
	<cfargument name="weight" type="string" required="false" default="" hint="weight in LBS or KGS">
	<cfargument name="weightunit" type="string" required="false" default="LBS" hint="LBS or KGS" >

	<cfargument name="packageValue" type="string" required="false" default=""
		hint=	"The monetary value of the package being shipped" >
		
	<cfargument name="packageValueCurrencyCode" type="string" required="false" default="USD" >	
	
	<cfargument name="packageDocumentsOnly" type="boolean" required="false" default="false"
		hint=	"If the package contains documents only" >

	<cfargument name="resubmitIfCandidatesReturned" type="boolean" required="false" default="true" 
		hint=	"If true, automatically re-submit the time in transit request if UPS finds multiple
				possible 'from' or 'to' addresses by using the first address candidates UPS suggests" >
	
	<cfargument name="serviceCodes" type="string" required="false" default=""	
		hint=	"Optional - A comma delimited list of UPS service codes that should have transit times returned.
				If specified, ONLY the services in the serviceCodes list will be returned by the this function,
				If not specifed transit times for all/any number of UPS services will be returned. " >

	<cfset var header = generateVerificationXML()>

	<cfset var validWeightUnits = "LBS,KGS">
	<cfset var shipWeight = val(arguments.weight) >
	<cfset var shipWeightLbs = 0 >
	<cfset var shipWeightKgs = 0 >
	
	<cfset var dd = "" >
	<cfset var summaries = "" >
	<cfset var sNode = "" >
	<cfset var i = 0 >
	
	<cfset var reqxml = "">
	<cfset var result = "">
	<cfset var xmlResult = "">
	<cfset var errMsg = "" >
	<cfset var resubmit = false >

	<cfset var errors = arrayNew(1)>
	
	<cfset var results = QueryNew("serviceCode,service,guaranteed,pickupDayTime,arrivalDayTime,businessTransitDays", "varchar,varchar,varchar,date,date,integer") >
	<cfset var node = "">
	<cfset var fromCandidates = "">
	<cfset var toCandidates = "">

	<!--- Do validations --->
	<cfif arguments.shipfrompostalcode is "" and arguments.shipfromcity is "">
		<cfthrow message="UPS TimeInTransit/Service Error: Ship From City may not be blank if postal code is blank.">
	</cfif>

	<cfif arguments.shiptopostalcode is "" and arguments.shiptocity is "">
		<cfthrow message="UPS TimeInTransit/Service Error: Ship To City may not be blank if postal code is blank.">
	</cfif>
	
	<cfif NOT listFindNoCase(validWeightUnits, arguments.weightunit) >
		<cfthrow message="UPS TimeInTransit/Service Error: Invalid weight unit (#arguments.weightunit#). Must be one of #validWeightUnits#.">
	</cfif>
	
	
	<!--- Weight required for any shipment outside the US, and non-document shipments inside the US --->
	<cfif	(NOT arguments.packageDocumentsOnly)
			OR
			(compareNoCase(arguments.shiptocountrycode, "US") OR compareNoCase(arguments.shipfromcountrycode, "US"))
	>
		<cfif NOT len(arguments.weight) >
			<cfthrow message="UPS TimeInTransit/Service Error: Weight is required for any shipment outside the US, and non-document shipments inside the US">						
		</cfif>
	</cfif>
	<cfif len(arguments.weight) AND NOT isNumeric(arguments.weight) >
		<cfthrow message="UPS TimeInTransit/Service Error: Invalid weight (#arguments.weight# #arguments.weightunit#)">						
	</cfif>
	
	
	<!--- Ship weight can NOT exceed 150lbs for US, 68KGS for Canada, 70KGS anywhere else. --->
	<cfif len(arguments.weight) >
		<cfif NOT compareNoCase(arguments.weightunit, "KGS") >
			<cfset shipWeightKgs = arguments.weight >
			<cfset shipWeightLbs = numberFormat(shipWeightKgs / lbAsKg, "0.0") >
		<cfelse>
			<cfset shipWeightLbs = arguments.weight >
			<cfset shipWeightKgs = numberFormat(shipWeightLbs * lbAsKg, "0.0") >	
		</cfif>
		
		<cfif NOT compareNoCase(arguments.shiptocountrycode, "US") OR NOT compareNoCase(arguments.shipfromcountrycode, "US") >
			<cfif shipWeightLbs LT 0 OR shipWeightLbs GT 150 >
				<cfthrow message="UPS TimeInTransit/Service Error: Invalid weight (#arguments.weight# #arguments.weightunit#). Shipments to/from the US must be between 0 and 150 lbs">				
			</cfif>
		</cfif>
		
		<cfif NOT compareNoCase(arguments.shiptocountrycode, "CA") OR NOT compareNoCase(arguments.shipfromcountrycode, "CA") >	
			<cfif shipWeightKgs LT 0 OR shipWeightKgs GT 68 >
				<cfthrow message="UPS TimeInTransit/Service Error: Invalid weight (#arguments.weight# #arguments.weightunit#). Shipments to/from Canada must be between 0 and 68 kgs">				
			</cfif>
		</cfif>
		
		<cfif NOT listFindNoCase("US,CA", arguments.shiptocountrycode) AND NOT listFindNoCase("US,CA", arguments.shipfromcountrycode) >	
			<cfif shipWeightKgs LT 0 OR shipWeightKgs GT 70 >
				<cfthrow message="UPS TimeInTransit/Service Error: Invalid weight (#arguments.weight# #arguments.weightunit#). Shipments outside the US and Canada must be between 0 and 70 kgs">				
			</cfif>
		</cfif>
	</cfif>
	
	
	<!--- Package Value required ONLY for non-document shipments outside the US or Document shipments when the Origin or Destination is Canada --->	
	<cfif (NOT arguments.packageDocumentsOnly AND (compareNoCase(arguments.shiptocountrycode, "US") OR compareNoCase(arguments.shipfromcountrycode, "US")))
		  OR
		  (arguments.packageDocumentsOnly AND (NOT compareNoCase(arguments.shiptocountrycode, "CA") OR NOT compareNoCase(arguments.shipfromcountrycode, "CA")))
	>
		<cfif NOT len(arguments.packageValue) >
			<cfthrow message="UPS TimeInTransit/Service Error: Package Value is required for non-document shipments outside the US or Document shipments when the Origin or Destination is Canada">					
		</cfif>
	</cfif>
	<cfif len(arguments.packageValue) AND NOT isNumeric(arguments.packageValue) >
		<cfthrow message="UPS TimeInTransit/Service Error: Package Value is invalid (#arguments.packageValue#)">						
	</cfif>
	
	
	<!--- Validate the pick-up date --->
	<cfset dd = dateDiff("d", dateFormat(now(), "mm/dd/yyyy"), arguments.pickupday) >
	<cfif dd LT -35 OR dd GT 60 >
		<cfthrow message="UPS TimeInTransit/Service Error: Invalid pickup date. Pickup dates can be no more than 35 days in the past or 60 days in the future">					
	</cfif>	

	
	<!--- create req xml --->
	<cfsavecontent variable="reqxml">
	<cfoutput>
<?xml version="1.0"?>
<TimeInTransitRequest xml:lang="en-US">
   <Request>
      <TransactionReference>
         <XpciVersion>1.0002</XpciVersion>
      </TransactionReference>
      <RequestAction>TimeInTransit</RequestAction>
   </Request>
   <TransitFrom>
      <AddressArtifactFormat>
		 <cfif len(arguments.shipfromcity) ><PoliticalDivision2>#xmlFormat(arguments.shipfromcity)#</PoliticalDivision2></cfif>
         <cfif len(arguments.shipfromstatecode) ><PoliticalDivision1>#xmlFormat(arguments.shipfromstatecode)#</PoliticalDivision1></cfif>
         <CountryCode>#xmlFormat(arguments.shipfromcountrycode)#</CountryCode>
         <cfif len(arguments.shipfrompostalcode) ><PostcodePrimaryLow>#xmlFormat(arguments.shipfrompostalcode)#</PostcodePrimaryLow></cfif>
	  </AddressArtifactFormat>
   </TransitFrom>
   <TransitTo>
      <AddressArtifactFormat>
		 <cfif len(arguments.shiptocity) ><PoliticalDivision2>#xmlFormat(arguments.shiptocity)#</PoliticalDivision2></cfif>
         <cfif len(arguments.shiptostatecode) ><PoliticalDivision1>#xmlFormat(arguments.shiptostatecode)#</PoliticalDivision1></cfif>
         <CountryCode>#xmlFormat(arguments.shiptocountrycode)#</CountryCode>
         <cfif len(arguments.shiptopostalcode) ><PostcodePrimaryLow>#xmlFormat(arguments.shiptopostalcode)#</PostcodePrimaryLow></cfif>
		 <cfif arguments.shiptoIsResidential ><ResidentialAddressIndicator/></cfif>
      </AddressArtifactFormat>
   </TransitTo>
   <cfif len(arguments.weight) >
   <ShipmentWeight>
      <UnitOfMeasurement>
         <Code>#xmlFormat(arguments.weightunit)#</Code>
      </UnitOfMeasurement>
      <Weight>#numberFormat(arguments.weight, "0.0")#</Weight>
   </ShipmentWeight>
   </cfif>   
   <cfif len(arguments.packageValue) >
   <InvoiceLineTotal>
      <CurrencyCode>#xmlFormat(arguments.packageValueCurrencyCode)#</CurrencyCode>
      <MonetaryValue>#xmlFormat(arguments.packageValue)#</MonetaryValue>
   </InvoiceLineTotal>
   </cfif>
   <PickupDate>#dateFormat(arguments.pickupday, "YYYYMMDD")#</PickupDate>
   <cfif arguments.packageDocumentsOnly ><DocumentsOnlyIndicator/></cfif>
</TimeInTransitRequest>
	</cfoutput>
	</cfsavecontent>

	<cfset reqxml = trim(reqxml) >

	<cfhttp url="#getURL()#" method="post" result="result">
		<cfhttpparam type="xml" name="data" value="#header##reqxml#">
	</cfhttp>

	<cfset xmlResult = result.filecontent>
	<cfset xmlResult = xmlParse(xmlResult)>


	<!---
		Determine if any candidates were returned and automatically re-submit the request using the FIRST candidate suggested
	--->
	<cfif arguments.resubmitIfCandidatesReturned >
		<cfset fromCandidates = xmlSearch(xmlResult, "/TimeInTransitResponse/TransitFromList/Candidate/") >
		<cfset toCandidates = xmlSearch(xmlResult, "/TimeInTransitResponse/TransitToList/Candidate") >
	
		<cfset reqxml = xmlParse(reqxml) >
		<!--- <cfdump var="#xmlResult#" > --->
	
	
		<cfif ArrayLen(fromCandidates) GT 0 >
			<cfset fromCandidates = fromCandidates[1].AddressArtifactFormat >
			<cfset node = xmlSearch(reqxml, "TimeInTransitRequest/TransitFrom/AddressArtifactFormat") >
			<cfset node = node[1] >	
			
			<cfset synchronizeAddressArtifactWithCandidate(reqxml, node, fromCandidates) >
			<cfset resubmit = true >
		</cfif>
	
		<cfif ArrayLen(toCandidates) GT 0 >
			<cfset toCandidates = toCandidates[1].AddressArtifactFormat >
			<cfset node = xmlSearch(reqxml, "TimeInTransitRequest/TransitTo/AddressArtifactFormat") >
			<cfset node = node[1] >	
			
			<cfset synchronizeAddressArtifactWithCandidate(reqxml, node, toCandidates) >
			<cfset resubmit = true >
		</cfif>
	
		<cfif resubmit >
			<cfhttp url="#getURL()#" method="post" result="result">
				<cfhttpparam type="xml" name="data" value="#header##toString(reqxml)#">
			</cfhttp>
			
			<cfset xmlResult = result.filecontent>
			<cfset xmlResult = xmlParse(xmlResult)>	
		</cfif>
	
		<!---
		<cfdump var="#reqxml#" ><cfdump var="#xmlResult#" ><cfabort>
		---->
	</cfif>



	<cfif structKeyExists(xmlResult, "TimeInTransitResponse")>
		<cfif NOT xmlResult.TimeInTransitResponse.Response.ResponseStatusCode.xmlText EQ 1 >
			<cfset errMsg = "UPS Error (##" & xmlResult.TimeInTransitResponse.Response.Error.ErrorCode.xmlText & ")" >
			<cfif isDefined("xmlResult.TimeInTransitResponse.Response.Error.ErrorDescription") >
				<cfset errMsg = errMsg & " " & xmlResult.TimeInTransitResponse.Response.Error.ErrorDescription.xmlText >
			</cfif>
			<cfthrow message="UPS TimeInTransit/Service Error: #errMsg#">
		</cfif>
		
		<!--- Now get the service summaries and build the query --->
		<cfset summaries = xmlSearch(xmlResult, "/TimeInTransitResponse/TransitResponse/ServiceSummary") >
		<cfloop from="1" to="#ArrayLen(summaries)#" index="i" >
			<cfset sNode = summaries[i] >
			
			<cfset QueryAddRow(results) >
			<cfset QuerySetCell(results, "serviceCode", sNode.Service.Code.xmlText, results.recordCount) >
			<cfif isDefined("sNode.Service.Description") >
				<cfset QuerySetCell(results, "service", sNode.Service.Description.xmlText, results.recordCount) >
			</cfif>			
			<cfset QuerySetCell(results, "guaranteed", false, results.recordCount) >
			<cfif isDefined("sNode.Guaranteed.Code") >
				<cfif NOT compareNoCase(sNode.Guaranteed.Code.xmlText, "Y") >
					<cfset QuerySetCell(results, "guaranteed", true, results.recordCount) >
				</cfif>
			</cfif>
			<cfset QuerySetCell(results, "pickupDayTime", sNode.EstimatedArrival.PickupDate.xmlText, results.recordCount)>
			<cfif structKeyExists(sNode.EstimatedArrival, "PickupTime")>
				<cfset querySetCell(results, "pickupDayTime", results.pickupDayTime[results.recordCount] & " " & sNode.EstimatedArrival.pickuptime.xmlText, results.recordCount)>
			</cfif>
			<cfset QuerySetCell(results, "arrivalDayTime", sNode.EstimatedArrival.Date.xmlText & " " & sNode.EstimatedArrival.Time.xmlText, results.recordCount) >			
			<cfset QuerySetCell(results, "businessTransitDays", sNode.EstimatedArrival.BusinessTransitDays.xmlText, results.recordCount) >			
		</cfloop>
	</cfif>
	
	<cfif len(arguments.serviceCodes) >
		<cfset arguments.serviceCodes = "'" & replaceNoCase(arguments.serviceCodes, ",", "','", "ALL") & "'" >
		<cfquery name="results" dbtype="query" >
			SELECT	*
			FROM	results
			WHERE	serviceCode IN ( #preserveSingleQuotes(arguments.serviceCodes)# )
		</cfquery>	
	</cfif>

	<cfreturn results >	
</cffunction>


<cffunction name="insertUpdateNode" returntype="void" output="no" >
	<cfargument name="xmlDoc" type="xml" required="yes" >
	<cfargument name="xmlNode" type="xml" required="yes" >
	<cfargument name="tag" type="string" required="yes" >
	<cfargument name="xmlText" type="string" required="no" >

	<cfif NOT isDefined("arguments.xmlNode.#arguments.tag#") >
		<cfset arguments.xmlNode.xmlChildren[ArrayLen(arguments.xmlNode.xmlChildren) + 1] = xmlElemNew(arguments.xmlDoc, arguments.tag) >
  	</cfif>
	
	<cfif isDefined("arguments.xmlText") >
		<cfset arguments.xmlNode[arguments.tag].xmlText = arguments.xmlText >
	</cfif>

	<!--- <cfdump var="#arguments.xmlNode#" ><cfabort>	 --->
</cffunction>


<cffunction name="synchronizeAddressArtifactWithCandidate" returntype="void" output="no" >
	<cfargument name="reqXmlDoc" type="xml" required="yes" >
	<cfargument name="addArtifactNode" type="xml" required="yes" >
	<cfargument name="candidateNode" type="xml" required="yes" >
	
	<cfset var fields = "PoliticalDivision1,PoliticalDivision2,PoliticalDivision3,Country,CountryCode,PostCodePrimaryLow,PostCodePrimaryHigh" > 
	<cfset var fld = "" >
	
	<cfloop list="#fields#" index="fld" >
		<cfif isDefined("arguments.candidateNode.#fld#") >
			<cfset insertUpdateNode(arguments.reqXmlDoc, arguments.addArtifactNode, fld, arguments.candidateNode[fld].xmlText) >
		<cfelseif isDefined("arguments.addArtifactNode.#fld#") >
			<cfset StructDelete(arguments.addArtifactNode, fld) >
		</cfif>		
	</cfloop>
</cffunction>

</cfcomponent>
