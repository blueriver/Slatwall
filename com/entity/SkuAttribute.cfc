component displayname="Sku Attribute" table="slatskuattribute" persistent="true" extends="slat.com.entity.BaseEntity" {

	property name="skuAttributeID" fieldtype="id" generator="increment";
	property name="sku" fieldtype="many-to-one" fkcolumn="SkuID" cfc="sku";
	property name="attribute" fieldtype="one-to-many" fkcolumn="AttributeID" cfc="attribute";

}
