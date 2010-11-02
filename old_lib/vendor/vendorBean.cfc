<cfcomponent extends="slat.lib.contactBean" output="false" name="vendorBean" hint="">

	<cfset variables.instance.VendorID = "" />
	<cfset variables.instance.AccountNumber = "" />
	<cfset variables.instance.VendorWebsite = "" />

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getVendorID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.VendorID />
    </cffunction>
    <cffunction name="setVendorID" access="private" output="false" hint="">
    	<cfargument name="VendorID" type="string" required="true" />
    	<cfset variables.instance.VendorID = trim(arguments.VendorID) />
    </cffunction>
	
	<cffunction name="getAccountNumber" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AccountNumber />
    </cffunction>
    <cffunction name="setAccountNumber" access="private" output="false" hint="">
    	<cfargument name="AccountNumber" type="string" required="true" />
    	<cfset variables.instance.AccountNumber = trim(arguments.AccountNumber) />
    </cffunction>
	
	<cffunction name="getVendorWebsite" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.VendorWebsite />
    </cffunction>
    <cffunction name="setVendorWebsite" access="private" output="false" hint="">
    	<cfargument name="VendorWebsite" type="string" required="true" />
    	<cfset variables.instance.VendorWebsite = trim(arguments.VendorWebsite) />
    </cffunction>
	
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfif isquery(arguments.record)>
			<cfset setVendorID(arguments.record.VendorID) />
			<cfset setVendorWebsite(arguments.record.VendorWebsite) />
			<cfset setAccountNumber(arguments.record.AccountNumber) />
			
			<cfset setCompany(arguments.record.Company) />
			<cfset setContactType(arguments.record.ContactType) />
			<cfset setFirstName(arguments.record.FirstName) />
			<cfset setLastName(arguments.record.LastName) />
			<cfset setPrimaryPhone(arguments.record.PrimaryPhone) />
			<cfset setPrimaryEmail(arguments.record.PrimaryEmail) />
			<cfset setStreetAddress(arguments.record.StreetAddress) />
			<cfset setStreet2Address(arguments.record.Street2Address) />
			<cfset setLocality(arguments.record.Locality) />
			<cfset setCity(arguments.record.City) />
			<cfset setState(arguments.record.State) />
			<cfset setPostalCode(arguments.record.PostalCode) />
			<cfset setCountry(arguments.record.Country) />
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="getBrandsQuery" access="public" output="false" returntype="query">
		<cfif not isDefined('variables.instance.BrandsQuery')>
			<cfset variables.instance.BrandsQuery = application.slat.brandManager.getBrandsQueryByVendorID(VendorID=variables.instance.vendorID) />
		</cfif>
		<cfreturn variables.instance.BrandsQuery />
	</cffunction>
	
	<cffunction name="getBrandsIterator" access="public" output="false" returntype="Any">
		<cfreturn application.slat.brandManager.getBrandIterator(getBrandsQuery())>
	</cffunction>
	
	<cffunction name="getDirectoryQuery" access="public" output="false" returntype="Any">
		<cfif not isDefined('variables.instance.DirectoryQuery')>
			<cfset variables.instance.DirectoryQuery = application.slat.directoryManager.getDirectoryQueryByVendorID(VendorID=variables.instance.VendorID) />
		</cfif>
		<cfreturn variables.instance.DirectoryQuery />
	</cffunction>
	
	<cffunction name="getDirectoryIterator" access="public" output="false" returntype="Any">
		<cfreturn application.slat.directoryManager.getDirectoryIterator(getDirectoryQuery())>
	</cffunction>
	
	<cffunction name="getProductsQuery" access="public" output="false" returntype="query">
		<cfset var BrandsQuery = getBrandsQuery() />
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset var FilterValue = "" />
		<cfif not isDefined('variables.instance.ProductsQuery')>
			<cfloop query="BrandsQuery">
				<cfset QueryOrganizer.addFilter(Column = 'BrandID', Value=BrandsQuery.BrandID) />
			</cfloop>
			<cfset QueryOrganizer.addOrder(Column = 'BrandID', Value='A') />
			<cfset variables.instance.ProductsQuery = QueryOrganizer.organizeQuery(application.slat.productManager.getAllProductsQuery()) />
		</cfif>
		<cfreturn variables.instance.ProductsQuery />
	</cffunction>
	
	<cffunction name="getProductsIterator" access="public" output="false" returntype="Any">
		<cfreturn application.slat.productManager.getProductIterator(getProductsQuery())>
	</cffunction>

	<cffunction name="getDebug">
		<cfreturn variables.instance />
	</cffunction>
	
</cfcomponent>
