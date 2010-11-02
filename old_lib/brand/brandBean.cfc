<cfcomponent output="false" name="brandBean" hint="">

	<cfset variables.instance.BrandID = "" />
	<cfset variables.instance.BrandName = "" />
	<cfset variables.instance.BrandWebsite = "" />

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBrandID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.BrandID />
    </cffunction>
    <cffunction name="setBrandID" access="private" output="false" hint="">
    	<cfargument name="BrandID" type="string" required="true" />
    	<cfset variables.instance.BrandID = trim(arguments.BrandID) />
    </cffunction>
    
	<cffunction name="getBrandName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.BrandName />
    </cffunction>
    <cffunction name="setBrandName" access="private" output="false" hint="">
    	<cfargument name="BrandName" type="string" required="true" />
    	<cfset variables.instance.BrandName = trim(arguments.BrandName) />
    </cffunction>
	
	<cffunction name="getBrandWebsite" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.BrandWebsite />
    </cffunction>
    <cffunction name="setBrandWebsite" access="private" output="false" hint="">
    	<cfargument name="BrandWebsite" type="string" required="true" />
    	<cfset variables.instance.BrandWebsite = trim(arguments.BrandWebsite) />
    </cffunction>
    
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfif isquery(arguments.record)>
			<cfset setBrandID(arguments.record.BrandID) />
			<cfset setBrandName(arguments.record.BrandName) />
			<cfset setBrandWebsite(arguments.record.BrandWebsite) />
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
		
	<cffunction name="getVendorsQuery" returntype="any" access="public" output="false" hint="">
    	<cfif not isDefined('variables.instance.VendorsQuery')>
			<cfset variables.instance.VendorsQuery = application.slat.vendorManager.getVendorsQueryByBrandID(BrandID=variables.instance.BrandID) />
    	</cfif>
    	<cfreturn variables.instance.VendorsQuery />
    </cffunction>
	
	<cffunction name="getVendorsIterator" returntype="Any" access="public" output="false" hint="">
		<cfreturn application.slat.vendorManager.getVendorIterator(getVendorsQuery()) />
	</cffunction>
	
	<cffunction name="getProductsQuery" returntype="any" access="public" output="false" hint="">
		<cfif not isDefined('variables.instance.ProductsQuery')>
    		<cfset ProductOrganizer = application.Slat.utilityManager.getNewQueryOrganizer() />
			<cfset ProductOrganizer.addFilter("BrandID","#variables.instance.BrandID#") />
			<cfset variables.instance.ProductsQuery = ProductOrganizer.OrganizeQuery(application.slat.productManager.getAllProductsQuery()) />
    	</cfif>
    	<cfreturn variables.instance.ProductsQuery />
    </cffunction>
	
	<cffunction name="getProductsIterator" returntype="any" access="public" output="false">
		<cfreturn application.slat.productManager.getProductIterator(getProductsQuery())>
	</cffunction>
</cfcomponent>
