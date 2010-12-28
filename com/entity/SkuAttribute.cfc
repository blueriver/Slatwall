component displayname="Sku Attribute" entityname="SlatwallSkuAttribute" table="SlatwallSkuAttribute" persistent="true" extends="slatwall.com.entity.BaseEntity" {

	property name="skuAttributeID" fieldtype="id" generator="increment";
	property name="sku" fieldtype="many-to-one" fkcolumn="SkuID" cfc="sku";
	property name="attribute" fieldtype="one-to-many" fkcolumn="AttributeID" cfc="attribute";

}
