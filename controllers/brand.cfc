<cfcomponent extends="main" output="false">

	<!--- Start: Injection Setters --->
	<cffunction name="setBrandService">
		<cfargument name="BrandService" />
		<cfset variables.BrandService = arguments.BrandService />
	</cffunction>
	<!--- End: Injection Setters --->
	
	<cffunction name="before">
		<cfargument name="rc" />
		
		<cfparam name="rc.BrandID" default="" />
		
		<cfset rc.Brand = variables.BrandService.getByID(rc.BrandID) />
		<cfif not isDefined('rc.Brand')>
			<cfset rc.Brand = variables.BrandService.getNewEntity() />
		</cfif>
	</cffunction>

	<cffunction name="list">
		<cfargument name="rc" />
	
		<cfset rc.BrandSmartList = variables.BrandService.getSmartList(arguments.rc) />
	</cffunction>
	
	<cffunction name="update">
		<cfargument name="rc" />
		
		<cfset rc.Brand = variables.fw.populate(cfc=rc.Brand, Keys=rc.Brand.getUpdateKeys(), trim=true) />
		<cfset rc.Brand = variables.BrandService.save(entity=rc.Brand) />
		<cfset variables.fw.redirect(action='Brand.detail',queryString='BrandID=#rc.Brand.getBrandID()#') />
	</cffunction>
	
</cfcomponent>