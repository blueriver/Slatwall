<cfcomponent persistent="true" table="slatvendoremail" extends="slat.com.entity.baseEntity">
	<cfproperty name="VendorEmailID" fieldtype="id" generator="increment" />
	<cfproperty name="EmailAddress" type="string" />
	
	<!--- Related and Nested Objects --->
	<cfproperty name="Vendor" cfc="vendor" fieldtype="many-to-one" fkcolumn="VendorID" />
	<cfproperty name="EmailType" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" />
	
	<cffunction name="getEmailType">
		<cfif not isDefined('variables.GenderType')>
			<cfset variables.EmailType = entityNew('type') />
		</cfif>
		<cfreturn variables.EmailType />
	</cffunction>
</cfcomponent>