/*

    Slatwall - An Open Source eCommerce Platform
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
component displayname="Image" entityname="SlatwallImage" table="SlatwallImage" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="imageService" {
			
	// Persistent Properties
	property name="imageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="imageName" ormtype="string";
	property name="imageDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="imageFile" ormtype="string" hb_formFieldType="file" hb_fileUpload="true" hb_fileAcceptMIMEType="image/*" hb_fileAcceptExtension=".jpeg,.jpg,.png,.gif";
	property name="directory" ormtype="string";
	
	// Related entity properties (many-to-one)
	property name="imageType" cfc="Type" fieldtype="many-to-one" fkcolumn="imageTypeID" hb_optionsSmartListData="f:parentType.systemCode=imageType";
	
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	property name="option" cfc="Option" fieldtype="many-to-one" fkcolumn="optionID";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public string function getImageFileUploadDirectory() {
		return setting('globalAssetsImageFolderPath') & "/" & getDirectory();
	}
	
	public string function getImageExtension() {
		return listLast(getImageFile(), ".");
	}
	
	public string function getImagePath() {
		return "#getHibachiScope().getBaseImageURL()#/#getDirectory()#/#getImageFile()#";
	}
	
	public string function getImage() {
		
		// Setup Image Path
		arguments.imagePath = getImagePath();
		
		// Alt Title Setting
		if(!structKeyExists(arguments, "alt") && len(setting('imageAlt'))) {
			arguments.alt = setting('imageAlt');
		}
		
		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}
		
		// DEPRECATED SIZE LOGIC
		if(structKeyExists(arguments, "size") && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l") {
				arguments.size = "Large";
			} else if (arguments.size eq "m") {
				arguments.size = "Medium";
			} else {
				arguments.size = "Small";
			}
			arguments.width = getProduct().setting("productImage#arguments.size#Width");
			arguments.height = getProduct().setting("productImage#arguments.size#Height");
			structDelete(arguments, "size");
		}
		
		return getService("imageService").getImage(argumentCollection=arguments);
	}
	
	public string function getResizedImagePath() {
		
		// Setup Image Path
		arguments.imagePath = getImagePath();
		
		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}
		
		// DEPRECATED SIZE LOGIC
		if(structKeyExists(arguments, "size") && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l") {
				arguments.size = "Large";
			} else if (arguments.size eq "m") {
				arguments.size = "Medium";
			} else {
				arguments.size = "Small";
			}
			arguments.width = getProduct().setting("productImage#arguments.size#Width");
			arguments.height = getProduct().setting("productImage#arguments.size#Height");
			structDelete(arguments, "size");
		}
		
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasProductImage( this )) {
			arrayAppend(arguments.product.getProductImages(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getProductImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getProductImages(), index);
		}
		structDelete(variables, "product");
	}
	
	// Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		if(isNew() or !arguments.promotion.hasPromotionImage( this )) {
			arrayAppend(arguments.promotion.getPromotionImages(), this);
		}
	}
	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, "promotion")) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getPromotionImages(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getPromotionImages(), index);
		}
		structDelete(variables, "promotion");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "imageFile";
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}