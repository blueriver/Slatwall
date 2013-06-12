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

	property name="accountService" type="any";
	property name="contentService" type="any";
	property name="subscriptionService" type="any";

	public struct function getAccessToContentDetails( required any account, required any content ) {
		
		// Setup the return struct
		var accessDetails = {
			accessFlag = false,
			nonRestrictedFlag = false,
			purchasedAccessFlag = false,
			subscribedAccessFlag = false,
			subscribedByContentFlag = false,
			subscribedByCategoryFlag = false
		};
		
		// Make sure there is restricted content in the system before doing any check
		if( !getService("contentService").restrictedContentExists() ) {
			accessDetails.accessFlag = true;
			accessDetails.nonRestrictedFlag = true;
			return accessDetails;
		}
		
		// Check the content's setting to determine if access is restriced
		if( !content.setting('contentRestrictAccessFlag') ) {
			accessDetails.accessFlag = true;
			accessDetails.nonRestrictedFlag = true;
			return accessDetails;
		}
		
		// Get the details of if this content requires a purchase or subscription (or both)
		var requirePurchaseSettingDetails = content.getSettingDetails('contentRequirePurchaseFlag');
		var requireSubscriptionSettingDetails = content.getSettingDetails('contentRequireSubscriptionFlag');
		
		// First, because it is faster we can check if the user has purchased access to any parent content
		var accountContentAccessSmartList = arguments.account.getAccountContentAccessesSmartList();
		accountContentAccessSmartList.addInFilter(propertyIdentifier="accessContents.contentID", value=content.getContentIDPath());
		
		// If any purchase records come back, then we can set purchasedAccess to true
		if(arrayLen(accountContentAccessSmartList.getRecords())) {
			
			accessDetails.accessFlag = true;
			accessDetails.purchasedAccessFlag = true;
			
			// If the content node does not 'requireSubscription' then we can return true and log it
			if(!requireSubscriptionSettingDetails.settingValue) {
				
				logAccess(content=arguments.content, accountContentAccess=accountContentAccessSmartList.getRecords()[1]);
				
				return accessDetails;
				
			}
			
		}
		
		// If either purchasing is not required, or it WAS purchased... then we can check subscriptions
		if(!requirePurchaseSettingDetails.settingValue || accessDetails.purchasedAccessFlag) {
			
			// First we can check if a subscription to this content or parent conent exist
			var activeAccountBenefitsViaContentSmartList = duplicate(arguments.account.getActiveSubscriptionUsageBenefitsSmartList());
			activeAccountBenefitsViaContentSmartList.addInFilter('contents.contentID', arguments.content.getContentIDPath());
			
			if(arrayLen(activeAccountBenefitsViaContentSmartList.getRecords())) {
				
				accessDetails.accessFlag = true;
				accessDetails.subscribedAccessFlag = true;
				accessDetails.subscribedByContentFlag = true;
				
				logAccess(content=arguments.content, accountContentAccess=activeAccountBenefitsViaContentSmartList.getRecords()[1]);
				
				return accessDetails;
			}
			
			// If there was not acess via content, then we can check via category or parent category... but only if this content has been categorized
			if(len(arguments.content.getAllCategoryIDPaths())) {
				var activeAccountBenefitsViaCategorySmartList = duplicate(arguments.account.getActiveSubscriptionUsageBenefitsSmartList());
				activeAccountBenefitsViaCategorySmartList.addInFilter('categories.categoryID', arguments.content.getAllCategoryIDPaths());
				
				if(arrayLen(activeAccountBenefitsViaCategorySmartList.getRecords())) {
					
					accessDetails.accessFlag = true;
					accessDetails.subscribedAccessFlag = true;
					accessDetails.subscribedByCategoryFlag = true;
					
					logAccess(content=arguments.content, accountContentAccess=activeAccountBenefitsViaCategorySmartList.getRecords()[1]);
					
					return accessDetails;
				}
			}
			
		}
		
		// By Default return the default data
		return accessDetails;
	}
	
	public void function logAccess(required any content, any subscriptionUsageBenefit, any accountContentAccess) {
		
		// Create a new content access log
		var contentAccess = this.newContentAccess();
		contentAccess.setContent(arguments.content);
		contentAccess.setAccount(getSlatwallScope().getCurrentAccount());
		
		// Setup the correct access type
		if( structKeyExists(arguments, "subscriptionUsageBenefit") ) {
			contentAccess.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
		} else if( structKeyExists(arguments,"accountContentAccess") ) {
			contentAccess.setAccountContentAccess(arguments.accountContentAccess);
		}
		
		// Pass into the hibernate context
		this.saveContentAccess(contentAccess);
		
		// persist the content access log, needed in case file download aborts the request 
		getHibachiDAO().flushORMSession();
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}