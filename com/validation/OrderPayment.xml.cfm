<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="paymentTypeCreditCard" serverTest="getPaymentMethodType() EQ 'creditCard'" />
	</conditions>
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
		<context name="chargePreAuthorization" />
		<context name="authorizeAndCharge" />
		<context name="authorize" />
		<context name="credit" />
	</contexts>
	<objectProperties>
		<property name="nameOnCreditCard">
			<rule type="required" contexts="save" condition="paymentTypeCreditCard" />
		</property>
		<property name="creditCardNumber">
			<rule type="required" contexts="save" condition="paymentTypeCreditCard" />
			<rule type="numeric" contexts="save" condition="paymentTypeCreditCard" />
		</property>
		<property name="amountUnauthorized">
			<rule type="min" contexts="authorize">
				<param name="min" value="0.01" />
			</rule>
		</property>
		<property name="amountUncaptured">
			<rule type="min" contexts="chargePreAuthorization">
				<param name="min" value="0.01" />
			</rule>
		</property>
		<property name="amountUnreceived">
			<rule type="min" contexts="authorizeAndCharge">
				<param name="min" value="0.01" />
			</rule>
		</property>
		<property name="amountUncredited">
			<rule type="min" contexts="credit">
				<param name="min" value="0.01" />
			</rule>
		</property>
		<property name="orderStatusCode">
			<rule type="inList" contexts="chargePreAuthorization,authorizeAndCharge,authorize,credit">
				<param name="list" value="ostNew,ostProcessing,ostOnHold" />
			</rule>
			<rule type="inList" contexts="edit">
				<param name="list" value="ostNotPlaced,ostNew,ostProcessing,ostOnHold" />
			</rule>
		</property>
	</objectProperties>
</validateThis>