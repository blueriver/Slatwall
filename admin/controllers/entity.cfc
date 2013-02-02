component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {

	property name="accountService" type="any";
	property name="imageService" type="any";
	property name="locationService" type="any";
	property name="measurementService" type="any";
	property name="optionService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService" type="any";
	property name="permissionService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	
	// Account Payment
	public any function createAccountPayment( required struct rc ) {
		param name="rc.accountID" type="string" default="";
		param name="rc.paymentMethodID" type="string" default="";
		
		rc.accountPayment = getAccountService().newAccountPayment();
		rc.account = getAccountService().getAccount( rc.accountID );
		rc.paymentMethod = getPaymentService().getPaymentMethod( rc.paymentMethodID );
		
		rc.edit = true;
	}
	
	// Address Zone Location
	public void function createAddressZoneLocation(required struct rc) {
		editAddressZoneLocation(rc);
	}
	
	public void function editAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		rc.edit=true;
		
		getFW().setView("admin:entity.detailaddresszonelocation");
	}
	
	public void function deleteAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		
		rc.addressZone.removeAddressZoneLocation( rc.addressZoneLocation );
		
		getFW().redirect(action="admin:entity.detailaddresszone", queryString="addressZoneID=#rc.addressZoneID#&messageKeys=admin.setting.deleteaddresszonelocation_success");
	}
	
	// Country
	public void function editCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
		rc.edit = true;
		getFW().setView("admin:entity.detailcountry");
	}
	
	public void function detailCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
	}
	
	
	// Currency
	public void function editCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
		rc.edit = true;
		getFW().setView("admin:entity.detailcurrency");
	}
	
	public void function detailCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
	}
	
	// Measurement Unit
	public void function editMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementService().getMeasurementUnit(rc.unitCode);
		rc.edit = true;
		getFW().setView("admin:entity.detailmeasurementunit");
	}
	
	public void function detailMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementService().getMeasurementUnit(rc.unitCode);
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
		
		getFW().setView("admin:entity.listorder");
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
			getFW().redirect(action='admin:entity.detailOrder', queryString='orderID=#rc.orderID#&messagekeys=admin.order.saveorder_success');	
		}
		
		for( var p in arguments.rc.order.getErrors() ) {
			var thisErrorArray = arguments.order.getErrors()[p];
			for(var i=1; i<=arrayLen(thisErrorArray); i++) {
				showMessage(thisErrorArray[i], "error");
			}
		}
		
		getFW().setView(action='admin:entity.detailOrder');
		arguments.rc.slatAction = 'admin:entity.detailOrder';
		arguments.rc.pageTitle = replace(getHibachiScope().rbKey('admin.define.detail'), "${itemEntityName}", getHibachiScope().rbKey('entity.order'));	
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
	
	// Option
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
	
	// Permission Group
	public void function editPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();

		super.genericEditMethod('PermissionGroup',rc);
	}
	
	public void function createPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();
		
		super.genericCreateMethod('PermissionGroup',rc);
	}
	 
	public void function detailPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();
		
		super.genericDetailMethod('PermissionGroup',rc);
	}
	
	// Product
	public void function createProduct(required struct rc) {
		genericCreateMethod(entityName="Product", rc=arguments.rc);
		getFW().setView("admin:entity.createproduct");
	}
	
	// Promotion
	public void function createPromotion(required struct rc) {
		super.genericCreateMethod('Promotion', rc);
		
		if( rc.promotion.isNew() ) {
			rc.promotionPeriod = getPromotionService().newPromotionPeriod();
		}
	}
	
	// Sku
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
	
	// Stock Adjustment
	public void function createStockAdjustment(required struct rc) {
		param name="rc.stockAdjustmentType" type="string" default="satLocationTransfer";
		
		// Call the generic logic
		genericCreateMethod(entityName="StockAdjustment", rc=arguments.rc);
		
		// Set the type correctly
		rc.stockAdjustment.setStockAdjustmentType( getSettingService().getTypeBySystemCode(rc.stockAdjustmentType) );
	}
	
	// Task
	public void function saveTask(required struct rc){
		rc.runningFlag=false;
		
		super.genericSaveMethod('Task',rc);
	}
	
	// Task Schedule
	public void function saveTaskSchedule(required struct rc){
		
		rc.nextRunDateTime = getScheduleService().getSchedule(rc.schedule.scheduleid).getNextRunDateTime(rc.startDateTime,rc.endDateTime); 	
		
		super.genericSaveMethod('TaskSchedule',rc);
	}
	
}