component extends="slatwall.com.service.BaseService" accessors="true" {
	
	public any function save(required any entity, required struct data) {	
		arguments.entity.populate(arguments.data);
		arguments.entity = Super.save(arguments.entity);
		
		if(!arguments.entity.hasErrors()) {
			// remove image if option is checked (unless a new image is set, in which case the old image is removed by processUpload
			if(structKeyExists(arguments.data,"removeImage") and arguments.entity.hasImage() and !structKeyExists(arguments.data,"imageUploadResult")) {
				removeImage(arguments.entity);
			}
			// process image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				processImageUpload(arguments.entity,arguments.data.imageUploadResult);
			} 
		} else {
			transactionRollback();
			// delete image if one was uploaded
			if(structKeyExists(arguments.data,"imageUploadResult")) {
				var result = arguments.data.imageUploadResult;
				var uploadPath = result.serverDirectory & "/" & result.serverFile;
				fileDelete(uploadPath);
			} 
		}
		return arguments.entity;
	}
	
	public boolean function delete(required any option) {
		if(arguments.option.hasSkus()) {
			getValidator().setError(entity=arguments.option,errorName="delete",rule="hasSkus");
		} else {
			removeImage(arguments.option);
		}
		return Super.delete(arguments.option);
	}
	
	public boolean function deleteOptionGroup(required any optionGroup) {
		if(arguments.optionGroup.hasOptions()) {
			getValidator().setError(entity=arguments.optionGroup,errorName="delete",rule="hasOptions");
		} else {
			removeImage(arguments.optionGroup);
		}
		return Super.delete(arguments.optionGroup);
	}
	
	public any function removeImage(required any entity) {
		if(arguments.entity.hasImage() && getFileService().removeImage(arguments.entity.getImagePath())) {
			if(arguments.entity.getClassName() == "SlatwallOption") {
				arguments.entity.setOptionImage(javacast('NULL', ''));
			} else if(arguments.entity.getClassName() == "SlatwallOptionGroup") {
				arguments.entity.setOptionGroupImage(javacast('NULL', ''));
			}
		}
		return arguments.entity;
	}
	
	public void function saveOptionSort(required string optionIDs) {
		for(var i=1; i<=listlen(arguments.optionIDs);i++) {
			var optionID = listGetAt(arguments.optionIDs,i);
			var thisOption = getByID(optionID);
			thisOption.setSortOrder(i);
			//save(thisOption);
		}
	}
	
	private void function processImageUpload(required any entity, required struct imageUploadResult) {
		var imageName = createUUID() & "." & arguments.imageUploadResult.serverFileExt;
		var filePath = arguments.entity.getImageDirectory() & imageName;
		var imageSaved = getFileService().saveImage(uploadResult=arguments.imageUploadResult,filePath=filePath);
		if(imageSaved) {
			// if this was a new image where a pre-existing one existed for this object, delete the old image
			if(arguments.entity.hasImage()) {
				removeImage(arguments.entity);
			}
			if(arguments.entity.getClassName() == "SlatwallOption") {
				arguments.entity.setOptionImage(imageName);
			} else if(arguments.entity.getClassName() == "SlatwallOptionGroup") {
				arguments.entity.setOptionGroupImage(imageName);
			}
		} else {
			// set error in the option group object
			var errorName = arguments.entity.getClassName() == "SlatwallOption" ? "optionImage" : "optionGroupImage";
			getValidator().setError(entity=arguments.entity,errorName=errorName,rule="imageFile");
		}	
	}	
}