/*

    Slatwall - An Open Source eCommerce Platform
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
component output="false" accessors="true" persistent="false" extends="Slatwall.org.Hibachi.HibachiEntity" {

	// @hint Override the populate method to look for custom attributes
	public any function populate( required struct data={} ) {
		
		// Call the super populate to do all the standard logic
		super.populate(argumentcollection=arguments);
		
		// Get the assigned attributes
		var assignedAttributeSets = getAssignedAttributeSetSmartList().getRecords();
		
		var attributeType = replace(getEntityName(),"Slatwall","");
		attributeType = lcase(left(attributeType, 1)) & right(attributeType, len(attributeType)-1);
					
		// Loop over attribute sets
		for(var ats=1; ats<=arrayLen(assignedAttributeSets); ats++) {
			var attributes = assignedAttributeSets.getAttributes();
			
			for(var at=1; at<=arrayLen(attributes); at++) {
				if(structKeyExists(arguments.data, attributes[at].getAttributeCode())) {
					var av = getAttributeValue(at.getAttributeCode, true);
					av.setAttributeValue( data[ attributes[at].getAttributeCode() ]);
					av.setAttribute(at);
					av.setAttributeType(attributeType);
					av.invokeMethod("set#attributeType#", {1=this});			
				}
			}
		}
		
		// Return this object
		return this;
	}

	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	// @hint helper function to return the details of a setting
	public struct function getSettingDetails(required any settingName, array filterEntities=[]) {
		return getService("settingService").getSettingDetails(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities);
	}
	
}
