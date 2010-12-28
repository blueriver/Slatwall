component displayname="Country" entityname="SlatwallCountry" table="SlatwallCountry" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="countryID" type="int" fieldtype="id" generator="increment";
	property name="countryName" type="string" default="" persistent="true" displayname="Country Name" hint="";
	property name="countryCode" type="string" default="" persistent="true" displayname="Country Code" hint="";
}