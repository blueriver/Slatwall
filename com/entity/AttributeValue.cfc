component displayname="Attribute Value" entityname="SlatwallAttributeValue" table="SlatwallAttributeValue" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="attributeValueID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeValue" ormtype="string";
	
	// Related Object Properties
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="profile" cfc="Profile" fieldtype="many-to-one" fkcolumn="profileID";
}