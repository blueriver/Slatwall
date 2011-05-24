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

component accessors="true" output="false" displayname="FedEx" implements="Slatwall.shippingServices.ShippingInterface" {

	// Custom Properties that need to be set by the end user
	property name="accountNo" validateRequired displayname="FedEx Account Number" type="string";
	property name="password" displayname="FedEx Password" type="string";
	property name="transactionKey" displayname="FedEx Transaction Key" type="string";
	property name="meterNo" displayname="FedEx Meter Number" type="string";
	property name="testingFlag" displayname="Testing Mode" type="boolean" default="false";
	property name="shipperStreet" displayname="Shipper Street Address" type="string";
	property name="shipperCity" displayname="Shipper City" type="string";
	property name="shipperStateCode" displayname="Shipper State Code" type="string";
	property name="shipperPostalCode" displayname="Shipper Postal Code" type="string";
	property name="shipperCountryCode" displayname="Shipper Country Code" type="string";

	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			FIRST_OVERNIGHT="FedEx First Overnight",
			PRIORITY_OVERNIGHT="FedEx Priority Overnight",
			STANDARD_OVERNIGHT="FedEx Standard Overnight",
			FEDEX_2_DAY="FedEx 2 Day",
			FEDEX_EXPRESS_SAVER="FedEx Express Saver",
			FEDEX_GROUND="FedEx Ground",
			INTERNATIONAL_ECONOMY="FedEx International Economy",
			INTERNATIONAL_PRIORITY="FedEx International Priority"
		};
		return this;
	}
	
	public Slatwall.com.utility.shipping.RatesResponseBean function getRates(required any orderShipping) {
		
		// Insert Custom Logic Here
		var totalItemsWeight = 0;
		var totalItemsPrice = 0;
		
		// Loop over all items to get a price and weight for shipping
		for(var i=1; i<=arrayLen(arguments.orderShipping.getOrderShippingItems()); i++) {
			totalItemsWeight += arguments.orderShipping.getOrderShippingItems()[i].getSku().getProduct().getShippingWeight();
			totalItemsPrice += arguments.orderShipping.getOrderShippingItems()[i].getSku().getPrice();
		}
		
		if(totalItemsWeight < 1) {
			totalItemsWeight = 1;
		}
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "RatesRequestTemplate.cfm";
        }
        
        // Setup Request to push to FedEx
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		if(variables.testingFlag) {
			httpRequest.setUrl("https://gatewaybeta.fedex.com/xml");
		} else {
			httpRequest.setUrl("https://gateway.fedex.com/xml");
		}
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="XML", name="name",value=xmlPacket);
		
		var xmlResponse = XmlParse(httpRequest.send().getPrefix().fileContent);
		
		var ratesResponseBean = new Slatwall.com.utility.shipping.RatesResponseBean();
		ratesResponseBean.setRawRequestData(XmlParse(xmlPacket));
		ratesResponseBean.setRawResponseData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			// If XML fault then log error
			var message = ratesResponseBean.getNewMessageBean();
			message.setMessageCode("0");
			message.setMessageType("Unexpected");
			message.setMessage("An unexpected programming error occured, please notify system administrator.");
			ratesResponseBean.addErrorMessageBean(message);
		} else {
			
			// Log all messages from FedEx into the response bean
			for(var i=1; i<=arrayLen(xmlResponse.RateReply.Notifications); i++) {
				
				var message = ratesResponseBean.getNewMessageBean();
				message.setMessageCode(xmlResponse.RateReply.Notifications[i].Code.xmltext);
				message.setMessageType(xmlResponse.RateReply.Notifications[i].Severity.xmltext);
				message.setMessage(xmlResponse.RateReply.Notifications[i].Message.xmltext);
				if(FindNoCase("Error", xmlResponse.RateReply.Notifications[i].Severity.xmltext)) {
					ratesResponseBean.addErrorMessageBean(message);
				} else {
					ratesResponseBean.addMessageBean(message);
				}
				
			}
			
			if(!ratesResponseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.RateReply.RateReplyDetails); i++) {
					var rate = ratesResponseBean.getNewMethodRateResponseBean();
					rate.setShippingProviderMethod(xmlResponse.RateReply.RateReplyDetails[i].ServiceType.xmltext);
					rate.setTotalCost(xmlResponse.RateReply.RateReplyDetails[i].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.xmltext);
					ratesResponseBean.addMethodRateResponseBean(rate);
				}
			}
		}
		
		return ratesResponseBean;
	}
	
	public Slatwall.com.utility.shipping.TrackingResponseBean function getTracking(required string trackingNumber) {
		var trackingResponseBean = new com.utility.shipping.TrackingResponseBean();
		
		// Insert Custom Logic Here
		
		return trackingResponseBean;
	}
	
	public Slatwall.com.utility.shipping.ShipmentResponseBean function createShipment(required any orderShipment) {
		var shipmentResponseBean = new com.utility.shipping.ShipmentResponseBean();
		
		// Insert Custom Logic Here
		
		return shipmentResponseBean;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
}
