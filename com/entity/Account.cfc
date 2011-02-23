component displayname="Account" entityname="SlatwallAccount" table="SlatwallAccount" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
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
	property name="accountEmails" singularname="accountEmail" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmail" inverse="true" cascade="all";
	
	// Non-Persistant Properties
	property name="primaryEmail" type="string" persistent="false" ;
	
	public array function getAccountEmails() {
		if(!isDefined("variables.accountEmails")) {
			variables.accountEmails = arrayNew(1);
		}
		return variables.accountEmails;
	}
	
	// Start: User Helpers
	// The following four functions are designed to connect a Slatwall account to a Mura account.  If the mura account exists then this will pull all data from mura, if not then the firstName, lastName & company will be stored in the Slatwall DB.
	public string function getFirstName() {
		if(!isNull(getMuraUser())) {
			variables.firstName = getMuraUser().getFirstName();
		}
		if(!structKeyExists(variables, "firstName")) {
			variables.firstName = "";
		}
		return variables.firstName;
	}
	
	public string function getLastName() {
		if(!isNull(getMuraUser())) {
			variables.lastName = getMuraUser().getLastName();
		}
		if(!structKeyExists(variables, "lastName")) {
			variables.lastName = "";
		}
		return variables.lastName;
	}
	
	public string function getCompany() {
		if(!isNull(getMuraUser())) {
			variables.company = getMuraUser().getCompany();
		}
		if(!structKeyExists(variables, "company")) {
			variables.company = "";
		}
		
		return variables.company;
	}
	// End: User Helpers
	
	public string function getFullName() {
		return "#getFirstName()# #getLastName()#";
	}
	
	public string function getPrimaryEmail() {
		if(!isDefined("variables.primaryEmail")) {
			
			// Look through all account emails for the primary one
			var emails = getAccountEmails();
			
			for(var i = 1; i <= arrayLen(emails); i++) {
				if(emails[i].getIsPrimary() == true) {
					variables.primaryEmail = emails[i].getEmail();
				}
			}
			
			// If one wasn't found, but there were 1 or more emails, set the first one as primary.  Otherwise set as blank
			if(!isDefined("variables.primaryEmail") && arrayLen(emails) > 0) {
				emails[1].setIsPrimary(true);
				getService("accountService").save(entity = emails[1]);
				variables.primaryEmail = emails[1].getEmail();
			} else if(!isDefined("variables.primaryEmail")) {
				variables.primaryEmail = "";
			}
		}

		return variables.primaryEmail;
	}
	
	public any function setPrimaryEmail() {
		throw("Setting the primary email for an account should be done to an accountEmail entity, and should be done by using the method 'setIsPrimary'");
	}
	
}