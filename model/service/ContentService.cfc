/*

    Slatwall - An Open Source eCommerce Platform
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
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="contentDAO" type="any";
	
	property name="productService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	
	public boolean function restrictedContentExists() {
		return getSettingService().getSettingRecordCount(settingName="contentRestrictAccessFlag", settingValue=1);
	}
	
	public any function getRestrictedContentByCMSContentIDAndCMSSiteID(required any cmsContentID, required any cmsSiteID) {
		var content = getContentByCMSContentIDAndCMSSiteID(arguments.cmsContentID, arguments.cmsSiteID);
		if(content.isNew()) {
			content.setCmsContentID(arguments.cmsContentID);
		}
		var settingDetails = content.getSettingDetails('contentRestrictAccessFlag');
		if(val(settingDetails.settingValue)){
			if(!content.isNew() && !settingDetails.settingInherited) {
				return content;
			} else if(settingDetails.settingInherited) {
				return this.getContentByCmsContentID(settingDetails.settingRelationships.cmsContentID);
			}
		}
	}
	
	public any function getCategoriesByCmsCategoryIDs(required any cmsCategoryIDs) {
		return getContentDAO().getCategoriesByCmsCategoryIDs(arguments.cmsCategoryIDs);
	}
	
	public any function getCmsCategoriesByCmsContentID(required any cmsContentID) {
		return getContentDAO().getCmsCategoriesByCmsContentID(arguments.cmsContentID);
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getDisplayTemplateOptions( required string templateType, string siteID ) {
		var returnArray = [];
		var displayTemplates = getContentDAO().getDisplayTemplates( argumentCollection=arguments );
		for(var template in displayTemplates) {
			arrayAppend(returnArray, {name=template.getTitle(), value=template.getContentID()});
		}
		return returnArray;
	}
	
	public any function getContentByCMSContentIDAndCMSSiteID( required string cmsContentID, required string cmsSiteID ) {
		return getContentDAO().getContentByCMSContentIDAndCMSSiteID( argumentCollection=arguments );
	}
	
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processContent_CreateSku(required any content, required any processObject) {
		
		// Get the product Type
		var productType = getProductService().getProductType( arguments.processObject.getProductTypeID() );
		
		// If incorrect product type, then just set it to the based 'contentAccess' product type
		if(isNull(productType) || productType.getBaseProductType() != "contentAccess") {
			var productType = getProductService().getProductType( "444df313ec53a08c32d8ae434af5819a" );
		}
		
		// Find the product
		var product = getProductService().getProduct( nullReplace(arguments.processObject.getProductID(), ""), true );
		
		// If the product was need, then set the necessary values
		if(product.isNew()) {
			product.setProductType( productType );
			product.setProductName( arguments.content.getTitle() );
			product.setProductCode( arguments.processObject.getProductCode() );
		}
		
		// Find the sku
		var sku = getSkuService().getSku( nullReplace(arguments.processObject.getSkuID(), ""), true);
		
		// If the sku was new, then set the necessary values
		if(sku.isNew()) {
			sku.setPrice( arguments.processObject.getPrice() );
			sku.setSkuCode( product.getProductCode() & "-#arrayLen(product.getSkus()) + 1#" );
			sku.setProduct( product );
			if(product.isNew()) {
				product.setDefaultSku( sku );
			}
			sku.setImageFile( sku.generateImageFileName() );
		}
		
		// Add this content node to the sku
		sku.addAccessContent( arguments.content );
		
		// Make sure product and sku are in the hibernate scope
		getHibachiDAO().save( product );
		getHibachiDAO().save( sku );
		
		return arguments.content;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}
