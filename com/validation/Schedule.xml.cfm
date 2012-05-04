<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="scheduleName">
			<rule type="required" contexts="save" />
		</property>
		<property name="recuringType">
			<rule type="required" contexts="save" />
		</property>
		<property name="frequencyInterval">
			<rule type="required" contexts="save" />
		</property>
		<property name="frequencyStartTime">
			<rule type="required" contexts="save" />
		</property>
		<property name="frequencyEndTime">
			<rule type="required" contexts="save" />
		</property>
	</objectProperties>
</validateThis>