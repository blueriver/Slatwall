<cfcomponent accessors="true" extends="Hibachi.HibachiObject">
	
	<cfproperty name="hibachiDAO" type="any">
	
	<!--- Variables Scope Used For Caching --->
	<cfset variables.entityORMMetaDataObjects = {} />
	<cfset variables.entityObjects = {} />
	<cfset variables.entityHasProperty = {} />
	<cfset variables.entityHasAttribute = {} />
	<cfset variables.entityServiceMapping = {} />
	
	<cfset variables.entityServiceMapping["Access"] = "accessService" />
	<cfset variables.entityServiceMapping["Account"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountAddress"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountAuthentication"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountContentAccess"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountEmailAddress"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountPayment"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountPaymentMethod"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountPhoneNumber"] = "accountService" />
	<cfset variables.entityServiceMapping["AccountRelationship"] = "accountService" />
	<cfset variables.entityServiceMapping["Address"] = "addressService" />
	<cfset variables.entityServiceMapping["AddressZone"] = "addressService" />
	<cfset variables.entityServiceMapping["AlternateSkuCode"] = "skuService" />
	<cfset variables.entityServiceMapping["Attribute"] = "attributeService" />
	<cfset variables.entityServiceMapping["AttributeOption"] = "attributeService" />
	<cfset variables.entityServiceMapping["AttributeSet"] = "attributeService" />
	<cfset variables.entityServiceMapping["AttributeValue"] = "attributeService" />
	<cfset variables.entityServiceMapping["Brand"] = "brandService" />
	<cfset variables.entityServiceMapping["Category"] = "contentService" />
	<cfset variables.entityServiceMapping["Comment"] = "commentService" />
	<cfset variables.entityServiceMapping["CommentRelationship"] = "commentService" />
	<cfset variables.entityServiceMapping["Content"] = "contentService" />
	<cfset variables.entityServiceMapping["ContentAccess"] = "accessService" />
	<cfset variables.entityServiceMapping["Country"] = "addressService" />
	<cfset variables.entityServiceMapping["Currency"] = "currencyService" />
	<cfset variables.entityServiceMapping["Email"] = "emailService" />
	<cfset variables.entityServiceMapping["EmailTemplate"] = "emailService" />
	<cfset variables.entityServiceMapping["FulfillmentMethod"] = "fulfillmentService" />
	<cfset variables.entityServiceMapping["Image"] = "imageService" />
	<cfset variables.entityServiceMapping["Integration"] = "integrationService" />
	<cfset variables.entityServiceMapping["Inventory"] = "inventoryService" />
	<cfset variables.entityServiceMapping["Location"] = "locationService" />
	<cfset variables.entityServiceMapping["LocationAddress"] = "locationService" />
	<cfset variables.entityServiceMapping["MeasurementUnit"] = "measurementUnitService" />
	<cfset variables.entityServiceMapping["Option"] = "optionService" />
	<cfset variables.entityServiceMapping["OptionGroup"] = "optionService" />
	<cfset variables.entityServiceMapping["Order"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderDelivery"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderDeliveryItem"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderFulfillment"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderItem"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderItemAppliedTax"] = "taxService" />
	<cfset variables.entityServiceMapping["OrderOrigin"] = "settingService" />
	<cfset variables.entityServiceMapping["OrderPayment"] = "orderService" />
	<cfset variables.entityServiceMapping["OrderReturn"] = "orderService" />
	<cfset variables.entityServiceMapping["PaymentMethod"] = "paymentService" />
	<cfset variables.entityServiceMapping["PaymentTerm"] = "paymentService" />
	<cfset variables.entityServiceMapping["PaymentTransaction"] = "paymentService" />
	<cfset variables.entityServiceMapping["PermissionGroup"] = "accountService" />
	<cfset variables.entityServiceMapping["PostalCode"] = "addressService" />
	<cfset variables.entityServiceMapping["PriceGroup"] = "priceGroupService" />
	<cfset variables.entityServiceMapping["PriceGroupRate"] = "priceGroupService" />
	<cfset variables.entityServiceMapping["Product"] = "productService" />
	<cfset variables.entityServiceMapping["ProductImage"] = "imageService" />
	<cfset variables.entityServiceMapping["ProductReview"] = "productService" />
	<cfset variables.entityServiceMapping["ProductType"] = "productService" />
	<cfset variables.entityServiceMapping["Promotion"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionApplied"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionCode"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionImage"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionPeriod"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionQualifier"] = "promotionService" />
	<cfset variables.entityServiceMapping["PromotionReward"] = "promotionService" />
	<cfset variables.entityServiceMapping["RoundingRule"] = "roundingRuleService" />
	<cfset variables.entityServiceMapping["Schedule"] = "scheduleService" />
	<cfset variables.entityServiceMapping["Session"] = "sessionService" />
	<cfset variables.entityServiceMapping["Setting"] = "settingService" />
	<cfset variables.entityServiceMapping["ShippingMethod"] = "shippingService" />
	<cfset variables.entityServiceMapping["ShippingMethodOption"] = "shippingService" />
	<cfset variables.entityServiceMapping["ShippingMethodRate"] = "shippingService" />
	<cfset variables.entityServiceMapping["Site"] = "siteService" />
	<cfset variables.entityServiceMapping["Sku"] = "skuService" />
	<cfset variables.entityServiceMapping["SkuCurrency"] = "skuService" />
	<cfset variables.entityServiceMapping["State"] = "addressService" />
	<cfset variables.entityServiceMapping["Stock"] = "stockService" />
	<cfset variables.entityServiceMapping["StockAdjustment"] = "stockService" />
	<cfset variables.entityServiceMapping["StockAdjustmentDelivery"] = "stockService" />
	<cfset variables.entityServiceMapping["StockAdjustmentDeliveryItem"] = "stockService" />
	<cfset variables.entityServiceMapping["StockAdjustmentItem"] = "stockService" />
	<cfset variables.entityServiceMapping["StockHold"] = "stockService" />
	<cfset variables.entityServiceMapping["StockReceiver"] = "stockService" />
	<cfset variables.entityServiceMapping["StockReceiverItem"] = "stockService" />
	<cfset variables.entityServiceMapping["SubscriptionBenefit"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionOrderItem"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionStatus"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionTerm"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionUsage"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionUsageBenefit"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["SubscriptionUsageBenefitAccount"] = "subscriptionService" />
	<cfset variables.entityServiceMapping["Task"] = "scheduleService" />
	<cfset variables.entityServiceMapping["TaskHistory"] = "scheduleService" />
	<cfset variables.entityServiceMapping["TaskSchedule"] = "scheduleService" />
	<cfset variables.entityServiceMapping["TaxApplied"] = "taxService" />
	<cfset variables.entityServiceMapping["TaxCategory"] = "taxService" />
	<cfset variables.entityServiceMapping["TaxCategoryRate"] = "taxService" />
	<cfset variables.entityServiceMapping["Term"] = "termService" />
	<cfset variables.entityServiceMapping["Type"] = "typeService" />
	<cfset variables.entityServiceMapping["UpdateScript"] = "updateService" />
	<cfset variables.entityServiceMapping["Vendor"] = "vendorService" />
	<cfset variables.entityServiceMapping["VendorAccount"] = "vendorService" />
	<cfset variables.entityServiceMapping["VendorAddress"] = "vendorService" />
	<cfset variables.entityServiceMapping["VendorEmailAddress"] = "vendorService" />
	<cfset variables.entityServiceMapping["VendorOrder"] = "vendorOrderService" />
	<cfset variables.entityServiceMapping["VendorOrderItem"] = "vendorOrderService" />
	<cfset variables.entityServiceMapping["VendorPhoneNumber"] = "vendorService" />
	<cfset variables.entityServiceMapping["VendorSkuStock"] = "vendorService" />
	
	
	<cfscript>
		public struct function getEntityServiceMapping() {
			return variables.entityServiceMapping;
		}
		
		
		public any function get(required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			return getHibachiDAO().get(argumentcollection=arguments);
		}
	
		public any function list(required string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
			return getHibachiDAO().list(argumentcollection=arguments);
		}
	
		public any function new(required string entityName ) {
			return getHibachiDAO().new(argumentcollection=arguments);
		}
	
		public any function count(required string entityName ) {
			return getHibachiDAO().count(argumentcollection=arguments);
		}
	
		public any function getSmartList(string entityName, struct data={}){
			var smartList = getHibachiDAO().getSmartList(argumentcollection=arguments);
			
			if(structKeyExists(arguments.data, "keyword") || structKeyExists(arguments.data, "keywords")) {
				var example = this.new(arguments.entityName);
				smartList.addKeywordProperty(propertyIdentifier=example.getSimpleRepresentationPropertyName(), weight=1);
			}
			
			return smartList;
		}
		
		public boolean function delete(required any entity){
			
			// If the entity Passes validation
			if(arguments.entity.isDeletable()) {
				
				// Remove any Many-to-Many relationships
				arguments.entity.removeAllManyToManyRelationships();
				
				getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
				
				// Call delete in the DAO
				getHibachiDAO().delete(target=arguments.entity);
				
				// Return that the delete was sucessful
				return true;
				
			}
				
			// Setup ormHasErrors because it didn't pass validation
			getSlatwallScope().setORMHasErrors( true );
	
			return false;
		}
		
		public boolean function process(required any entity, required string processContext=""){
			
			// If the entity Passes validation
			if(arguments.entity.isDeletable()) {
				
				// Remove any Many-to-Many relationships
				arguments.entity.removeAllManyToManyRelationships();
				
				getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
				
				// Call delete in the DAO
				getHibachiDAO().delete(target=arguments.entity);
				
				// Return that the delete was sucessful
				return true;
				
			}
				
			// Setup ormHasErrors because it didn't pass validation
			getSlatwallScope().setORMHasErrors( true );
	
			return false;
		}
		
		
		// @hint the default save method will populate, validate, and if not errors delegate to the DAO where entitySave() is called.
	    public any function save(required any entity, struct data, string context="save") {
	    	
	    	if(!isObject(arguments.entity) || !arguments.entity.isPersistent()) {
	    		throw("The entity being passed to this service is not a persistent entity. READ THIS!!!! -> Make sure that you aren't calling the oMM method with named arguments. Also, make sure to check the spelling of your 'fieldname' attributes.");
	    	}
	    	
			// If data was passed in to this method then populate it with the new data
	        if(structKeyExists(arguments,"data")){
	        	
	        	// Populate this object
				arguments.entity.populate(argumentCollection=arguments);
	
			    // Validate this object now that it has been populated
			    arguments.entity.validate(context=arguments.entity.getValidationContext( arguments.context ));
	        }
	        
	        // If the object passed validation then call save in the DAO, otherwise set the errors flag
	        if(!arguments.entity.hasErrors()) {
	            arguments.entity = getHibachiDAO().save(target=arguments.entity);
	        } else {
	            getSlatwallScope().setORMHasErrors( true );
	        }
	
	        // Return the entity
	        return arguments.entity;
	    }
	    
		/**
		* exports the given query/array to file.
		* 
		* @param data      Data to export. (Required) (Currently only supports query).
		* @param columns      list of columns to export. (optional, default: all)
		* @param columnNames      list of column headers to export. (optional, default: none)
		* @param fileName      file name for export. (default: uuid)
		* @param fileType      file type for export. (default: csv)
		*/
		public void function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv') {
			if(!structKeyExists(arguments,"fileName")){
				arguments.fileName = createUUID() ;
			}
			var fileNameWithExt = arguments.fileName & "." & arguments.fileType ;
			var filePath = getSlatwallVFSRootDirectory() & "/" & fileNameWithExt ;
			if(isQuery(data) && !structKeyExists(arguments,"columns")){
				arguments.columns = arguments.data.columnList;
			}
			if(structKeyExists(arguments,"columns") && !structKeyExists(arguments,"columnNames")){
				arguments.columnNames = arguments.columns;
			}
			var columnArray = listToArray(arguments.columns);
			var columnCount = arrayLen(columnArray);
			
			if(arguments.fileType == 'csv'){
				var dataArray=[arguments.columnNames];
				for(var i=1; i <= data.recordcount; i++){
					var row = [];
					for(var j=1; j <= columnCount; j++){
						arrayAppend(row,'"#data[columnArray[j]][i]#"');
					}
					arrayAppend(dataArray,arrayToList(row));
				}
				var outputData = arrayToList(dataArray,"#chr(13)##chr(10)#");
				fileWrite(filePath,outputData);
			} else {
				throw("Implement export for fileType #arguments.fileType#");
			}
	
			// Open / Download File
			getUtilityFileService().downloadFile(fileNameWithExt,filePath,"application/#arguments.fileType#",true);
		}
			
			    
	 	/**
		 * Generic ORM CRUD methods and dynamic methods by convention via onMissingMethod.
		 *
		 * See all onMissing* method comments and other method signatures for usage.
		 *
		 * CREDIT:
		 *   Heavily influenced by ColdSpring 2.0-pre-alpha's coldspring.orm.hibernate.AbstractGateway.
	 	 *   So, thank you Mark Mandel and Bob Silverberg :)
		 *
		 * Provides dynamic methods, by convention, on missing method:
		 *
		 *   newXXX()
		 *
		 *   countXXX()
		 *
		 *   saveXXX( required any xxxEntity )
		 *
		 *   deleteXXX( required any xxxEntity )
		 *
		 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYYANDZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
		 *		AND here is case sensetive to avoid matching in property name i.e brAND
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 *	 exportXXX()
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		*/
		public any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
			var lCaseMissingMethodName = lCase( missingMethodName );
	
			if ( lCaseMissingMethodName.startsWith( 'get' ) ) {
				if(right(lCaseMissingMethodName,9) == "smartlist") {
					return onMissingGetSmartListMethod( missingMethodName, missingMethodArguments );
				} else {
					return onMissingGetMethod( missingMethodName, missingMethodArguments );
				}
			} else if ( lCaseMissingMethodName.startsWith( 'new' ) ) {
				return onMissingNewMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'list' ) ) {
				return onMissingListMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'save' ) ) {
				return onMissingSaveMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'delete' ) )	{
				return onMissingDeleteMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'count' ) ) {
				return onMissingCountMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'export' ) ) {
				return onMissingExportMethod( missingMethodName, missingMethodArguments );
			}
	
			throw( 'No matching method for #missingMethodName#().' );
		}
		
	
	
		/********** PRIVATE ************************************************************/
		private function onMissingDeleteMethod( required string missingMethodName, required struct missingMethodArguments ) {
			return delete( missingMethodArguments[ 1 ] );
		}
	
	
		/**
		 * Provides dynamic get methods, by convention, on missing method:
		 *
		 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYYAndZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
		 *		AND here is case sensetive to avoid matching in property name i.e brAND
		 *
		 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingGetMethod( required string missingMethodName, required struct missingMethodArguments ){
			var isReturnNewOnNotFound = structKeyExists( missingMethodArguments, '2' ) ? missingMethodArguments[ 2 ] : false;
	
			var entityName = missingMethodName.substring( 3 );
	
			if ( entityName.matches( '(?i).+by.+' ) ) {
				var tokens = entityName.split( '(?i)by', 2 );
				entityName = tokens[ 1 ];
				if( tokens[ 2 ].matches( '.+AND.+' ) ) {
					tokens = tokens[ 2 ].split( 'AND' );
					var filter = {};
					for(var i = 1; i <= arrayLen(tokens); i++) {
						filter[ tokens[ i ] ] = missingMethodArguments[ 1 ][ i ];
					}
					return get( entityName, filter, isReturnNewOnNotFound );
				} else {
					var filter = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
					return get( entityName, filter, isReturnNewOnNotFound );
				}
			} else {
				var id = missingMethodArguments[ 1 ];
				return get( entityName, id, isReturnNewOnNotFound );
			}
		}
	
		/**
		 * Provides dynamic getSmarList method, by convention, on missing method:
		 *
		 *   getXXXSmartList( struct data )
		 *
		 * ...in which XXX is an ORM entity name
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		 
		private function onMissingGetSmartListMethod( required string missingMethodName, required struct missingMethodArguments ){
			var smartListArgs = {};
			var entityNameLength = len(arguments.missingMethodName) - 12;
			
			var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
			var data = {};
			if( structCount(missingMethodArguments) && !isNull(missingMethodArguments[ 1 ]) && isStruct(missingMethodArguments[ 1 ]) ) {
				data = missingMethodArguments[ 1 ];
			}
			
			return getSmartList(entityName=entityName, data=data);
		} 
		 
	
		/**
		 * Provides dynamic list methods, by convention, on missing method:
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListMethod( required string missingMethodName, required struct missingMethodArguments ){
			var listMethodForm = 'listXXX';
	
			if ( findNoCase( 'FilterBy', missingMethodName ) ) {
				listMethodForm &= 'FilterByYYY';
			}
	
			if ( findNoCase( 'OrderBy', missingMethodName ) ) {
				listMethodForm &= 'OrderByZZZ';
			}
	
			switch( listMethodForm ) {
				case 'listXXX':
					return onMissingListXXXMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXFilterByYYY':
					return onMissingListXXXFilterByYYYMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXOrderByZZZ':
					return onMissingListXXXOrderByZZZMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXFilterByYYYOrderByZZZ':
					return onMissingListXXXFilterByYYYOrderByZZZMethod( missingMethodName, missingMethodArguments );
			}
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 * ...in which XXX is an ORM entity name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXMethod( required string missingMethodName, required struct missingMethodArguments ) {
			var listArgs = {};
	
			listArgs.entityName = missingMethodName.substring( 4 );
			
			if ( structKeyExists( missingMethodArguments, '1' ) ) {
				listArgs.filterCriteria = missingMethodArguments[ '1' ];
	
				if ( structKeyExists( missingMethodArguments, '2' ) ) {
					listArgs.sortOrder = missingMethodArguments[ '2' ];
	
					if ( structKeyExists( missingMethodArguments, '3' ) ) {
						listArgs.options = missingMethodArguments[ '3' ];
					}
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXFilterByYYYMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)FilterBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			listArgs.filterCriteria = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
	
			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.sortOrder = missingMethodArguments[ '2' ];
	
				if ( structKeyExists( missingMethodArguments, '3' ) )
				{
					listArgs.options = missingMethodArguments[ '3' ];
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXFilterByYYYOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)FilterBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			tokens = tokens[ 2 ].split( '(?i)OrderBy', 2 );
	
			listArgs.filterCriteria = { '#tokens[ 1 ]#' = missingMethodArguments[ 1 ] };
	
			listArgs.sortOrder = tokens[ 2 ];
	
			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.options = missingMethodArguments[ '2' ];
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and ZZZ is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)OrderBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			listArgs.sortOrder = tokens[ 2 ];
	
			if ( structKeyExists( missingMethodArguments, '1' ) )
			{
				listArgs.filterCriteria = missingMethodArguments[ '1' ];
	
				if ( structKeyExists( missingMethodArguments, '2' ) )
				{
					listArgs.options = missingMethodArguments[ '2' ];
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic count methods, by convention, on missing method:
		 *
		 *   countXXX()
		 *
		 * ...in which XXX is an ORM entity name.
		 */
		private function onMissingCountMethod( required string missingMethodName, required struct missingMethodArguments ){
			var entityName = missingMethodName.substring( 5 );
	
			return count( entityName );
		}
	
	
		private function onMissingNewMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var entityName = missingMethodName.substring( 3 );
	
			return new( entityName );
		}
	
	
		private function onMissingSaveMethod( required string missingMethodName, required struct missingMethodArguments ) {
			if ( structKeyExists( missingMethodArguments, '2' ) ) {
				return save( entity=missingMethodArguments[1], data=missingMethodArguments[2]);
			} else {
				return save( entity=missingMethodArguments[1] );
			}
		}
		
		/**
		 * Provides dynamic export methods, by convention, on missing method:
		 *
		 *   exportXXX()
		 *
		 * ...in which XXX is an ORM entity name.
		 */
		private function onMissingExportMethod( required string missingMethodName, required struct missingMethodArguments ){
			var entityName = missingMethodName.substring( 6 );
			var exportQry = getDAO().getExportQuery(entityName = entityName);
			
			export(data=exportQry);
		}
	
		// @hint returns the correct service on a given entityName.  This is very useful for creating abstract code
		public any function getServiceByEntityName( required string entityName ) {
			
			// This removes the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName, 8) == "Slatwall") {
				arguments.entityName = right(arguments.entityName, len(arguments.entityName) - 8);
			}
			
			if(structKeyExists(getEntityServiceMapping(), arguments.entityName)) {
				return getService( getEntityServiceMapping()[ arguments.entityName ] );
			}
			
			throw("You have requested the service for the entity of '#arguments.entityName#' and that entity was not defined in the coldspring config.xml so please add it, and the appropriate service it should use.")
		}
		
		// ======================= START: Entity Name Helper Methods ==============================
		
		public string function getProperlyCasedShortEntityName( required string entityName ) {
			if(left(arguments.entityName, 8) == "Slatwall") {
				arguments.entityName = right(arguments.entityName, len(arguments.entityName)-8);
			}
			
			if( structKeyExists(getEntityServiceMapping(), arguments.entityName) ) {
				var keyList = structKeyList(getEntityServiceMapping());
				var keyIndex = listFindNoCase(keyList, arguments.entityName);
				return listGetAt(keyList, keyIndex);
			}
			
			throw("The entity name that you have requested: #arguments.entityname# is not in the ORM Library of entity names that is setup in coldsrping.  Please add #arguments.entityname# to the list of entity mappings in coldspring.");
		}
		
		public string function getProperlyCasedFullEntityName( required string entityName ) {
			return "Slatwall#getProperlyCasedShortEntityName( arguments.entityName )#";
		}
		
		public string function getProperlyCasedFullClassNameByEntityName( required string entityName ) {
			return "Slatwall.model.entity.#replace(getProperlyCasedFullEntityName( arguments.entityName ), 'Slatwall', '')#";
		}
		
		// =======================  END: Entity Name Helper Methods ===============================
		
		// ===================== START: Cached Entity Meta Data Methods ===========================
		
		// @hint returns the entity meta data object that is used by a lot of the helper methods below
		public any function getEntityORMMetaDataObject( required string entityName ) {
			
			arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
			
			if(!structKeyExists(variables.entityORMMetaDataObjects, arguments.entityName)) {
				variables.entityORMMetaDataObjects[ arguments.entityName ] = ormGetSessionFactory().getClassMetadata( arguments.entityName );
			}
			
			return variables.entityORMMetaDataObjects[ arguments.entityName ];
		}
		
		// @hint returns the metaData struct for an entity
		public any function getEntityObject( required string entityName ) {
			
			arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
			
			if(!structKeyExists(variables.entityObjects, arguments.entityName)) {
				variables.entityObjects[ arguments.entityName ] = createObject(getProperlyCasedFullClassNameByEntityName( arguments.entityName ));
			}
			
			return variables.entityObjects[ arguments.entityName ];
		}
		
		// @hint returns the properties of a given entity
		public any function getPropertiesByEntityName( required string entityName ) {
			
			// First Check the application cache
			if( hasApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
				return getApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
			}
			
			// Pull the meta data from the object (which in turn will cache it in the application for the next time)
			return getEntityObject( arguments.entityName ).getProperties();
		}
		
		// @hint returns the properties of a given entity
		public any function getPropertiesStructByEntityName( required string entityName ) {
			
			// First Check the application cache
			if( hasApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
				return getApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
			}
			
			// Pull the meta data from the object (which in turn will cache it in the application for the next time)
			return getEntityObject( arguments.entityName ).getPropertiesStruct(); 
		}
		
		// =====================  END: Cached Entity Meta Data Methods ============================
		
		
		// ============================== START: Logical Methods ==================================
		
		// @hint returns an array of ID columns based on the entityName
		public array function getIdentifierColumnNamesByEntityName( required string entityName ) {
			return getEntityORMMetaDataObject( arguments.entityName ).getIdentifierColumnNames();
		}
		
		// @hint returns the primary id property name of a given entityName
		public string function getPrimaryIDPropertyNameByEntityName( required string entityName ) {
			var idColumnNames = getIdentifierColumnNamesByEntityName( arguments.entityName );
			
			if( arrayLen(idColumnNames) == 1) {
				return idColumnNames[1];
			} else {
				throw("There is not a single primary ID property for the entity: #arguments.entityName#");
			}
		}
		
		// @hint returns true or false based on an entityName, and checks if that property exists for that entity 
		public boolean function getEntityHasPropertyByEntityName( required string entityName, required string propertyName ) {
			return structKeyExists(getPropertiesStructByEntityName(arguments.entityName), arguments.propertyName );
		}
		
		// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
		public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
			if(listFindNoCase(getAttributeService().getAttributeCodesListByAttributeSetType( "ast#getProperlyCasedShortEntityName(arguments.entityName)#" ), arguments.attributeCode)) {
				return true;
			}
			return false; 
		}
		
		// @hint leverages the getEntityHasPropertyByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
		public boolean function getHasPropertyByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			return getEntityHasPropertyByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), propertyName=listLast(arguments.propertyIdentifier, "._") );
		}
		
		// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
		public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			return getEntityHasAttributeByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), attributeCode=listLast(arguments.propertyIdentifier, "._") );
		}
		
		// @hint traverses a propertyIdentifier to find the last entityName in the list... this is then used by the hasProperty and hasAttribute methods()
		public string function getLastEntityNameInPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			if(listLen(arguments.propertyIdentifier, "._") gt 1) {
				var propertiesSruct = getPropertiesStructByEntityName( arguments.entityName );
				if( !structKeyExists(propertiesSruct, listFirst(arguments.propertyIdentifier, "._")) || !structKeyExists(propertiesSruct[listFirst(arguments.propertyIdentifier, "._")], "cfc") ) {
					throw("The Property Identifier #arguments.propertyIdentifier# is invalid for the entity #arguments.entityName#");
				}
				return getLastEntityNameInPropertyIdentifier( entityName=propertiesSruct[listFirst(arguments.propertyIdentifier, "._")].cfc, propertyIdentifier=right(arguments.propertyIdentifier, len(arguments.propertyIdentifier)-(len(listFirst(arguments.propertyIdentifier, "._"))+1)));	
			}
			
			return arguments.entityName;
		}
		
	</cfscript>
</cfcomponent>