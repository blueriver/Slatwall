<cfcomponent output="false" name="communicationManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="communicationDAO" type="any" required="yes"/>
		<cfargument name="communicationGateway" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.communicationDAO />
		<cfset variables.Gateway=arguments.communicationGateway />
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="communicationid" required="true" />
		<cfreturn variabls.DAO.read(arguemtns.communicationid) />
	</cffunction>
	
	
	
</cfcomponent>
