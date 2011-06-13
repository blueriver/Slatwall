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
component accessors="true" output="false" displayname="PayPal Express" implements="Slatwall.paymentServices.PaymentInterface" {
	
	public any function init() {
		return this;
	}
	
	public Slatwall.com.utility.payment.CreditCardProcessResponseBean function processCreditCard(required Slatwall.com.utility.payment.CreditCardProcessRequestBean requestBean){
		
	}
	
	public any function getPaymentMethods() {
		return "paypalExpress";
	}
	
}
/*
component accessors="true" output="false" displayname="PayPal Express" implements="Slatwall.paymentServices.PaymentInterface" {
	
	// Custom Properties that need to be set by the end user
	property name="vendor" displayname="Vendor" type="string";
	property name="partner" displayname="Partner" type="string";
	property name="username" displayname="Username" type="string";
	property name="password" displayname="Password" type="string";
	property name="liveModeFlag" displayname="Live Mode" type="boolean" ;
	
	//Global variables
	variables.liveGatewayAddress = "payflowpro.paypal.com";
	variables.testGatewayAddress = "pilot-payflowpro.paypal.com";
	variables.expressCheckoutURL = "https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout";
	variables.verbosity = "MEDIUM";
	variables.timeout = 45;
	variables.transactionCodes = {};

	public any function init(){
		variables.transactionCodes = getTransactionCodes();
		return this;
	}
	
	public any function getSupportedPaymentMethods() {
		return "paypalExpress";
	}
	
	public Slatwall.com.utility.payment.ResponseBean function processTransaction(required Slatwall.com.utility.payment.RequestBean requestBean,required string transactionType){
		var rawResponse = "";
		var requestData = getRequestData(requestBean,action);
		rawResponse = postRequest(requestData);
		return getResponseBean(rawResponse);
	}
	
	public Slatwall.com.utility.payment.ResponseBean function setExpressCheckout(required any requestBean){
		if(requestBean.getReturnURL() == "" || requestBean.getCancelURL() == "" || requestBean.getAmount() == ""){
			throw("Invalid request, for setExpressCheckout() method request bean must have returnURL,cancelURL and amount specified.","Slatwall")
		} else{
			return processTransaction(requestBean,"S");
		}
	}
	
	public Slatwall.com.utility.payment.ResponseBean function getExpressCheckoutDetails(required any requestBean){
		if(requestBean.getOriginalTransactionID() == ""){
			throw("Invalid request, for getExpressCheckoutDetails() method request bean must have getOriginalTransactionID, which is token provided returned from setExpressCheckout().","Slatwall")
		} else{
			return processTransaction(requestBean,"G");
		}
	}
	
	public Slatwall.com.utility.payment.ResponseBean function doExpressCheckoutPayment(required any requestBean){
		if(requestBean.getOriginalTransactionID() == "" || requestBean.getPayerID() == "" || requestBean.getAmount() == ""){
			throw("Invalid request, for doExpressCheckoutPayment() method request bean must have getOriginalTransactionID,payerID and amount which is returned from getExpressCheckoutDetails().","Slatwall")
		} else{
			return processTransaction(requestBean,"D");
		}
	}
	
	public string function getRedirectURL(required string token,string userAction){
		var allowedUserActions = "commit,continue";
		if(structKeyExists(arguments,"userAction") && listFindNoCase(allowedUserActions,userAction) == 0){
			throw("Valid values for userAction is 'commit,continue'","Slatwall");
		}
		if(structKeyExists(arguments,"userAction")){
			return variables.expressCheckoutURL & "&token=#token#&useraction=#userAction#";
		}else{
			return variables.expressCheckoutURL & "&token=#token#";
		}
	}
	
	private string function getRequestData(required any requestBean,required string action){
		var requestData = "";
		requestData = "TRXTYPE=#variables.transactionCodes[requestBean.getTransactionType()]#&TENDER=P&ACTION=#action#&VERBOSITY=#variables.verbosity#";
		requestData = listAppend(requestData,getLoginNVP(),"&");
		requestData = listAppend(requestData,"AMT=#requestBean.getAmount()#","&");
		if(requestBean.getOriginalTransactionID() != ""){
			requestData = listAppend(requestData,"TOKEN=#requestBean.getOriginalTransactionID()#","&");
		}
		if(requestBean.getPayerID() != ""){
			requestData = listAppend(requestData,"PAYERID=#requestBean.getPayerID()#","&");
		}
		
		return requestData;
	}

	private string function getLoginNVP(required any requestBean){
		var loginData = [];
		arrayAppend(loginData,"USER=#getUserName()#");
		arrayAppend(loginData,"PARTNER=#getPartner()#");
		arrayAppend(loginData,"VENDOR=#getVENDOR()#");
		arrayAppend(loginData,"PWD=#getPassword()#");
		return arrayToList(loginData,"&");
	}

	private struct function getTransactionCodes(){
		return {Charge="S",Auth="A",Credit="C",Capture="D",Void="V",Inquiry="I"};
	}
	
	private any function postRequest(required string requestData){
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl(getGatewayURL());
		httpRequest.setPort(getGatewayPort());
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="header",name="Content-Type",VALUE="text/namevalue");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#Len(requestData)#");
		httpRequest.addParam(type="header",name="Host",value="#getGatewayAddress()#");
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
		var responseData = {result="",respmsg="",ppref="",pnref="",avsaddr="",avszip="",token="",payerID=""};
		for(var item in responseDataArray){
			responseData[listFirst(item,"=")] = listRest(item,"=");
		}
		response.setResult(rawResponse);
		response.setStatus(responseData["result"]);
		response.setMessage(responseData["respmsg"]);
		response.setAuthCode(responseData["ppref"]);
		response.setTransactionID(responseData["pnref"]);
		response.setAVSCode(responseData["avsaddr"] & responseData["avszip"]);
		response.setToken(responseData["token"]);
		response.setPayerID(responseData["payerID"]);
		
		return response;
	}
	
}
*/