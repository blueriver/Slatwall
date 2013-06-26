component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="account";

	// Data Properties
	property name="swprid";
	property name="password";
	property name="passwordConfirm";
	property name="accountPasswordResetID";
	
	public string function getAccountPasswordResetID() {
		return getAccount().getPasswordResetID();
	}
	
}