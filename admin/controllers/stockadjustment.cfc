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

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="stockService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="typeService" type="any";
	property name="productService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:stockadjustment.listStockAdjustments");
	}
	
	public void function listStockAdjustments(required struct rc) {
        param name="rc.orderBy" default="stockAdjustmentId|ASC";
        rc.stockAdjustmentSmartList = getStockService().getStockAdjustmentSmartList(data=arguments.rc);  
    }

    public void function initStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	rc.stockAdjustment = getStockService().getStockAdjustment(rc.stockAdjustmentID, true);
    	
    	// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");
		
		rc.stockAdjustmentTypeSmartList = getTypeService().getTypeSmartList();
		rc.stockAdjustmentTypeSmartList.addSelect(propertyIdentifier="type", alias="name");
		rc.stockAdjustmentTypeSmartList.addSelect(propertyIdentifier="typeID", alias="value");
		rc.stockAdjustmentTypeSmartList.addFilter(propertyIdentifier="parentType_systemCode", value="stockAdjustmentType"); 
		rc.stockAdjustmentTypeSmartList.addOrder("type|ASC");
		
		rc.productSmartList = getProductService().getSmartList("Product");
		rc.productSmartList.addSelect(propertyIdentifier="productName", alias="name");
		rc.productSmartList.addSelect(propertyIdentifier="productID", alias="value");
	}

    public void function createStockAdjustment(required struct rc) {
    	initStockAdjustment(rc);
    	
    	rc.edit = true;
		rc.itemTitle = rc.StockAdjustment.isNew() ? rc.$.Slatwall.rbKey("admin.stockadjustment.createStockAdjustment") : rc.$.Slatwall.rbKey("admin.stockadjustment.editStockAdjustment") & rc.$.Slatwall.rbKey("admin.stockadjustment.typeName_#rc.stockadjustment.getReceiverType()#");
		getFW().setView(action="admin:stockadjustment.detailstockadjustment");
	}
	
	public void function detailStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	initStockAdjustment(rc);

    	rc.edit = false; 
    	getFW().setView("admin:stockadjustment.detailstockadjustment");  
	}
    
	public void function editStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	initStockAdjustment(rc);
    	
    	rc.edit = true; 
    	getFW().setView("admin:stockadjustment.detailstockadjustment");  
	}
	

	public void function saveStockAdjustment(required struct rc) {
		param name="productId";
		initStockAdjustment(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		var wasNew = rc.stockAdjustment.isNew();
		//dumpScreen(rc);
		rc.stockAdjustment = getStockService().saveStockAdjustment(rc.stockAdjustment, rc);

		if(!rc.stockAdjustment.hasErrors()) {
			if(wasNew) { 
				rc.message=rbKey("admin.stockadjustment.savestockadjustment_successnowadditems");
				getFW().redirect(action="admin:stockAdjustment.editStockAdjustment", querystring="stockAdjustmentID=#rc.stockAdjustment.getStockAdjustmentID()#", preserve="message");
			} else {
				rc.message=rbKey("admin.stockadjustment.savestockadjustment_success");
				getFW().redirect(action="admin:stockAdjustment.listStockAdjustments", preserve="message");
			}		
		} else { 			
			rc.edit = true;
			rc.itemTitle = rc.StockAdjustment.isNew() ? rc.$.Slatwall.rbKey("admin.stockadjustment.createStockAdjustment") : rc.$.Slatwall.rbKey("admin.stockadjustment.editStockAdjustment");
			getFW().setView(action="admin:stockadjustment.detailstockadjustment");
		}		
	}
	
	public void function saveStockAdjustmentItems(required struct rc) {
		param name="productId";
		param name="stockAdjustmentId";
		initStockAdjustment(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		var wasNew = rc.stockAdjustment.isNew();
		//dumpScreen(rc);
		rc.stockAdjustment = getStockService().saveStockAdjustment(rc.stockAdjustment, rc);
		rc.product = getProductService().getProduct(rc.productID);
		
		// Assign StockAdjustmentItems. Look over all product skus and get the quantity from the rc
		for(var i=1; i <= ArrayLen(rc.product.getSkus()); i++) {
			var sku = rc.product.getSkus()[i];
			var qty = rc["qty_skuid(#sku.getSkuID()#)"];
			
			// First, see if we already have a StockAdjustmentItem for this Sku
			var stockAdjustmentItem = rc.StockAdjustment.getStockAdjustmentItemForSku(sku);
			
			if(isNumeric(qty) && qty > 0) {
				
				if(stockAdjustmentItem.isNew()) {
					stockAdjustmentItem.setStockAdjustment(rc.stockAdjustment);

					if(rc.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || rc.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satManualIn") {
						var stock = getStockService().getStockBySkuAndLocation(sku, rc.stockAdjustment.getToLocation());
						stockAdjustmentItem.setToStock(stock);	
					}
					
					if(rc.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || rc.stockAdjustment.getStockAdjustmentType().getSystemCode() == "satManualOut") {
						var stock = getStockService().getStockBySkuAndLocation(sku, rc.stockAdjustment.getFromLocation());
						stockAdjustmentItem.setFromStock(stock);	
					}	
				}
				
				stockAdjustmentItem.setQuantity(qty); 
			} else if(!stockAdjustmentItem.isNew()) {
				// Otherwise, the user specified 0 quantity and this was an existing stock adjustment item, so remove the item!
				rc.StockAdjustment.removeStockAdjustmentItem(stockAdjustmentItem);
			}
		}

		rc.message=rbKey("admin.stockadjustment.savestockadjustment_success");
		getFW().redirect(action="admin:stockAdjustment.editStockAdjustment", querystring="stockAdjustmentID=#rc.stockAdjustment.getStockAdjustmentID()#", preserve="message");
		
	}
	
	public void function processStockAdjustment(required struct rc) {
		param name="stockAdjustmentId";
		initStockAdjustment(rc);

		getStockService().processStockAdjustment(rc.stockAdjustment);
		
		rc.message=rbKey("admin.stockadjustment.processstockadjustment_success");
		getFW().redirect(action="admin:stockAdjustment.listStockAdjustments", preserve="message");
	}
	
	public void function editStockAdjustmentItems(required struct rc) {
		param name="rc.stockAdjustmentId";
		rc.stockAdjustment = getStockService().getStockAdjustment(rc.stockAdjustmentId);

		rc.product = getProductService().getProduct(rc.productID);
	
		getFW().setView(action="admin:stockAdjustment.editStockAdjustmentItems");
	}
	
	public void function deleteStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
		rc.stockAdjustment = getStockService().getStockAdjustment(rc.stockAdjustmentID);

    	var deleteOK = getStockService().deleteStockAdjustment(rc.stockAdjustment);
	
		if( deleteOK ) {
			rc.message = rbKey("admin.stockadjustment.deleteStockAdjustment_success");
		} else {
			rc.message = rbKey("admin.stockadjustment.deleteStockAdjustment_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:stockAdjustment.listStockAdjustments", preserve="message,messageType");
	}
	
}
