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
component displayname="Stock Adjustment" entityname="SlatwallStockAdjustment" table="SlatwallStockAdjustment" persistent="true" accessors="true" output="false" extends="BaseEntity" {

	// Persistent Properties
	property name="stockAdjustmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="fromLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="fromLocationID";
	property name="toLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="toLocationID";
	property name="stockAdjustmentType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentTypeID";
	property name="stockAdjustmentStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentStatusTypeID";
	
	// Related Object Properties (one-to-many)
	property name="stockAdjustmentItems" singularname="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" inverse="true" cascade="all-delete-orphan";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Stock Adjustment Items (one-to-many)
	public void function addStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.orderItem.setStockAdjustment( this );
	}
	
	public void function removeStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.orderItem.removeStockAdjustment( this );
	}
	
	/************   END Association Management Methods   *******************/
}