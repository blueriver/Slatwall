<cfcomponent output="false" name="contactBean" hint="This Component gets extended for Customers, Vendor Contacts & Orders">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.ContactType = "" />
	<cfset variables.instance.Company = "" />
	<cfset variables.instance.FirstName = "" />
	<cfset variables.instance.LastName = "" />
	<cfset variables.instance.PrimaryPhone = "" />
	<cfset variables.instance.PrimaryEmail = "" />
	<cfset variables.instance.StreetAddress = "" />
	<cfset variables.instance.Street2Address = "" />
	<cfset variables.instance.Locality = "" />
	<cfset variables.instance.City = "" />
	<cfset variables.instance.State = "" />
	<cfset variables.instance.PostalCode = "" />
	<cfset variables.instance.Country = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getContactType" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.ContactType />
    </cffunction>
    <cffunction name="setContactType" access="private" output="false" hint="">
    	<cfargument name="ContactType" type="string" required="true" />
    	<cfset variables.instance.ContactType = trim(arguments.ContactType) />
    </cffunction>
	
	<cffunction name="getCompany" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Company />
    </cffunction>
    <cffunction name="setCompany" access="private" output="false" hint="">
    	<cfargument name="Company" type="string" required="true" />
    	<cfset variables.instance.Company = trim(arguments.Company) />
    </cffunction>
    
	
	<cffunction name="getFirstName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.FirstName />
    </cffunction>
    <cffunction name="setFirstName" access="private" output="false" hint="">
    	<cfargument name="FirstName" type="string" required="true" />
    	<cfset variables.instance.FirstName = trim(arguments.FirstName) />
    </cffunction>
	
	<cffunction name="getLastName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.LastName />
    </cffunction>
    <cffunction name="setLastName" access="private" output="false" hint="">
    	<cfargument name="LastName" type="string" required="true" />
    	<cfset variables.instance.LastName = trim(arguments.LastName) />
    </cffunction>
	
	<cffunction name="getPrimaryPhone" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PrimaryPhone />
    </cffunction>
    <cffunction name="setPrimaryPhone" access="private" output="false" hint="">
    	<cfargument name="PrimaryPhone" type="string" required="true" />
    	<cfset variables.instance.PrimaryPhone = trim(arguments.PrimaryPhone) />
    </cffunction>
    
    <cffunction name="getPrimaryEmail" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PrimaryEmail />
    </cffunction>
    <cffunction name="setPrimaryEmail" access="private" output="false" hint="">
    	<cfargument name="PrimaryEmail" type="string" required="true" />
    	<cfset variables.instance.PrimaryEmail = trim(arguments.PrimaryEmail) />
    </cffunction>
	
	<cffunction name="getStreetAddress" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.StreetAddress />
    </cffunction>
    <cffunction name="setStreetAddress" access="private" output="false" hint="">
    	<cfargument name="StreetAddress" type="string" required="true" />
    	<cfset variables.instance.StreetAddress = trim(arguments.StreetAddress) />
    </cffunction>
    
    <cffunction name="getStreet2Address" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Street2Address />
    </cffunction>
    <cffunction name="setStreet2Address" access="private" output="false" hint="">
    	<cfargument name="Street2Address" type="string" required="true" />
    	<cfset variables.instance.Street2Address = trim(arguments.Street2Address) />
    </cffunction>
	
	<cffunction name="getLocality" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Locality />
    </cffunction>
    <cffunction name="setLocality" access="private" output="false" hint="">
    	<cfargument name="Locality" type="string" required="true" />
    	<cfset variables.instance.Locality = trim(arguments.Locality) />
    </cffunction>
	
	<cffunction name="getCity" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.City />
    </cffunction>
    <cffunction name="setCity" access="private" output="false" hint="">
    	<cfargument name="City" type="string" required="true" />
    	<cfset variables.instance.City = trim(arguments.City) />
    </cffunction>
	
	<cffunction name="getState" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.State />
    </cffunction>
    <cffunction name="setState" access="private" output="false" hint="">
    	<cfargument name="State" type="string" required="true" />
    	<cfset variables.instance.State = trim(arguments.State) />
    </cffunction>
	
	<cffunction name="getPostalCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PostalCode />
    </cffunction>
    <cffunction name="setPostalCode" access="private" output="false" hint="">
    	<cfargument name="PostalCode" type="string" required="true" />
    	<cfset variables.instance.PostalCode = trim(arguments.PostalCode) />
    </cffunction>
	
	<cffunction name="getCountry" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Country />
    </cffunction>
    <cffunction name="setCountry" access="private" output="false" hint="">
    	<cfargument name="Country" type="string" required="true" />
    	<cfset variables.instance.Country = trim(arguments.Country) />
    </cffunction>
    
</cfcomponent>