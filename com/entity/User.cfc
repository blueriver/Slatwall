component entityname="SlatwallUser" displayname="Slatwall User" table="tusers" readonly="true" accessors="true" persistent="true" {
	
	property name="muraUserID" column="UserID" fieldtype="id" generated="always" ormType="string";
	property name="firstName" column="Fname" ormType="string";
	property name="lastName" column="Lname" ormType="string"; 
	property name="company" column="Company" ormType="string";
}