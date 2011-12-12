<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="priceGroupName">
			<rule type="required" contexts="*" />
		</property>
		<property name="priceGroupCode">
			<rule type="required" contexts="*" />
		</property>
		<property name="childPriceGroups">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>