<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="orderDeliveryItems">
			<rule type="collectionSize" contexts="save">
				<param name="min" value="1" />
			</rule>
		</property>
	</objectProperties>
</validateThis>