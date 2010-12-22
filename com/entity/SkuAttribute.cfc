<cfcomponent displayname="Sku Attribute" table="slatskuattribute" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="SkuAttributeID" fieldtype="id" generator="increment" />
	
	<!--- Related and Nested Objects --->
	<cfproperty name="Sku" fieldtype="many-to-one" fkcolumn="SkuID" cfc="sku">
	<cfproperty name="Attribute" fieldtype="one-to-many" fkcolumn="AttributeID" cfc="attribute">
	
</cfcomponent>