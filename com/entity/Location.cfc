component displayname="Location" entityname="SlatLocation" table="SlatLocation" persistent=true accessors=true output=false extends="slat.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="locationID" fieldtype="id" generator="guid" persistent=true;
	property name="locationName" type="string" persistent=true;
}