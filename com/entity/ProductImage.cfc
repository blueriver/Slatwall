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
component displayname="Product Image" entityname="SlatwallProductImage" table="SlatwallImage" persistent="true" extends="Image" discriminatorvalue="product" {
			
	// Related Entities
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
	public any function init() {
		setDirectory("product");
		
		return super.init();
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Product (many-to-one)
	
	
	public void function setProduct(required product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasProductImage(this)) {
			arrayAppend(arguments.product.getProductImages(), this);
		}
	}
	
	public void function removeProduct(required product) {
		var index = arrayFind(arguments.product.getProductImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getProductImages(), index);
		}
		structDelete(variables, "product");
	}
    
	/************   END Association Management Methods   *******************/

	public string function getResizedImagePath(string size, numeric width=0, numeric height=0, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		if(structKeyExists(arguments, "size")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l" || arguments.size eq "large") {
				arguments.size = "large";
			} else if (arguments.size eq "m" || arguments.size eq "medium") {
				arguments.size = "medium";
			} else {
				arguments.size = "small";
			}
			arguments.width = setting("productImage#arguments.size#Width");
			arguments.height = setting("productImage#arguments.size#Height");
		}
		arguments.imagePath = getImagePath();
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}