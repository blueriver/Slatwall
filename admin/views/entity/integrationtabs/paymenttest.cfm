<cfset creditCardRequestBean = createObject("component", "Slatwall.model.transient.payment.CreditCardTransactionRequestBean").init() />

<cfset response = rc.integration.getIntegrationCFC("payment").processCreditCard(creditCardRequestBean) />

<cfdump var="#response#" />