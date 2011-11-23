<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="attributeName">
			<rule type="required" contexts="*" />
		</property>
		<property name="attributeCode">
			<rule type="required" contexts="*" />
			<rule type="custom" contexts="*" failureMessage="Attribute Code is Not Unique">
				<param name="methodName" value="hasUniqueAttributeCode" />
			</rule>
		</property>
		<property name="attributeType">
			<rule type="required" contexts="*" />
		</property>
	</objectProperties>
</validateThis>