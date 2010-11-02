<cfcomponent output="false" name="communicationGateway" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllCommunicationsQuery" returntype="query" output="false">
		<cfset var AllCommunicationsQuery = queryNew('empty') />
		
		<cfquery name="AllCommunicationsQuery" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				CommunicationID,
				CommunicationType,
				EmailFrom,
				EmailTo,
				Subject,
				Body,
				CustomerID,
				OrderID
			FROM
				tslatcommunication
		</cfquery>
	
		<cfreturn AllCommunicationsQuery />
	</cffunction>
	
</cfcomponent>