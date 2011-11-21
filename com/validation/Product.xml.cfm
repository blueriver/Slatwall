<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="filename">
			<rule type="required" contexts="*" />
		</property>
		<property name="productName">
			<rule type="required" contexts="*" />
		</property>
		<property name="productCode">
			<rule type="required" contexts="*" />
			<rule type="custom" contexts="*" failureMessage="Product Code is Not Unique">
				<param name="methodName" value="hasUniqueProductCode" />
			</rule>
		</property>
		<property name="brand">
			<rule type="required" contexts="*" />
		</property>
		<property name="productType">
			<rule type="required" contexts="*" />
		</property>
		<property name="price">
			<rule type="required" contexts="*" />
			<rule type="numeric" contexts="*" />
		</property>
	</objectProperties>
</validateThis>