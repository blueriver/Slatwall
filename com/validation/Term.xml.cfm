<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="termName">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
	<property name="termHours">
		<rule type="numeric" contexts="save" />
	</property>
	<property name="termDays">
		<rule type="numeric" contexts="save" />
	</property>
	<property name="termMonths">
		<rule type="numeric" contexts="save" />
	</property>
	<property name="termYears">
		<rule type="numeric" contexts="save" />
	</property>
</validateThis>