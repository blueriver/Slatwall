component displayname="State" entityname="SlatwallState" table="SlatwallState" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="stateCode" type="string" fieldtype="id" displayname="State Code";
	property name="stateName" type="string" default="" persistent="true" displayname="State Name" hint="";
	
	// Related Object Properties
	property name="country" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
}