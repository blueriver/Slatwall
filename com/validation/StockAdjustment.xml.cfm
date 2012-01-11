<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="ShouldHaveFromLocation" serverTest="getStockAdjustmentType().getSystemCode() EQ 'satLocationTransfer' OR getStockAdjustmentType().getSystemCode() EQ 'satManualOut'" />
		<condition name="ShouldHaveToLocation" serverTest="getStockAdjustmentType().getSystemCode() EQ 'satLocationTransfer' OR getStockAdjustmentType().getSystemCode() EQ 'satManualIn'" />	
	</conditions>
	
	<objectProperties>
		<property name="stockAdjustmentType">
			<rule type="required" contexts="save" />
		</property>
		<property name="stockAdjustmentStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="fromLocation">
			<rule type="required" contexts="save" condition="ShouldHaveFromLocation" />
		</property>
		<property name="toLocation">
			<rule type="required" contexts="save" condition="ShouldHaveToLocation" />
		</property>
	</objectProperties>
</validateThis>