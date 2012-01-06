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
component displayname="Stock Receiver Item" entityname="SlatwallStockReceiverItem" table="SlatwallStockReceiverItem" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="stockReceiverItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	property name="cost" ormtype="big_decimal";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	
	// Related Object Properties (many-to-one)
	property name="stock" fieldtype="many-to-one" fkcolumn="stockID" cfc="Stock";
	property name="stockReceiver" fieldtype="many-to-one" fkcolumn="stockReceiverID" cfc="StockReceiver";
	
	
	// Maintain bidirectional relationships (many-to-one). Notice that the child (StockReceiverItem) is the handler of the relationship, while the parent (StockReceiver), has inverse="true".
	public void function setStockReceiver(required any stockReceiver) {
	   variables.stockReceiver = arguments.stockReceiver;
	   
	   //logSlatwall("About to append stock receiver item: #this.getStockReceiverItemId()# - isNew(): #isNew()# - #!arguments.stockReceiver.hasStockReceiverItem(this)#");
	   if(isNew() || !arguments.stockReceiver.hasStockReceiverItem(this)) {
	       arrayAppend(arguments.stockReceiver.getStockReceiverItems(), this);
	   }
	}
	
	public void function removeStockReceiver() {
       var index = arrayFind(variables.stockReceiver.getStockReceiverItems(), this);
       if(index > 0) {
           arrayDeleteAt(variables.stockReceiver.getStockReceiverItems(), index);
       }
       structDelete(variables,"stockReceiver");
    }
    
    //  -------------------- ORM Event Metods -------------------
	public void function preInsert(){
		getService("inventoryService").createInventory( this );
		super.preInsert();
	}
	
	public void function preUpdate(Struct oldData){
		throw("Updates to Stock Receiver Items are not allowed because this illustrates a fundimental flaw in inventory tracking.");
	}
	//  -------------------- END: ORM Event Metods -------------------
    
}