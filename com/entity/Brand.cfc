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
component displayname="Brand" entityname="SlatwallBrand" table="SlatwallBrand" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="brandID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="brandName" ormtype="string" validateRequired="true" persistent="true" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" ormtype="string" validateURL="true" persistent="true" hint="This is the Website of the brand";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="products" singularname="product" cfc="Product" fieldtype="one-to-many" fkcolumn="brandID" inverse="true" cascade="all";    
	//property name="brandVendors" singularname="brandVendor" cfc="VendorBrand" fieldtype="one-to-many" fkcolumn="brandID" lazy="extra" inverse="true" cascade="all";
	
	// Calculated Properties
	property name="assignedFlag" type="boolean" formula="SELECT count(sp.productID) from SlatwallProduct sp INNER JOIN SlatwallBrand sb on sp.brandID = sb.brandID where sp.brandID=brandID";
	
	public Brand function init(){
	   // set default collections for association management methods
	   if(isNull(variables.Products))
	       variables.Products = [];
	   return Super.init();
	}
 
 /******* Association management methods for bidirectional relationships **************/
	
	// Products (one-to-many)
	
	public void function addProduct(required Product Product) {
	   arguments.Product.setBrand(this);
	}
	
	public void function removeProduct(required Product Product) {
	   arguments.Product.removeBrand(this);
	}
	
    /************   END Association Management Methods   *******************/
}
