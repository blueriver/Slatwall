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
	property name="skuService" type="any";
	property name="dataService" type="any";  
	property name="utilityFileService" type="any";
	property name="utilityTagService" type="any";
	
	// Mura Service Injection
	property name="categoryManager" type="any";
	property name="contentManager" type="any";
	property name="feedManager" type="any";
	
	// Cached Properties
	property name="productTypeTree" type="any";
	
	public any function getProductTemplates(required string siteID) {
		
		var pageFeed = getContentFeed().set({ siteID=arguments.siteID,sortBy="title",sortDirection="asc",maxItems=0,showNavOnly=0 });
		pageFeed.addParam( relationship="AND", field="tcontent.subType", criteria="SlatwallProductTemplate", dataType="varchar" );
		
		return pageFeed.getQuery();
	}
	
	public any function getContentFeed() {
		return getFeedManager().getBean();
	}
	
	public any function getProductPages(required string siteID, string returnFormat="iterator") {
		var pageFeed = getContentFeed().set({ siteID=arguments.siteID,sortBy="title",sortDirection="asc",maxItems=0,showNavOnly=0 });
		
		pageFeed.addParam( relationship="AND", field="tcontent.subType", criteria="SlatwallProductListing", dataType="varchar" );
		
		if( arguments.returnFormat == "iterator" ) {
			return pageFeed.getIterator();
		} else if( arguments.returnFormat == "query" ) {
			return pageFeed.getQuery();
		} else if( arguments.returnFormat == "nestedIterator" ) {
			return application.serviceFactory.getBean("contentIterator").setQuery(treeSort(pageFeed.getQuery()));
		}
		
	}

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
		smartList.addKeywordProperty(propertyIdentifier="brand_brandName", weight=3);
		
		smartList.joinRelatedProperty("SlatwallProduct","productType");
		
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
	
	public any function getProductContentSmartList(required string contentID, struct data={}, currentURL="") {
		var smartList = getDAO().getSmartList(entityName="SlatwallProduct", data=arguments.data, currentURL=arguments.currentURL);
		
		if( structKeyExists(arguments.data, "showSubPageProducts") && arguments.data.showSubPageProducts) {
			smartList.addLikeFilter(propertyIdentifier="productContent_contentPath", value="%#arguments.contentID#%");
		} else {
			smartList.addFilter(propertyIdentifier="productContent_contentID", value=arguments.contentID);	
		}
		
		smartList.addKeywordProperty(propertyIdentifier="productCode", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="productName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="productDescription", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="brand_brandName", weight=3);
		
		smartList.joinRelatedProperty("SlatwallProduct","defaultSku");
		
		return smartList;	
	}
	
	public any function getProductSkusBySelectedOptions(required string selectedOptions, required string productID){
		return getSkuDAO().getSkusBySelectedOptions(argumentCollection=arguments);
	}
	
	public any function getMuraCategories(required string siteID, string parentID=0) {
		var categories = getCategoryManager().getCategoriesBySiteID(siteID=arguments.siteID);
    	var categoryTree = getService("utilityService").queryTreeSort(
    		theQuery = categories,
    		itemID = "categoryID",
    		parentID = "parentID",
    		pathColumn = "name",
    		rootID = "#arguments.parentID#"
    	);
    	return categoryTree;
	}

	public void function updateProductContentPaths(required string contentID, required string siteID) {
		var pcArray = getDAO().list(entityName="SlatwallProductContent");
		for( var i=1; i<=arrayLen(pcArray); i++) {
			local.thisPC = pcArray[i];
			if( listContains(local.thisPC.getContentPath(),arguments.contentID) ) {
				var newPath = getContentManager().read(contentID=local.thisPC.getContentID(),siteID=arguments.siteID).getPath();
				local.thisPC.setContentPath(newPath);
			}
		} 
	}
	
	public void function deleteProductContent(required string contentID) {
		var pcArray = getDAO().list(entityName="SlatwallProductContent");
		for( var i=1; i<=arrayLen(pcArray); i++ ) {
			local.thisPC = pcArray[i];
			if( listContains(local.thisPC.getContentPath(),arguments.contentID) ) {
				// when mura content is deleted, so is all content nested underneath, so we delete all productContent records in which we find the passed in content ID in the content path
				getDAO().delete(local.thisPC);
			}
		}
	}

	/**
	/* @hint associates this product with Mura categories
	*/
	public void function assignProductCategories(required any product,required string categoryID,string featuredCategories) {
		for(var i=1;i<=listLen(arguments.categoryID);i++) {
			local.isFeatured = false;
			local.thisCategoryID = listGetAt(arguments.categoryID,i);
			if(listFindNoCase(arguments.featuredCategories,listLast(local.thisCategoryID," "))) {
				local.isFeatured = true;
			}
			local.thisProductCategory = this.newSlatwallProductCategory({categoryID=listLast(local.thisCategoryID," "),categoryPath=listChangeDelims(local.thisCategoryID,","," "),featuredFlag=local.isFeatured});
			arguments.product.addProductCategory(local.thisProductCategory);
		}
	}

	public void function updateProductCategoryPaths(required string categoryID, required string siteID) {
		var pcategoryArray = getDAO().list(entityName="SlatwallProductCategory");
		for( var i=1; i<=arrayLen(pcategoryArray); i++) {
			local.thisPC = pcategoryArray[i];
			if( listContains(local.thisPC.getCategoryPath(),arguments.categoryID) ) {
				var newPath = getCategoryManager().read(categoryID=local.thisPC.getCategoryID(),siteID=arguments.siteID).getPath();
				// this is just temporary until the Mura bug is fixed which puts single quotes around the categoryID's in the path
				newPath = cleanPath(newPath);
				local.thisPC.setCategoryPath(newPath);
			}
		} 
	}

	// this is only here to get around a Mura bug for now (see above)
	private string function cleanPath (string path) {
		var cleanedPath = "";
		for(var i = 1; i<=listLen(arguments.path);i++) {
			local.thisID = listGetAt(arguments.path,i);
			local.thisID = replace(local.thisID,"'","","all");
			cleanedPath = listAppend(cleanedPath,local.thisID);
		}
		return cleanedPath;
	}
	
	public void function deleteProductCategory(required string categoryID) {
		var pcategoryArray = getDAO().list(entityName="SlatwallProductCategory");
		for( var i=1; i<=arrayLen(pcategoryArray); i++ ) {
			local.thisPC = pcategoryArray[i];
			if( listLast(local.thisPC.getCategoryPath()) == arguments.categoryID ) {
				// if the last element in the path is the same as the ID, the category assigned is the one being deleted, so delete association
				getDAO().delete(local.thisPC);
			} else if( listFindNoCase(local.thisPC.getCategoryPath(),arguments.categoryID) ) {
				local.thisPath = local.thisPC.getCategoryPath();
				local.newPath = listDeleteAt(local.thisPath,listFind(local.thisPath,arguments.categoryID));
				local.thisPC.setCategoryPath(local.newPath);
			}
		}
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
			var imageSaved = getService("utilityFileService").saveImage(uploadResult=arguments.imageUploadResult,filePath=imagePath ,allowedExtensions="jpg,jpeg,png,gif");	
			if(!imageSaved) {
				// if there was an error with the file upload, we dont want to set an error because we want all valid image uploads and entity saving to proceed
				// but we remove the image entity that had the file error and set a flag in the request cache service
				arguments.product.removeProductImage(alternateImage);
				getDAO().delete(alternateImage);
				getService("requestCacheService").setValue("uploadFileError",true);
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
		return getService("utilityFileService").removeImage(arguments.image.getImagePath());
	}
	
	public any function saveProduct(required any product, required struct data) {
		
		// populate bean from values in the data Struct
		arguments.product.populate(arguments.data);
		
		// populate custom attributes
		if(structKeyExists(arguments.data,"attribute")){
			for(var attributeID in arguments.data.attribute){
				for(var attributeValueID in arguments.data.attribute[attributeID]){
					var attributeValue = getService("AttributeService").getProductAttributeValue(attributeValueID, true);
					attributeValue.setAttributeValue(arguments.data.attribute[attributeID][attributeValueID]);
					if(attributeValue.isNew()){
						var attribute = getService("AttributeService").getAttribute(attributeID);
						attributeValue.setAttribute(attribute);
						arguments.product.addAttribtueValue(attributeValue);
					}
				}
			}
		}
		
		// if weight and/or prices (values passed on to populate SKU entities) are blank or not numeric, default them to zero
		if(!isNumeric(arguments.data.price) || len(trim(arguments.data.price)) == 0) {
			arguments.data.price = 0;
		}
				
		// set up sku(s) if this is a new product
		if(arguments.product.isNew()) {

			var optionsStruct = {};
			if(structKeyExists(arguments.data, "options")) {
				optionsStruct = arguments.data.options;
			}
			
			getSkuService().createSkus(arguments.Product,optionsStruct,arguments.data.price);
		}
		
		// set up associations between product and content
		if(structKeyExists(arguments.data, "productContentIDPaths")) {
			
			// Remove Existing product Content
			for(var i=arrayLen(arguments.product.getProductContent()); i >= 1; i--) {
				arguments.product.getProductContent()[i].removeProduct();
			}
			
			// Assign all new product Content
			for(var i=1; i<=listLen(arguments.data.productContentIDPaths); i++) {
				var thisPath = listGetAt(arguments.data.productContentIDPaths, i);
				var thisProductContent = this.newProductContent();
				thisProductContent.setProduct(arguments.product);
				thisProductContent.setContentID(listLast(thisPath, " "));
				thisProductContent.setContentPath(listChangeDelims(thisPath,","," "));
			}
		}
		
		// set up associations between product and mura categories
		/*		
		if(structKeyExists(arguments.data, "categoryID")) {
			assignProductCategories(arguments.Product,arguments.data.categoryID,arguments.data.featuredCategories);
		}
		*/
		
		// check for images to upload
		if(structKeyExists(arguments.data,"images")) {
			saveAlternateImages(arguments.Product,arguments.data.images);
		}
		
		// if filename wasn't set in bean, default it to the product's name.
		if(arguments.Product.getFileName() == "") {
			arguments.Product.setFileName(getService("utilityFileService").filterFileName(arguments.Product.getProductName()));
		}
		
		// make sure that the filename (product URL title) doesn't already exist, if it does then just rename with a number until it doesn't
		var lastAppended = 1;
		var uniqueFilename = getDataService().isUniqueProperty(propertyName="filename", entity=arguments.product);
		while(!uniqueFilename) {
			arguments.Product.setFileName(arguments.Product.getFileName() & lastAppended);	
			uniqueFilename = getDataService().isUniqueProperty(propertyName="filename", entity=arguments.product);
			lastAppended += 1;
		}
				
		// validate the product
		arguments.product.validate();
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.product.hasErrors()) {
        	clearProductTypeTree();
            arguments.product = getDAO().save(target=arguments.product);
        } else {
            getService("requestCacheService").setValue("ormHasErrors", true);
        }
        
        // Return the product
		return arguments.product;
	}
	
	public boolean function deleteProduct( required any product ) {
		
		// Set the default sku temporarily in this local so we can reset if delete fails
		var defaultSku = arguments.product.getDefaultSku();
		
		// Remove the default sku so that we can delete this entity
		arguments.product.setDefaultSku(javaCast("null",""));
		
		// Use the base delete method to check validation
		var deleteOK = super.delete( arguments.product );
		
		// If the delete failed, then we just reset the default sku into the product and return false
		if( !deleteOK ) {
			arguments.product.setDefaultSku(defaultSku);
			
			return false;
		}
		
		return true;
	}
	
	public boolean function deleteProductType(required any productType) {
		
		// Use the base delete method to check validation
		var deleteOK = super.delete(arguments.productType);
		
		if( deleteOK ) {
	   		// clear cached product type tree so that it's refreshed on the next request
	   		clearProductTypeTree();
	   	}
		
		return deleteOK;
	}

	//   Product Type Methods
	public void function setProductTypeTree() {
    	var qProductTypes = getProductTypeDAO().getProductTypeQuery();
    	var productTypeTree = getService("utilityService").queryTreeSort(
    		theQuery = qProductTypes,
    		itemID = "productTypeID",
    		parentID = "parentProductTypeID",
    		pathColumn = "productTypeName"
    	);
        variables.productTypeTree = productTypeTree;
    }
    
    public any function getProductTypeTree(string format="query") {
    	if( !structKeyExists(variables, "productTypeTree") ) {
    		setProductTypeTree();
    	}
    	var treeParams = {theQuery = variables.productTypeTree,displayColumn = "productTypeName"};
    	if(arguments.format == "query") {    		
	    	return variables.productTypeTree; 
    	} else if (arguments.format == "list") {
    		return getService("utilityService").htmlListFromQueryTree(argumentCollection=treeParams);
    	} else if (arguments.format == "struct") {
     		return getService("utilityService").structFromQueryTree(argumentCollection=treeParams);   		
    	}
    }
    
    public string function getJsonProductTypeTree() {
    	return getProductTypeTree("json");
    }
    
    public any function getProductTypeFromTree(string productTypeID) {
		var productType = new Query();
		productType.setAttributes(productTypeTree = getProductTypeTree());
		productType.setSQL("select * from productTypeTree where productTypeID = :productTypeID");
		productType.setDBType("query");
		productType.addParam(name="productTypeID", value=arguments.productTypeID, cfsqlType="cf_sql_varchar");
		productType = productType.execute().getResult();
    	return productType; 
    }
    
    public void function clearProductTypeTree() {
    	structDelete(variables,"productTypeTree");
    }
	
	public any function saveProductType(required any productType, required struct data) {
		
		arguments.productType.populate(data=arguments.data);

		// set attributeSetAssignemnts
		// remove the ones not selected, loop in reverse to prevent shifting of array items
    	var attributeSetAssignmentCount = arrayLen(arguments.productType.getAttributeSetAssignments());
    	for(var i = attributeSetAssignmentCount; i > 0; i--){
    		var attributeSetAssignment = arguments.productType.getAttributeSetAssignments()[i];
    		if(structKeyExists(data,"attributeSetIDs") && listFindNoCase(data.attributeSetIDs,attributeSetAssignment.getAttributeSet().getAttributeSetID()) == 0){
    			arguments.productType.removeAttributeSetAssignment(attributeSetAssignment);
    		}
    	}
    	// Add new ones
    	if(structKeyExists(data,"attributeSetIDs")){
    		var attributeSetIDArray = listToArray(data.attributeSetIDs);
    		for(var attributeSetID in attributeSetIDArray){
    			var dataStruct = {"F:attributeSet_attributeSetID"=attributeSetID,"F:productType_productTypeID"=arguments.productType.getProductTypeID()};
    			var attributeSetAssignmentArray = getDAO().getSmartList(entityName="SlatwallProductTypeAttributeSetAssignment",data=dataStruct).getRecords();
    			if(!arrayLen(attributeSetAssignmentArray)){
	    			var attributeSetAssignment = getService("AttributeService").newProductTypeAttributeSetAssignment();
	    			var attributeSet = getService("AttributeService").getAttributeSet(attributeSetID);
	    			attributeSetAssignment.setProductType(arguments.productType);
	    			attributeSetAssignment.setAttributeSet(attributeSet);
	    			arguments.productType.addAttributeSetAssignment(attributeSetAssignment);
    			}
    		}
    	}
    	
		arguments.productType.validate();

		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
		
		if( !arguments.productType.hasErrors() ) {
			// clear cached product type tree so that it's refreshed on the next request
			clearProductTypeTree();
			
			// Call entitySave on the productType 
			getDAO().save(target=arguments.productType);
		}
		
		return arguments.productType;
	}
	
	
	/**
	* @hint recursively looks through the cached product type tree query to the the first non-empty value in the type lineage, or returns empty record if it wasn't set
	*/
	public any function getProductTypeRecordWhereSettingDefined( required string productTypeID,required string settingName ) {
		// use q of q to get the setting, looking up the lineage of the product type tree if an empty string is encountered
		var qoq = new Query();
		qoq.setAttributes(ptTable = getProductTypeTree());
		qoq.setSQL("select productTypeName, productTypeID, productTypeNamePath, #arguments.settingName#, idpath from ptTable where productTypeID = :ptypeID");
		qoq.setDBType("query");
		qoq.addParam(name="ptypeID", value=arguments.productTypeID, cfsqlType="cf_sql_varchar");
		var qGetSetting = qoq.execute().getResult();
		if(qGetSetting.recordCount == 1) {
			local.settingValue = qGetSetting[arguments.settingName];
			if(local.settingValue != "") {
				return qGetSetting;
			} else if(local.settingValue == "" && lcase(qGetSetting.idpath) != lcase(arguments.productTypeID)) {
				// gets the next product type up in the lineage and calls this function recursively
				local.parentProductTypeID = listGetAt(qGetSetting.idpath,listLen(qGetSetting.idpath)-1);
				return getProductTypeRecordWhereSettingDefined( productTypeID=local.parentProductTypeID,settingName=arguments.settingName );
			} else {
				return queryNew("productTypeID");
			}
		}
		else return queryNew("productTypeID");
	}
	
	public any function getProductTypeSetting( required string productTypeID, required string settingName ) {
		var productTypeRecord = getProductTypeRecordWhereSettingDefined(argumentCollection=arguments);
		if( productTypeRecord.recordCount == 1 ) {
			return productTypeRecord[arguments.settingName][1];
		} else {
			return "";
		}
	}
	
	public any function getWhereSettingDefined( required string productTypeID, required string settingName ) {
		var productTypeRecord = getProductTypeRecordWhereSettingDefined(argumentCollection=arguments);
		if( productTypeRecord.recordCount == 1 ) {
			return {
				type = "Product Type",
				name = productTypeRecord.productTypeName,
				id = productTypeRecord.productTypeID
			};
		} else {
			return {
				type = "Global",
				name = "Global"
			};
		}		
	}

	public string function getParentProductTypeIDs(string productTypeID) {
		var qoq = new Query();
		qoq.setAttributes(ptTable = getProductTypeTree());
		qoq.setSQL("select idPath from ptTable where productTypeID = :ptypeID");
		qoq.setDBType("query");
		qoq.addParam(name="ptypeID", value=arguments.productTypeID, cfsqlType="cf_sql_varchar");
		var qGetIDPath = qoq.execute().getResult();
		if(qGetIDPath.recordCount == 1) {
			return qGetIDPath.idPath[1];
		} else {
			return "";
		}
	}
	
	public string function getChildProductTypeIDs(string productTypeID) {
		var qoq = new Query();
		qoq.setAttributes(ptTable = getProductTypeTree());
		qoq.setSQL("select productTypeID from ptTable where idPath like :ptypeID");
		qoq.setDBType("query");
		qoq.addParam(name="ptypeID", value="%#arguments.productTypeID#%", cfsqlType="cf_sql_varchar");
		var qGetChildIDs = qoq.execute().getResult();
		if(qGetChildIDs.recordCount > 0) {
			return valueList(qGetChildIDs.productTypeID);
		} else {
			return "";
		}
	}
	
	public any function searchProductsByProductType(string term,string productTypeID) {
		var productTypeIDs = getChildProductTypeIDs(arguments.productTypeID);
		return getDAO().searchProductsByProductType(arguments.term,productTypeIDs);
	}	

	private query function treeSort(required query productPages) {
		// loop through query and construct an array of parent IDs from the 'path' column
		var parentIDArray = [];
		for( var i=1; i <= arguments.productPages.recordCount; i++ ) {
			local.path = arguments.productPages.path[i];
			local.parentID = listLen( local.path ) > 1 ? listGetAt( local.path, listLen(local.path) -1 ) : 0;
			parentIDArray[i] = local.parentID;
		}
		// add column of parentIDs to query so we can treeSort it
		queryAddColumn(arguments.productPages, "parentID", "VarChar", parentIDArray );
    	var productPagesTree = getService("utilityService").queryTreeSort(
    		theQuery = arguments.productPages,
    		itemID = "contentID",
    		parentID = "parentID",
    		pathColumn = "menuTitle"
    	);
		return productPagesTree;
	}

	/* get the attribute sets for a product */
	public array function getAttributeSets(array attributeSetTypeCode,array productTypeIDs = []){
		return getDAO().getAttributeSets(arguments.attributeSetTypeCode,arguments.productTypeIDs);
	}
	
	public void function loadDataFromFile(required string fileURL, string textQualifier = ""){
		getUtilityTagService().cfSetting(requesttimeout="3600"); 
		getDAO().loadDataFromFile(arguments.fileURL,arguments.textQualifier);
	}
	
	public any function addProductReview(required struct data) {
		var newReview = this.newProductReview();
		return this.saveProductReview(newReview, arguments.data);
	}
	
}
