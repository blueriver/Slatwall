component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="optionService" type="any";
	
	public void function before(required struct rc) {
		param name="rc.optionID" default="";
		param name="rc.itemTitle" default="";
		
		rc.sectionTitle = rc.rbFactory.getKeyValue(session.rb,"option.productoptions");
		rc.option = getOptionService().getByID(ID=rc.optionID);
		if(!isDefined("rc.option")) {
			rc.option = getOptionService().getNewEntity();
		}
	}
	
	public void function detail(required struct rc) {
		if(len(rc.option.getOptionName()))
			rc.itemTitle = rc.rbFactory.getKeyValue(session.rb,"option.optiondetail") & ": " & rc.option.getOptionName();
		else
			variables.fw.redirect("option.list");
	}
	
	public void function list(required struct rc) {
		rc.itemTitle = rc.rbFactory.getKeyValue(session.rb,"option.optionlist");
		rc.options = getOptionService().list();
		rc.optionGroups = getOptionService().listOptionGroups();
		//rc.OptionSmartList = getOptionService().getSmartList(rc=arguments.rc);
	}

	public void function update(required struct rc) {
		rc.option = variables.fw.populate(cfc=rc.option, keys=rc.option.getUpdateKeys(), trim=true);
		rc.option = getOptionService().save(entity=rc.option);
		variables.fw.redirect(action="admin:option.detail", queryString="optionID=#rc.option.getOptionID()#");
	}
	
	public void function delete(required struct rc) {
		getOptionService().delete(entity=rc.option);
		variables.fw.redirect(action="admin:option.list");
	}
	
	public void function optiongroupdetail(required struct rc) {
		if(structKeyExists(rc,"optionGroupID") and isSimpleValue(rc.optionGroupID)) {
			rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		}
		if(isDefined("rc.optionGroup") and len(rc.optionGroup.getOptionGroupName()))
			rc.itemTitle=rc.rbFactory.getKeyValue(session.rb,"option.optiongroupdetail") & ": " & rc.optionGroup.getOptionGroupName();
		//else
			//variables.fw.redirect("admin:option.list");
	}
	
	public void function optiongroupform(required struct rc) {
		rc.edit=true;
		if(structKeyExists(rc,"optionGroupID") and isSimpleValue(rc.optionGroupID)) {
			rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		}
		if(!isDefined("rc.optionGroup"))
			rc.optionGroup = getOptionService().getOptionGroup();
		if(len(rc.optionGroup.getOptionGroupName()))
			rc.itemTitle = rc.rbFactory.getKeyValue(session.rb,"option.editoptiongroup")& ": " & rc.optionGroup.getOptionGroupName();
		else
			rc.itemTitle = rc.rbFactory.getKeyValue(session.rb,"option.addoptiongroup");
		variables.fw.setView("admin:option.optiongroupdetail");
	}
	
	public void function processoptiongroupform(required struct rc) {
		var fu = variables.fw.getBeanFactory().getBean("formUtilities");
		var optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		var imageDir = rc.$.siteConfig("assetPath") & "/images/Slatwall";
		optionGroup = variables.fw.populate(cfc=optionGroup, keys=optionGroup.getUpdateKeys(), trim=true);
		var optionsArray = fu.buildFormCollections(rc)["options"];
		if(arrayLen(optionsArray)){
			for(var i=1; i<=arraylen(optionsArray);i++) {
				if(len(trim(optionsArray[i].optionName))) {
					var option = getOptionService().getByID(optionsArray[i].optionID);
					option.setOptionName(optionsArray[i].optionName);
					option.setOptionID(optionsArray[i].optionID);
					option.setOptionCode(optionsArray[i].optionCode);
					option.setOptionDescription(optionsArray[i].optionDescription);
					if(optionsArray[i].optionImageFile != "") 
						saveImage(option,"options[#i#].optionImageFile",imageDir);
					if(option.isNew()){
						optionGroup.addOption(option);
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
		//writeDump(var=optiongroup,abort=true );
		optionGroup = getOptionService().save(entity=optionGroup);
		if(!optionGroup.hasErrors()) {
			variables.fw.redirect(action="admin:option.list");
		} else {
			rc.optionGroup=optionGroup;
			variables.fw.redirect("admin:option.optiongroupform","optionGroup");
		}
	}
	
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
				imageWrite(img,"#destination#/#imageName#");
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