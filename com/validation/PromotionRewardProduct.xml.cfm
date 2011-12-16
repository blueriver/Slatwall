<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="itemRewardQuantity">
			<rule type="numeric" contexts="save" />
		</property>
		<property name="itemPercentageOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidItemPercentageOffValue" />
			</rule>
		</property>
		<property name="itemAmountOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for amount off.">
				<param name="methodName" value="hasValidItemAmountOffValue" />
			</rule>
		</property>
		<property name="itemAmount">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for amount.">
				<param name="methodName" value="hasValidItemAmountValue" />
			</rule>
		</property>
	</objectProperties>
</validateThis>