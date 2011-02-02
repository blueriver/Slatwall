component displayname="State" entityname="SlatwallState" table="SlatwallState" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="stateCode" ormtype="string" fieldtype="id" displayname="State Code";
	property name="stateName" ormtype="string" default="" displayname="State Name" hint="";
	
	// Related Object Properties
	property name="country" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
}