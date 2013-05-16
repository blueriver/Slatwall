<!--- ADD BUTTON GEN CODE HERE --->
<cfparam name="params.edit" type="boolean" default="true" />
<cfparam name="params.orderPayment" type="any" />
<cfparam name="params.orderPaymentIndex" type="string" />
<cfparam name="params.paymentMethod" type="any" />

<a href="&returnURL={domainHere}?slatAction=paypalexpress:main.processResponse&orderID=#$.slatwall.cart().getOrderID()#&pmid=#params.paymentMethod.getPaymentMethodID()#">$.slatwall.</a>