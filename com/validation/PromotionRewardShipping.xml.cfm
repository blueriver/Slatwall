<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="percentageOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidPercentageOffValue" />
			</rule>
		</property>
		<property name="amountOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidAmountOffValue" />
			</rule>
		</property>
		<property name="amount">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidAmountValue" />
			</rule>
		</property>
	</objectProperties>
</validateThis>