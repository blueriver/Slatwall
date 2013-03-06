component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="account";

	// Data Properties
	property name="firstName";
	property name="lastName";
	property name="company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag";
	property name="password";
	property name="passwordConfirm";
	
	public boolean function getCreateAuthenticationFlag() {
		if(!structKeyExists(variables, "createAuthenticationFlag")) {
			variables.createAuthenticationFlag = 1;
		}
		return variables.createAuthenticationFlag;
	}
	
}