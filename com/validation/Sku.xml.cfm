<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="price">
			<rule type="required" contexts="*" />
		</property>
		<property name="skuCode">
			<rule type="custom" contexts="*" failureMessage="Sku Code is Not Unique">
				<param name="methodName" value="hasUniqueSkuCode" />
			</rule>
		</property>
		<property name="options">
			<rule type="custom" contexts="*" failureMessage="This Sku has the same options as another Sku">
				<param name="methodName" value="hasUniqueOptions" />
			</rule>
			<rule type="custom" contexts="*" failureMessage="This Sku has two options from the same option group">
				<param name="methodName" value="hasOneOptionPerOptionGroup" />
			</rule>
		</property>
	</objectProperties>
</validateThis>