/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" accessors="true" output="false" {
	property name="inventoryDAO" type="any";

	// entity will be one of StockReceiverItem, StockPhysicalItem, StrockAdjustmentDeliveryItem, VendorOrderDeliveryItem, OrderDeliveryItem
	public void function createInventory(required any entity) {
		
		switch(entity.getEntityName()) {
			case "SlatwallStockReceiverItem": {
				if(arguments.entity.getStock().getSku().getProduct().getSetting("trackInventoryFlag")) {
					var inventory = this.newInventory();
					inventory.setQuantityIn(arguments.entity.getQuantity());
					inventory.setStock(arguments.entity.getStock());
					inventory.setStockReceiverItem(arguments.entity);
					getDAO().save(inventory);
				}
				break;
			}
			case "SlatwallStockPhysicalItem": {
				break;
			}
			case "SlatwallStrockAdjustmentDeliveryItem": {
				break;
			}
			case "SlatwallVendorOrderDeliveryItem": {
				break;
			}
			case "SlatwallOrderDeliveryItem": {
				if(arguments.entity.getStock().getSku().getProduct().getSetting("trackInventoryFlag")) {
					var inventory = this.newInventory();
					inventory.setQuantityOut(arguments.entity.getQuantityDelivered());
					inventory.setStock(arguments.entity.getStock());
					inventory.setOrderDeliveryItem(arguments.entity);
					getDAO().save(inventory);
				}
				break;
			}
			default: {
				throw("You are trying to create an inventory record for an entity that is not one of the 5 entities that manage inventory.  Those entities are: StockReceiverItem, StockPhysicalItem, StrockAdjustmentDeliveryItem, VendorOrderDeliveryItem, OrderDeliveryItem");
			}
		}
		
	}
}