<cfcomponent persistent="true" table="slatvendor" extends="slat.com.entity.baseEntity">
	<cfproperty name="VendorID" fieldtype="id" generator="guid" />
	<cfproperty name="VendorName" type="string" />
	<cfproperty name="VendorWebsite" type="string" />
	<cfproperty name="AccountNumber" type="string" />
	
	<cfproperty name="PhoneNumbers" cfc="vendorphone" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true" />
	<cfproperty name="EmailAddresses" cfc="vendoremail" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true" />
	<cfproperty name="Brands" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="VendorID" type="array" cascade="all" inverse="true" />
	
	<cffunction name="getPhoneNumbers">
		<cfif not isDefined('variables.PhoneNumbers')>
			<cfif isDefined('variables.VendorID')>
				<!--- <cfset variables.PhoneNumber = application.SlatwallApp.getValue('vendorService').getVendorPhone(variable.VendorID) /> --->
			<cfelse>
				<cfset variables.PhoneNumbers = arrayNew(1) />
			</cfif>
		</cfif>
		
		<cfreturn variables.PhoneNumbers />
	</cffunction>
	
	<cffunction name="getEmailAddresses">
		<cfif not isDefined('variables.EmailAddresses')>
			<cfif isDefined('variables.VendorID')>
				<cfset variables.EmailAddresses = application.SlatwallApp.getValue('vendorService').getVendorEmails(variables.VendorID) />
			<cfelse>
				<cfset variables.EmailAddresses = arrayNew(1) />
			</cfif>
		</cfif>
		
		<cfreturn variables.EmailAddresses />
	</cffunction>
</cfcomponent>
