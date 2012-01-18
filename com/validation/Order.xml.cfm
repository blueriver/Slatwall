<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="orderType">
			<rule type="required" contexts="save,saveReturnOrder" />
		</property>
		<property name="orderStatusType">
			<rule type="required" contexts="save,saveReturnOrder" />
		</property>
		<property name="orderItems">
			<rule type="collectionSize" contexts="saveReturnOrder">
				<param name="min" value="1" />
			</rule>
		</property>
	</objectProperties>
</validateThis>