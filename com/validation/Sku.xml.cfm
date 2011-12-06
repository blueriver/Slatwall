<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="price">
			<rule type="required" contexts="*" />
		</property>
		<property name="skuCode">
			<rule type="required" contexts="*" />
			<rule type="custom" contexts="*" failureMessage="Sku Code is Not Unique">
				<param name="methodName" value="hasUniqueSkuCode" />
			</rule>
		</property>
	</objectProperties>
</validateThis>