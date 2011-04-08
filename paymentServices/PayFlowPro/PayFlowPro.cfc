<!---

    This component was built by:
    Greg Moser
    http://www.gregmoser.com
    
    It is based on a custom tag Written by Ryan Stille, CF WebTools.
	These are the associated Credits & License of that tag.
	 
	--------------------------------------------------------
	CF_PayFlowPro v1.4
	Written by Ryan Stille, CF WebTools.
	Based on code discussed on this blog post:
	http://www.dervishmoose.com/blog/index.cfm/2008/3/10/Drop-in-replacement-for-CFXPAYFLOWPRO-on-ColdFusion-8

	Me:
	http://www.stillnetstudios.com
	http://www.cfwebtools.com
	Please send me feedback at ryan@cfwebtools.com. 

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


<cfcomponent>
	
	<cffunction name="processPayment" returntype="query">
		<cfargument name="hostAddress" />
		<cfargument name="hostPort" />
		<cfargument name="timeout" />
		<cfargument name="requestID" />
		
		<cfargument name="TRXTYPE" />
		<cfargument name="TENDER" />
		<cfargument name="PARTNER" />
		<cfargument name="USER" />
		<cfargument name="PWD" />
		<cfargument name="ACCT" />
		<cfargument name="EXPDATE" />
		<cfargument name="AMT" />
		<cfargument name="CVV2" />
		<cfargument name="COMMENT1" />
		<cfargument name="COMMENT2" />
		<cfargument name="ACTION" />
		<cfargument name="EMAIL" />
		<cfargument name="NAME" />
		<cfargument name="STREET" />
		<cfargument name="CITY" />
		<cfargument name="STATE" />
		<cfargument name="ZIP" />
		<cfargument name="START" />
		<cfargument name="PROFILENAME" />
		<cfargument name="PAYPERIOD" />
		<cfargument name="OPTIONALTRX" />
		<cfargument name="OPTIONALTRXAMT" />
		<cfargument name="IP" />
		<cfargument name="PHONENUM" />
		<cfargument name="TERM" />
		<cfargument name="ORIGPROFILEID" />
		<cfargument name="ORIGID" />
		<cfargument name="ABA" />
		<cfargument name="ACCTTYPE" />		
		
		<cfset arguments.vendor = arguments.user />
		
		<cfset var ParmList = "">
		
		<cfloop list="TRXTYPE,TENDER,PARTNER,VENDOR,USER,PWD,ACCT,EXPDATE,AMT,CVV2,COMMENT1,COMMENT2,ACTION,EMAIL,NAME,STREET,CITY,STATE,ZIP,START,PROFILENAME,PAYPERIOD,OPTIONALTRX,OPTIONALTRXAMT,IP,PHONENUM,TERM,ORIGPROFILEID,ORIGID,ABA,ACCTTYPE" index="field">
			<cfif StructKeyExists(Attributes,field) AND Len(Attributes[field])>
				<cfif Len(ParmList)>
					<cfset ParmList = ParmList & "&">
				</cfif>
				<cfset ParmList = ParmList & "#field#[#len(attributes[field])#]=#Attributes[field]#">
			</cfif>
		</cfloop>
		
		<cfhttp method="POST" url="https://#arguments.hostaddress#/transaction" resolveurl="no" timeout="#arguments.timeout#" port="#arguments.hostPort#">
		   <cfhttpparam type="header" name="Content-Type" VALUE="text/namevalue">
		   <cfhttpparam type="header" name="Content-Length" VALUE="#Len(ParmList)#">
		   <cfhttpparam type="header" name="Host" value="#arguments.hostaddress#">
		   <cfhttpparam type="header" name="X-VPS-REQUEST-ID" VALUE="#arguments.requestID#">
		   <cfhttpparam type="header" name="X-VPS-CLIENT-TIMEOUT" VALUE="#arguments.timeout#">
		   <cfhttpparam type="header" name="X-VPS-VITCLIENTCERTIFICATION-ID" VALUE="#arguments.partner##arguments.user#">
		   <cfhttpparam type="body" value="#ParmList#">
		</cfhttp>
		
		<cfset tmpResponse = QueryNew("")>
		
		<cfset QueryAddRow(tmpResponse, 1)>
		
		<cfloop list="#cfhttp.FileContent#" index="i" delimiters="&">
			<cfset QueryAddColumn(tmpResponse, Replace(listfirst(i,'='), ' ', '_', 'all') , ListToArray(listlast(i,"=")))>
		</cfloop>
		
		<cfset QueryAddColumn(tmpResponse, 'RESULTSTR' , ListToArray(cfhttp.FileContent))>
		<cfset QueryAddColumn(tmpResponse, 'PARMLIST' , ListToArray(ParmList))>
		
		<cfreturn tmpResponse />
	</cffunction>
	
</cfcomponent>