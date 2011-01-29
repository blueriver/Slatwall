component displayname="Country" entityname="SlatwallCountry" table="SlatwallCountry" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="countryCode" type="string" fieldtype="id" displayname="Country Code";
	property name="countryName" type="string" default="" persistent="true" displayname="Country Name" hint="";
	
}