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
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="SkuService" type="any";  
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	property name="feedManager" type="any";
	property name="ProductTypeTree" type="any";
	
	public any function init(required any productTypeDAO) {
		//TODO: look at changing it to property injection through coldspring
		setproductTypeDAO(arguments.productTypeDAO);
		setProductTypeTree();
		
		return this;
	}
		
	public any function getProductTemplates() {
		return getSettingsManager().getSite(session.siteid).getTemplates();
	}
	
	public any function getContentFeed() {
		return getFeedManager().getBean();
	}
	
	public any function getProductPages() {
		return getContentFeed().set({ siteID=$.event("siteID"),sortBy="title",sortDirection="asc" }).getIterator();
	}

	/**
	/* @hint associates this product with Mura content objects
	*/
	public void function assignProductContent(required any product,required string contentID) {
		var productContentArray = [];
		getDAO().clearProductContent(arguments.product);
		for(var i=1;i<=listLen(arguments.contentID);i++) {
			local.thisContentID = listGetAt(arguments.contentID,i);
			local.thisProductContent = entityNew("SlatwallProductContent",{contentID=local.thisContentID});
			arrayAppend(productContentArray,local.thisProductContent);
		}
		arguments.product.setProductContent(productContentArray);
	}
	
	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice) {
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
			createSkus(arguments.Product,arguments.data.optionsStruct,arguments.data.price,arguments.data.listPrice);
		} else {
			updateSkus(arguments.Product,arguments.data.skuArray);
		}
		
		// set Default sku
		if( structKeyExists(arguments.data,"defaultSku") && len(arguments.data.defaultSku) ) {
			var dSku = arguments.Product.getSkuByID(arguments.data.defaultSku);
			if(!dSku.getIsDefault()) {
				dSku.setIsDefault(true);
			}
		}
		
		// set up associations between product and content
		assignProductContent(arguments.Product,arguments.data.contentID);
		
		arguments.Product = Super.save(arguments.Product);
		
		return arguments.Product;
	}
	
	public any function getProductContentSmartList(required struct rc, required string contentID) {
		return getDAO().getProductContentSmartList(rc=arguments.rc, entityName=getEntityName(), contentID=arguments.contentID);
	}
	
	//   Product Type Methods
	
    public void function setProductTypeTree() {
        variables.productTypeTree = getProductTypeDAO().getProductTypeTree();
    }
	
	public any function saveProductType(required any productType, required struct data) {
		
		arguments.productType.populate(data=arguments.data);
		
		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
	   var entity = Super.save(arguments.productType);
	   return entity;
	}
	
	public any function deleteProductType(required any productType) {
		if( arguments.productType.hasProduct() || arguments.productType.hasSubProductType() ) {
			getValidator().setError(entity=arguments.productType,errorName="delete",rule="isAssigned");
		}
		var deleted = Super.delete(arguments.productType);
		return deleted;
	}
	
	/**
	* @hint recursively looks through the cached product type tree query to the the first non-empty value in the type lineage, or returns empty string if it wasn't set
	*/
	public any function getProductTypeSetting( required string productType,required string setting ) {
		var ptTree = getProductTypeTree();
		// use q of q to get the setting, looking up the lineage of the product type tree if an empty string is encountered
		var qoq = new Query();
		qoq.setAttributes(ptTable = ptTree);
		qoq.setSQL("select #arguments.setting#, path from ptTable where lower(productTypeName) = :ptype");
		qoq.addParam(name="ptype", value=lcase(arguments.productType), cfsqlType="cf_sql_varchar");
		var qGetSetting = qoq.execute(dbtype="query").getResult();
		if(qGetSetting.recordCount == 1) {
			local.theValue = evaluate("qGetSetting.#arguments.setting#");
			if(local.theValue != "") {
				return local.theValue;
			} else if(local.theValue == "" && lcase(qGetSetting.path) != lcase(arguments.productType)) {
				// gets the next product type up in the lineage and calls this function recursively
				local.parentProductType = listGetAt(qGetSetting.path,listLen(qGetSetting.path)-1);
				return getProductTypeSetting( productType=local.parentProductType,setting=arguments.setting );
			} else {
				return "";
			}
		}
		else return "";
	}
	
}
