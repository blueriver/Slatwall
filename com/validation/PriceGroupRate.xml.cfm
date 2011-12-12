<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="MustHavePercentageOff" 
			serverTest="false"
			clientTest="" />
	</conditions>
	
	<objectProperties>
		<property name="priceGroup">
			<rule type="required" contexts="*" />
		</property>
		<property name="percentageOff">
			<rule type="numeric" />
			<rule type="required" condition="MustHavePercentageOff"
				failureMessage="You must define a numeric value for percentage off.">
			</rule>
		</property>
	</objectProperties>
</validateThis>