<cfcomponent displayname="Brand" table="slatbrand" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="BrandID" fieldtype="id" generator="guid" />
	<cfproperty name="BrandName" type="string" />
	<cfproperty name="BrandWebsite" type="string" />
	
	<cfproperty name="BrandVendors" cfc="vendorbrand" fieldtype="one-to-many" fkcolumn="BrandID" />
</cfcomponent>
