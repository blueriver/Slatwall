component displayname="Account Email" entityname="SlatwallAccountEmail" table="SlatwallAccountEmail" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistant Properties
	property name="accountEmailID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="email" ormtype="string";
	property name="isPrimary" default="false" ormtype="boolean"; 
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	
	public void function setIsPrimary(required boolean isPrimary) {
		if(isPrimary == true) {
			var emails = getAccount().getAccountEmails();
			for(var i = 0; i <= arrayLen(emails); i++) {
				if(emails[i].getIsPrimary() == true) {
					emails[i].setIsPrimary(false);
					getService("accountService").save(entity=emails[i]);
				}
			}
		}
		variables.isPrimary = arguments.isPrimary;
	}
	
}