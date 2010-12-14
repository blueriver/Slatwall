/*
Copyright: ten24, LLC
Author: Sumit Verma(sumit.verma@ten24web.com)
$Id: BaseValidator.cfc 10 2009-12-20 22:04:23Z sverma $

Notes:
*/
/**
 * @hint Base validator class that all validators will extend.
 */
component {
	
	public boolean function init(){
		return validate(argumentcollection=arguments);
	}
	
	/**
	 * @hint override this method in all validator class.
	 */
	private boolean function validate(){
		return true;
	}

}