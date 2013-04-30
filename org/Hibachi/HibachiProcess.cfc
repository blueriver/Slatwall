component output="false" accessors="true" extends="HibachiTransient" {

	property name="preProcessDisplayedFlag";

	public boolean function isProcessObject() {
		return true;
	}
	
	public boolean function getPreProcessDisplayedFlag() {
		if(!structKeyExists(variables, "preProcessDisplayedFlag")) {
			variables.preProcessDisplayedFlag = 0;
		}
		return variables.preProcessDisplayedFlag;
	}
	
}