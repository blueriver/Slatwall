component displayname="Type" entityname="SlatwallType" table="SlatwallType" persistent="true" accessors="true" output="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="typeID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="type" type="string" default="" persistent="true";
	
	// Related Object Properties
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="parentTypeID";
	property name="childTypes" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="parentTypeID" cascade="all" inverse="true";
	
	public any function getChildTypes() {
		if(!isDefined('variables.childTypes')) {
			variables.childTypes = arraynew(1);
		}
		return variables.childTypes;
	}
	
}