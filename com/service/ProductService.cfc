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
	property name="ProductTypeDAO" type="any";
	property name="SkuService" type="any";  
	property name="ProductTypeTree" type="any";
	
	// Mura Service Injection
	property name="contentManager" type="any";
	property name="feedManager" type="any";
		
	public any function getProductTemplates(required string siteID) {
		var productTemplatesID = getContentManager().getActiveContentByFilename(filename="product-templates", siteid=arguments.siteid).getContentID();
		return getContentManager().getNest(parentID=productTemplatesID, siteid=arguments.siteid);
	}
	
	public any function getContentFeed() {
		return getFeedManager().getBean();
	}
	
	public any function getProductPages(returnFormat="iterator") {
		var pageFeed = getContentFeed().set({ siteID=$.event("siteID"),sortBy="title",sortDirection="asc" });
		
		pageFeed.addParam( relationship="AND", field="tcontent.subType", criteria="SlatwallProductListing", dataType="varchar" );
		
		if( arguments.returnFormat == "iterator" ) {
			return pageFeed.getIterator();
		} else if( arguments.returnFormat == "query" ) {
			return pageFeed.getQuery();
		} else if( arguments.returnFormat == "nestedIterator" ) {
			return $.getBean("contentIterator").setQuery(treeSort(pageFeed.getQuery()));
		}
		
	}

	public any function getProductSmartList(struct data={}) {
		arguments.entityName = "SlatwallProduct";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		smartList.addKeywordProperty(propertyIdentifier="productCode", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="productName", weight=3);
		smartList.addKeywordProperty(propertyIdentifier="productDescription", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="brand_brandName", weight=3);
		
		smartList.joinRelatedProperty("SlatwallProduct","productType");
		
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
	
	public any function getProductSkuBySelectedOptions(required string selectedOptions,required string productID){
		return getSkuDAO().getSkusBySelectedOptions(argumentCollection=arguments)[1];
	}

	/**
	/* @hint associates this product with Mura content objects
	*/
	public void function assignProductContent(required any product,required string contentID) {
		var productContentArray = [];
		getDAO().clearProductContent(arguments.product);
		for(var i=1;i<=listLen(arguments.contentID);i++) {
			local.thisContentID = listGetAt(arguments.contentID,i);
			local.thisProductContent = entityNew("SlatwallProductContent",{contentID=listLast(local.thisContentID," "),contentPath=listChangeDelims(local.thisContentID,","," ")});
			arrayAppend(productContentArray,local.thisProductContent);
		}
		arguments.product.setProductContent(productContentArray);
	}
	
	public void function updateProductContentPaths(required string contentID) {
		var pcArray = getDAO().list(entityName="SlatwallProductContent");
		for( var i=1; i<=arrayLen(pcArray); i++) {
			local.thisPC = pcArray[i];
			if( listContains(local.thisPC.getContentPath(),arguments.contentID) ) {
				var newPath = getContentManager().read(contentID=local.thisPC.getContentID(),siteID=$.event("siteID")).getPath();
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
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice, required shippingWeight) {
		return getSkuService().createSkus(argumentCollection=arguments);
	}
	
    /**
    /* @hint updates Sku data on product edit
    */
    public boolean function updateSkus(required any product, required array skus) {
        return getSkuService().updateSkus(argumentCollection=arguments);
    }
	
	public any function save(required any Product,required struct data) {
		// populate bean from values in the data Struct
		arguments.Product.populate(arguments.data);
		
		// if filename wasn't set in bean, default it to the product's name.
		if(arguments.Product.getFileName() == "") {
			arguments.Product.setFileName(getFileService().filterFileName(arguments.Product.getProductName()));
		}
		
		// set up sku(s) if this is a new product
		if(arguments.Product.isNew()) {
			createSkus(arguments.Product,arguments.data.optionsStruct,arguments.data.price,arguments.data.listPrice,arguments.data.shippingWeight);
		} else {
			updateSkus(arguments.Product,arguments.data.skuArray);
		}
		
		// set up associations between product and content
		assignProductContent(arguments.Product,arguments.data.contentID);
		
		// make sure that the product code doesn't already exist
		if( len(data.productCode) ) {
			var checkProductCode = getDAO().isDuplicateProperty("productCode", arguments.product);
			var productCodeError = getValidationService().validateValue(rule="assertFalse",objectValue=checkProductCode,objectName="productCode",message=rbKey("entity.product.productCode_validateUnique"));
			if( !structIsEmpty(productCodeError) ) {
				arguments.product.addError(argumentCollection=productCodeError);
			}
		}
		
		// make sure that the filename (product URL title) doesn't already exist
		var checkFilename = getDAO().isDuplicateProperty("filename", arguments.product);
		var filenameError = getValidationService().validateValue(rule="assertFalse",objectValue=checkFilename,objectName="filename",message=rbKey("entity.product.filename_validateUnique"));
		if( !structIsEmpty(filenameError) ) {
			arguments.product.addError(argumentCollection=filenameError);
		}
		
		arguments.Product = Super.save(arguments.Product);
		
		if( !arguments.Product.hasErrors() ) {
			// clear cached product type tree so that it's refreshed on the next request
	   		clearProductTypeTree();
		}
		
		return arguments.Product;
	}
	
	public any function delete( required any product ) {
		// make sure this product isn't in the order history
		if( arguments.product.getOrderedFlag() ) {
			getValidationService().setError(entity=arguments.product,errorName="delete",rule="Ordered");
		}
		var deleteResponse = Super.delete( arguments.product );
		if( !deleteResponse.hasErrors() ) {
			// clear cached product type tree so that it's refreshed on the next request
	   		clearProductTypeTree();
		}
		return deleteResponse;
	}

	//   Product Type Methods
	public void function setProductTypeTree() {
    	var qProductTypes = getProductTypeDAO().getProductTypeQuery();
    	var productTypeTree = getService("utilities").queryTreeSort(
    		theQuery = qProductTypes,
    		itemID = "productTypeID",
    		parentID = "parentProductTypeID",
    		pathColumn = "productTypeName"
    	);
        variables.productTypeTree = productTypeTree;
    }
    
    public any function getProductTypeTree() {
    	if( !structKeyExists(variables, "productTypeTree") ) {
    		setProductTypeTree();
    	}
    	return variables.productTypeTree; 
    }
    
    public any function getProductTypeFromTree(string productTypeID) {
		var productTypeTree = getProductTypeTree();
		var productType = new Query();
		productType.setAttributes(productTypeTable = productTypeTree);
		productType.setSQL("select * from productTypeTable where productTypeID = :productTypeID");
		productType.addParam(name="productTypeID", value=arguments.productTypeID, cfsqlType="cf_sql_varchar");
		productType = productType.execute(dbtype="query").getResult();
    	return productType; 
    }
    
    public void function clearProductTypeTree() {
    	structDelete(variables,"productTypeTree");
    }
	
	public any function saveProductType(required any productType, required struct data) {
		
		arguments.productType.populate(data=arguments.data);
		
		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
	   var entity = Super.save(arguments.productType);
	   if( !entity.hasErrors() ) {
	   		// clear cached product type tree so that it's refreshed on the next request
	   		clearProductTypeTree();
	   }
	   return entity;
	}
	
	public any function deleteProductType(required any productType) {
		if( arguments.productType.hasProduct() || arguments.productType.hasSubProductType() ) {
			getValidationService().setError(entity=arguments.productType,errorName="delete",rule="isAssigned");
		}
		if( !arguments.productType.hasErrors() ) {
	   		// clear cached product type tree so that it's refreshed on the next request
	   		clearProductTypeTree();
	   }
		var deleted = Super.delete(arguments.productType);
		return deleted;
	}
	
	/**
	* @hint recursively looks through the cached product type tree query to the the first non-empty value in the type lineage, or returns empty record if it wasn't set
	*/
	public any function getProductTypeRecordWhereSettingDefined( required string productTypeID,required string settingName ) {
		var ptTree = getProductTypeTree();
		// use q of q to get the setting, looking up the lineage of the product type tree if an empty string is encountered
		var qoq = new Query();
		qoq.setAttributes(ptTable = ptTree);
		qoq.setSQL("select productTypeName, productTypeID, productTypeNamePath, #arguments.settingName#, idpath from ptTable where productTypeID = :ptypeID");
		qoq.addParam(name="ptypeID", value=arguments.productTypeID, cfsqlType="cf_sql_varchar");
		var qGetSetting = qoq.execute(dbtype="query").getResult();
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
    	var productPagesTree = getService("utilities").queryTreeSort(
    		theQuery = arguments.productPages,
    		itemID = "contentID",
    		parentID = "parentID",
    		pathColumn = "menuTitle"
    	);
		return productPagesTree;
	}
}
