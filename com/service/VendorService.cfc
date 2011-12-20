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
component extends="BaseService" accessors="true" output="false" {
	
	property name="vendorOrderService" type="any";

	
	
	public any function saveVendor(required any vendor, required struct data) {
		
		// Call the super.save() to do population and validation
		arguments.vendor = super.save(entity=arguments.vendor, data=arguments.data);
		
		// Vendor Email
		if( structKeyExists(arguments.data, "emailAddress") && isNull(arguments.vendor.getPrimaryEmailAddress()) ) {
			
			// Setup Email Address
			var vendorEmailAddress = this.newVendorEmailAddress();
			vendorEmailAddress.populate(arguments.data);
			vendorEmailAddress.setVendor(arguments.vendor);
			arguments.vendor.setPrimaryEmailAddress(vendorEmailAddress);
			
			// Validate This Object
			vendorEmailAddress.validate();
			if(vendorEmailAddress.hasErrors()) {
				arguments.vendor.addError("emailAddress", "The Email address has errors");
			}

		}

		// Vendor Phone Number
		if( structKeyExists(arguments.data, "phoneNumber") && isNull(arguments.vendor.getPrimaryPhoneNumber())) {
			
			// Setup Phone Number
			var vendorPhoneNumber = this.newVendorPhoneNumber();
			vendorPhoneNumber.populate(arguments.data);
			vendorPhoneNumber.setVendor(arguments.vendor);
			arguments.vendor.setPrimaryPhoneNumber(vendorPhoneNumber);
			
			// Validate This Object
			vendorPhoneNumber.validate();
			if(vendorPhoneNumber.hasErrors()) {
				arguments.vendor.addError("phoneNumber", "The Phone Number has errors");
			}
		}
		
		return arguments.vendor;
	}
	

	/*public any function getVendorSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendor";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);

		
		return smartList;
	}*/
}