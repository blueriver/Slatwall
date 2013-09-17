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

	<cffunction name="verifySessionLogin" access="public" returntype="boolean">
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getAdminLoginHTML" access="public" returntype="string">
		<cfset var adminLoginHTML = "" />
		<cfset var initializationStruct = {} />
		
		<cfset initializationStruct[ "siteName" ] = setting('siteName') />
		<cfset initializationStruct[ "enabledProviders" ] = setting('enabledProviders') />
		
		<cfsavecontent variable="adminLoginHTML">
			<cfoutput>
				<script type="text/javascript" src="http://cdn.gigya.com/js/socialize.js?apiKey=#setting('apiKey')#">
					#serializeJSON(initializationStruct)#
				</script>
				<script type="text/javascript" src="#getApplicationValue('baseURL')#/integrationServices/gigya/assets/js/gigya.js"></script>
				<script type="text/javascript">
					var login_params= {
						showTermsLink: 'false'
						,height: 100
						,width: 330
						,containerID: 'gigyaLogin'
						,buttonsStyle: 'fullLogo'
						,autoDetectUserProviders: ''
						,facepilePosition: 'none'
					}
				</script>
				<div id="gigyaLogin"></div>
				<script type="text/javascript">
				   gigya.socialize.showLoginUI( login_params );
				</script>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn adminLoginHTML />
	</cffunction>
	
	<cffunction name="linkAccountToGigya">
		<cfargument name="account" type="any" required="true" />
		<cfargument name="data" type="struct" required="true" />
		
		<cfset var gigyaNotifyResponse = "" />
		
		<cfhttp method="post" url="https://socialize.gigya.com/socialize.notifyRegistration" name="gigyaNotifyResponse">
			<cfhttpparam type="formfield" name="UID" value="#arguments.data.UID#" />
			<cfhttpparam type="formfield" name="siteUID" value="#arguments.account.getAccountID()#" />
		</cfhttp>
		
		<cfdump var="#gigyaNotifyResponse#" />
		<cfabort />
	</cffunction>

	<!---
	<cffunction name="init" access="public" returntype="Gigya" output="false">
		<cfargument name="secret" type="string" default="Kz0XznsVOeNRSTwL4WpbJlDR8yDQrxfPb3e/8JzH+xI=" required="false">
		
		<cfscript>
			variables.secret = arguments.secret;
		</cfscript>
		
		<cfreturn this/>
	</cffunction>

	<cffunction name="getSignature" access="public" returntype="any" output="false" hint="Returns signature">
		<cfargument name="UID" type="string" default="" required="true">
		<cfargument name="giventimestamp" type="string" default="" required="false">
		<cfargument name="regPath" type="boolean" default="false" required="false">
		<cfargument name="offset" type="numeric" default="0" required="false">
		
		<cfset var stResult = {timeStamp='', sig=''} />
		
		<cfif not len(arguments.giventimestamp)>
			<cfset timeStamp = DateDiff("s", "January 1 1970 00:00", now()+arguments.offset)+18000><!--- GetTimeZoneInfo().utcTotalOffset --->
		<cfelse>
			<cfset timeStamp = arguments.giventimestamp>
		</cfif>
		<cfset baseString = timeStamp & "_" & arguments.UID>
		<cfset binarySecret = ToBinary(variables.secret)>
		

		<cfscript>
			if (arguments.regPath == true) {
				sourcePaths = ["/netscape_data/CustomTags/com/gigya/signatureSrc"];
			}
			else {
				sourcePaths = ["/netscape_data/CustomTags/com/gigya/signatureSrc"];
			}

			loader = createObject("component", "com.sciam.tags.javaloader.JavaLoader").init(sourceDirectories=sourcePaths);
			oSig = loader.create("OAuthSignature").init();
		</cfscript>
		<cfset stResult.sig = oSig.GetOAuthSignatureBase64(binarySecret,baseString)>
		<cfset stResult.timeStamp = timeStamp>
		
		<cfreturn stResult>
	</cffunction>
		
	<cffunction name="checkSignature" access="public" returntype="any" output="false" hint="Returns signature">
		<cfargument name="UID" type="string" default="" required="true">
		<cfargument name="timestamp" type="string" default="" required="true">
		<cfargument name="sig" type="string" default="" required="true">
		<cfargument name="regPath" type="boolean" default="false" required="false">


		<cfset validTimeStamp = DateDiff("s", "January 1 1970 00:00", now())+18000><!--- GetTimeZoneInfo().utcTotalOffset --->
		
		<cfif not regPath AND Abs(validTimeStamp-arguments.timestamp) gt 180>
			<cfreturn false>
		</cfif>
		
		<cfset checkSig = getSignature(arguments.UID, arguments.timestamp, arguments.regPath)>

		<cfif checkSig.sig eq arguments.sig>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>


	<cffunction name="gLogin" access="remote" returntype="struct" returnformat="JSON">
		<cfargument name="gUID" type="string" required="false" default="" />
		<cfargument name="gigyaSig" required="true" type="string" displayname="signature" default="">
		<cfargument name="gigyaTimestamp" required="true" type="string" displayname="timestamp" default="">

		<cfset var stResult = {error=false, message='', username='', UID='', sig='', timestamp=''} />
		<cfset arguments.gUID = trim(arguments.gUID)>

		<cfset gigya = createObject("component","com.sciam.providers.gigya").init()/>
		<cfset isValidSig = gigya.checkSignature(arguments.gUID, arguments.gigyaTimestamp, arguments.gigyaSig)>

		<cfif isValidSig>
			<cfif NOT len(arguments.gUID)>
				<cfset stResult.error = true />
				<cfset stResult.message = "Invalid login." />
			<cfelse>
				<cfparam name="Cookie.sSciAmUser" default=""/>
		        <cfset Request.stSciAmUser = Application.objSciAmUsers.getCurrentStatus_Cookie(sCookieIN=Cookie.sSciAmUser, gUID=arguments.gUID)>

				<cfif Request.stSciAmUser.auth>
					<cfset stResult.UID = arguments.gUID>

					<cfset sigResult = gigya.getSignature(stResult.UID)>
					<cfset stResult.timestamp = sigResult.timeStamp>
					<cfset stResult.sig = sigResult.sig>
					<cfset stResult.message = "<p>Sign in for #request.stSciAmUser.username# was successful</p>">
					<cfset stResult.username = Request.stSciAmUser.username>
				<cfelse>
					<cfset stResult.error = true />
					<cfset stResult.message = "<p>Sign in failed. Invalid username or password</p>" />
				</cfif>
			</cfif>
		<cfelse>
			<cfset stResult.error = true />
			<cfset stResult.message = "Illegal access!" />
		</cfif>
		<cfreturn stResult/>
	</cffunction>

	<cffunction name="gLinkAccounts" access="remote" returntype="struct" returnformat="JSON">
		<cfargument name="gUSERNAME" required="true" type="string" displayname="Username" default="#form.gusername#">
		<cfargument name="gPASSWORD" required="true" type="string" displayname="Password" default="#form.gusername#">
		<cfargument name="gigyaUID" required="true" type="string" displayname="gigya UID from request" default="#form.gigyaUID#">
		<cfargument name="sig" required="true" type="string" displayname="signature" default="#form.gigyaSig#">
		<cfargument name="timestamp" required="true" type="string" displayname="timestamp" default="#form.gigyaTimestamp#">

		<cfset var stResult = {error=false, message='', username='', UID='', sig='', timestamp=''} />

		<cfset gigya = createObject("component","com.sciam.providers.gigya").init()/>
		<cfset isValidSig = gigya.checkSignature(arguments.gigyaUID, arguments.timestamp, arguments.sig)>

		<cfif isValidSig>
			<cfset oU = createObject("component","com.sciam.dao.sciam_user").init()/>
	        <cfset isAuthenticated = oU.Authenticate(arguments.gUSERNAME, arguments.gPASSWORD)>

			<cfif isAuthenticated.recordCount>
 				<cfset stResult.UID = isAuthenticated.User_ID>

				<cfset sigResult = gigya.getSignature(stResult.UID)>
				<cfset stResult.timestamp = sigResult.timeStamp>
				<cfset stResult.sig = sigResult.sig>

				<cfset sigResult2 = gigya.getSignature(stResult.UID, "", false, .001)>
				<cfset stResult.timestamp2 = sigResult2.timeStamp>
				<cfset stResult.sig2 = sigResult2.sig>

				<cfset stResult.message = "<p>Your accounts were successfully linked and you are now logged in.<br><a href='http://www.scientificamerican.com/page.cfm?section=my-account'>Review your profile</a></p>" />
				<cfset authenticate = loginUser(arguments.gUSERNAME, arguments.gPASSWORD)>
				<cfset stResult.username = Request.stSciAmUser.username>
			<cfelse>
				<cfset stResult.error = true />
				<cfset stResult.message = "<p>Sign in failed. Invalid username or password</p>" />
			</cfif>
		<cfelse>
			<cfset stResult.error = true />
			<cfset stResult.message = "<p>Illegal access!</p>" />
		</cfif>

		<cfreturn stResult/>
	</cffunction>
	--->

</cfcomponent>

