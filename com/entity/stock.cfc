<cfcomponent displayname="Stock" table="slatstock" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="StockID" fieldtype="id" generator="guid" />
	<cfproperty name="QOH" type="numeric" />
	<cfproperty name="QC" type="numeric" />
	<cfproperty name="QOO" type="numeric" />
	
	<cfproperty name="Location" fieldtype="many-to-one" fkcolumn="LocationID" cfc="location">
	<cfproperty name="Sku" fieldtype="many-to-one" fkcolumn="SkuID" cfc="sku">
</cfcomponent>