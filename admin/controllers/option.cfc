component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="optionService" type="any";

	public void function dashboard(required struct rc) {
		getFW().redirect(action="option.list");
	}
	
	public void function create(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		rc.newOption = getOptionService().getNewEntity();
		rc.htmlheadscripts = '<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/sorter.js"></script>';
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
			getFW().setView("option.edit");
		} else {
			getFW().redirect("option.list");
		}
	}

	public void function edit(required struct rc) {
		rc.htmlheadscripts = '<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/sorter.js"></script>';
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		// if we're coming back from a new option submission with errors set that one as the new option
		if(!isNull(rc.optionGroup) && structKeyExists(rc,"option") && isObject(rc.option)) {
			if(rc.optionID=="") {
				rc.newOption = rc.option;
			} else {
				rc.newOption = getOptionService().getNewEntity();
			}
		} else {
			rc.newOption = getOptionService().getNewEntity();
		}
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
        rc.optionGroups = getOptionService().list(entityName="SlatwallOptionGroup",sortOrder="OptionGroupName Asc");
    }
	
	public void function save(required struct rc) {
		if(structKeyExists(rc,"optionid")) {
			var option = getOptionService().getByID(rc.optionID);
		} else {
			var option = getOptionService().getNewEntity();
		}
		rc.option = getFW().populate(cfc=option, keys=option.getUpdateKeys(),trim=true);
		
		// set the option group to which this option belongs to
		if(rc.option.isNew()) {
			rc.option.setOptionGroup(getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup"));
		}
					
		// remove image if option is checked (unless a new image is set, in which case the old image is removed by saveimage())
		if(structKeyExists(rc,"removeOptionImage") and rc.option.hasImage() and rc.optionImageFile == ""){
			getOptionService().removeImage(rc.option);
		}
		// upload the image and return the result struct, or an empty struct if no file was uploaded
		if(rc.optionImageFile != "") {
			var uploadResult = fileUpload(getTempDirectory(),"optionImageFile","","makeUnique");
		} else {
			var uploadResult = {};
		}
		
		rc.option = getOptionService().save(entity=rc.option, imageUploadResult=uploadResult);
		
		if(!rc.option.hasErrors()) {
			// go to the 'manage option group' form to add/edit more options
			getFW().redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroupID#");
		} else {
			getFW().redirect(action="option.edit",querystring="optiongroupid=#rc.optionGroupID#&optionID=rc.option.getOptionID()" ,preserve="option");
		}
		
	}
	
	public void function saveOptionSort(required struct rc) {
		getOptionService().saveOptionSort(rc.optionID);
		getFW().redirect("admin:option.list");
	}
	
	public void function delete(required struct rc) {
		var option = getOptionService().getByID(rc.optionid);
		var optiongroupID = option.getOptionGroup().getOptionGroupID();
		if(!option.getIsAssigned()) {
			getOptionService().delete(option);
			rc.message="admin.option.delete_success";
		} else {
			rc.message="admin.option.delete_disabled";
			rc.messagetype="warning";
		}
		getFW().redirect(action="admin:option.edit", querystring="optiongroupid=#optiongroupid#",preserve="message,messagetype");
	}
	
	public void function createoptiongroup(required struct rc) {
	   rc.edit=true;
	   rc.optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
	   getFW().setView("admin:option.detailoptiongroup");
	}
	
	public void function detailoptiongroup(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup) and !rc.optionGroup.isNew()) {
			rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
		} else {
			getFW().redirect("admin:option.list");
		}
	}
	
	public void function editoptiongroup(required struct rc) {
		rc.edit=true;
		if(!structKeyExists(rc,"optionGroup") or !isObject(rc.optionGroup)) {
			rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		}
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
			getFW().setView("admin:option.detailoptiongroup");
		} else
		  getFW().redirect("admin:option.list");
	}

	public void function saveoptiongroup(required struct rc) {
		if(len(trim(rc.optiongroupID))) {
			var optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		} else {
			var optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
		}
		rc.optionGroup = getFW().populate(cfc=optionGroup, keys=optionGroup.getUpdateKeys(), trim=true);
		
		// remove image if option is checked (unless a new image is set, in which case the old image is removed by saveimage())
		if(structKeyExists(rc,"removeOptionGroupImage") and rc.optionGroup.hasImage() and rc.optionGroupImageFile == ""){
			getOptionService().removeImage(rc.OptionGroup);
		}
		// upload the image and return the result struct, or an empty struct if no file was uploaded
		if(rc.optionGroupImageFile != "") {
			var uploadResult = fileUpload(getTempDirectory(),"optionGroupImageFile","","makeUnique");
		} else {
			var uploadResult = {};
		}
		rc.optionGroup = getOptionService().save(entity=rc.optionGroup, imageUploadResult=uploadResult);
		if(!rc.optionGroup.hasErrors()) {
			// go to the 'manage option group' form to add options
			getFW().redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#");
		} else {
			getFW().redirect(action="admin:option.editoptiongroup",preserve="optionGroup",querystring=rc.optionGroup.getOptionGroupID());
		}
	}
	
	public void function deleteoptiongroup(required struct rc) {
		var optionGroup = getOptionService().getByID(rc.optiongroupid,"SlatwallOptionGroup");
		if(optionGroup.getOptionsCount() eq 0) {
			getOptionService().delete(getOptionService().getByID(rc.optiongroupid,"SlatwallOptionGroup"));
			rc.message = "admin.option.deleteoptiongroup_success";
		} else {
			rc.message = "admin.option.deleteoptiongroup_disabled";
			rc.messagetype = "warning";
		}
		getFW().redirect(action="admin:option.list",preserve="message,messagetype");
	}
	
}