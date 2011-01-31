component displayname="Product Relationship" entityname="SlatwallProductRelationship" table="SlatwallProductRelationship" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="productRelationshipID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="relatedProduct" cfc="Product" fieldtype="many-to-one" fkcolumn="relatedProductID";
	property name="relationshipType" cfc="Type" fieldtype="many-to-one" fkcolumn="relationshipTypeID";
	
}