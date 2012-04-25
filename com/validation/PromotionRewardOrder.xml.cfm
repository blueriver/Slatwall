<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="amountType">
			<rule type="required" contexts="save" />
		</property>
		<property name="amount">
			<rule type="required" contexts="save" />
			<rule type="numeric" contexts="save" />
		</property>
	</objectProperties>
</validateThis>