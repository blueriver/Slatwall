<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="filename">
			<rule type="required" contexts="save" />
		</property>
		<property name="productName">
			<rule type="required" contexts="save" />
		</property>
		<property name="productCode">
			<rule type="required" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="Product Code is Not Unique">
				<param name="methodName" value="hasUniqueProductCode" />
			</rule>
		</property>
		<property name="brand">
			<rule type="required" contexts="save" />
		</property>
		<property name="productType">
			<rule type="required" contexts="save" />
		</property>
		<property name="price">
			<rule type="required" contexts="save" />
			<rule type="numeric" contexts="save" />
		</property>
	</objectProperties>
</validateThis>