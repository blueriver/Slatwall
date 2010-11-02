<cfcomponent output="false" name="communicationBean" extends="slat.lib.coreBean" hint="">

	<cfset variables.instance.CommunicationID = "" />
	<cfset variables.instance.CommunicationDateTime = "" />
	<cfset variables.instance.CommunicationType = "" />
	<cfset variables.instance.EmailFrom = "" />
	<cfset variables.instance.EmailTo = "" />
	<cfset variables.instance.Subject = "" />
	<cfset variables.instance.Body = "" />
	<cfset variables.instance.CustomerID = "" />
	<cfset variables.instance.OrderID = "" />
		
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="send" access="public" returntype="void" output="false">
		<cfmail
			to="#getEmailTo()#"
			cc="#getEmailBCC()#"
			bcc="#getEmailCC()#"
			from="#getEmailFrom()#"
			subject="#getSubject()#"
			Type="#getFormat()#"
			PORT="25"
			SERVER="127.0.0.1">
			<cfoutput>#variables.instance.body#</cfoutput>
		</cfmail>

	</cffunction>

</cfcomponent>
