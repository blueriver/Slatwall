component displayname="Address" entityname="SlatAddress" table="SlatAddress" persistent="true" output="false" accessors="true" extends="slat.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="addressID" fieldtype="id" generator="guid";
	property name="name" type="string" persistent=true;
	property name="company" type="string" persistent=true;
	property name="streetAddress" type="string" persistent=true;
	property name="street2Address" type="string" persistent=true;
	property name="locality" type="string" persistent=true;
	property name="city" type="string" persistent=true;
	property name="stateCode" type="string" persistent=true;
	property name="postalCode" type="string" persistent=true;
	property name="countryCode" type="string" persistent=true;
	
}