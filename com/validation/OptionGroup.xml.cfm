<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="optionGroupName">
			<rule type="required" contexts="*" />
		</property>
		<property name="optionGroupCode">
			<rule type="required" contexts="*" />
			<rule type="custom" contexts="*" failureMessage="Option Group Code is Not Unique">
				<param name="methodName" value="hasUniqueOptionGroupCode" />
			</rule>
		</property>
		<property name="options">
			<rule type="collectionSize" context="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>