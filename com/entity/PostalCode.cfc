component displayname="Postal Code" entityname="SlatwallPostalCode" table="SlatwallPostalCode" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="postalCode" type="string" fieldtype="id" displayname="Postal Code";
	property name="city" type="string";
	property name="latitude" type="numeric";
	property name="longitude" type="numeric";
	
	// Related Object Properties
	property name="country" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
	property name="state" cfc="State" fieldtype="many-to-one" fkcolumn="stateCode";   
	
}