<cfset creditCardRequestBean = createObject("component", "Slatwall.model.transient.payment.CreditCardTransactionRequestBean").init() />

<cfset creditCardRequestBean.setnameOnCreditCard("Paul John") />

<cfset creditCardRequestBean.settransactionType("sale") />

<cfset creditCardRequestBean.settransactionID("1010") />

<cfset response = rc.integration.getIntegrationCFC("payment").processCreditCard(creditCardRequestBean) />

<cfdump var="#response#" />