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
component displayname="Product Relationship" entityname="SlatwallProductRelationship" table="SlatwallProductRelationship" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="productRelationshipID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="relationshipType" cfc="Type" fieldtype="many-to-one" fkcolumn="relationshipTypeID";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
	// Related Object Properties (many-to-many)
	property name="relatedProductTypes" singularname="relatedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallProductRelationshipProductType" fkcolumn="productRelationshipID" inversejoincolumn="productTypeID" cascade="save-update";
	property name="relatedProducts" singularname="relatedProduct" cfc="Product" fieldtype="many-to-many" linktable="SlatwallProductRelationshipProduct" fkcolumn="productRelationshipID" inversejoincolumn="productID" cascade="save-update";
	property name="relatedSkus" singularname="relatedSku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallProductRelationshipSku" fkcolumn="productRelationshipID" inversejoincolumn="skuID" cascade="save-update";
	

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
