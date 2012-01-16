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

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="locationService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:location.listlocations");
	}
	
	public void function listLocations(required struct rc) {
        param name="rc.orderBy" default="locationId|ASC";
        
        rc.locationSmartList = getLocationService().getLocationSmartList(data=arguments.rc);  
    }
    
    public void function detailLocation(required struct rc) {
    	param name="rc.locationID" default="";
    	param name="rc.edit" default="false";
    	
    	rc.location = getLocationService().getLocation(rc.locationID);
    	
    	if(isNull(rc.location)) {
    		getFW().redirect(action="admin:location.listLocations");
    	}
    }
    
    public void function createLocation(required struct rc) {
    	editLocation(rc);
	}
    
    public void function editLocation(required struct rc) {
    	param name="rc.locationID" default="";
    	param name="rc.locationRateID" default="";
    	
    	rc.location = getLocationService().getLocation(rc.locationID, true);
    	
    	rc.edit = true; 
    	getFW().setView("admin:location.detaillocation");  
	}
	

	public void function saveLocation(required struct rc) {
		editLocation(rc);

		var wasNew = rc.Location.isNew();

		
		// this does an RC -> Entity population, and flags the entities to be saved.
		rc.location = getLocationService().saveLocation(rc.location, rc);

		if(!rc.location.hasErrors()) {
			// If added or edited a Price Group Rate
			rc.message=rbKey("admin.location.savelocation_success");
			getFW().redirect(action="admin:location.listLocations", querystring="locationID=#rc.location.getLocationID()#", preserve="message");		
		} 
		else { 			
			rc.edit = true;
			rc.itemTitle = rc.Location.isNew() ? rc.$.Slatwall.rbKey("admin.location.createLocation") : rc.$.Slatwall.rbKey("admin.location.editLocation") & ": #rc.location.getLocationName()#";
			getFW().setView(action="admin:location.detailLocation");
		}	
	}
	
	public void function deleteLocation(required struct rc) {
		var location = getLocationService().getLocation(rc.locationId);
		var deleteOK = getLocationService().deleteLocation(location);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.location.deleteLocation_success");
		} else {
			rc.message = rbKey("admin.location.deleteLocation_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:location.listLocations", preserve="message,messagetype");
	}
}
