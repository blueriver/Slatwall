component accessors="true" extends="Slatwall.org.Hibachi.HibachiService" {

	public any function getSlatwallScope() {
		return getHibachiScope();
	} 
	public void function logSlatwall(required string message, boolean generalLog=false) {
		logHibachi(message=arguments.message, generalLog=arguments.generalLog);
	}

}