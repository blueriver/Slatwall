component displayname="Country" entityname="SlatCountry" table="SlatCountry" persistent="true" extends="slat.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="countryID" type="int" fieldtype="id" generator="increment";
	property name="countryName" type="string" default="" persistent="true" displayname="Country Name" hint="";
	property name="countryCode" type="string" default="" persistent="true" displayname="Country Code" hint="";
}