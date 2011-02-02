component displayname="Type" entityname="SlatwallType" table="SlatwallType" persistent="true" accessors="true" output="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="typeID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="type" ormtype="string" default="";
	
	// Related Object Properties
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="parentTypeID";
	property name="childTypes" singularname="childType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="parentTypeID" cascade="all" inverse="true";
	
	public any function getChildTypes() {
		if(!isDefined('variables.childTypes')) {
			variables.childTypes = arraynew(1);
		}
		return variables.childTypes;
	}
	
}