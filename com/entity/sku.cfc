<cfcomponent displayname="Sku" table="slatsku" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="SkuID" fieldtype="id" generator="guid" />
	<cfproperty name="OriginalPrice" type="numeric" />
	<cfproperty name="ListPrice" type="numeric" />
	
	<!--- Related and Nested Objects --->
	<cfproperty name="Product" fieldtype="many-to-one" fkcolumn="ProductID" cfc="product">
	<cfproperty name="Stocks" fieldtype="one-to-many" fkcolumn="SkuID" cfc="stock">
	
	<!--- Non Persistant Properties --->
	<cfproperty name="LivePrice" persistent="false" />
	<cfproperty name="QOH" persistent="false" type="numeric" />
	<cfproperty name="QC" persistent="false" type="numeric" />
	<cfproperty name="QOO" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQOH" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQC" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQOO" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQOH" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQC" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQOO" persistent="false" type="numeric" />
</cfcomponent>