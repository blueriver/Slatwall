<cfcomponent extends="slat.lib.contactBean" output="false" name="directoryBean" hint="">
	
	<cfset variables.instance.DirectoryID = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getDirectoryID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.DirectoryID />
    </cffunction>
    <cffunction name="setDirectoryID" access="private" output="false" hint="">
    	<cfargument name="DirectoryID" type="string" required="true" />
    	<cfset variables.instance.DirectoryID = trim(arguments.DirectoryID) />
    </cffunction>
    
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfif isquery(arguments.record)>
			<cfset setDirectoryID(arguments.record.DirectoryID) />
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
	
</cfcomponent>
