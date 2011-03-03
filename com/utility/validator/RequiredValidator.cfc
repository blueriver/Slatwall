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
	
	private boolean function validate(any objectValue){
		var valid = true;
		if((isSimpleValue(arguments.objectValue) and len(arguments.objectValue) == 0) || isNull(arguments.objectValue)) {
			valid = false;
		}
		
		return valid;
	}

}