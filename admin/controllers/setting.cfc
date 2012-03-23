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
component extends="BaseController" output="false" accessors="true" {
	
	// Slatwall Service Injection		
	property name="addressService" type="any";
	property name="attributeService" type="any";
	property name="dataService" type="any";
	property name="fulfillmentService" type="any";
	property name="integrationService" type="any";
	property name="locationService" type="any";
	property name="productService" type="any";
	property name="paymentService" type="any";
	property name="roundingRuleService" type="any";
	property name="settingService" type="any";
	property name="shippingService" type="any";
	property name="skuCacheService" type="any";
	property name="taxService" type="any";
	property name="termService" type="any";
	property name="updateService" type="any";
	property name="utilityFormService" type="any";
	property name="utilityFileService" type="any";
	
	public void function default() {
		getFW().redirect(action="admin:setting.detailsetting");
	}
	
	// Global Settings
	public void function detailsetting(required struct rc) {
		rc.edit = false;
		rc.allSettings = getSettingService().getSettings();
		rc.productTemplateOptions = getProductService().getProductTemplates(siteID=rc.$.event('siteid'));
		
		rc.shippingWeightUnitCodeOptions = getSettingService().getMeaurementUnitOptions(measurementType="weight");
		rc.customIntegrations = getIntegrationService().listIntegrationFilterByCustomActiveFlag(1);
		
		var rootCategoryID = rc.$.slatwall.setting("product_rootProductCategory");
		if(rootCategoryID == "0") {
			rc.rootCategory = rc.$.slatwall.rbKey("define.all");
		} else {
			rc.rootCategory = getCMSBean("categoryManager").read(categoryID=rootCategoryID).getName();
		}
	}
	
	public void function editsetting(required struct rc) {
		detailsetting(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailsetting");
	}
	
	public void function createAddressZoneLocation(required struct rc) {
		editAddressZoneLocation(rc);
	}
	
	public void function editAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		rc.edit=true;
		
		getFW().setView("admin:setting.detailAddressZoneLocation");
	}
	
	public void function deleteAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		
		rc.addressZone.removeAddressZoneLocation( rc.addressZoneLocation );
		
		getFW().redirect(action="admin:setting.detailaddresszone", queryString="addressZoneID=#rc.addressZoneID#&messageKeys=admin.setting.deleteaddresszonelocation_success");
	}
	
	public void function createAccountAttributeSet( required struct rc ) {    
		param name="rc.attributeSetID" default="";
		
		rc.attributeSet = getAttributeService().getAttributeSet( rc.attributeSetID, true );
		var asType = getService("typeService").getTypeBySystemCode( "astAccount" );
		rc.attributeSet.setAttributeSetType( asType );
		rc.edit = true;
		rc.listAction = "admin:setting.listattributeset"; 
		rc.saveAction = "admin:setting.saveattributeset";
		rc.cancelAction = "admin:setting.listattributeset";
		getFW().setView( "admin:setting.detailattributeset" );
	}
	
	public void function createProductAttributeSet( required struct rc ) {    
		param name="rc.attributeSetID" default="";
		
		rc.attributeSet = getAttributeService().getAttributeSet( rc.attributeSetID, true );
		var asType = getService("typeService").getTypeBySystemCode( "astProduct" );
		rc.attributeSet.setAttributeSetType( asType );
		rc.edit = true;
		rc.listAction = "admin:setting.listattributeset"; 
		rc.saveAction = "admin:setting.saveattributeset";
		rc.cancelAction = "admin:setting.listattributeset";
		getFW().setView( "admin:setting.detailattributeset" );
	}

	public void function createProductCustomizationAttributeSet( required struct rc ) {    
		param name="rc.attributeSetID" default="";
		
		rc.attributeSet = getAttributeService().getAttributeSet( rc.attributeSetID, true );
		var asType = getService("typeService").getTypeBySystemCode( "astProductCustomization" );
		rc.attributeSet.setAttributeSetType( asType );
		rc.edit = true;
		rc.listAction = "admin:setting.listattributeset"; 
		rc.saveAction = "admin:setting.saveattributeset";
		rc.cancelAction = "admin:setting.listattributeset";
		getFW().setView( "admin:setting.detailattributeset" );
	}

	// Frontend Views
	public void function detailViewUpdate(required struct rc) {

	}
	
	public void function updateFrontendViews(required struct rc) {

		var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
		var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#rc.$.event('siteid')#/includes/display_objects/custom/slatwall/"));

		getUtilityFileService().duplicateDirectory(baseSlatwallPath,baseSitePath,true,true,".svn");
		getFW().redirect(action="admin:main");
	}
	
	// slatwall update
	public void function detailSlatwallUpdate(required struct rc) {

		var versions = getUpdateService().getAvailableVersions();
		rc.availableDevelopVersion = versions.develop;
		rc.availableMasterVersion = versions.master;

		rc.currentVersion = getPluginConfig().getApplication().getValue('SlatwallVersion');
		if(find("-", rc.currentVersion)) {
			rc.currentBranch = "develop";
		} else {
			rc.currentBranch = "master";
		}

	}

	public void function updateSlatwall(required struct rc) {
		getUpdateService().update(branch=rc.updateBranch);
		rc.message = rbKey("admin.setting.updateslatwall_success");
		getFW().redirect(action="admin:setting.detailslatwallupdate?reload=true", preserve="message");	
	}

	public void function updateSkuCache(required struct rc) {
		getSkuCacheService().updateAllSkus();
		rc.message = rbKey("admin.setting.updateSkuCache_success");
		getFW().redirect(action="admin:main.default", preserve="message");	
	}

	public void function updateProductCache(required struct rc) {
		getSkuCacheService().updateAllProducts();
		rc.message = rbKey("admin.setting.updateProductCache_success");
		getFW().redirect(action="admin:main.default", preserve="message");	
	}
	
}
