component displayname="Account" entityname="SlatwallAccount" table="SlatwallAccount" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="firstName" ormtype="string" default="" hint="This Value is only Set if a MuraID does not exist";
	property name="lastName" ormtype="string" default="" hint="This Value is only Set if a MuraID does not exist";
	property name="company" ormtype="string" default="" hint="This Value is only Set if a MuraID does not exist";
	property name="remoteEmployeeID" ormtype="string" default="" hint="Only used when integrated with a remote system";
	property name="remoteCustomerID" ormtype="string" default="" hint="Only used when integrated with a remote system";
	property name="remoteContactID" ormtype="string" default="" hint="Only used when integrated with a remote system";
	
	// Related Object Properties
	property name="type" fieldtype="many-to-one" fkcolumn="accountTypeID" cfc="Type";
	property name="muraUser" fieldtype="many-to-one" fkcolumn="muraUserID" cfc="User";
	property name="accountEmail" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmail" inverse="true" cascade="all";
	
	// Start: User Helpers
	// The following four functions are designed to connect a Slatwall account to a Mura account.  If the mura account exists then this will pull all data from mura, if not then the firstName, lastName & company will be stored in the Slatwall DB.
	public string function getFirstName() {
		if(isNull(getMuraUser())) {
			if(!isDefined("variables.firstName")) {
				variables.firstName = "";
			}
		} else {
			variables.firstName = getMuraUser().getFirstName();
		}
		
		return variables.firstName;
	}
	
	public string function getLastName() {
		if(isNull(getMuraUser())) {
			if(!isDefined("variables.lastName")) {
				variables.lastName = "";
			}
		} else {
			variables.lastName = getMuraUser().getLastName();
		}
		
		return variables.lastName;
	}
	
	public string function getCompany() {
		if(isNull(getMuraUser())) {
			if(!isDefined("variables.company")) {
				variables.company = "";
			}
		} else {
			variables.company = getMuraUser().getCompany();
		}
		
		return variables.company;
	}
	// End: User Helpers
	
}