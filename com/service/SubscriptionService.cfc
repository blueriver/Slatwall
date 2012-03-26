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
component extends="BaseService" output="false" {
	
	public boolean function createSubscriptionUsageBenefitAccountByAccess(required any access, required any account) {
		var subscriptionUsageBenefitAccountCreated = false;
		if(!isNull(arguments.access.getSubscriptionUsageBenefitAccount()) && isNull(arguments.access.getSubscriptionUsageBenefitAccount().getAccount())) {
			arguments.access.getSubscriptionUsageBenefitAccount().setAccount(arguments.account);
			arguments.access.getSubscriptionUsageBenefitAccount().setActiveFlag(1);
			subscriptionUsageBenefitAccountCreated = true;
		} else if(!isNull(arguments.access.getSubscriptionUsageBenefit())) {
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(arguments.access.getSubscriptionUsageBenefit(), arguments.account);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		} else if(!isNull(arguments.access.getSubscriptionUsage())) {
			var subscriptionUsageBenefitAccountArray = createSubscriptionUsageBenefitAccountBySubscriptionUsage(arguments.access.getSubscriptionUsage(), arguments.account);
			if(arrayLen(subscriptionUsageBenefitAccountArray)) {
				subscriptionUsageBenefitAccountCreated = true;
			}
		}
		return subscriptionUsageBenefitAccountCreated;
	}
	
	// Create subscriptionUsageBenefitAccount by subscription usage, returns array of all subscriptionUsageBenefitAccountArray created
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsage(required any subscriptionUsage, any account) {
		var subscriptionUsageBenefitAccountArray = [];
		for(var subscriptionUsageBenefit in arguments.subscriptionUsage.getSubscriptionUsageBenefits()) {
			var data.subscriptionUsageBenefit = subscriptionUsageBenefit;
			data.account = arguments.account;
			var subscriptionUsageBenefitAccount = createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(argumentCollection=data);
			if(!isNull(subscriptionUsageBenefitAccount)) {
				arrayAppend(subscriptionUsageBenefitAccountArray,subscriptionUsageBenefitAccount);
			}
		}
		return subscriptionUsageBenefitAccountArray;
	}
	
	public any function createSubscriptionUsageBenefitAccountBySubscriptionUsageBenefit(required any subscriptionUsageBenefit, any account) {
		if(arguments.subscriptionUsageBenefit.getAvailableUseCount() GT 0) {
			var subscriptionUsageBenefitAccount = this.newSubscriptionUsageBenefitAccount();
			subscriptionUsageBenefitAccount.setSubscriptionUsageBenefit(arguments.subscriptionUsageBenefit);
			this.saveSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
			// if account is passed then set the account to this benefit else create an access record to be used for account creation
			if(structKeyExists(arguments,"account")) {
				subscriptionUsageBenefitAccount.setAccount(arguments.account);
				subscriptionUsageBenefitAccount.setActiveFlag(1);
			} else {
				var access = getService("accessService").newAccess();
				access.setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount);
				getService("accessService").saveAccess(access);
			}
			return subscriptionUsageBenefitAccount;
		}
	}
	
}
