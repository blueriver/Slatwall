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

	public void function dashboard(required struct rc) {
		getFW().redirect(action="option.list");
	}
	
	public void function create(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup)) {
			rc.newOption = getOptionService().getNewEntity();
			rc.create = true;
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
			getFW().setView("option.edit");
		} else {
			getFW().redirect("option.list");
		}
	}

	public void function edit(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
		} else {
			getFW().redirect("option.list");
		}
	}
	
	public void function detail(required struct rc) {
		if(len(rc.option.getOptionName())) {
			rc.itemTitle &= ": #rc.option.getOptionName()#";
		} else {
			getFW().redirect("admin:option.list");
		}
	}
	
    
    public void function list(required struct rc) {
        param name="rc.listby" default="optiongroups";
        rc.orderby="optiongroup_optiongroupname|A^sortOrder|A";
        rc.options = getOptionService().getSmartList(rc=arguments.rc);
        rc.optionGroups = getOptionService().list(entityName="SlatwallOptionGroup",sortby="sortOrder Asc");
    }
	
	public void function save(required struct rc) {
		if(structKeyExists(rc,"optionid")) {
			rc.option = getOptionService().getByID(rc.optionID);
		} else {
			rc.option = getOptionService().getNewEntity();
		}
		
		//put optionGroup in rc in case we have to show the edit screen again
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
					
		// upload the image and return the result struct
		if(rc.optionImageFile != "") {
			rc.imageUploadResult = fileUpload(getTempDirectory(),"optionImageFile","","makeUnique");
		} 

		rc.option = getOptionService().save(rc.option,rc);
		
		if(!rc.option.hasErrors()) {
			// go to the 'manage option group' form to add/edit more options
			rc.message="admin.option.save_success";
			getFW().redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroupID#",preserve="message");
		} else {
			if(rc.option.isNew()) {
				rc.newOption = rc.option;
				rc.create = true;
				rc.optionID = "new";
				rc.itemTitle = rc.$.Slatwall.rbKey("admin.option.create");
				getFW().setView("admin:option.edit");
			} else {
				rc.activeOption = rc.option;
				rc.optionID = rc.option.getOptionID();
				rc.itemTitle = rc.$.Slatwall.rbKey("admin.option.create") & ": #rc.optionGroup.getOptionGroupName()#";
				getFW().setView("admin:option.edit");
			}		
		}
		
	}
	
	public void function saveOptionSort(required struct rc) {
		getOptionService().saveOptionSort(rc.optionID);
		getFW().redirect("admin:option.list");
	}
	
	public void function delete(required struct rc) {
		var option = getOptionService().getByID(rc.optionid);
		var optiongroupID = option.getOptionGroup().getOptionGroupID();
		var deleteResponse = getOptionService().delete(option);
		if(deleteResponse.getStatusCode()) {
			rc.message=deleteResponse.getMessage();
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:option.edit", querystring="optiongroupid=#optiongroupid#",preserve="message,messagetype");
	}
	
	public void function createOptionGroup(required struct rc) {
	   rc.edit=true;
	   rc.optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
	   getFW().setView("admin:option.detailoptiongroup");
	}
	
	public void function detailOptionGroup(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup) and !rc.optionGroup.isNew()) {
			rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
		} else {
			getFW().redirect("admin:option.list");
		}
	}
	
	public void function editOptionGroup(required struct rc) {
		rc.edit=true;
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup)) {
			if( len(rc.optionGroup.getOptionGroupName()) ) {
				rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
			}
			getFW().setView("admin:option.detailoptiongroup");
		} else
		  getFW().redirect("admin:option.list");
	}

	public void function saveOptionGroup(required struct rc) {
		if(len(trim(rc.optiongroupID))) {
			rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		} else {
			rc.optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
		}

		// upload the image and return the result struct
		if(rc.optionGroupImageFile != "") {
			rc.imageUploadResult = fileUpload(getTempDirectory(),"optionGroupImageFile","","makeUnique");
		} 
		
		rc.optionGroup = getOptionService().save(rc.optionGroup,rc);
		
		if(!rc.optionGroup.hasErrors()) {
			// go to the 'manage option group' form to add options
			rc.message="admin.option.saveoptiongroup_success";
			getFW().redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#",preserve="message");
		} else {
			rc.edit = true;
			rc.itemTitle = rc.OptionGroup.isNew() ? rc.$.Slatwall.rbKey("admin.option.createOptionGroup") : rc.$.Slatwall.rbKey("admin.option.editOptionGroup") & ": #rc.optionGroup.getOptionGroupName()#";
			getFW().setView(action="admin:option.detailOptionGroup");
		}
	}

	public void function saveOptionGroupSort(required struct rc) {
		getOptionService().saveOptionGroupSort(rc.optionGroupID);
		getFW().redirect("admin:option.list");
	}
	
	public void function deleteOptionGroup(required struct rc) {
		var optionGroup = getOptionService().getByID(rc.optiongroupid,"SlatwallOptionGroup");
		var deleteResponse = getOptionService().deleteOptionGroup(optionGroup);
		if(deleteResponse.getStatusCode()) {
			rc.message = deleteResponse.getMessage();
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		getFW().redirect(action="admin:option.list",preserve="message,messagetype");
	}
	
}
