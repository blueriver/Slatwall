<cfcomponent extends="slat.com.service.baseService">
	<cfset variables.entityname = 'SlatVendor' />
	
	<cffunction name="getSmartList">
		<cfargument name="rc" />
		<cfset var SmartList = createObject("component","slat.com.entity.smartlist").init('vendor', arguments.rc) />
		<cfset SmartList.addKeywordColumn('VendorName', 1) />
		
		<cfset SmartList = getDAO().fillSmartList(SmartList) />
		
		<cfreturn SmartList />
	</cffunction>
	
	<cffunction name="getVendorEmails">
		<cfargument name="VendorID" />
		<cfreturn getDAO().getVendorEmails(arguments.VendorID) />
	</cffunction>
	
</cfcomponent>