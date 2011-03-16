component extends="slatwall.com.service.BaseService" accessors="true" {
	
	public any function save(required any entity, required struct imageUploadResult=structNew()) {
		if(!structIsEmpty(arguments.imageUploadResult)) {
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
		return Super.save(arguments.entity);
	}
	
	public void function delete(required any entity) {
		removeImage(arguments.entity);
		Super.delete(arguments.entity);
	}
	
	public any function removeImage(required any entity) {
		if(arguments.entity.hasImage() && getFileService().removeImage(arguments.entity.getImagePath())) {
			if(arguments.entity.getClassName() == "SlatwallOption") {
				arguments.entity.setOptionImage("");
			} else if(arguments.entity.getClassName() == "SlatwallOptionGroup") {
				arguments.entity.setOptionGroupImage("");
			}
		}
		return arguments.entity;
	}
	
	public void function saveOptionSort(required string optionIDs) {
		for(var i=1; i<=listlen(arguments.optionIDs);i++) {
			var optionID = listGetAt(arguments.optionIDs,i);
			var thisOption = getByID(optionID);
			thisOption.setSortOrder(i);
			save(thisOption);
		}
	}	
}