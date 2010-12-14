/*
Copyright: ten24, LLC
Author: Sumit Verma(sumit.verma@ten24web.com)
$Id: AssertTrueValidator.cfc 16 2010-01-01 18:16:23Z sverma $

Notes:
*/
/**
 * @hint validates that the value is true
 */
component extends="BaseValidator" {

	public boolean function validate(any objectValue){
		var valid = true;
		if(!isBoolean(arguments.objectValue) || !arguments.objectValue){
			valid = false;
		}
		return valid;
	}
}