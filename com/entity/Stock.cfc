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
component displayname="Stock" entityname="SlatwallStock" table="SlatwallStock" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="stockID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="location" fieldtype="many-to-one" fkcolumn="locationID" cfc="Location";
	property name="sku" fieldtype="many-to-one" fkcolumn="skuID" cfc="Sku";
	
	// Related Object Properties (one-to-many). Including this property to allow HQL to do  stock -> vendorOrderItem lookups
	property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" fieldtype="one-to-many" fkcolumn="stockID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Quantity Properties For On Hand & Inventory in Motion (Deligated to the DAO)
	property name="qoh" type="numeric" persistent="false" hint="Quantity On Hand";
	property name="qosh" type="numeric" persistent="false" hint="Quantity On Stock Hold";
	property name="qndoo" type="numeric" persistent="false" hint="Quantity Not Delivered On Order";
	property name="qndorvo" type="numeric" persistent="false" hint="Quantity Not Delivered On Return Vendor Order";
	property name="qndosa" type="numeric" persistent="false" hint="Quantity Not Delivered On Stock Adjustment";
	property name="qnroro" type="numeric" persistent="false" hint="Quantity Not Received On Return Order";
	property name="qnrovo" type="numeric" persistent="false" hint="Quantity Not Received On Vendor Order";
	property name="qnrosa" type="numeric" persistent="false" hint="Quantity Not Received On Stock Adjustment";
	
	// Non-Persistent Quantity Properties For Reporting (Deligated to DAO)
	property name="qr" type="numeric" persistent="false" hint="Quantity Received";
	property name="qs" type="numeric" persistent="false" hint="Quantity Sold";
	
	// Non-Persistent Quantity Properties For Logic & Display Based on On Hand & Inventory in Motion values (Could be calculated here, but delegated to the Service, for Consitency of Product / Sku / Stock)
	property name="qc" type="numeric" persistent="false" hint="Quantity Commited";
	property name="qe" type="numeric" persistent="false" hint="Quantity Expected";
	property name="qnc" type="numeric" persistent="false" hint="Quantity Not Commited";
	property name="qats" type="numeric" persistent="false" hint="Quantity Available To Sell";
	property name="qiats" type="numeric" persistent="false" hint="Quantity Immediately Available To Sell";
	
	// Non-Persistent Quantity Properties For Settings (Because these can be defined in multiple locations it is delectaed to the Service)
	property name="qmin" type="numeric" persistent="false" hint="Quantity Minimum";
	property name="qmax" type="numeric" persistent="false" hint="Quantity Maximum";
	property name="qhb" type="numeric" persistent="false" hint="Quantity Held Back";
	property name="qomin" type="numeric" persistent="false" hint="Quantity Order Minimum";
	property name="qomax" type="numeric" persistent="false" hint="Quantity Order Maximum";
	property name="qvomin" type="numeric" persistent="false" hint="Quantity Vendor Order Minimum";
	property name="qvomax" type="numeric" persistent="false" hint="Quantity Vendor Order Maximum";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// Non-Persistent Quantity Properties For On Hand & Inventory in Motion (Deligated to the DAO)
	public numeric function getQOH() {
		if(!structKeyExists(variables, "qoh")) {
			variables.qoh = getService("inventoryService").getQOH(stockID=getStockID());
		}
		return variables.qoh;
	}
	public numeric function getQOSH() {
		if(!structKeyExists(variables, "qosh")) {
			variables.qosh = getService("inventoryService").getQOSH(stockID=getStockID());
		}
		return variables.qosh;
	}
	public numeric function getQNDOO() {
		if(!structKeyExists(variables, "qndoo")) {
			variables.qndoo = getService("inventoryService").getQNDOO(stockID=getStockID());
		}
		return variables.qndoo;
	}
	public numeric function getQNDORVO() {
		if(!structKeyExists(variables, "qndorvo")) {
			variables.qndorvo = getService("inventoryService").getQNDORVO(stockID=getStockID());
		}
		return variables.qoh;
	}
	public numeric function getQNDOSA() {
		if(!structKeyExists(variables, "qndosa")) {
			variables.qndosa = getService("inventoryService").getQNDOSA(stockID=getStockID());
		}
		return variables.qndosa;
	}
	public numeric function getQNRORO() {
		if(!structKeyExists(variables, "qnroro")) {
			variables.qnroro = getService("inventoryService").getQNRORO(stockID=getStockID());
		}
		return variables.qnroro;
	}
	public numeric function getQNROVO() {
		if(!structKeyExists(variables, "qnrovo")) {
			variables.qnrovo = getService("inventoryService").getQNROVO(stockID=getStockID());
		}
		return variables.qnrovo;
	}
	public numeric function getQNROSA() {
		if(!structKeyExists(variables, "qnrosa")) {
			variables.qnrosa = getService("inventoryService").getQNROSA(stockID=getStockID());
		}
		return variables.qnrosa;
	}
	
	// Non-Persistent Quantity Properties For Reporting (Deligated to DAO)
	public numeric function getQR() {
		if(!structKeyExists(variables, "qr")) {
			variables.qr = getService("inventoryService").getQR(stockID=getStockID());
		}
		return variables.qr;
	}
	public numeric function getQS() {
		if(!structKeyExists(variables, "qs")) {
			variables.qs = getService("inventoryService").getQS(stockID=getStockID());
		}
		return variables.qs;
	}
	
	// Non-Persistent Quantity Properties For Logic & Display Based on On Hand & Inventory in Motion values (Could be calculated here, but delegated to the Service, for Consitency of Product / Sku / Stock)
	public numeric function getQC() {
		if(!structKeyExists(variables, "qc")) {
			variables.qc = getService("inventoryService").getQC(entity=this);
		}
		return variables.qc;
	}
	public numeric function getQE() {
		if(!structKeyExists(variables, "qe")) {
			variables.qe = getService("inventoryService").getQE(entity=this);
		}
		return variables.qe;
	}
	public numeric function getQNC() {
		if(!structKeyExists(variables, "qnc")) {
			variables.qnc = getService("inventoryService").getQNC(entity=this);
		}
		return variables.qnc;
	}
	public numeric function getQATS() {
		if(!structKeyExists(variables, "qats")) {
			variables.qats = getService("inventoryService").getQATS(entity=this);
		}
		return variables.qats;
	}
	public numeric function getQIATS() {
		if(!structKeyExists(variables, "qiats")) {
			variables.qiats = getService("inventoryService").getQIATS(entity=this);
		}
		return variables.qiats;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Vendor Order Items (one-to-many)
	public void function addVendorOrderItem(required any vendorOrderItem) {
		arguments.vendorOrderItem.setStock( this );
	}
	public void function removeVendorOrderItem(required any vendorOrderItem) {
		arguments.vendorOrderItem.removeStock( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
