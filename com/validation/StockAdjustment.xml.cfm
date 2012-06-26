<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="shouldHaveFromLocation" serverTest="getStockAdjustmentType().getSystemCode() EQ 'satLocationTransfer' OR getStockAdjustmentType().getSystemCode() EQ 'satManualOut'" />
		<condition name="shouldHaveToLocation" serverTest="getStockAdjustmentType().getSystemCode() EQ 'satLocationTransfer' OR getStockAdjustmentType().getSystemCode() EQ 'satManualIn'" />	
	</conditions>
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="edit" />
	</contexts>
	<objectProperties>
		<property name="stockAdjustmentType">
			<rule type="required" contexts="save" />
		</property>
		<property name="stockAdjustmentStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="fromLocation">
			<rule type="required" contexts="save" condition="shouldHaveFromLocation" />
		</property>
		<property name="toLocation">
			<rule type="required" contexts="save" condition="shouldHaveToLocation" />
		</property>
	</objectProperties>
</validateThis>