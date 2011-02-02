component displayname="Postal Code" entityname="SlatwallPostalCode" table="SlatwallPostalCode" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="postalCode" type="string" fieldtype="id" displayname="Postal Code";
	property name="city" ormtype="string";
	property name="latitude" ormtype="float";
	property name="longitude" ormtype="float";
	
	// Related Object Properties
	property name="country" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
	property name="state" cfc="State" fieldtype="many-to-one" fkcolumn="stateCode";   
	
}