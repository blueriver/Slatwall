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
component displayname="Product Cache" entityname="SlatwallProductCache" table="SlatwallProductCache" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Related Object Properties (Many-to-One)
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="foreign" params="{property='product'}";
	property name="product" fieldtype="one-to-one" cfc="Product" constrained="true";
	
	// Persistent Properties
	property name="skuImageFileList" ormtype="string" length="4000";
	
	// Persistent Properties (Calculations)
	property name="salePrice" ormtype="big_decimal" default=0;
	property name="salePriceExpirationDateTime" ormtype="timestamp";
	property name="qoh" ormtype="integer" default=0;
	property name="qosh" ormtype="integer" default=0;
	property name="qndoo" ormtype="integer" default=0;
	property name="qndorvo" ormtype="integer" default=0;
	property name="qndosa" ormtype="integer" default=0;
	property name="qnroro" ormtype="integer" default=0;
	property name="qnrovo" ormtype="integer" default=0;
	property name="qnrosa" ormtype="integer" default=0;
	property name="qats" ormtype="integer" default=0;
	property name="qiats" ormtype="integer" default=0;
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="modifiedDateTime" ormtype="timestamp";
	
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