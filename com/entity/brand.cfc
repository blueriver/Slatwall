<cfcomponent displayname="Brand" table="slatbrand" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="BrandID" fieldtype="id" generator="guid" />
	<cfproperty name="BrandName" type="string" default="" displayname="Brand Name" hint="This is the common name that the brand goes by." />
	<cfproperty name="BrandWebsite" type="string" default="" displayname="Brand Website" hint="This is the Website of the brand" />
	
	<cfproperty name="BrandVendors" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="BrandID" />
</cfcomponent>
