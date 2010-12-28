component displayname="Location" entityname="SlatwallLocation" table="SlatwallLocation" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="locationID" fieldtype="id" generator="guid" persistent=true;
	property name="locationName" type="string" persistent=true;
}