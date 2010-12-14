/*
Copyright: ten24, LLC
Author: Sumit Verma(sumit.verma@ten24web.com)
$Id: RequiredValidator.cfc 37 2010-02-02 16:40:05Z sverma $

Notes:
*/
/**
 * @hint required value validator.
 */
component extends="BaseValidator" {
	
	private boolean function validate(String objectValue){
		var valid = true;
		
		if(isNull(arguments.objectValue) || len(arguments.objectValue) EQ 0){
			valid = false;
		}
		return valid;
	}

}