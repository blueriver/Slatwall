component output="false" accessors="true" extends="HibachiProcess" {

	property name="emailAddress" default="" hb_validationrules="{required=true,inlist=}";
	property name="password" default="";
	property name="statusCode" default="" hb_validationrules="{inlist='ostNotPlaced,ostNew,ostProcessing,ostOnHold',contexts='placeOrder'}";
	
	
	/*
	public any function init() {
		writeDump(getProperties()[1]);
		
		this.validations = {};
		this.validations.emailAddress = [{required=true}];
		this.validations.statusCode = [
			{contexts="placeOrder",inlist="ostNotPlaced"},
			{contexts="addOrderItem",inlist="ostNotPlaced,ostNew,ostProcessing,ostOnHold"},
			{contexts="addOrderPayment,cancelOrder,closeOrder",inlist="ostNew,ostProcessing,ostOnHold"}
		];
	}
	
	
	<property name="orderType">
			<rule type="required" contexts="save" />
		</property>
		<property name="orderStatusType">
			<rule type="required" contexts="save" />
		</property>
		<property name="statusCode">
			<rule type="inList" contexts="placeOrder">
				<param name="list" value="ostNotPlaced" />
			</rule>
			<rule type="inList" contexts="addOrderItem">
				<param name="list" value="ostNotPlaced,ostNew,ostProcessing,ostOnHold" />
			</rule>
			<rule type="inList" contexts="addOrderPayment,cancelOrder,closeOrder">
				<param name="list" value="ostNew,ostProcessing,ostOnHold" />
			</rule>
			<rule type="inList" contexts="createReturn">
				<param name="list" value="ostNew,ostProcessing,ostOnHold,ostClosed" />
			</rule>
			<rule type="inList" contexts="takeOffHold">
				<param name="list" value="ostOnHold" />
			</rule>
			<rule type="inList" contexts="placeOnHold">
				<param name="list" value="ostNew,ostProcessing" />
			</rule>
		</property>
		<property name="quantityDelivered">
			<rule type="max" contexts="cancelOrder">
				<param name="max" value="0" />
			</rule>
			<rule type="min" contexts="createReturn">
				<param name="min" value="1" />
			</rule>
		</property>
		<property name="quantityReceived">
			<rule type="max" contexts="cancelOrder">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="total">
			<rule type="equalTo" contexts="placeOrder">
				<param name="comparePropertyName" value="paymentAmountTotal" />
			</rule>
		</property>	
	
	
	
	
	
	
	
	
	
	<?xml version="1.0" encoding="UTF-8"?>
	<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<contexts>
			<context name="save" />
			<context name="delete" />
			<context name="edit" />
		</contexts>
		<objectProperties>
			<property name="brandName">
				<rule type="required" contexts="save" />
			</property>
			<property name="brandWebsite">
				<rule type="url" contexts="save" />
			</property>
			<property name="urlTitle">
				<rule type="required" contexts="save" />
				<rule type="custom" contexts="save" failureMessage="URL Title is Not Unique">
					<param name="methodName" value="hasUniqueURLTitle" />
				</rule>
			</property>
			<property name="products">
				<rule type="collectionSize" contexts="delete">
					<param name="max" value="0" />
				</rule>
			</property>
		</objectProperties>
	</validateThis>
	*/
	
}