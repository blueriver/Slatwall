<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="attributeSetName">
			<rule type="required" contexts="*" />
		</property>
		<property name="attributeSetCode">
			<rule type="required" contexts="*" />
			<rule type="custom" contexts="*" failureMessage="Attribute Set Code is Not Unique">
				<param name="methodName" value="hasUniqueAttributeSetCode" />
			</rule>
		</property>
		<property name="attributeSetType">
			<rule type="required" contexts="*" />
		</property>
	</objectProperties>
</validateThis>