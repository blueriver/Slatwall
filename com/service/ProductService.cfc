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
component extends="BaseService" accessors="true" {
	
	// Slatwall Service Injection
	property name="skuDAO" type="any";
	property name="productTypeDAO" type="any";
	property name="dataService" type="any";  
	property name="contentService" type="any";
	property name="skuService" type="any";
	property name="utilityFileService" type="any";
	property name="utilityTagService" type="any";
	
	public any function getProductSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallProduct";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="productCode", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="productName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="productDescription", weight=1);
		
		smartList.joinRelatedProperty("SlatwallProduct","productType");
		smartList.joinRelatedProperty("SlatwallProduct","defaultSku");
		
		return smartList;
	}
	
	public any function getProductTypeSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallProductType";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="productTypeName", weight=6);
		smartList.addKeywordProperty(propertyIdentifier="productTypeDescription", weight=1);
		
		return smartList;
	}
	
	public any function getProductSkusBySelectedOptions(required string selectedOptions, required string productID){
		return getSkuDAO().getSkusBySelectedOptions(argumentCollection=arguments);
	}
	
	public void function saveAlternateImages(required any product, required array imagesArray) {
		for(var i = 1; i <= arrayLen(arguments.imagesArray); i++) {
			local.thisImageStruct = arguments.imagesArray[i];
			// check to see if this is a new image
			if(trim(local.thisImageStruct.imageID) != "") {
				local.thisImage = this.getProductImage(local.thisImageStruct.imageID);
				local.thisImage = Super.save(entity=local.thisImage, data=local.thisImageStruct);
			} else {
				if(structKeyExists(local.thisImageStruct, "productImageFile") && trim(local.thisImageStruct.productImageFile) != "") {
					local.thisImageUploadResult = fileUpload(getTempDirectory(),"images[#i#].productImageFile","","makeUnique");
					local.thisImage = addAlternateImage(local.thisImageUploadResult,arguments.product,local.thisImageStruct);
				}
			}
		}
	}
    
	public any function addAlternateImage(required struct imageUploadResult, required any product, required struct data) {
		var alternateImage = this.newProductImage();
		var imageDirectory = arguments.product.getAlternateImageDirectory();
		var imageExt = lcase(arguments.imageUploadResult.serverFileExt);
		alternateImage.setImageExtension(imageExt);
		arguments.product.addProductImage(alternateImage);
		alternateImage = Super.save(entity=alternateImage, data=arguments.data);
		if(!alternateImage.hasErrors()) {
			var imagePath = imageDirectory & alternateImage.getImageID() & "." & imageExt;
			var imageSaved = getService("imageService").saveImage(uploadResult=arguments.imageUploadResult,filePath=imagePath ,allowedExtensions="jpg,jpeg,png,gif");	
			if(!imageSaved) {
				// if there was an error with the file upload, we dont want to set an error because we want all valid image uploads and entity saving to proceed
				// but we remove the image entity that had the file error and set a flag in the request cache service
				arguments.product.removeProductImage(alternateImage);
				getDAO().delete(alternateImage);
				//getService("requestCacheService").setValue("uploadFileError", true);
			}
		} else {
			//delete file in the temp directory
			var uploadPath = imageUploadResult.serverDirectory & "/" & imageUploadResult.serverFile;
			fileDelete(uploadPath);
		}
		return alternateImage;
	}
	
	public boolean function removeAlternateImage(required any image,required any product) {
		arguments.product.removeProductImage(arguments.image);
		return getService("imageService").removeImage(arguments.image.getImagePath());
	}
	
	public any function saveProduct(required any product, required struct data) {
		
		// populate bean from values in the data Struct
		arguments.product.populate(arguments.data);
		
		// If this is a new product and it doesn't have any errors... there are a few additional steps we need to take
		if(arguments.product.isNew() && !arguments.product.hasErrors()) {
			
			// Create Skus
			getSkuService().createSkus(arguments.product, arguments.data);
			
			// if urlTitle wasn't set in bean, default it to the product's name.
			if(arguments.Product.getUrlTitle() == "") {
				arguments.Product.setUrlTitle(getService("utilityFileService").filterFileName(arguments.Product.getProductName()));
			}
			
			// make sure that the UrlTitle doesn't already exist, if it does then just rename with a number until it doesn't
			var lastAppended = 1;
			var uniqueUrlTitle = getDataService().isUniqueProperty(propertyName="urlTitle", entity=arguments.product);
			while(!uniqueUrlTitle) {
				arguments.Product.setUrlTitle(arguments.Product.getUrlTitle() & lastAppended);	
				uniqueUrlTitle = getDataService().isUniqueProperty(propertyName="urlTitle", entity=arguments.product);
				lastAppended += 1;
			}
		}
		
		// validate the product
		arguments.product.validate();
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.product.hasErrors()) {
        	arguments.product = getDAO().save(target=arguments.product);
        } else {
            getSlatwallScope().setORMHasErrors( true );
        }
        
        // Return the product
		return arguments.product;
	}
	
	public boolean function deleteProduct(required any product) {
	
		// Set the default sku temporarily in this local so we can reset if delete fails
		var defaultSku = arguments.product.getDefaultSku();
		
		// Remove the default sku so that we can delete this entity
		arguments.product.setDefaultSku(javaCast("null", ""));
	
		// Use the base delete method to check validation
		var deleteOK = super.delete(arguments.product);
		
		// If the delete failed, then we just reset the default sku into the product and return false
		if(!deleteOK) {
			arguments.product.setDefaultSku(defaultSku);
		
			return false;
		}
	
		return true;
	}
	
	//   Product Type Methods
	public any function saveProductType(required any productType, required struct data) {
		
		arguments.productType.populate(data=arguments.data);

		arguments.productType.validate();

		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
		
		if( !arguments.productType.hasErrors() ) {
			// Call entitySave on the productType 
			getDAO().save(target=arguments.productType);
		} else {
            getSlatwallScope().setORMHasErrors( true );
        }
		
		return arguments.productType;
	}
	
	/* get the attribute sets for a product */
	public array function getAttributeSets(array attributeSetTypeCode,array productTypeIDs = []){
		return getDAO().getAttributeSets(arguments.attributeSetTypeCode, arguments.productTypeIDs);
	}
	
	public void function loadDataFromFile(required string fileURL, string textQualifier = ""){
		getUtilityTagService().cfSetting(requesttimeout="3600"); 
		getDAO().loadDataFromFile(arguments.fileURL,arguments.textQualifier);
	}
	
	public boolean function getProductIsOnTransaction(required any product) {
		return getDAO().getProductIsOnTransaction(product=arguments.product);
	}
	
	public any function processProduct(required any product, struct data={}, string processContext="process") {
		
		var skus = 	arguments.product.getSkus();
		
		for(i=1; i <= arrayLen(skus); i++){
			skus[i].setPrice(arguments.data.skuPrice);
		}
	}
}
