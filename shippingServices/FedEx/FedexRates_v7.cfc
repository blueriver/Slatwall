<cfcomponent>
<!---
***** ColdFusion FedEx Rate Component *****
http://code.google.com/p/cffedexrates/downloads
Original Developer: Brandon Wolf, FusionAge Inc. (BrandonWolf@FusionAge.com) http://www.fusionage.com
Feel free to modify this script, but I would appreciate it if you left the credits
See INFO.TXT for detailed information on this Component
--->
	<cffunction name="getRates" access="public" returntype="struct" output="true">
		<!---VALIDATION -- YOU MUST FILL THIS IN WITH YOUR INFORMATION FROM FEDEX--->
        <cfargument name="myKey" type="string" required="no" default="">
        <cfargument name="myPassword" type="string" required="no" default="">
        <cfargument name="myAccountNo" type="string" required="no" default="">
        <cfargument name="myMeterNo" type="string" required="no" default="">
        <cfargument name="sandbox" type="boolean" required="no" default="true">
    	<!---Shipper (Sender) Details--->
    	<cfargument name="shipperAddress1" type="string" required="yes">
        <cfargument name="shipperAddress2" type="string" required="no" default="">
        <cfargument name="shipperCity" type="string" required="yes">
        <cfargument name="shipperState" type="string" required="yes">
        <cfargument name="shipperZip" type="string" required="yes">
        <cfargument name="shipperCountry" type="string" required="no" default="US">
        <!---Ship To (Recipient) Details--->
        <cfargument name="shipToAddress1" type="string" required="yes">
        <cfargument name="shipToAddress2" type="string" required="no" default="">
        <cfargument name="shipToCity" type="string" required="yes">
        <cfargument name="shipToState" type="string" required="yes">
        <cfargument name="shipToZip" type="string" required="yes">
        <cfargument name="shipToCountry" type="string" required="yes" default="US">
        <cfargument name="shipToResidential" type="boolean" required="no" default="false">
        <!---Package Details--->
		<cfargument name="pkgWeight" type="numeric" required="yes">
        <cfargument name="pkgValue" type="numeric" required="yes">
	    <cfargument name="pkgLength" type="numeric" required="no" default="0">
	    <cfargument name="pkgWidth" type="numeric" required="no" default="0">
	    <cfargument name="pkgHeight" type="numeric" required="no" default="0">

		<cfset var XMLPacket 	= "" />
		<cfset var fedexUrl 		= "" />
		<cfset var xmlFile 			= "" />
		<cfset var cfhttp			= "" />
		<cfset var err				= "" />
		<cfset var fedexReply		= "" />
		<cfset var n				= "" />
		<cfset var r				= "" />
				
        <!---Build the XML Packet to send to FedEx--->
		<cfsavecontent variable="XMLPacket"><cfoutput>
        <ns:RateRequest xmlns:ns="http://fedex.com/ws/rate/v7" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ns:WebAuthenticationDetail>
                <ns:UserCredential>
                    <ns:Key>#arguments.myKey#</ns:Key>
                    <ns:Password>#arguments.myPassword#</ns:Password>
                </ns:UserCredential>
            </ns:WebAuthenticationDetail>
            <ns:ClientDetail>
                <ns:AccountNumber>#arguments.myAccountNo#</ns:AccountNumber>
                <ns:MeterNumber>#arguments.myMeterNo#</ns:MeterNumber>
            </ns:ClientDetail>
            <ns:Version>
                <ns:ServiceId>crs</ns:ServiceId>
                <ns:Major>7</ns:Major>
                <ns:Intermediate>0</ns:Intermediate>
                <ns:Minor>0</ns:Minor>
            </ns:Version>
            <ns:RequestedShipment>
                <ns:ShipTimestamp>#DateFormat(Now(),'yyyy-mm-dd')#T#TimeFormat(Now(),'hh:mm:ss')#</ns:ShipTimestamp>
                <ns:DropoffType>REGULAR_PICKUP</ns:DropoffType>
                <ns:PackagingType>YOUR_PACKAGING</ns:PackagingType>
                <ns:TotalWeight>
                    <ns:Units>LB</ns:Units>
                    <ns:Value>#arguments.pkgWeight#</ns:Value>
                </ns:TotalWeight>
                <ns:TotalInsuredValue>
                    <ns:Currency>USD</ns:Currency>
                    <ns:Amount>#arguments.pkgValue#</ns:Amount>
                </ns:TotalInsuredValue>
                <ns:Shipper>
                    <ns:Address>
                        <ns:StreetLines>#arguments.shipperAddress1#</ns:StreetLines>
                        <ns:City>#arguments.shipperCity#</ns:City>
                        <ns:StateOrProvinceCode>#arguments.shipperState#</ns:StateOrProvinceCode>
                        <ns:PostalCode>#arguments.shipperZip#</ns:PostalCode>
                        <ns:CountryCode>#arguments.shipperCountry#</ns:CountryCode>
                    </ns:Address>
                </ns:Shipper>
                <ns:Recipient>
                    <ns:Address>
                        <ns:StreetLines>#arguments.shiptoaddress1#</ns:StreetLines>
                        <ns:City>#arguments.shiptocity#</ns:City>
                        <ns:StateOrProvinceCode>#arguments.shiptostate#</ns:StateOrProvinceCode>
                        <ns:PostalCode>#arguments.shiptozip#</ns:PostalCode>
                        <ns:CountryCode>#arguments.shiptocountry#</ns:CountryCode>
						<ns:Residential>#arguments.shiptoresidential#</ns:Residential>
                    </ns:Address>
                </ns:Recipient>
                <ns:RateRequestTypes>LIST</ns:RateRequestTypes>
                <ns:PackageCount>1</ns:PackageCount>
                <ns:PackageDetail>INDIVIDUAL_PACKAGES</ns:PackageDetail>
                <ns:RequestedPackageLineItems>
                    <ns:SequenceNumber>1</ns:SequenceNumber>
                    <ns:InsuredValue>
                        <ns:Currency>USD</ns:Currency>
                        <ns:Amount>#arguments.pkgValue#</ns:Amount>
                    </ns:InsuredValue>
                    <ns:Weight>
                        <ns:Units>LB</ns:Units>
                        <ns:Value>#arguments.pkgWeight#</ns:Value>
                    </ns:Weight>
			        <cfif arguments.pkgLength GT 0 AND arguments.pkgWidth GT 0 AND arguments.pkgHeight>
				    <ns:Dimensions>
						<ns:Length>#arguments.pkgLength#</ns:Length>
				   		<ns:Width>#arguments.pkgWidth#</ns:Width>
				   		<ns:Height>#arguments.pkgHeight#</ns:Height>
	                	<ns:Units>IN</ns:Units>
	                </ns:Dimensions>
			 		</cfif>
                </ns:RequestedPackageLineItems>
            </ns:RequestedShipment>
        </ns:RateRequest>
        </cfoutput></cfsavecontent>

        <cfif arguments.sandbox>
        	<cfset fedexUrl = "https://gatewaybeta.fedex.com/xml">
        <cfelse>
        	<cfset fedexUrl = "https://gateway.fedex.com/xml">
        </cfif>

		<!--- send the request --->
        <cfhttp url="#fedexurl#" port="443" method ="POST" throwonerror="yes"> 
            <cfhttpparam name="name" type="XML" value="#XMLPacket#"> 
        </cfhttp>
        <cfset xmlFile = XmlParse(CFHTTP.FileContent)>

		<!---Build the Struct for Return--->
        <cfset err = false>
        <cfset fedexReply = StructNew()>
        <cfset fedexReply.response = Arraynew(1)>

        <!---Did you pass bad info or malformed XML?--->
        <cfif not isDefined('xmlFile.Fault')>

        	<cfloop from="1" to="#arrayLen(xmlfile.RateReply.Notifications)#" index="n">
            	<cfset fedexReply.response[n] = structNew()>
                <cfset fedexReply.response[n].status = xmlfile.RateReply.Notifications[n].Severity.xmltext>
                <cfset fedexReply.response[n].msg = xmlfile.RateReply.Notifications[n].Message.xmltext>
                <cfif fedexReply.response[n].status contains "Error">
					<cfset err = true>
				</cfif>
			</cfloop>

            <!---Did FedEx reply with an error?--->
            <cfif NOT err>
				
				<!--- Extract rates --->
            	<cfset fedexReply.rate = ArrayNew(1)>
                <cfloop from="1" to="#arrayLen(xmlfile.RateReply.RateReplyDetails)#" index="r">
                   	<cfset fedexReply.rate[r] = StructNew()>
					<cfset fedexReply.rate[r].type = xmlfile.RateReply.RateReplyDetails[r].ServiceType.xmltext>
                    <cfset fedexReply.rate[r].cost = xmlfile.RateReply.RateReplyDetails[r].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext>
				</cfloop>

			</cfif>

		<cfelse>
           	<cfset fedexReply.response = ArrayNew(1)>
        	<cfset fedexReply.response[1] = structNew()>
			<cfset fedexReply.response[1].status = "Error">
            <cfset fedexReply.response[1].msg = "Please check your code...you most likely have an invalid character in your validation variables">
		</cfif>

		<cfreturn fedexReply>
	</cffunction>
</cfcomponent>