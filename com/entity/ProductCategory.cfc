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
component displayname="Product Category" entityname="SlatwallProductCategory" table="SlatwallProductCategory" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="productCategoryID" ormtype="string" length="35" fieldtype="id" generator="uuid";
	property name="categoryID" ormtype="string" length="35";
	property name="categoryPath" ormtype="string";
	property name="featuredFlag" ormType="boolean" default="false";
	 
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Product (many-to-one)
	
	public void function setProduct(required Product Product) {
	   variables.product = arguments.Product;
	   if(isNew() or !arguments.Product.hasProductCategory(this)) {
	       arrayAppend(arguments.Product.getProductCategories(),this);
	   }
	}
	
	public void function removeProduct(required Product Product) {
       var index = arrayFind(arguments.Product.getProductCategories(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Product.getProductCategories(),index);
       }    
       entityDelete(this);
    }
    
	/************   END Association Management Methods   *******************/
		
}
