<cfcomponent extends="slat.com.service.BaseService" accessors="true" >

	<cfset variables.entityName = "SlatBrand" />
	
	<cffunction name="init">
		<cfargument name="DAO" type="any" />
		
		<cfset setDAO(arguments.DAO) />
	</cffunction>
	
	<cffunction name="getSmartList">
		<cfargument name="rc" />
				
		<cfset var SmartList = createObject("component","slat.com.entity.smartlist").init("brand", arguments.rc) />
		<cfset SmartList.addKeywordColumn('BrandName', 6) />
		<cfreturn getDAO().fillSmartList(smartList=SmartList, variables.entityName) />
	</cffunction>
	
</cfcomponent>