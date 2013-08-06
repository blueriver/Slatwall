<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

	Notes:
	
--->
<cfcomponent extends="Slatwall.model.service.HibachiService" output="false">
	
	<cffunction name="syncPush" access="public" returntype="Any" >
		
		<cfset var responseBean = new Slatwall.model.transient.ResponseBean() />
		<cfset var integration = getService("integrationService").getIntegrationByIntegrationPackage("endicia") /> 
		
		<!--- Setup Remote Dropoff File Location --->
		<cfset var remoteFullFilePath = integration.setting('syncFTPSiteDropoffDirectory') />
		<cfif right(remoteFullFilePath, 1) eq "/" or right(remoteFullFilePath, 1) eq "\">
			<cfset remoteFullFilePath &= integration.setting('syncFTPSiteDropoffFilename') />
		<cfelse>
			<cfset remoteFullFilePath &= "/#integration.setting('syncFTPSiteDropoffFilename')#" />
		</cfif>
		
		<!--- Get all of the order fulfillments we are going to export --->
		<cfset var orderFulfillmentSmartList = getService("orderService").getOrderFulfillmentSmartList() />
		<cfset orderFulfillmentSmartList.addInFilter("fulfillmentMethod.fulfillmentMethodType", "shipping") />
		<cfset orderFulfillmentSmartList.addInFilter("order.orderStatusType.systemCode", "ostNew,ostProcessing,ostOnHold") />
		
		<!--- Setup Local File Name --->
		<cfset localFullFilePath = getTempDirectory() & "endiciaPush.txt" />
		
		<!--- Create a line Array that will be used to write to the file --->
		<cfset var lineArray = arrayNew(1) />
		
		<!--- 1 --->	<cfset arrayAppend(lineArray, "orderFulfillmentID") />
		<!--- 2 --->	<cfset arrayAppend(lineArray, "fulfillmentCharge") />
		<!--- 3 --->	<cfset arrayAppend(lineArray, "order_orderID") />
		<!--- 4 --->	<cfset arrayAppend(lineArray, "order_orderNumber") />
		<!--- 5 --->	<cfset arrayAppend(lineArray, "order_account_accountID") />
		<!--- 6 --->	<cfset arrayAppend(lineArray, "order_account_firstName") />
		<!--- 7 --->	<cfset arrayAppend(lineArray, "order_account_lastName") />
		<!--- 8 --->	<cfset arrayAppend(lineArray, "order_account_emailAddress") />
		<!--- 9 --->	<cfset arrayAppend(lineArray, "order_account_phoneNumber") />
		<!--- 10 --->	<cfset arrayAppend(lineArray, "address_name") />
		<!--- 11 --->	<cfset arrayAppend(lineArray, "address_company") />
		<!--- 12 --->	<cfset arrayAppend(lineArray, "address_phone") />
		<!--- 13 --->	<cfset arrayAppend(lineArray, "address_streetAddress") />
		<!--- 14 --->	<cfset arrayAppend(lineArray, "address_street2Address") />
		<!--- 15 --->	<cfset arrayAppend(lineArray, "address_locality") />
		<!--- 16 --->	<cfset arrayAppend(lineArray, "address_city") />
		<!--- 17 --->	<cfset arrayAppend(lineArray, "address_stateCode") />
		<!--- 18 --->	<cfset arrayAppend(lineArray, "address_postalCode") />
		<!--- 19 --->	<cfset arrayAppend(lineArray, "address_countryCode") />
		<!--- 20 --->	<cfset arrayAppend(lineArray, "shippingMethod_shippingMethodID") />
		<!--- 21 --->	<cfset arrayAppend(lineArray, "shippingMethod_shippingMethodName") />
		<!--- 22 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingMethodRateID") />
		<!--- 23 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingIntegrationMethod") />
		<!--- 24 --->	<cfset arrayAppend(lineArray, "shippingMethodRate_shippingIntegration_integrationPackage") />
		
		<!--- Write First Line Of New File --->
		<cffile action="write" file="#localFullFilePath#" output="#arrayToList(lineArray, chr(9))#" />
		
		<!--- Loop over order fulfillments and append each one to a new line in the file --->
		<cfset var orderFulfillment = "" />
		<cfloop array="#orderFulfillmentSmartList.getRecords()#" index="orderFulfillment">
			<cftry>
				
				<!--- Create fulfillment line --->
				<cfset lineArray = arrayNew(1) />
				
				<!--- 1 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrderFulfillmentID()) />
				<!--- 2 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getFulfillmentCharge(), 0)) />
				<!--- 3 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getOrderID()) />
				<!--- 4 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getOrderNumber()) />
				<!--- 5 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getAccountID()) />
				<!--- 6 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getFirstName()) />
				<!--- 7 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getLastName()) />
				<!--- 8 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getEmailAddress()) />
				<!--- 9 --->	<cfset arrayAppend(lineArray, orderFulfillment.getOrder().getAccount().getPhoneNumber()) />
				<!--- 10 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getName(), "")) />
				<!--- 11 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getCompany(), "")) />
				<!--- 12 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getPhone(), "")) />
				<!--- 13 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getStreetAddress(), "")) />
				<!--- 14 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getStreet2Address(), "")) />
				<!--- 15 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getLocality(), "")) />
				<!--- 16 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getCity(), "")) />
				<!--- 17 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getStateCode(), "")) />
				<!--- 18 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getPostalCode(), "")) />
				<!--- 19 --->	<cfset arrayAppend(lineArray, nullReplace(orderFulfillment.getAddress().getCountryCode(), "")) />
				<!--- 20 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethod().getShippingMethodID()) />
				<!--- 21 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethod().getShippingMethodName()) />
				<cfif not isNull(orderFulfillment.getShippingMethodRate())>
					<!--- 22 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingMethodRateID()) />
					<!--- 23 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingIntegrationMethod()) />
					<cfif not isNull(orderFulfillment.getShippingMethodRate().getShippingIntegration())>
						<!--- 24 --->	<cfset arrayAppend(lineArray, orderFulfillment.getShippingMethodRate().getShippingIntegration().getIntegrationPackage()) />
					<cfelse>
						<!--- 24 --->	<cfset arrayAppend(lineArray, "") />
					</cfif>
				<cfelse>
					<!--- 22 --->	<cfset arrayAppend(lineArray, "") />
					<!--- 23 --->	<cfset arrayAppend(lineArray, "") />
					<!--- 24 --->	<cfset arrayAppend(lineArray, "") />
				</cfif>
				
				<!--- Write this line to the file --->
				<cffile action="append" file="#localFullFilePath#" output="#arrayToList(lineArray, chr(9))#" addnewline="true" />
				
				<cfcatch>
					<cfset responseBean.addError("line", "There was an error adding one of the order fulfillments to the export file, but others may have exported") />
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cftry>
			
			<!---[SEVER CONDITIONAL]--->
			<cfif structKeyExists(server, "railo")>
				<cfftp action="putfile" server="#integration.setting('syncFTPSite')#" username="#integration.setting('syncFTPSiteUsername')#" password="#integration.setting('syncFTPSitePassword')#" port="#integration.setting('syncFTPSitePort')#" remotefile="#remoteFullFilePath#" localfile="#localFullFilePath#">
			<cfelse>
				<cfinclude template="cfftp_acfonly.cfm" />
			</cfif>

			<cfcatch>
				<cfset logHibachiException(cfcatch) />
				<cfset responseBean.addError("ftp", "There was an error connecting to the sync ftp server.  Please check your setting credentials and try again") />
			</cfcatch>
		</cftry>
		
		<cfreturn responseBean />	
	</cffunction>
	
	<cffunction name="syncPull" access="public" returntype="Any" >
		<cfset var responseBean = getTransient("ResponseBean") />
		
		<cfset responseBean.addError("test", "This is a test error") />
		
		<cfreturn responseBean />		
	</cffunction>
</cfcomponent>