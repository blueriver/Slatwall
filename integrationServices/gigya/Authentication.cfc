<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->

<cfcomponent accessors="true" output="false" implements="Slatwall.integrationServices.AuthenticationInterface" extends="Slatwall.integrationServices.BaseAuthentication">

	<cfproperty name="signatureUtilities" type="any" />
	
	<!--- ============== START: Slatwall API Hooks ================= --->
	<cffunction name="verifySessionLogin" access="public" returntype="boolean">
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getAdminLoginHTML" access="public" returntype="string">
		<cfreturn renderGigyaWidget({
			loginFormID = 'adminLogin'
		}) />
	</cffunction>
	
	<cffunction name="renderGigyaWidget" access="public" returntype="string">
		<cfargument name="config" default="#structNew()#" />
		
		<!--- setup the defaults --->
		<cfparam name="arguments.config.showTermsLink" default="false" />
		<cfparam name="arguments.config.height" default="100" />
		<cfparam name="arguments.config.width" default="400" />
		<cfparam name="arguments.config.containerID" default="#createUUID()#" />
		<cfparam name="arguments.config.buttonsStyle" default="fullLogo" />
		<cfparam name="arguments.config.autoDetectUserProviders" default="" />
		<cfparam name="arguments.config.facepilePosition" default="none" />
		
		<cfset var gigyaWidget = "" />
		
		<cfsavecontent variable="gigyaWidget">
			<cfoutput>
				<script type="text/javascript">
					var login_params = #serializeJSON(arguments.config)#;
				</script>
				<div id="#arguments.config.containerID#"></div>
				<script type="text/javascript">
				   gigya.socialize.showLoginUI( login_params );
				</script>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn gigyaWidget />
	</cffunction>
	
	<!--- =============== END: Slatwall API Hooks ================== --->
		
	<!--- =============== START: GIGYA REST Calls =-================ --->
		
	<!--- socialize.notifyRegistration --->
	<cffunction name="socializeNotifyRegistration">
		<cfargument name="account" type="any" required="true" />
		<cfargument name="uid" type="struct" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.notifyRegistration" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#arguments.UID#" />
			<cfhttpparam type="formfield" name="siteUID" value="#arguments.account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.removeConnection --->
	<cffunction name="socializeRemoveConnection">
		<cfargument name="account" type="any" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		 
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.removeConnection" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- socialize.logout --->
	<cffunction name="socializeLogout">
		<cfargument name="account" type="any" required="true" />
		
		<cfset var rawResponse = "" />
		<cfset var xmlResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.logout" result="rawResponse">
			<cfhttpparam type="formfield" name="apiKey" value="#setting('apiKey')#" />
			<cfhttpparam type="formfield" name="secret" value="#setting('secretKey')#" />
			<cfhttpparam type="formfield" name="UID" value="#account.getAccountID()#" />
		</cfhttp>
		
		<cfset xmlResponse = xmlParse(rawResponse.fileContent) />
		
		<cfreturn xmlResponse />
	</cffunction>
	
	<!--- =============== END: GIGYA REST Calls =-================ --->
		
		
	<!--- ============== START: Processing Methods =============== --->
		
	<cffunction name="loginViaGigya">
		<cfargument name="uid" type="string" required="true" />
		<cfargument name="uidSignature" type="string" required="true" />
		<cfargument name="signatureTimestamp" type="string" required="true" />
		
		<!--- Validate the signature --->
		<cfif getSignatureUtilities().validateUserSignature( arguments.uid, arguments.signatureTimestamp, setting('secretKey'), arguments.uidSignature )>
			
			<!--- Get the account by the UID --->
			<cfset var account = getService("accountService").getAccount( uid ) />
			
			<!--- Make sure the account was found --->
			<cfif !isNull(account)>
				
				<!--- Loop over the account authentications --->
				<cfloop array="#account.getAccountAuthentications()#" index="accountAuthentication">
					
					<!--- When the gigya authentication is found, login the account --->
					<cfif accountAuthentication.getIntegration().getIntegrationPackage() eq 'gigya'>
						<cfset getService("sessionService").loginAccount( account=account, accountAuthentication=accountAuthentication) />
						<cfbreak />
					</cfif>
					
				</cfloop>
					
			</cfif>
			
		</cfif>
		
	</cffunction>
		
	<!--- ============== START: Processing Methods =============== --->
	
	<cffunction name="getSignatureUtilities">
		<cfif not structKeyExists(variables, "signatureUtilities")>
			<cfset var JavaLoader = createObject("Component", "Slatwall.integrationServices.gigya.org.javaloader.JavaLoader").init([expandPath('/Slatwall/integrationServices/gigya/org/gigya/GSJavaSDK.jar')]) />
			<cfset variables.signatureUtilities = JavaLoader.create("com.gigya.socialize.SigUtils").init() />
		</cfif>
		<cfreturn variables.signatureUtilities />
	</cffunction>

</cfcomponent>

