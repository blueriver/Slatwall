<cfset creditCardRequestBean = createObject("component", "Slatwall.model.transient.payment.CreditCardTransactionRequestBean").init() />

<cfset creditCardRequestBean.setnameOnCreditCard("Paul John") />

<cfset creditCardRequestBean.settransactionType("authorize") />

<cfset creditCardRequestBean.setCreditCardNumber("411111111111111111") />

<cfset creditCardRequestBean.settransactionID(createuuid()) />

<cfset response = rc.integration.getIntegrationCFC("payment").processCreditCard(creditCardRequestBean) />

<cfdump var="#response#" />

