component displayname="Address" entityname="SlatwallAddress" table="SlatwallAddress" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="addressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="name" ormtype="string";
	property name="company" ormtype="string";
	property name="phone" ormtype="string";
	property name="streetAddress" ormtype="string";
	property name="street2Address" ormtype="string";
	property name="locality" ormtype="string";
	property name="city" ormtype="string";
	property name="stateCode" ormtype="string";
	property name="postalCode" ormtype="string";
	property name="countryCode" ormtype="string";
	
}