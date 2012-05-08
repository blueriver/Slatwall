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
component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="any";
	property name="SkuService" type="any";
	property name="OptionService" type="any";
	property name="UtilityORMService" type="any";
	
	this.publicMethods='';
	this.secureMethods='listproduct,editproduct,detailproduct,deleteProduct,saveproduct,listProductType,editProductType,detailProductType,deleteProductType,saveProductType,listOptionGroup,editOptionGroup,detailOptionGroup,deleteOptionGroup,saveOptionGroup,listBrand,editBrand,detailBrand,deleteBrand,saveBrand,listSubscriptionTerm,editSubscriptionTerm,detailSubscriptionTerm,deleteSubscriptionTerm,saveSubscriptionTerm,listSubscriptionBenefit,editSubscriptionBenefit,detailSubscriptionBenefit,deleteSubscriptionBenefit,saveSubscriptionBenefit,listProductReview,editProductReview,detailProductReview,deleteProductReview,saveProductReview';
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:product.listproduct");
	}
	
	public void function createMerchandiseProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "merchandise";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createSubscriptionProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "subscription";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
				
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createContentAccessProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "contentAccess";
				
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:product.listproduct"; 
		rc.saveAction = "admin:product.saveproduct";
		rc.cancelAction = "admin:product.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:product.createproduct");
	}
	
	public void function createMerchandiseProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "merchandise";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function createSubscriptionProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "subscription";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function createContentAccessProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "contentAccess";
		
		rc.listAction = "admin:product.listproducttype"; 
		rc.saveAction = "admin:product.saveproducttype";
		rc.cancelAction = "admin:product.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:product.detailproducttype");
	}
	
	public void function saveSku(required struct rc){
		var sku = getSkuService().getSku(rc.skuID,true);
		
		if(rc.imageFile != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFile','','makeUnique');
			
			if(len(sku.getImageFile()) && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
				fileDelete(expandpath(sku.getImageDirectory()) & sku.getImageFile());	
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(sku.getImageDirectory()) & documentData.serverFile);
				rc.imageFile = documentData.serverfile;
			}else if(fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
				fileDelete(expandpath(sku.getImageDirectory()) & sku.getImageFile());	
			}
			
		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
			fileDelete(expandpath(sku.getImageDirectory()) & sku.getImageFile());	
			rc.imageFile='';
		}else{
			rc.imageFile = sku.getImageFile();
		}
		
		super.genericSaveMethod('Sku',rc);
	}
	
	public void function saveProductImage(required struct rc){
		var entityService = getUtilityORMService().getServiceByEntityName( entityName='ProductImage' );
		var productImage = entityService.getProductImage(rc.ImageID,true);
		
		if(rc.imageFile != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFile','','makeUnique');
			
			if(len(productImage.getImageFile()) && fileExists(expandpath(productImage.getImageDirectory()) & productImage.getImageFile())){
				fileDelete(expandpath(productImage.getImageDirectory()) & productImage.getImageFile());	
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(productImage.getImageDirectory()) & documentData.serverFile);
				rc.imageFile = documentData.serverfile;
			}else if (fileExists(expandpath(productImage.getImageDirectory()) & productImage.getImageFile())){
				fileDelete(expandpath(productImage.getImageDirectory()) & productImage.getImageFile());	
			}
			
		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(productImage.getImageDirectory()) & productImage.getImageFile())){
			fileDelete(expandpath(productImage.getImageDirectory()) & productImage.getImageFile());	
			rc.imageFile='';
		}else{
			rc.imageFile = productImage.getImageFile();
		}
		
		super.genericSaveMethod('ProductImage',rc);
	}
}