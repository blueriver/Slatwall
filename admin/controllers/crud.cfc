component accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerCRUD" {

	property name="accountService";
	property name="locationService" type="any";
	property name="optionService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService";
	
	
	
	
	
	// fw1 Auto-Injected Service Properties
	
	
	
	property name="UtilityORMService" type="any";
	property name="ImageService" type="any";
	
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:crud.listproduct");
	}
	
	public void function createMerchandiseProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "merchandise";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:crud.listproduct"; 
		rc.saveAction = "admin:crud.saveproduct";
		rc.cancelAction = "admin:crud.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:crud.createproduct");
	}
	
	public void function createSubscriptionProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "subscription";
		
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:crud.listproduct"; 
		rc.saveAction = "admin:crud.saveproduct";
		rc.cancelAction = "admin:crud.listproduct";
				
		rc.edit = true;
		getFW().setView("admin:crud.createproduct");
	}
	
	public void function createContentAccessProduct(required struct rc) {
		rc.product = getProductService().newProduct();
		rc.baseProductType = "contentAccess";
				
		rc.pageTitle = replace(rbKey('admin.define.create'), '${itemEntityName}', rbKey('entity.product')); 
		rc.listAction = "admin:crud.listproduct"; 
		rc.saveAction = "admin:crud.saveproduct";
		rc.cancelAction = "admin:crud.listproduct";
		
		rc.edit = true;
		getFW().setView("admin:crud.createproduct");
	}
	
	public void function createMerchandiseProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "merchandise";
		
		rc.listAction = "admin:crud.listproducttype"; 
		rc.saveAction = "admin:crud.saveproducttype";
		rc.cancelAction = "admin:crud.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:crud.detailproducttype");
	}
	
	public void function createSubscriptionProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "subscription";
		
		rc.listAction = "admin:crud.listproducttype"; 
		rc.saveAction = "admin:crud.saveproducttype";
		rc.cancelAction = "admin:crud.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:crud.detailproducttype");
	}
	
	public void function createContentAccessProductType(required struct rc) {
		rc.producttype = getProductService().newProductType();
		rc.baseProductType = "contentAccess";
		
		rc.listAction = "admin:crud.listproducttype"; 
		rc.saveAction = "admin:crud.saveproducttype";
		rc.cancelAction = "admin:crud.listproducttype";
		
		rc.edit = true;
		getFW().setView("admin:crud.detailproducttype");
	}
	
	public void function saveSku(required struct rc){
		var sku = getSkuService().getSku(rc.skuID,true);
		var imageNameToUse='';
		
		if(structKeyExists(rc,'imageFileUpload') && rc.imageFileUpload != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFileUpload','','makeUnique');
			
			//if overwriting old image, delete image			
			if(len(sku.getImageFile()) && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
				fileDelete(expandpath(sku.getImageDirectory()) & sku.getImageFile());	
			}
			
			
			//set up image name
			if(structKeyExists(rc,'imageExclusive') && rc.imageExclusive){
				if(left(setting('globalImageExtension'),1) eq '.') {
					imageNameToUse = rc.skucode & setting('globalImageExtension');	
				} else {
					imageNameToUse = rc.skucode & '.' & setting('globalImageExtension');
				}
			}else{
				imageNameToUse=sku.getImageFile();
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				if(fileExists(expandpath(sku.getImageDirectory()) & imageNameToUse)){
					fileDelete(expandpath(sku.getImageDirectory()) & imageNameToUse);
				}
				
				if( !directoryExists( replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') )) {
					directoryCreate( replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') );
				}
				
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, replaceNoCase(expandPath(sku.getImageDirectory()), 'index.cfm/', '', 'all') & imageNameToUse);
				
				rc.imageFile = imageNameToUse;
				
			}else{
				fileDelete(documentData.serverDirectory & '/' & documentData.serverFile);	
			}
			
			getImageService().clearImageCache(sku.getImageDirectory(),sku.getImageFile());
			
		}else if(structKeyExists(rc,'deleteImage') && rc.deleteImage && fileExists(expandpath(sku.getImageDirectory()) & sku.getImageFile())){
			// Clear the cache
			getImageService().clearImageCache(sku.getImageDirectory(),sku.getImageFile());
			
			// Delete the file
			fileDelete( expandPath(sku.getImageDirectory()) & sku.getImageFile());
			
			// Set the imageName back to whatever automatically gets generated
			rc.imageFile=sku.generateImageFileName();
		}else{
			
			rc.imageFile = sku.getImageFile();
		}
		
		super.genericSaveMethod('Sku', rc);
	}
	
	public void function saveOption(required struct rc){
		var option = getOptionService().getOption(rc.optionID,true);
		
		if(rc.optionImage != ''){
			var documentData = fileUpload(getTempDirectory(),'optionImage','','makeUnique');
			
			if(len(option.getOptionImage()) && fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
				fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			}
			
			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(option.getImageDirectory()) & documentData.serverFile);
				rc.optionImage = documentData.serverfile;
			}else if (fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
				fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			}
			
		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(option.getImageDirectory()) & option.getOptionImage())){
			fileDelete(expandpath(option.getImageDirectory()) & option.getOptionImage());	
			rc.optionImage='';
		}else{
			rc.optionImage = option.getOptionImage();
		}
		
		super.genericSaveMethod('Option',rc);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// Account Payment
	public any function createAccountPayment( required struct rc ) {
		param name="rc.accountID" type="string" default="";
		param name="rc.paymentMethodID" type="string" default="";
		
		rc.accountPayment = getAccountService().newAccountPayment();
		rc.account = getAccountService().getAccount( rc.accountID );
		rc.paymentMethod = getPaymentService().getPaymentMethod( rc.paymentMethodID );
		
		rc.edit = true;
	}
	
	// Order
	public void function listOrder(required struct rc) {
		genericListMethod(entityName="Order", rc=arguments.rc);
		
		arguments.rc.orderSmartList.addInFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
		
		arguments.rc.orderSmartList.addOrder("orderOpenDateTime|DESC");
	}
	
	public void function listCartAndQuote(required struct rc) {
		genericListMethod(entityName="Order", rc=arguments.rc);
		
		arguments.rc.orderSmartList.addOrder("createdDateTime|DESC");
		arguments.rc.orderSmartList.addInFilter('orderStatusType.systemCode', 'ostNotPlaced');
		
		getFW().setView("admin:crud.listorder");
	}
	
	// Order Item
	public any function createOrderItem(required struct rc) {
		param name="rc.orderID" type="string" default="";
		
		rc.orderItem = getOrderService().newOrderItem();
		rc.order = getOrderService().getOrder(rc.orderID);

	}
	
	public any function addOrderItem(required struct rc) {
		param name="rc.orderID" type="any" default="";
		param name="rc.skuID" type="any" default="";
		param name="rc.quantity" type="any" default="";
		param name="rc.orderFulfillmentID" type="any" default="";
		
		arguments.rc.order = getOrderService().getOrder(arguments.rc.orderID);
		var sku = getSkuService().getSku(arguments.rc.skuID);
		var orderFulfillment = getOrderService().getOrderFulfillment(arguments.rc.orderFulfillmentID);
		
		if(!isNull(orderFulfillment)) {
			getOrderService().addOrderItem(order=arguments.rc.order, sku=sku, quantity=arguments.rc.quantity, orderFulfillment=orderFulfillment);	
		} else {
			getOrderService().addOrderItem(order=arguments.rc.order, sku=sku, quantity=arguments.rc.quantity, data=arguments.rc);
		}
		
		// If no errors redirect to success
		if(!rc.order.hasErrors()) {
			getFW().redirect(action='admin:crud.detailOrder', queryString='orderID=#rc.orderID#&messagekeys=admin.order.saveorder_success');	
		}
		
		for( var p in arguments.rc.order.getErrors() ) {
			var thisErrorArray = arguments.order.getErrors()[p];
			for(var i=1; i<=arrayLen(thisErrorArray); i++) {
				showMessage(thisErrorArray[i], "error");
			}
		}
		
		getFW().setView(action='admin:crud.detailOrder');
		arguments.rc.slatAction = 'admin:crud.detailOrder';
		arguments.rc.pageTitle = replace(rbKey('admin.define.detail'), "${itemEntityName}", rbKey('entity.order'));	
	}

	
	// Order Payment
	public any function createorderpayment( required struct rc ) {
		param name="rc.orderID" type="string" default="";
		param name="rc.paymentMethodID" type="string" default="";
		
		rc.orderPayment = getOrderService().newOrderPayment();
		rc.order = getOrderService().getOrder(rc.orderID);
		rc.paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);
		
		rc.edit = true;
		
	}
	
	// Order Return
	public any function createreturnorder( required struct rc ) {
		param name="rc.originalorderid" type="string" default="";
		
		rc.originalOrder = getOrderService().getOrder(rc.originalOrderID);
		
		rc.edit = true;
	}
	
	// Permission Group
	public void function editPermissionGroup(required struct rc){
		rc.permissions = getPermissionService().getPermissions();
		
		super.genericEditMethod('PermissionGroup',rc);
	}
	
	public void function createPermissionGroup(required struct rc){
		rc.permissions = getPermissionService().getPermissions();
		
		super.genericCreateMethod('PermissionGroup',rc);
	}
	 
	public void function detailPermissionGroup(required struct rc){
		rc.permissions = getPermissionService().getPermissions();
		
		super.genericDetailMethod('PermissionGroup',rc);
	}
	
	// Promotion
	public void function createPromotion(required struct rc) {
		super.genericCreateMethod('Promotion', rc);
		
		if( rc.promotion.isNew() ) {
			rc.promotionPeriod = getPromotionService().newPromotionPeriod();
		}
	}
	
	
}