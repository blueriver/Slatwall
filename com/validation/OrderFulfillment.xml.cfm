<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="fulfilmentTypeShipping" serverTest="getFulfillmentMethodType() EQ 'shipping'" />
	</conditions>
	<contexts>
		<context name="save" />
		<context name="delete" />
		<context name="placeOrder" />
		<context name="fulfillItems" />
	</contexts>
	<objectProperties>
		<property name="orderFulfillmentItems">
			<rule type="collectionSize" contexts="save,placeOrder,fufillItems">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="quantityUndelivered">
			<rule type="collectionSize" contexts="fufillItems">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="address">
			<rule type="required" condition="fulfillmentTypeShipping" />
		</property>
		<property name="shippingMethod">
			<rule type="required" condition="fulfillmentTypeShipping" />
			<rule type="custom" condition="fulfillmentTypeShipping">
				<param name="methodName" value="hasValidShippingMethodRate" /> 
			</rule>
		</property>
	</objectProperties>
</validateThis>