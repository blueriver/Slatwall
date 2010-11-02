<cfcomponent persistent="true" table="slatvendorbrand" extends="slat.com.entity.baseEntity">
	<cfproperty name="VendorBrandID" fieldtype="id" generator="increment" />
		
	<!--- Related and Nested Objects --->
	<cfproperty name="Vendor" cfc="vendor" fieldtype="many-to-one" fkcolumn="VendorID" />
	<cfproperty name="Brand" cfc="brand" fieldtype="many-to-one" fkcolumn="BrandID" />
</cfcomponent>