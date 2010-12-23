<cfcomponent extends="slat.com.service.baseService" accessors="true" >

	<cfproperty name="SkuDAO" type="any" />
	<cfproperty name="ContentManager" type="any" />
	<cfproperty name="SettingsManager" type="any" />
	
	<cfset variables.entityName = "SlatProduct" />
	
	<cffunction name="init">
		<cfargument name="DAO" type="any" />
		<cfargument name="SkuDAO" type="any" />
		<cfargument name="ContentManager" type="any" />
		<cfargument name="SettingsManager" type="any" />
		
		<cfset setDAO(arguments.DAO) />
		<cfset setSkuDAO(arguments.SkuDAO) />
		<cfset setContentManager(arguments.ContentManager) />
		<cfset setSettingsManager(arguments.SettingsManager) />
	</cffunction>
	
	<cffunction name="getSmartList">
		<cfargument name="rc" />
				
		<cfset var SmartList = createObject("component","slat.com.entity.smartlist").init("product", arguments.rc) />
		
		<cfset SmartList.addKeywordColumn('ProductCode', 9) />
		<cfset SmartList.addKeywordColumn('ProductName', 4) />
		<cfset SmartList.addKeywordColumn('ProductDescription', 1) />
		<cfset SmartList.addKeywordColumn('Brand_BrandID', 6) />
		<cfset SmartList.addKeywordColumn('Brand_BrandName', 6) />
		
		<cfreturn getDAO().fillSmartList(SmartList, variables.entityName) />
	</cffunction>
	
	<cffunction name="getProductTemplates">
		<cfreturn getSettingsManager().getSite(session.siteid).getTemplates() />
	</cffunction>
	
</cfcomponent>