component displayname="Account Relationship" entityname="SlatwallAccountRelationship" table="SlatwallAccountRelationship" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountRelationshipID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="relatedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="relatedAccountID";
	property name="relationshipType" cfc="Type" fieldtype="many-to-one" fkcolumn="relationshipTypeID";
	
}