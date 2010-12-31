component displayname="Type" entityname="SlatwallType" table="SlatwallType" persistent="true" accessors="true" output="true" extends="slatwall.com.entity.BaseEntity" {
	
	property name="typeID" fieldtype="id" generator="guid";
	property name="type" type="string" default="" persistent="true";
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="ParentTypeID";
	property name="childType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="ParentTypeID" cascade="all" inverse="true";
	
	public any function getChildType() {
		if(!isDefined('variables.childType')) {
			variables.childType = arraynew(1);
		}
		return variables.childType;
	}
	
}