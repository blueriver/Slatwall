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

component accessors="true" output="false" displayname="Endicia" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {
	
	// Custom Properties that need to be set by the end user
	property name="accountID" validateRequired displayname="Endicia Account Number" type="string";
	property name="passPhrase" validateRequired displayname="PassPhrase" type="string";
	property name="fromPostalCode" validateRequired displayname="Shipping From Postal Code" type="string";
	
	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			FIRST_CLASS_MAIL="First-Class Mail",
			PRIORITY_MAIL="Priority Mail",
			EXPRESS_MAIL="Express Mail",
			LIBRARY_MAIL="Library Mail",
			MEDIA_MAIL="Media Mail",
			PARCEL_POST="Parcel Post"
		};
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://usps.com/Tracking?tracknumber=${trackingNumber}";
	}
	
	public Slatwall.com.utility.fulfillment.ShippingRatesResponseBean function getRates(required Slatwall.com.utility.fulfillment.ShippingRatesRequestBean requestBean) {
		var totalItemsWeight = 0;
		var totalItemsValue = 0;
		
		// Loop over all items to get a price and weight for shipping
		for(var i=1; i<=arrayLen(arguments.requestBean.getShippingItemRequestBeans()); i++) {
			if(isNumeric(arguments.requestBean.getShippingItemRequestBeans()[i].getWeight())) {
				totalItemsWeight +=	arguments.requestBean.getShippingItemRequestBeans()[i].getWeight();
			}
			 
			totalItemsValue += arguments.requestBean.getShippingItemRequestBeans()[i].getValue();
		}
		
		if(totalItemsWeight < 1) {
			totalItemsWeight = 1;
		}
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "PostageRatesRequestTemplate.cfm";
        }
        
        // Setup Request to push to Endicia
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		httpRequest.setUrl("https://www.envmgr.com/LabelService/EwsLabelService.asmx/CalculatePostageRatesXML");
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="header",name="Content-Type",VALUE="application/x-www-form-urlencoded");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#len(xmlPacket)#");
		
		httpRequest.addParam(type="body",value="postageRatesRequestXML=#trim(xmlPacket)#");
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var ratesResponseBean = new Slatwall.com.utility.fulfillment.ShippingRatesResponseBean();
		ratesResponseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			// If XML fault then log error message
			ratesResponseBean.addMessage(messageCode="0", messageType="Unexpected", message="An unexpected communication error occured, please notify system administrator.");
			ratesResponseBean.getErrorBean().addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from Endicia into the response bean
			
			if(xmlResponse.PostageRatesResponse.Status.xmltext neq "0") {
				ratesResponseBean.addMessage(
					messageCode=xmlResponse.PostageRatesResponse.Status.xmltext,
					message=xmlResponse.PostageRatesResponse.ErrorMessage.xmltext
				);
				ratesResponseBean.getErrorBean().addError(
					xmlResponse.PostageRatesResponse.Status.xmltext,
					xmlResponse.PostageRatesResponse.ErrorMessage.xmltext
				);
			} else {
				ratesResponseBean.addMessage(
					messageCode="0",
					message="Successful"
				);
			}
			
			if(!ratesResponseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.PostageRatesResponse.PostagePrice); i++) {
					var shippingMethod = UCASE(Replace(Replace(xmlResponse.PostageRatesResponse.PostagePrice[i].Postage.MailService.xmltext, "-", "_", "all")," ", "_", "all"));
					ratesResponseBean.addShippingMethod(
						shippingProviderMethod=shippingMethod,
						totalCharge=xmlResponse.PostageRatesResponse.PostagePrice[i].Postage.XmlAttributes.TotalAmount
					);
				}
			}
			
		}
		return ratesResponseBean;
	}
	
	private numeric function convertPoundsToOunces(required numeric pounds) {
		return arguments.pounds * 16;
	}
}
