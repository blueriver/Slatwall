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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="subscriptionUsage";
	
	// Lazy Objects
	property name="order";

	// Data Properties
	property name="renewalStartType" hb_formFieldType="select";
	property name="proratedPrice" hb_rbKey="entity.sku.renewalPrice" hb_formatType="currency";
	property name="extendExpirationDate" hb_formatType="date";
	property name="prorateExpirationDate" hb_formatType="date";
	
	property name="renewalPaymentType" hb_formFieldType="select";
	
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldType="many-to-one" persistent="false" fkcolumn="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod";
	property name="orderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID" hb_rbKey="entity.orderPayment";
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID";
	
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_formFieldType="yesno";
	property name="updateSubscriptionUsageAccountPaymentMethodFlag" hb_formFieldType="yesno";
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	
	public boolean function getUpdateSubscriptionUsageAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "updateSubscriptionUsageAccountPaymentMethodFlag")) {
			variables.updateSubscriptionUsageAccountPaymentMethodFlag = 0;
		}
		return variables.updateSubscriptionUsageAccountPaymentMethodFlag;
	}
	
	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService('orderService').newOrderPayment();
		}
		return variables.newOrderPayment;
	}
	
	public any function getOrder() {
		if(!structKeyExists(variables, "order")) {
			for(var subscriptionOrderItem in getSubscriptionUsage().getSubscriptionOrderItems()) {
				if(subscriptionOrderItem.getSubscriptionOrderItemType().getSystemCode() == 'soitRenewal' && subscriptionOrderItem.getOrderItem().getOrder().getOrderStatusType().getSystemCode() != 'ostClosed') {
					variables.order = subscriptionOrderItem.getOrderItem().getOrder();
					break;
				}
			}
			if(!structKeyExists(variables, "order")) {
				variables.order = getService("orderService").newOrder();
			}
		}
		return variables.order;
	}
	
	public string function getExtendExpirationDate() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( getSubscriptionUsage().getExpirationDate() );
	}
	
	public string function getProrateExpirationDate() {
		return getSubscriptionUsage().getSubscriptionOrderItems()[1].getOrderItem().getSku().getSubscriptionTerm().getRenewalTerm().getEndDate( now() );
	}
	
	public numeric function getProratedPrice() {
		var extendDurationFromNow = dateDiff("d", getSubscriptionUsage().getExpirationDate(), getExtendExpirationDate() );
		var prorateDurationFromNow = dateDiff("d", getSubscriptionUsage().getExpirationDate(), getProrateExpirationDate() );
		var proratePercentage = prorateDurationFromNow / extendDurationFromNow * 100;
		
		return round(getSubscriptionUsage().getRenewalPrice() * proratePercentage)/100;
	}
	
	public string function getRenewalStartType() {
		if(!structKeyExists(variables, "renewalStartType")) {
			variables.renewalStartType = 'extend';
		}
		
		return variables.renewalStartType;
	}
	
	public array function getRenewalStartTypeOptions() {
		return [
			{name="Extend Current Expiration", value='extend'},
			{name="Prorate & Extend From Today", value='prorate'}
		];
	}
	
	public string function getRenewalPaymentType() {
		if(!structKeyExists(variables, "renewalPaymentType")) {
			if(arrayLen(getAccountPaymentMethodOptions())) {
				variables.renewalPaymentType = 'accountPaymentMethod';
			} else if(arrayLen(getOrderPaymentOptions())) {
				variables.renewalPaymentType = 'orderPayment';	
			} else {
				variables.renewalPaymentType = 'new';
			}
		}
		
		return variables.renewalPaymentType;
	}
	
	public any function getAccountPaymentMethod() {
		if(!isNull(variables.accountPaymentMethod)) {
			return variables.accountPaymentMethod;
		} else if(!isNull(getSubscriptionUsage().getAccountPaymentMethod()))  {
			return getSubscriptionUsage().getAccountPaymentMethod();
		}
	}
	
	public array function getRenewalPaymentTypeOptions() {
		var options = [];
		
		if(arrayLen(getAccountPaymentMethodOptions())) {
			arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.accountPaymentMethod'), value='accountPaymentMethod'});
		}
		if(arrayLen(getOrderPaymentOptions())) {
			arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.orderPayment'), value='orderPayment'});
		}
		arrayAppend(options, {name=rbKey('processObject.SubscriptionUsage_Renew.renewalPaymentType.new'), value='new'});
		
		return options;
	}
	
	public array function getOrderPaymentOptions() {
		if(!structKeyExists(variables, "orderPaymentOptions")) {
			variables.orderPaymentOptions = [];
			var previousOrderPayments = getSubscriptionUsage().getUniquePreviousSubscriptionOrderPayments();
			for(var orderPayment in previousOrderPayments) {
				arrayAppend(variables.orderPaymentOptions, {name=orderPayment.getSimpleRepresentation(), value=orderPayment.getOrderPaymentID()});	
			}
		}
		return variables.orderPaymentOptions;
	}
	
	public any function getAccountPaymentMethodOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodOptions")) {
			variables.accountPaymentMethodOptions = [];
			var smartList = getService("accountService").getAccountPaymentMethodSmartList();
			smartList.addFilter(propertyIdentifier="account.accountID", value=getSubscriptionUsage().getAccount().getAccountID());
			smartList.addOrder("accountPaymentMethodName|ASC");
			for(var apm in smartList.getRecords()) {
				arrayAppend(variables.accountPaymentMethodOptions,{name=apm.getSimpleRepresentation(),value=apm.getAccountPaymentMethodID()});
			}
		}
		return variables.accountPaymentMethodOptions;
    }
	
}