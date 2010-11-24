<cfcomponent extends="fw1EventAdapter">

	<cffunction name="contentproductlist">
		<cfargument name="$" />
		
		<cfreturn doAction($,'frontend:content.productlist') />
	</cffunction>
</cfcomponent>