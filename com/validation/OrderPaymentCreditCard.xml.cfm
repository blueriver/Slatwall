<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="nameOnCreditCard">
			<rule type="required" contexts="*" />
		</property>
		<property name="creditCardNumber">
			<rule type="required" contexts="*" />
			<rule type="numeric" contexts="*" />
		</property>
		<property name="securityCode">
			<rule type="required" contexts="*" />
			<rule type="numeric" contexts="*" />
		</property>
	</objectProperties>
</validateThis>