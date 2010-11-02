<cfcomponent extends="slat.com.dao.baseDAO">

	<cffunction name="fillSmartList">
		<cfargument name="SmartList" type="any" required="true" />
		
		
		<cfset var EntityRecords = arrayNew(1) />
		
		<cfset var HQL = " from product p where p.Brand.BrandID = '1' or p.Brand.BrandID = '2'" />
		
		<cfset EntityRecords = ormExecuteQuery(HQL, {}) />
		
		<cfset arguments.SmartList.setEntityRecords(EntityRecords) />

		<cfreturn arguments.SmartList />
	</cffunction>
	
</cfcomponent>