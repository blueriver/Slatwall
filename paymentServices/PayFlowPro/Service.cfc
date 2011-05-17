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

component accessors="true" output="false" displayname="PayFlowPro" implements="Slatwall.paymentServices.PaymentInterface" {
	
	// Custom Properties that need to be set by the end user
	property name="vendor" displayname="Vendor" type="sting";
	property name="partner" displayname="Partner" type="sting";
	property name="username" displayname="Username" type="sting";
	property name="password" displayname="Password" type="sting";
	property name="liveModeFlag" displayname="Live Mode" type="boolean" ;
	
	//Global variables
	variables.liveGatewayAddress = "payflowpro.paypal.com";
	variables.testGatewayAddress = "pilot-payflowpro.paypal.com";
	variables.verbosity = "MEDIUM";
	variables.timeout = 45;
	variables.transactionCodes = {};

	public any function init(){
		variables.transactionCodes = getTransactionCodes();
		return this;
	}
	
	public Slatwall.com.utility.payment.ResponseBean function processTransaction(required Slatwall.com.utility.payment.RequestBean requestBean, required string transactionType){
		var rawResponse = "";
		var requestData = getRequestData(requestBean,transactionType);
		var requestID = getRequestID(requestBean);
		rawResponse = postRequest(requestData,requestID);
		return getResponseBean(rawResponse);
	}
	
	private string function getRequestData(required any requestBean,required string transactionType){
		var requestData = "";
		requestData = "TRXTYPE=#variables.transactionCodes[transactionType]#&TENDER=C&VERBOSITY=#variables.verbosity#";
		requestData = listAppend(requestData,getLoginNVP(),"&");
		requestData = listAppend(requestData,getPaymentNVP(requestBean),"&");
		requestData = listAppend(requestData,getCustomerNVP(requestBean),"&");
		requestData = listAppend(requestData,getExtraNVP(requestBean),"&");
		requestData = listAppend(requestData,"ORIGID=#getOriginalTransactionID()#","&");
		
		return requestData;
	}

	private string function getRequestID(required any requestBean){
		return requestbean.getOrderID();
	}
	
	private string function getOriginalTransactionID(required any requestBean){
		return requestbean.getOriginalTransactionID();
	}
	
	private string function getLoginNVP(required any requestBean){
		var loginData = [];
		arrayAppend(loginData,"USER=#getUserName()#");
		arrayAppend(loginData,"PARTNER=#getPartner()#");
		arrayAppend(loginData,"VENDOR=#getVENDOR()#");
		arrayAppend(loginData,"PWD=#getPassword()#");
		return arrayToList(loginData,"&");
	}
	
	private string function getPaymentNVP(required any requestBean){
		var paymentData = [];
		arrayAppend(paymentData,"ACCT[#len(requestBean.getccNumber())#]=#requestBean.getccNumber()#");
		arrayAppend(paymentData,"EXPDATE[4]=#Left(requestBean.getExpMonth(),2)##Right(requestBean.getExpYear(),2)#");
		arrayAppend(paymentData,"CVV2[#len(requestBean.getCVV())#]=#requestBean.getCVV()#");
		arrayAppend(paymentData,"AMT[#len(requestBean.getAmount())#]=#requestBean.getAmount()#");
		return arrayToList(paymentData,"&");
	}
	
	private string function getCustomerNVP(required any requestBean){
		var customerData = [];
		arrayAppend(customerData,"CUSTCODE[#len(requestBean.getAccountID())#]=#requestBean.getAccountID()#");
		arrayAppend(customerData,"FIRSTNAME[#len(requestBean.getFirstName())#]=#requestBean.getFirstName()#");
		arrayAppend(customerData,"LASTNAME[#len(requestBean.getLastName())#]=#requestBean.getLastName()#");
		arrayAppend(customerData,"STREET[#len(requestBean.getStreetAddress())#]=#requestBean.getStreetAddress()#");
		arrayAppend(customerData,"CITY[#len(requestBean.getCity())#]=#requestBean.getCity()#");
		arrayAppend(customerData,"STATE[#len(requestBean.getStateCode())#]=#requestBean.getStateCode()#");
		arrayAppend(customerData,"ZIP[#len(requestBean.getPostalCode())#]=#requestBean.getPostalCode()#");
		arrayAppend(customerData,"EMAIL[#len(requestBean.getEmail())#]=#requestBean.getEmail()#");
		arrayAppend(customerData,"PHONENUM[#len(requestBean.getPhone())#]=#requestBean.getPhone()#");
		return arrayToList(customerData,"&");
	}
	
	private string function getExtraNVP(required any requestBean){
		var extraData = [];
		arrayAppend(extraData,"COMMENT[#len(requestBean.getComment())#]=#requestBean.getComment()#");
		return arrayToList(extraData,"&");
	}
	
	private struct function getTransactionCodes(){
		return {Charge="S",Auth="A",Credit="C",Capture="D",Void="V",Inquiry="I"};
	}
	
	private any function postRequest(required string requestData,required string requestID){
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl(getGatewayURL());
		httpRequest.setPort(getGatewayPort());
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="header",name="Content-Type",VALUE="text/namevalue");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#Len(requestData)#");
		httpRequest.addParam(type="header",name="Host",value="#getGatewayAddress()#");
		httpRequest.addParam(type="header",name="X-VPS-REQUEST-ID",VALUE="#requestID#");
		httpRequest.addParam(type="header",name="X-VPS-CLIENT-TIMEOUT",VALUE="#variables.timeout#");
		httpRequest.addParam(type="header",name="X-VPS-VIT-INTEGRATION-PRODUCT",VALUE="Slatwall");
		httpRequest.addParam(type="body",value="#requestData#");
		return httpRequest.send().getPrefix();
	}
	
	private string function getGatewayURL(){
		return "https://" & getGatewayAddress() & "/";
	}
	
	private numeric function getGatewayPort(){
		return 443;
	}
	
	private string function getGatewayAddress(){
		if(liveModeFlag){
			return variables.liveGatewayAddress;
		} else {
			return variables.testGatewayAddress;
		}
	}
	
	private any function getResponseBean(required string rawResponse){
		var response = new Slatwall.com.utility.payment.ResponseBean();
		var responseDataArray = listToArray(rawResponse,"&");
		var responseData = {result="",respmsg="",authcode="",pnref="",avsaddr="",avszip="",cvv2match=""};
		for(var item in responseDataArray){
			responseData[listFirst(item,"=")] = listRest(item,"=");
		}
		response.setResult(rawResponse);
		response.setStatus(responseData["result"]);
		response.setMessage(responseData["respmsg"]);
		response.setAuthCode(responseData["authcode"]);
		response.setTransactionID(responseData["pnref"]);
		response.setAVSCode(responseData["avsaddr"]&responseData["avszip"]);
		response.setCVVCode(responseData["cvv2Match"]);
		
		return response;
	}
	
}