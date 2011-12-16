<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="HasPercentageOff" 
			serverTest="getType() EQ 'percentageOff'"
			clientTest="" />
			
		<condition name="HasAmountOff" 
			serverTest="getType() EQ 'amountOff'"
			clientTest="" />
			
		<condition name="HasAmount" 
			serverTest="getType() EQ 'amount'"
			clientTest="" />
			
		<condition name="isNotGlobal" 
			serverTest="getGlobalFlag() EQ 0"
			clientTest="" />
			
		<!--<condition name="HasNoIncludesButIsNotGlobal" 
			serverTest="getGlobalFlag() EQ 0 AND ((ArrayLen(getProducts()) + ArrayLen(getProductTypes()) + ArrayLen(getSkus())) EQ 0)"
			clientTest="" />-->	
			
	</conditions>
	
	<objectProperties>
		<property name="priceGroup">
			<rule type="required" contexts="save" />
		</property>
		
		<property name="percentageOff">
			<rule type="numeric" contexts="save" condition="HasPercentageOff" />
			<rule type="required" contexts="save" condition="HasPercentageOff" failureMessage="You must define a numeric value for percentage off (between 0 and 100)." />
			<rule type="rangelength" contexts="save" condition="HasPercentageOff">
				<param name="minlength" value="0" />
				<param name="maxlength" value="100" />
			</rule>
		</property>
		
		<property name="amountOff">
			<rule type="numeric" contexts="save" condition="HasAmountOff" />
			<rule type="required" contexts="save" condition="HasAmountOff" failureMessage="You must define a numeric value for amount off."/>
		</property>
		
		<property name="amount">
			<rule type="numeric" contexts="save" condition="HasAmount" />
			<rule type="required" contexts="save" condition="HasAmount" failureMessage="You must define a numeric value for amount."/>
		</property>
		
		<!--<property name="productTypes">
			<rule type="required" condition="HasNoIncludesButIsNotGlobal" failureMessage="You require at least one product or product type in this non-global rate."/>
			<rule type="collectionSize" contexts="*" condition="HasNoIncludesButIsNotGlobal" failureMessage="You require at least one product or product type in this non-global rate.">
				<param name="min" value="1" />
			</rule>
		</property>-->
	</objectProperties>
</validateThis>