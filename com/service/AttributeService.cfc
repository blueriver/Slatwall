/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

component  extends="Slatwall.com.service.BaseService" accessors="true" {
	
	public void function saveAttributeSort(required string attributeIDs) {
		for(var i=1; i<=listlen(arguments.attributeIDs);i++) {
			var attributeID = listGetAt(arguments.attributeIDs,i);
			var thisAttribute = this.getAttribute(attributeID);
			thisAttribute.setSortOrder(i);
		}
	}
	
	public any function saveAttribute( required any attribute, required struct data ) {
		// generate the attribute code if not specified
		if(!structKeyExists(arguments.data,"attributeCode") || trim(arguments.data.attributeCode) == "") {
			arguments.data.attributeCode = replace(getService("utilityFileService").filterFileName(arguments.data.attributeName),"-","","all");	
		}
		arguments.attribute = Super.save(arguments.attribute,arguments.data);
		
		// save attribute options if the saved entity was the correct type and there were no errors
		var optionsAttributeTypeList = "atSelectBox,atCheckBox,atRadioGroup";
		if( listFind(optionsAttributeTypeList,arguments.attribute.getAttributeType().getSystemCode()) 
			&& structKeyExists(arguments.data,"optionsArray")
			&& !arguments.attribute.hasErrors() ) {
			saveAttributeOptions(arguments.attribute,arguments.data.optionsArray);
		}
		return arguments.attribute;
	}
	
	private void function saveAttributeOptions( required any attribute, required array optionsArray ) {
		var order=0;
		// list of option values to keep track of so we don't include any duplicates
		var optionValueList = "";
		// set the attribute options into the attribute, if defined.
		for( var i=1; i<=arrayLen(arguments.optionsArray);i++ ) {
			// it's possible that array elements are undefined if options were deleted, so check
			if(arrayIsDefined(arguments.optionsArray,i)) {
				var thisOptionStruct = arguments.optionsArray[i];
				// don't do anything unless there is an actual value passed in and it's not a duplicate
				if( len(trim(thisOptionStruct.value)) && !listFind(optionValueList,trim(thisOptionStruct.value)) ) {
					order++;
					if(len(thisOptionStruct.attributeOptionID)) {
						var thisAttributeOption = this.getAttributeOption(thisOptionStruct.attributeOptionID);
					} else {
						var thisAttributeOption = this.newAttributeOption();
					}
					thisAttributeOption.setAttributeOptionValue(trim(thisOptionStruct.value));
					optionValueList = listAppend(optionValueList, thisAttributeOption.getAttributeOptionValue());
					if(len(thisOptionStruct.label)) {
						thisAttributeOption.setAttributeOptionLabel(thisOptionStruct.label);
					}
					if(len(trim(thisOptionStruct.sortOrder)) && isNumeric(thisOptionStruct.sortOrder)) {
						thisAttributeOption.setSortOrder(trim(thisOptionStruct.sortOrder));
					} else {
						thisAttributeOption.setSortOrder(order);
					}
					arguments.attribute.addAttributeOption(thisAttributeOption);
				}
			}
		}		
	}
		
	public any function getAttributeSets(array systemCode) {
		var smartList = this.getAttributeSetSmartList();
		if(structKeyExists(arguments,"systemCode")){
			for(var i = 1; i <= arrayLen(systemCode); i++){
				smartList.addFilter("attributeSetType_systemCode",systemCode[i],i);
			}
		}
		smartList.addOrder("attributeSetType_systemCode|ASC");
		smartList.addOrder("sortOrder|ASC");
		return smartList.getRecords();
	}
	
	public any function deleteAttributeSet( required any attributeSet ) {
		//TODO: delete validation
		return super.delete(attributeSet);
	}
}
