/*
Copyright: ten24, LLC
Author: Sumit Verma(sumit.verma@ten24web.com)
$Id: NumericValidator.cfc 10 2009-12-20 22:04:23Z sverma $

Notes:
*/
/**
 * @hint numeric value validator.
 */
component extends="BaseValidator" {
	
	private boolean function validate(String objectValue){
		var valid = false;
		
		if(isNumeric(arguments.objectValue)){
			valid = true;
		}
		return valid;
	}

}