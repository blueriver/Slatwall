<cfcomponent persistent="true" table="slataddress" extends="slat.com.entity.baseEntity">
	<cfproperty name="AddressID" fieldtype="id" generator="guid" />
	<cfproperty name="Name" type="string" />
	<cfproperty name="Company" type="string" />
	<cfproperty name="StreetAddress" type="string" />
	<cfproperty name="Street2Address" type="string" />
	<cfproperty name="Locality" type="string" />
	<cfproperty name="City" type="string" />
	<cfproperty name="StateCode" type="string" />
	<cfproperty name="PostalCode" type="string" />
	<cfproperty name="CountryCode" type="string" />
</cfcomponent>
