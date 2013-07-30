component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="account";

	// Data Properties
	property name="emailAddress";
	property name="siteID";
	
	public string function getSiteID() {
		if(!structKeyExists(variables, "siteID")) {
			variables.siteID = getHibachiScope().getSite().getSiteID();
		}
		return variables.siteID;
	}
}