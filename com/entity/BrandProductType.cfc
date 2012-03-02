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
component displayname="Brand Product Type" entityname="SlatwallBrandProductType" table="SlatwallBrandProductType" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="brandProductTypeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Persistent Properties - Inheritence Settings
	property name="allowBackorderFlag" ormtype="boolean";
	property name="allowDropshipFlag" ormtype="boolean";
	property name="allowPreorderFlag" ormtype="boolean";
	property name="allowShippingFlag" ormtype="boolean";
	property name="callToOrderFlag" ormtype="boolean";
	property name="productDisplayTemplate" ormtype="string";
	property name="productTypeDisplayTemplate" ormtype="string";
	property name="quantityHeldBack" ormtype="integer";
	property name="quantityMinimum" ormtype="integer";
	property name="quantityMaximum" ormtype="integer";
	property name="quantityOrderMinimum" ormtype="integer";
	property name="quantityOrderMaximum" ormtype="integer";
	property name="shippingWeight" ormtype="integer";
	property name="shippingWeightUnitCode" ormtype="string";
	property name="trackInventoryFlag" ormtype="boolean";
	
	// Related Object Properties (Many-to-One)
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	
	// Related Object Properties (One-to-Many)
	
	// Related Object Properties (Many-to-Many)
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties



	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}