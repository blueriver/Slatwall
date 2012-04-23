<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="nameOnCreditCard">
			<rule type="required" contexts="creditCard" />
		</property>
		<property name="creditCardNumber">
			<rule type="required" contexts="creditCard" />
			<rule type="numeric" contexts="creditCard" />
		</property>
		<property name="securityCode">
			<rule type="required" contexts="creditCard" />
			<rule type="numeric" contexts="creditCard" />
		</property>
	</objectProperties>
</validateThis>