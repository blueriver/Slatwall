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

	// fw1 Auto-Injected Service Properties
	property name="optionService" type="any";

	public void function default(required struct rc) {
		getFW().redirect(action="option.listoptiongroups");
	}

	public void function listOptionGroups(required struct rc) {
        param name="rc.orderBy" default="sortOrder|ASC";
        
        rc.optionGroupSmartList = getOptionService().getOptionGroupSmartList(data=arguments.rc);
        
    }
    
    public void function detailOptionGroup(required struct rc) {
    	param name="rc.optionGroupID" default="";
    	param name="rc.edit" default="false";
    	
    	rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
    	
    	if(isNull(rc.optionGroup)) {
    		getFW().redirect(action="admin:option.listOptionGroups");
    	}
    }
    
    public void function createOptionGroup(required struct rc) {
    	editOptionGroup(rc);
	}
    
    public void function editOptionGroup(required struct rc) {
    	param name="rc.optionGroupID" default="";
    	param name="rc.optionID" default="";
    	
    	rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID, true);
    	rc.option = getOptionService().getOption(rc.optionID, true);
    	
    	rc.edit = true;
    	getFW().setView("admin:option.detailOptionGroup"); 
    }
    
    public void function saveOptionGroup(required struct rc) {
		editOptionGroup(rc);
		
		rc.optionGroup = getOptionService().saveOptionGroup(rc.optionGroup, rc);
		
		if(!rc.optionGroup.hasErrors()) {
			rc.message="admin.option.saveoptiongroup_success";
			if(rc.populateSubProperties) {
				getFW().redirect(action="admin:option.editOptionGroup",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#",preserve="message");	
			} else {
				getFW().redirect(action="admin:option.detailOptionGroup",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#",preserve="message");
			}
		} else {
			// If one of the sub-options had the error, then find out which one and populate it
			if(rc.optionGroup.hasError("options")) {
				for(var i=1; i<=arrayLen(rc.optionGroup.getOptions()); i++) {
					if(rc.optionGroup.getOptions()[i].hasErrors()) {
						rc.option = rc.optionGroup.getOptions()[i];
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.OptionGroup.isNew() ? rc.$.Slatwall.rbKey("admin.option.createOptionGroup") : rc.$.Slatwall.rbKey("admin.option.editOptionGroup") & ": #rc.optionGroup.getOptionGroupName()#";
			getFW().setView(action="admin:option.detailOptionGroup");
		}
	}
	public void function deleteOptionGroup(required struct rc) {
		param name="rc.optionGroupID" default="";
		
		var optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		
		var deleteOK = getOptionService().deleteOptionGroup(optionGroup);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.optionGroup.delete_success");
		} else {
			rc.message = rbKey("admin.optionGroup.delete_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:option.listOptionGroups", preserve="message,messagetype");
	}
	
	public void function deleteOption(required struct rc) {
		
		var option = getOptionService().getOption(rc.optionid);
		var optionGroupID = option.getOptionGroup().getOptionGroupID();
		var deleteOK = getOptionService().deleteOption(option);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.option.delete_success");
		} else {
			rc.message = rbKey("admin.option.delete_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:option.editOptionGroup", querystring="optiongroupid=#optionGroupID#",preserve="message,messagetype");
	}
	
	public void function saveOptionGroupSort(required struct rc) {
		param name="rc.optionGroupIDs" default="";
		
		getOptionService().saveOptionGroupSort(rc.optionGroupIDs);
		getFW().redirect("admin:option.listOptionGroups");
	}
	
	public void function saveOptionSort(required struct rc) {
		param name="rc.optionIDs" default="";
		
		getOptionService().saveOptionSort(rc.optionIDs);
		getFW().redirect("admin:option.listOptionGroups");
	}
	
}
