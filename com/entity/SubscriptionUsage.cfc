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
component displayname="Subscription Usage" entityname="SlatwallSubscriptionUsage" table="SlatwallSubscriptionUsage" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="subscriptionUsageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="allowProrateFlag" ormtype="boolean" formatType="yesno";
	property name="renewalPrice" ormtype="big_decimal" formatType="currency";
	property name="nextBillDate" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="initialTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="initialTermID";
	property name="renewalTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="renewalTermID";
	property name="gracePeriodTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="gracePeriodTermID";
	
	// Related Object Properties (one-to-many)
	property name="subscriptionUsageBenefits" singularname="subscriptionUsageBenefit" cfc="SubscriptionUsageBenefit" type="array" fieldtype="one-to-many" fkcolumn="subscriptionUsageID" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public any function init() {
		if(isNull(variables.subscriptionUsageBenefits)) {
			variables.subscriptionUsageBenefits = [];
		}
		return super.init();
	}
	

	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		//copy all the info form subscription term
		var subscriptionTerm = orderItem.getSku().getSubscriptionTerm();
		setInitialTerm(subscriptionTerm.getInitialTerm());
		setRenewalTerm(subscriptionTerm.getRenewalTerm());
		setGracePeriodTerm(subscriptionTerm.getGracePeriodTerm());
		setAllowProrateFlag(subscriptionTerm.getAllowProrateFlag());
		setRenewalPrice(orderItem.getSku().getRenewalPrice());
		// copy all the subscription benefits
		for(var subscriptionBenefit in subscriptionTerm.getSubscriptionBenefits()) {
			var subscriptionUsageBenefit = getService("subscriptionService").newSubscriptionUsageBenefit();
			subscriptionUsageBenefit.copyFromSubscriptionBenefit(subscriptionBenefit);
			addSubscriptionUsageBenefit(subscriptionUsageBenefit);
			// add this benefit to access
			if(subscriptionBenefit.getAccessType().getSystemCode() EQ "satPerSubscription") {
				var accessSmartList = getService("accessService").getAccessSmartList();
				accessSmartList.addFilter(propertyIdentifier="subscriptionUsage_subscriptionUsageID", value=subscriptionUsageBenefit.getSubscriptionUsage().getSubscriptionUsageID());
				if(!accessSmartList.getRecordCount()) {
					var access = getService("accessService").newAccess();
					access.setSubscriptionUsage(subscriptionUsageBenefit.getSubscriptionUsage());
					getService("accessService").saveAccess(access);
				}
			} else if(subscriptionBenefit.getAccessType().getSystemCode() EQ "satPerBenefit") {
				var access = getService("accessService").newAccess();
				access.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
				getService("accessService").saveAccess(access);
			} else if(subscriptionBenefit.getAccessType().getSystemCode() EQ "satPerAccount") {
				for(var i = 0; i < subscriptionBenefit.getTotalQuantity(); i++) {
					var subscriptionUsageBenefitAccount = getService("subscriptionService").newSubscriptionUsageBenefitAccount();
					subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(subscriptionUsageBenefit);
					getService("subscriptionService").saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
					var access = getService("accessService").newAccess();
					access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
					getService("accessService").saveAccess(access);
				}
			}
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// subscriptionUsageBenefits (one-to-many)    
	public void function addSubscriptionUsageBenefit(required any subscriptionUsageBenefit) {    
		arguments.subscriptionUsageBenefit.setSubscriptionUsage( this );    
	}    
	public void function removeSubscriptionUsageBenefit(required any subscriptionUsageBenefit) {    
		arguments.subscriptionUsageBenefit.removeSubscriptionUsage( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}