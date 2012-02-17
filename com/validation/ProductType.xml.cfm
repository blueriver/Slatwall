<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="productTypeName">
			<rule type="required" contexts="save" />
		</property>
		<property name="products">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="childProductTypes">
			<rule type="collectionSize" contexts="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="systemCode">
			<rule type="maxLength" contexts="delete">
				<param name="maxLength" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>