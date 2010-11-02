<cfcomponent output="false" name="customerManager" hint="">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="customerDAO" type="any" required="yes"/>
		<cfargument name="customerGateway" type="any" required="yes"/>
	
		<cfset variables.DAO=arguments.customerDAO />
		<cfset variables.Gateway=arguments.customerGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="CustomerID" type="String" />
	
		<cfreturn variables.DAO.read(arguments.CustomerID) />
	</cffunction>
	
	<cffunction name="getAllCustomersQuery" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getAllCustomersQuery() />
	</cffunction>
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('Company') />
		<cfset QueryOrganizer.addKeywordColumn('FirstName') />
		<cfset QueryOrganizer.addKeywordColumn('LastName') />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryPhone',2) />
		<cfset QueryOrganizer.addKeywordColumn('PrimaryEMail',2) />
		<cfreturn QueryOrganizer />
	</cffunction>
	
	<cffunction name="getCustomerIterator" access="public" output="false" returntype="any">
		<cfargument name="CustomerQuery" type="any" required="true">
		
		<cfset var customerIterator=createObject("component","customerIterator").init() />
		<cfset customerIterator.setQuery(arguments.CustomerQuery, 100) />
		<cfreturn customerIterator />
	</cffunction>
</cfcomponent>
