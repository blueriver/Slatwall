<cfcomponent extends="fw1EventAdapter">
	<cffunction name="contentproducts">
		<cfargument name="$" />
		
		<cfreturn doAction($,'frontend.contentproducts') />
	</cffunction>
</cfcomponent>