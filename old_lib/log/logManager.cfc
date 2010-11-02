<cfcomponent output="false" name="logManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="addLog" access="public" returntype="numeric" output="false">
		<cfargument name="LogType" required="true" />
		<cfargument name="SupportingInfo" required="false" default="" type="any" />
		
		<cfset variables.CurrentSession = "">
		<cfset variables.CurrentForm = "">
		<cfset variables.CurrentCGI = "">
		<cfset variables.SupportingInfo = "">
		
		<cfwddx action="CFML2WDDX" input="#Session#" output="variables.CurrentSession" />
		<cfwddx action="CFML2WDDX" input="#Form#" output="variables.CurrentForm" />
		<cfwddx action="CFML2WDDX" input="#CGI#" output="variables.CurrentCGI" />
		
		<cfif isStruct(arguments.SupportingInfo)>
			<cfwddx action="CFML2WDDX" input="#arguments.SupportingInfo#" output="variables.SupportingInfo" />
		<cfelse>
			<cfset variables.SupportingInfo = arguments.SupportingInfo />
		</cfif>
				
		<cfquery name="InsertLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Insert Into	tslatlog(
				RequestStart,
				LogType,
				SessionValues,
				FormValues,
				CGIValues,
				SupportingInfo
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(now(), 'MM/DD/YYYY')# #TimeFormat(now(), 'HH:MM:SS.l')#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.LogType#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentSession#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentForm#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.CurrentCGI#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.SupportingInfo#" />
			);
			SELECT IDENT_CURRENT('tslatlog') as LogID;
		</cfquery>
		
		<cfreturn InsertLog.LogID>
	</cffunction>
	
	<cffunction name="updateLog" access="public" output="false">
		<cfargument name="LogID" required="true" />
		
		<cfquery name="UpdateLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			update tslatlog set RequestEnd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(now(), 'MM/DD/YYYY')# #TimeFormat(now(), 'HH:MM:SS.l')#" /> Where LogID = '#arguments.LogID#'
		</cfquery>
	</cffunction>
	
	<cffunction name="getAllLogs" access="public" returntype="query" output="false">
		<cfquery name="AllLogs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select top 100
				LogId,
				RequestStart,
				RequestEnd,
				LogType,
				SessionValues,
				FormValues,
				CGIValues,
				SupportingInfo
			FROM
				tslatlog
			ORDER BY
				LogId Desc
		</cfquery>
		
		<cfreturn AllLogs>
	</cffunction>
	
	<cffunction name="getLogDetail" access="public" returntype="query" output="false">
		<cfargument name="LogID" required="true" />
		
		<cfquery name="LogDetail" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select
				LogId,
				RequestStart,
				RequestEnd,
				LogType,
				FormValues,
				CGIValues,
				SessionValues,
				SupportingInfo
			FROM
				tslatlog
			WHERE
				LogId = '#arguments.LogID#'
		</cfquery>
		
		<cfreturn LogDetail>
	</cffunction>
</cfcomponent>