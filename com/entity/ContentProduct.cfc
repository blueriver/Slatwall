<cfcomponent displayname="ContentProduct" table="slatcontentproduct" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="ContentProductID" fieldtype="id" generator="increment" />
	<cfproperty name="ContentID" hint="Mura Content ID" />
	<cfproperty name="Product" cfc="product" fieldtype="many-to-one" fkcolumn="ProductID" />
		
</cfcomponent>