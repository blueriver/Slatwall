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
component extends="BaseController" persistent="false" accessors="true" output="false" {
	
	property name="vendorService";
	property name="vendorOrderService";
	property name="addressService";
	
	public void function before(required struct rc) {
	}
	
	public void function listVendors(required struct rc) {
        param name="rc.orderBy" default="vendorId|ASC";
        
        rc.vendorSmartList = getVendorService().getVendorSmartList(data=arguments.rc);  
    }
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:vendor.listvendors");
	}
	
	public void function detailVendor(required struct rc) {
		param name="rc.vendorID" default="";
    	param name="rc.edit" default="false";
    		
    	// Get the vendor, but to NOT create a new vendor if the ID is not found (hense lack of second parameter=true).
    	rc.vendor = getVendorService().getVendor(rc.vendorID);
    	
    	if(isNull(rc.vendor)) {
    		getFW().redirect(action="admin:vendor.listvendors");
    	}
			
		var orderParams['vendorID'] = rc.vendorID;
		var orderParams.orderBy = "createdDateTime|DESC";
		rc.vendorOrderSmartList = getVendorOrderService().getVendorOrderSmartList(data=orderParams);
	}
	
	public void function createVendor(required struct rc) {
		editVendor(rc);
	}
	
	// Display edit interface
	public void function editVendor(required struct rc) {
		param name="rc.vendorID" default="";
    	param name="rc.vendorAddressID" default="";
    	
    	// These both will return blank objects if the rc fields are empty (no IDs).
    	rc.vendor = getVendorService().getVendor(rc.vendorID, true);

    	rc.vendorAddress = getVendorService().getVendorAddress(rc.vendorAddressId, true);
    	
    	// If vendorAddress is new then it won't contain an "Address" (vendorAddress is only a relational entity), so create a new one.
    	if(rc.vendorAddress.isNew()) {
    		rc.vendorAddress.setAddress(getAddressService().getAddress(0, true));	
    	}
    	
    	var orderParams['vendorID'] = rc.vendorID;
		var orderParams.orderBy = "createdDateTime|DESC";
		rc.vendorOrderSmartList = getVendorOrderService().getVendorOrderSmartList(data=orderParams);
    	
    	rc.edit = true; 
    	getFW().setView("admin:vendor.detailvendor");  
	}
	
	public void function deleteVendor(required struct rc) {
		param name="rc.vendorID";
		var vendor = getVendorService().getVendor(rc.vendorID);
		var deleteOK = getVendorService().deleteVendor(vendor);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.vendor.delete_success");
		} else {
			rc.message = rbKey("admin.vendor.delete_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:vendor.listvendors",preserve="message,messageType");
	}
	
	public void function deletevendoraddress(required struct rc) {
		param name="rc.vendorAddressID";
		var vendorAddress = getVendorService().getVendorAddress(rc.vendorAddressID);
		var deleteOK = getVendorService().deleteVendorAddress(vendorAddress);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.vendor.deleteVendorAddress_success");
		} else {
			rc.message = rbKey("admin.vendor.deleteVendorAddress_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:vendor.detailvendor", querystring="vendorId=#vendorAddress.getVendor().getVendorId()#", preserve="message,messageType");
	}
	

	public void function listVendor(required struct rc) {
		param name="rc.keyword" default="";
		
		rc.vendorSmartList = getVendorService().getVendorSmartList(data=arguments.rc);
	}
	
	public void function saveVendor(required struct rc) {
		param name="rc.vendorID" default="";
		param name="rc.vendorAddressID" default="";
		editVendor(rc);

		var wasNew = rc.Vendor.isNew();
		
		

		// this does an RC -> Entity population, and flags the entities to be saved.
		rc.Vendor = getVendorService().saveVendor(rc.Vendor, rc);

dumpScreen(request.slatwallcache.cachelog);
		// Popualate new Address with RC. Both entities will be blank if no ID specified. 
		var vendorAddress = getAddressService().getVendorAddress(rc.vendoraddresses[1].vendorAddressID, true);
		var addressId = "";
		if(!isNull(vendorAddress.getAddress())) {
			addressId = vendorAddress.getAddress().getAddressId();		
		}
		
		// Address will be either a new entity (if is is empty) or an address from the DB. 
		var address = getAddressService().getAddress(addressId, true);
		
		//dumpScreen(rc);
		// This does an RC -> Entity population, and flags the entities to be saved.
		getAddressService().saveAddress(address, rc.vendoraddresses[1].address);
		vendorAddress.setAddress(address);
		vendorAddress.setVendor(rc.Vendor);
		//dumpScreen(vendorAddress);
		
		// This does an RC -> Entity population, and flags the entities to be saved.
		getAddressService().saveVendorAddress(vendorAddress);
	
	
	
		if(!rc.Vendor.hasErrors()) {
			// If added or edited a Price Group Rate
			if(wasNew) {
				rc.message=rbKey("admin.vendor.saveVendor_success");
				//getFW().redirect(action="admin:vendor.editVendor", querystring="Vendorid=#rc.Vendor.getVendorID()#", preserve="message");
				getFW().redirect(action="admin:vendor.listvendors", preserve="message");	
			} else {
				rc.message=rc.message=rbKey("admin.vendor.saveVendor_success");
				
				// If any of the sub properties (such as address or email) has changed during this edit, then stay on the details page, otherwise, list.
				if(rc.populateSubProperties)
					getFW().redirect(action="admin:vendor.editVendor", querystring="vendorID=#rc.Vendor.getVendorID()#", preserve="message");
				else
					getFW().redirect(action="admin:vendor.listVendors", preserve="message");
			}	
		} 
		else { 			
			// If one of the sub properties had the error, then find out which one and populate it
			if(rc.Vendor.hasError("VendorAddress")) {
				for(var i=1; i<=arrayLen(rc.Vendor.getVendorAddresses()); i++) {
					if(rc.Vendor.getVendorAddresses()[i].getAddress().hasErrors()) {
						rc.VendorAddress = rc.Vendor.getVendorAddresses()[i];
						break;
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.Vendor.isNew() ? rc.$.Slatwall.rbKey("admin.Vendor.createVendor") : rc.$.Slatwall.rbKey("admin.Vendor.editVendor") & ": #rc.Vendor.getVendorName()#";
			getFW().setView(action="admin:vendor.detailVendor");
		}	
		
		
		/*
		detailVendor(rc);
		
		rc.vendor = getVendorService().saveVendor(vendor=rc.vendor, data=rc);
		
		if(rc.vendor.hasErrors()) {
			rc.edit = true;
			getFW().setView("admin:vendor.detailvendor");
		} else {
			rc.message = "admin.vendor.save_success";
        	getFW().redirect(action="admin:vendor.listvendor",preserve="message");	
		}
		*/
	}
}
