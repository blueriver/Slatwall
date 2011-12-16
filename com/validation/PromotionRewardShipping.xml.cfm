<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="shippingPercentageOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidShippingPercentageOffValue" />
			</rule>
		</property>
		<property name="shippingAmountOff">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidShippingAmountOffValue" />
			</rule>
		</property>
		<property name="shippingAmount">
			<rule type="numeric" contexts="save" />
			<rule type="custom" contexts="save" failureMessage="You must enter a vaild value for percentage off.">
				<param name="methodName" value="hasValidShippingAmountValue" />
			</rule>
		</property>
	</objectProperties>
</validateThis>