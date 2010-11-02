<cfcomponent output="false" name="messageManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="addMessage" access="public" returntype="string" output="false">
		<cfargument name="MessageCode" type="string" required="true" />
		<cfargument name="FormName" type="string" default="" />
		<cfargument name="InputName" type="string" default="" />
		<cfargument name="CustomID" type="string" default="" />
		<cfargument name="slatProcess" type="string" default="" />
		
		<cfset NewMessage = structNew() />
		<cfset NewMessage.MessageCode = arguments.MessageCode />
		<cfset NewMessage.FormName = arguments.FormName />
		<cfset NewMessage.InputName = arguments.InputName />
		<cfset NewMessage.CustomID = arguments.CustomID />
		<cfset NewMessage.slatProcess = arguments.slatProcess />
		<cfset NewMessage.MessageLogID = 0 />
		<!--- <cfset NewMessage.MessageLogID = logMessage(NewMessage) /> --->
		
		<cfif not isDefined("Request.Slat.Messages")>
			<cfset Request.Slat.Messages = arraynew(1) />
		</cfif>
		
		<cfset ArrayAppend(Request.Slat.Messages, NewMessage) />
	</cffunction>

	<cffunction name="dspMessage" access="public" returntype="string" output="false">
		<cfargument name="FormName" type="string" default="none" />
		<cfargument name="InputName" type="string" default="none" />
		<cfargument name="CustomID" type="string" default="none" />
		
		<cfset DisplayMessage = "" />
		
		<cfif isDefined("Request.Slat.Messages")>
			<cfloop array="#Request.Slat.Messages#" Index="ThisMessage">
				<cfif ThisMessage.FormName eq arguments.FormName or ThisMessage.InputName eq arguments.InputName or ThisMessage.CustomID eq Arguments.CustomID>
					<cfset DisplayMessage = getMessage(ThisMessage.MessageCode, ThisMessage.MessageLogID) />			
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif DisplayMessage neq "">
			<cfset DisplayMessage = "<div class='slatMessage'>#DisplayMessage#</div>" />
		</cfif>
		
		<cfreturn DisplayMessage>
	</cffunction>
	
	<cffunction name="getMessage" access="private" returntype="string" output="false">
		<cfargument name="MessageCode" type="string">
		<cfargument name="MessageLogID" default=0>
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select
				Message
			From
				tslatmessage
			Where
				MessageCode = '#arguments.MessageCode#'
		</cfquery>
		
		<!---
		<cfif MessageLogID gt 0>
			<cfquery name="UpdateMessageLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				Update tslatmessagelog Set Shown=1, DTShown=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" /> Where MessageLogID = #arguments.MessageLogID#
			</cfquery>
		</cfif>
		--->
		<cfif rs.recordcount eq 0>
			<cfset return = "An Unexpected Error Occured">
		<cfelse>
			<cfset return = rs.Message>
		</cfif>
		
		<cfreturn return>
	</cffunction>
	
	<cffunction name="logMessage" access="private" returntype="numeric" output="false">
		<cfargument name="Message" required="true" />
		
		
		<cfwddx action="CFML2WDDX" input="#Session#" output="variables.CurrentSession" />
		<cfwddx action="CFML2WDDX" input="#Form#" output="variables.CurrentForm" />
		<cfwddx action="CFML2WDDX" input="#CGI#" output="variables.CurrentCGI" />		
		
		<cfquery name="InsertMessageLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Insert Into	tslatmessagelog(
				DTCreated,
				MessageCode,
				FormName,
				InputName,
				CustomID,
				slatProcess,
				CurrentSession,
				CurrentForm,
				CurrentCGI
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Message.MessageCode#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Message.FormName#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Message.InputName#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Message.CustomID#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Message.slatProcess#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentSession#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentForm#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentCGI#" />
			);
			SELECT IDENT_CURRENT('tslatmessagelog') as LogID;
		</cfquery>
		
		<cfreturn InsertMessageLog.LogID>
	</cffunction>
	
	<cffunction name="getMessageLog" access="public" returntype="query" output="false">
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select top 100
				MessageLogID,
				DTCreated,
				MessageCode,
				FormName,
				InputName,
				CustomID,
				slatProcess,
				CurrentSession,
				CurrentForm,
				CurrentCGI,
				Shown,
				DTShown
			FROM
				tslatmessagelog
			ORDER BY
				MessageLogID Desc
		</cfquery>
		
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="getMessageLogDetail" access="public" returntype="query" output="false">
		<cfargument name="MessageLogID" required="true">
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select
				MessageLogID,
				DTCreated,
				MessageCode,
				FormName,
				InputName,
				CustomID,
				slatProcess,
				CurrentSession,
				CurrentForm,
				CurrentCGI,
				Shown,
				DTShown
			FROM
				tslatmessagelog
			WHERE
				MessageLogID = '#arguments.MessageLogID#'
		</cfquery>
		
		<cfreturn rs>
	</cffunction>
</cfcomponent>