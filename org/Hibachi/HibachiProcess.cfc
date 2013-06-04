component output="false" accessors="true" extends="HibachiTransient" {

	property name="preProcessDisplayedFlag";
	property name="populatedFlag";

	public boolean function isProcessObject() {
		return true;
	}
	
	public boolean function getPreProcessDisplayedFlag() {
		if(!structKeyExists(variables, "preProcessDisplayedFlag")) {
			variables.preProcessDisplayedFlag = 0;
		}
		return variables.preProcessDisplayedFlag;
	}
	
	public boolean function getPopulatedFlag() {
		if(!structKeyExists(variables, "populatedFlag")) {
			variables.populatedFlag = 0;
		}
		return variables.populatedFlag;
	}
	
}