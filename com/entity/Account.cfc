component displayname="Account" entityname="SlatwallAccount" table="SlatwallAccount" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="accountID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accountID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="muraUserID" type="string" default="" persistent=true hint="This is the mura user id that ties an account to a login";
	property name="firstName" type="string" default="" persistent=true hint="This Value is only Set if a MuraID does not exist";
	property name="lastName" type="string" default="" persistent=true hint="This Value is only Set if a MuraID does not exist";
	property name="company" type="string" default="" persistent=true hint="This Value is only Set if a MuraID does not exist";
	property name="remoteEmployeeID" type="string" default="" persistent=true hint="Only used when integrated with a remote system";
	property name="remoteCustomerID" type="string" default="" persistent=true hint="Only used when integrated with a remote system";
	property name="remoteContactID" type="string" default="" persistent=true hint="Only used when integrated with a remote system";
	
	// Non-Persistant Properties
	property name="muraUser" type="any" persistent="false";
	
	// Start: User Helpers
	// The following four functions are designed to connect a Slatwall account to a Mura account.  If the mura account exists then this will pull all data from mura, if not then the firstName, lastName & company will be stored in the Slatwall DB.
	public any function getMuraUser() {
		if(!isDefined("variables.muraUser")) {
			if(isDefined("variables.muraUserID") && variable.MuraUserID != ""){
				variables.muraUser = getService("userManager").getByID(ID=variables.muraUserID);
			} else {
				variables.muraUser = getService("userManager").getBean();
			}
		}
		return variables.muraUser; 
	}
	
	public string function getFirstName() {
		if(!isDefined("variables.firstName") or variables.firstName == "") {
			variables.firstName = getMuraUser().getFname();
		}
		return variables.firstName;
	}
	
	public string function getLastName() {
		if(!isDefined("variables.lastName") or variables.lastName == "") {
			variables.lastName = getMuraUser().getLname();
		}
		return variables.lastName;
	}
	
	public string function getCompany() {
		if(!isDefined("variables.company") or variables.company == "") {
			variables.company = getMuraUser().getCompany();
		}
		return variables.lastName;
	}
	// End: User Helpers
}