component displayname="Product Relationship" entityname="SlatwallProductRelationship" table="SlatwallProductRelationship" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="productRelationshipID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="relatedProduct" cfc="Product" fieldtype="many-to-one" fkcolumn="relatedProductID";
	property name="relationshipType" cfc="Type" fieldtype="many-to-one" fkcolumn="relationshipTypeID";
	
}