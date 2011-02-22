component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="optionService" type="any";

	public void function dashboard(required struct rc) {
		variables.fw.redirect(action="option.list");
	}
	
	public void function create(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		rc.newOption = getOptionService().getNewEntity();
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
			variables.fw.setView("option.edit");
		} else {
			variables.fw.redirect("option.list");
		}
	}

	public void function edit(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		rc.newOption = getOptionService().getNewEntity();
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": " & rc.optionGroup.getOptionGroupName();
		} else {
			variables.fw.redirect("option.list");
		}
	}
	
	public void function detail(required struct rc) {
		if(len(rc.option.getOptionName())) {
			rc.itemTitle &= ": #rc.option.getOptionName()#";
		} else {
			variables.fw.redirect("admin:option.list");
		}
	}
	
    
    public void function list(required struct rc) {
        param name="rc.listby" default="optiongroups";
        rc.orderby="optiongroup_optiongroupname|A^optionname|A";
        rc.options = getOptionService().getSmartList(rc=arguments.rc);
        rc.optionGroups = entityLoad("SlatwallOptionGroup",{},"OptionGroupName Asc");
    }
	
	public void function save(required struct rc) {
		if(structKeyExists(rc,"optionid")) {
			var option = getOptionService().getByID(rc.optionID);
		} else {
			var option = getOptionService().getNewEntity();
		}
		rc.option = variables.fw.populate(cfc=option, keys=option.getUpdateKeys(),trim=true);
		
		// set the option group to which this option belongs to
		rc.option.setOptionGroup(getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup"));
		
		// validate the form first before proceeding with image file operations
		rc.option = getOptionService().validate(rc.option);
			
		if(!rc.option.hasErrors()) {			
			// remove image if option is checked (unless a new image is set, in which case the old image is removed by saveimage())
			if(structKeyExists(rc,"removeImage") and rc.option.hasImage() and rc.optionImageFile == ""){
				rc.option.removeImage();
			}
			// save image file and set the image name is a property
			if(rc.optionImageFile != "") {
				rc.optionGroup.setImage("optionGroupImageFile");
			}
			rc.option = getOptionService().save(entity=rc.option);
			// go to the 'manage option group' form to add options
			variables.fw.redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroupID#");
		} else {
			variables.fw.redirect(action="option.edit",preserve="option");
		}
		
	}
	
	public void function delete(required struct rc) {
		var option = getOptionService().getByID(rc.optionid);
		var optiongroupID = option.getOptionGroup().getOptionGroupID();
		getOptionService().delete(option);
		variables.fw.redirect(action="admin:option.edit", querystring="optiongroupid=#optiongroupid#");
	}
	
	public void function createoptiongroup(required struct rc) {
	   rc.edit=true;
	   rc.optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
	   variables.fw.setView("admin:option.optiongroupdetail");
	}
	
	public void function detailoptiongroup(required struct rc) {
		rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		if(!isNull(rc.optionGroup) and !rc.optionGroup.isNew()) {
			rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
		} else {
			variables.fw.redirect("admin:option.list");
		}
	}
	
	public void function editoptiongroup(required struct rc) {
		rc.edit=true;
		if(!structKeyExists(rc,"optionGroup") or !isObject(rc.optionGroup)) {
			rc.optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		}
		if(!isNull(rc.optionGroup)) {
			rc.itemTitle &= ": #rc.optionGroup.getOptionGroupName()#";
			variables.fw.setView("admin:option.detailoptiongroup");
		} else
		  variables.fw.redirect("admin:option.list");
	}

	public void function saveoptiongroup(required struct rc) {
		if(len(trim(rc.optiongroupID))) {
			var optionGroup = getOptionService().getByID(rc.optionGroupID,"SlatwallOptionGroup");
		} else {
			var optionGroup = getOptionService().getNewEntity("SlatwallOptionGroup");
		}
		rc.optionGroup = variables.fw.populate(cfc=optionGroup, keys=optionGroup.getUpdateKeys(), trim=true);
		
		// validate the form first before proceeding with image file operations
		rc.optionGroup = getOptionService().validate(rc.optionGroup);

		if(!rc.optionGroup.hasErrors()) {
			// remove image if option is checked (unless a new image is set, in which case the old image is removed by saveimage())
			if(structKeyExists(rc,"removeImage") and rc.optionGroup.hasImage() and rc.optionGroupImageFile == ""){
				rc.optionGroup.removeImage();
			}
			// save image file and set the image name is a property
			if(rc.optionGroupImageFile != "") {
				rc.optionGroup.setImage("optionGroupImageFile");
			}
			rc.optionGroup = getOptionService().save(entity=rc.optionGroup);
			// go to the 'manage option group' form to add options
			variables.fw.redirect(action="admin:option.create",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#");
		} else {
			variables.fw.redirect(action="admin:option.editoptiongroup",preserve="optionGroup");
		}
	}
	
	public void function deleteoptiongroup(required struct rc) {
		getOptionService().delete(getOptionService().getByID(rc.optiongroupid,"SlatwallOptionGroup"));
		variables.fw.redirect(action="admin:option.list");
	}	
	
	/*public void function saveoptiongroup(required struct rc) {
		var fu = variables.fw.getBeanFactory().getBean("formUtilities");
		var optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		var imageDir = rc.$.siteConfig("assetPath") & "/images/Slatwall";
		optionGroup = variables.fw.populate(cfc=optionGroup, keys=optionGroup.getUpdateKeys(), trim=true);
		var optionsArray = fu.buildFormCollections(rc)["options"];
		if(arrayLen(optionsArray)){
			for(var i=1; i<=arraylen(optionsArray);i++) {
				if(len(trim(optionsArray[i].optionName))) {
					var option = getOptionService().getByID(optionsArray[i].optionID);
					if(structKeyExists(optionsArray[i],"deleteOption") and !option.isNew()) {
						fileDelete(expandPath("#imageDir#/#option.getImagePath()#"));
						getOptionService().delete(option);
					} else {
						option.setOptionName(optionsArray[i].optionName);
						option.setOptionID(optionsArray[i].optionID);
						option.setOptionCode(optionsArray[i].optionCode);
						option.setOptionDescription(optionsArray[i].optionDescription);
						if(structKeyExists(optionsArray[i],"removeOptionImage") and option.hasImage() and optionsArray[i].optionImageFile == "") {
							fileDelete(expandPath("#imageDir#/#option.getImagePath()#"));
							option.setOptionImage("");
						}
						if(option.isNew())
							optionGroup.addOption(option);
						if(optionsArray[i].optionImageFile != "") 
							saveImage(option,"options[#i#].optionImageFile",imageDir);
					}
				}
			}
		}
		// remove image if option is checked (unless a new image is set, in which case the old image is removed by saveimage())
		if(structKeyExists(rc,"removeImage") and optionGroup.hasImage() and rc.optionGroupImageFile == ""){
			filedelete(expandPath("#imageDir#/#optionGroup.getImagePath()#"));
			optionGroup.setOptionGroupImage("");
		}
		// save image file and set the image name is a property
		if(rc.optionGroupImageFile != "") {
			saveImage(optionGroup,"optionGroupImageFile",imageDir);
		}
		optionGroup = getOptionService().save(entity=optionGroup);
		if(!optionGroup.hasErrors()) {
			variables.fw.redirect(action="admin:option.optiongroupdetail",querystring="optiongroupID=#optionGroup.getOptionGroupID()#");
		} else {
			rc.optionGroup=optionGroup;
			variables.fw.redirect("admin:option.optiongroupform","optionGroup");
		}
	}
	
	public void function deleteoptiongroup(required struct rc) {
		getOptionService().deleteOptionGroup(rc.optiongroupid);
		variables.fw.redirect(action="admin:option.list");
	}	
	
	public void function detail(required struct rc) {
		if(len(rc.option.getOptionName())) {
			rc.itemTitle &= ": #rc.option.getOptionName()#";
		} else {
			variables.fw.redirect("admin:option.list");
		}
	}*/
	
	private function saveImage(required entity,required string imageFileField,required string imageDir) {
		var result = fileUpload(getTempDirectory(),arguments.imageFileField,"image/jpeg,image/jpg,image/png,image/gif","makeUnique");
		if(result.fileWasSaved) {
			var theFile = result.serverdirectory & "/" & result.serverFile;
			if(isImageFile(thefile)) {
				var img = imageRead(thefile);
				// image size should probably be configured somewhere
				imageScaleToFit(img, 150, 150);
				if(arguments.entity.hasImage()){
					// if entity currently has an image, delete it
					fileDelete(expandPath("#arguments.imageDir#/#arguments.entity.getImagePath()#"));
				}
				if(arguments.entity.getClassName() == "SlatwallOption") {
				   var imageName = filterFileName(arguments.entity.getOptionGroup().getOptionGroupName() & "_" & arguments.entity.getOptionName()) & "." & result.serverFileExt;
				   arguments.entity.setOptionImage(imageName);
				}
				else if(arguments.entity.getClassName() == "SlatwallOptionGroup") {
				   var imageName = filterFileName(arguments.entity.getOptionGroupName()) & "." & result.serverFileExt;
				   arguments.entity.setOptionGroupImage(imageName);
				}
				var destination = expandPath(arguments.imageDir & "/#arguments.entity.getClassName()#");
				if(!directoryExists(destination))
					directoryCreate(destination);
				imageWrite(img,"#destination#/#imageName#",true);
				return true;
			} else { // file was not an image
				fileDelete(theFile);
				return false;
			}
		} else return false;
	}

// this function here should probably be in some sort of utility class

	/*
	*  This function is part of the Common Function Library Project. An open source
	*   collection of UDF libraries designed for ColdFusion 5.0 and higher. For more information,
	*   please see the web site at:
	*
	*       http://www.cflib.org
	*
	*   License:
	*   This code may be used freely.
	*   You may modify this code as you see fit, however, this header, and the header
	*   for the functions must remain intact.
	*
	*   This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
	*
	*  @hint This function will remove any reserved characters from a filename string and replace any spaces with dashes.
	*  @param filename   Filename. (Required)
	*  @return Returns a string. 
	*  @author Jason Sheedy (jason@jmpj.net) 
	*  @version 1, January 19, 2006 
	*/
	
	public string function filterFilename(required string filename) {
	    var filenameRE = "[" & "'" & '"' & "##" & "/\\%&`@~!,:;=<>\+\*\?\[\]\^\$\(\)\{\}\|]";
	    var newfilename = reReplace(arguments.filename,filenameRE,"","all");
	    newfilename = replace(newfilename," ","-","all");
	    
	    return lcase(newfilename);
	}
}