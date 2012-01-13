<!--- Add logic here to run for Version 1.3 --->
<cfquery name="updateQuantity">
	UPDATE SlatwallOrderDeliveryItem
	SET quantity = quantityDelivered
</cfquery>

<cfquery name="dropQuantityDelivered">
	ALTER TABLE SlatwallOrderDeliveryItem
	DROP COLUMN quantityDelivered
</cfquery>

<cfquery name="updateOrder">
	UPDATE SlatwallOrder
	SET orderTypeID = (SELECT typeID FROM SlatwallType WHERE systemCode = 'otSalesOrder')
	WHERE orderTypeID IS NULL
</cfquery>

<cfquery name="updateOrderItem">
	UPDATE SlatwallOrderItem
	SET orderItemTypeID = (SELECT typeID FROM SlatwallType WHERE systemCode = 'oitSale')
	WHERE orderItemTypeID IS NULL
</cfquery>

<cfquery name="createIndex">
	CREATE UNIQUE INDEX SkuLocation ON SlatwallStock (locationID,skuID)
</cfquery>

