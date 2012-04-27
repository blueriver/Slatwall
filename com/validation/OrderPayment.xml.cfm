<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="nameOnCreditCard">
			<rule type="required" contexts="saveCreditCard" />
		</property>
		<property name="creditCardNumber">
			<rule type="required" contexts="saveCreditCard" />
			<rule type="numeric" contexts="saveCreditCard" />
		</property>
	</objectProperties>
</validateThis>