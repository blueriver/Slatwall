component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="optionService" type="any";

	public void function dashboard(required struct rc) {
		getFW().redirect(action="option.list");
	}
	
	public void function create(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup)) {
			// if we're coming back from a new option submission with errors set that one as the new option
			if(structKeyExists(rc,"option") && isObject(rc.option) && rc.optionID=="new") {
				rc.newOption = rc.option;
			} else {
				rc.newOption = getOptionService().getNewEntity();
			}
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
			getFW().setView("option.edit");
		} else {
			getFW().redirect("option.list");
		}
	}

	public void function edit(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup)) {
			// if we're coming back from an option update submission with errors set that one as the active option
			if(structKeyExists(rc,"option") && isObject(rc.option) && rc.optionID==rc.option.getOptionID()) {
				// merge entity with current session and transfer error bean
				var errors = rc.option.getErrorBean();
				rc.activeOption = entityMerge(rc.option);
				rc.activeOption.setErrorBean(errors);
			} 
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
        rc.optionGroups = getOptionService().list(entityName="SlatwallOptionGroup",sortOrder="OptionGroupName Asc");
    }
	
	public void function save(required struct rc) {
		if(structKeyExists(rc,"optionid")) {
			rc.option = getOptionService().getByID(rc.optionID);
		} else {
			rc.option = getOptionService().getNewEntity();
		}
					
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
				getFW().redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroupID#&optionID=new" ,preserve="option");
			} else {
				getFW().redirect(action="admin:option.edit",querystring="optiongroupid=#rc.optionGroupID#&optionID=#rc.option.getOptionID()#" ,preserve="option");
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
		if(getOptionService().delete(option)) {
			rc.message="admin.option.delete_success";
		} else {
			rc.message="admin.option.delete_disabled";
			rc.messagetype="warning";
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
		if(structKeyExists(rc,"optionGroup") && isObject(rc.optionGroup)) {
			// entity came back from a failed validation, so merge it with the new session and transfer over the error bean
			var errors = rc.optionGroup.getErrorBean();
			rc.optionGroup = entityMerge(rc.optionGroup);
			rc.optionGroup.setErrorBean(errors);
		} else { 
			rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		}
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
			getFW().redirect(action="admin:option.editoptiongroup",preserve="optionGroup",querystring=rc.optionGroup.getOptionGroupID());
		}
	}
	
	public void function deleteOptionGroup(required struct rc) {
		var optionGroup = getOptionService().getByID(rc.optiongroupid,"SlatwallOptionGroup");
		if(getOptionService().deleteOptionGroup(optionGroup)) {
			rc.message = "admin.option.deleteoptiongroup_success";
		} else {
			rc.message = "admin.option.deleteoptiongroup_disabled";
			rc.messagetype = "warning";
		}
		getFW().redirect(action="admin:option.list",preserve="message,messagetype");
	}
	
}