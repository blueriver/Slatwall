<cfcomponent extends="main" output="false">

	<cffunction name="before">
		<cfargument name="rc" />
		<cfparam name="rc.VendorID" default="" />
		
	</cffunction>

	<cffunction name="setVendorService">
		<cfargument name="VendorService" />
		<cfset variables.VendorService = arguments.VendorService />
	</cffunction>
	
	<cffunction name="detail">
		<cfargument name="rc" />
		<cfset rc.Vendor = variables.VendorService.getByID(ID=rc.VendorID) />
	</cffunction>
	
	<cffunction name="list">
		<cfargument name="rc" />
		
		<cfset rc.VendorSmartList = variables.VendorService.getSmartList(arguments.rc) />
	</cffunction>
	
</cfcomponent>