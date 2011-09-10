<cfcomponent accessors="true">

	<cfproperty name="fw" />
	<cfproperty name="brandService" />
	<cfproperty name="optionService" />
	<cfproperty name="productService" />
	<cfproperty name="skuService" />
	<cfproperty name="utilityFileService" />
	<cfproperty name="dataService" />
	
	<cffunction name="init">
		<cfargument name="fw" />
		
		<cfset setFW(arguments.fw) />
	</cffunction>

	<cffunction name="productImport" returntype="void">
		<cfargument name="rc" type="struct" />
		
		<cfset var newFilename = createUUID() & ".txt" />
		<cfset var importDirectory = expandPath(rc.$.siteConfig('assetPath')) & '/assets/file/slatwall/productImport/' />
		
		<cfif not directoryExists(importDirectory)>
			<cfset directoryCreate(importDirectory) />
		</cfif>
		
		<cffile action="upload" filefield="inventoryImport" destination="#importDirectory#" nameConflict="makeunique" result="uploadedFile">
		<cffile action="rename" destination="#importDirectory##newFilename#" source="#importDirectory##uploadedFile.serverFile#" >
		
		<cfloop file="#importDirectory##newFilename#" index="fileLine">
			<cfset var lineArray = listToArray(fileLine, chr(9)) />
			
			<cfif arrayLen(lineArray) gt 1
				and lineArray[1] eq "INVITEM"
				and (listLen(lineArray[2], ":") eq 4 OR ( listLen(lineArray[2], ":") eq 3 and listGetAt(lineArray[2], 2, ":") neq "ALL OVER PRINTS" and listGetAt(lineArray[2], 2, ":") neq "MEN'S PREMIUM T'S" and listGetAt(lineArray[2], 2, ":") neq "MEGA PACK SPECIAL"))
				and (listGetAt(lineArray[2], 1, ":") eq "WEBSTORE" or listGetAt(lineArray[2], 1, ":") eq "WEB STORE")>
				
				<cfif listLen(lineArray[2], ":") eq 4>
					<cfset var hasOptions = true>
					<cfset var remoteSkuID = listGetAt(lineArray[2], 4, ":") />
					<cfset var fullRemoteSkuID = lineArray[2] />
				<cfelse>
					<cfset var hasOptions = false>
					<cfset var remoteSkuID = listGetAt(lineArray[2], 3, ":") />
					<cfset var fullRemoteSkuID = lineArray[2] />
				</cfif>
				
				<cfset var remoteProductID = left(remoteSkuID, 11) />
				<cfset var remoteProductTypeID = listGetAt(lineArray[2], 2, ":") />
				<cfset var remoteBrandID = "762" />
				
				<cfset var brand = getBrandService().getBrandByRemoteID(remoteBrandID) />
				<cfif isNull(brand)>
					<cfset brand = getBrandService().newBrand() />
					<cfset brand.setRemoteID(remoteBrandID) />
					<cfset brand.setBrandName("7.62 Design") />
					<cfset entitySave(brand) />
				</cfif>
				
				<cfset var productType = getProductService().getProductTypeByRemoteID(remoteProductTypeID) />
				<cfif isNull(productType)>
					<cfset productType = getProductService().newProductType() />
					<cfset productType.setRemoteID(remoteProductTypeID) />
					<cfset productType.setProductTypeName(remoteProductTypeID) />
					<cfset entitySave(productType) />
				</cfif>
					
				<cfset var product = getProductService().getProductByRemoteID(remoteProductID) />
				<cfif isNull(product)>
					<cfset product = getProductService().newProduct() />
					<cfset product.setRemoteID(remoteProductID) />
					<cfset product.setProductName(lineArray[6]) />
					
					<cfset product.setFilename( getUtilityFileService().filterFileName(product.getProductName()) ) />
					<cfset var duplicate = getDataService().isDuplicateProperty("filename", product) />
					<cfset var fileAddon = 1 />
					<cfloop condition="duplicate eq true">
						<cfset product.setFilename( getUtilityFileService().filterFileName(product.getProductName()) & fileAddon ) />
						<cfset var duplicate = getDataService().isDuplicateProperty("filename", product) />
						<cfset fileAddon++ />
					</cfloop>
				</cfif>
				
				<cfset var sku = getSkuService().getSkuByRemoteID(fullRemoteSkuID) />
				
				<cfif isNull(sku)>
					<cfset sku = getSkuService().getSkuByRemoteID(remoteSkuID) />
				</cfif>
				
				<cfif isNull(sku)>
					<cfset sku = getSkuService().getSkuBySkuCode(remoteSkuID) />
				</cfif>
				
				<cfif isNull(sku)>
					<cfset sku = getSkuService().newSku() />
					<cfset sku.setRemoteID(remoteSkuID) />
					
					<cfif hasOptions>
						<!--- Sku Has Size --->
						<cfif listLen(remoteSkuID, "-") gt 3>
							<cfset var remoteSizeID = listGetAt(remoteSkuID, 4, "-") />
							<cfset var size = getOptionService().getOptionByRemoteID(remoteSizeID) />
							<cfif isNull(size)>
								<cfset var size = getOptionService().newOption() />
								<cfset size.setOptionName(listGetAt(remoteSkuID, 4, "-")) />
								<cfset size.setOptionCode(listGetAt(remoteSkuID, 4, "-")) />
								<cfset size.setRemoteID(listGetAt(remoteSkuID, 4, "-")) />
								
								<cfset var sizeGroup = getOptionService().getOptionGroupByRemoteID("size", true) />
								<cfif sizeGroup.isNew()>
									<cfset sizeGroup.setRemoteID("size") />
									<cfset sizeGroup.setOptionGroupName("Size") />
									<cfset sizeGroup.setOptionGroupCode("size") />
									<cfset sizeGroup.setImageGroupFlag(0) />
								</cfif>
								<cfset sizeGroup.addOption(size) />
								<cfset entitySave(sizeGroup) />
								<cfset entitySave(size) />
							</cfif>
							
							<cfset sku.addOption(size) />
						</cfif>
						
						<!--- Sku Has Color --->
						<cfif listLen(remoteSkuID, "-") gt 4>
							<cfset var remoteColorID = listGetAt(remoteSkuID, 5, "-") />
							<cfset var color = getOptionService().getOptionByRemoteID(remoteColorID) />
							<cfif isNull(color)>
								<cfset var color = getOptionService().newOption() />
								<cfset color.setOptionName(listGetAt(remoteSkuID, 5, "-")) />
								<cfset color.setOptionCode(listGetAt(remoteSkuID, 5, "-")) />
								<cfset color.setRemoteID(listGetAt(remoteSkuID, 5, "-")) />
								
								<cfset var colorGroup = getOptionService().getOptionGroupByRemoteID("color", true) />
								<cfif colorGroup.isNew()>
									<cfset colorGroup.setRemoteID("color") />
									<cfset colorGroup.setOptionGroupName("Color") />
									<cfset colorGroup.setOptionGroupCode("color") />
									<cfset colorGroup.setImageGroupFlag(1) />
								</cfif>
								<cfset colorGroup.addOption(color) />
								<cfset entitySave(colorGroup) />
								<cfset entitySave(color) />
							</cfif>
							
							<cfset sku.addOption(color) />
						</cfif>
					</cfif>
				</cfif>
				
				<!--- Update the skus remoteID --->
				<cfset sku.setRemoteID(fullRemoteSkuID) />
				
				<!--- Update the skus price --->
				<cfset sku.setPrice(lineArray[13]) />
				<cfset sku.setListPrice(lineArray[13]) />
				<cfset sku.setSkuCode(remoteSkuID) />
				
				<!--- Update the skus Product --->
				<cfset product.addSku(sku) />
				<cfif arrayLen(product.getSkus()) lt 2>
					<cfset product.setDefaultSku(sku) />
				</cfif>
				
				<!--- Update the product's details --->
				<cfset product.setProductType(productType) />
				<cfset product.setBrand(brand) />
				<cfset product.setProductCode(remoteProductID) />
				<cfset product.setSortOrder(listLast(remoteProductID, "-")) />
				
				<!--- Update the Skus Image --->
				<cfset sku.setImageFile( getSkuService().generateImageFileName(sku) ) />
				
				<cfset entitySave( product ) />
				<cfset ormFlush() />
			</cfif>
		</cfloop>
		
		<cfset getFW().setView("quickbooks:main.default") />
	</cffunction>
	
	<cffunction name="orderExport">
		<cfargument name="rc" />
		
		<cfset var exportDirectory = expandPath(rc.$.siteConfig('assetPath')) & '/assets/file/slatwall/orderExport/' />
		
		<cfif not directoryExists(exportDirectory)>
			<cfset directoryCreate(exportDirectory) />
		</cfif>
		
		<cfset var orderExportID = "#dateFormat(now(),"YYYY-MM-DD")#_#timeFormat(now(),"HHMMSS")#" />
		
		<cfset var exportOrders = ormExecuteQuery("SELECT o FROM SlatwallOrder o WHERE o.orderStatusType.typeID = '444df2b8b98441f8e8fc6b5b4266548c' and o.remoteID is null") />
		
		<!--- Var'd variables to use in loops --->
		<cfset var order = "" />
		<cfset var item = "" />
		
		<cfloop array="#exportOrders#" index="order">
			<!--- Header --->
			<cffile output="!TRNS#chr(9)#TRNSID#chr(9)#TRNSTYPE#chr(9)#DATE#chr(9)#ACCNT#chr(9)#NAME#chr(9)#CLASS#chr(9)#AMOUNT#chr(9)#DOCNUM#chr(9)#CLEAR#chr(9)#PONUM#chr(9)#TOPRINT#chr(9)#NAMEISTAXABLE#chr(9)#ADDR1#chr(9)#ADDR2#chr(9)#ADDR3#chr(9)#ADDR4#chr(9)#ADDR5#chr(9)#DUEDATE#chr(9)#PAID#chr(9)#PAYMETH#chr(9)#SHIPVIA#chr(9)#SHIPDATE#chr(9)#SADDR1#chr(9)#SADDR2#chr(9)#SADDR3#chr(9)#SADDR4#chr(9)#SADDR5#chr(9)#TOSEND#chr(9)#ISAJE" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			<cffile output="!SPL#chr(9)#SPLID#chr(9)#TRNSTYPE#chr(9)#DATE#chr(9)#ACCNT#chr(9)#NAME#chr(9)#CLASS#chr(9)#AMOUNT#chr(9)#DOCNUM#chr(9)#CLEAR#chr(9)#QNTY#chr(9)#PRICE#chr(9)#INVITEM#chr(9)#PAYMETH#chr(9)#TAXABLE#chr(9)#VALADJ#chr(9)#EXTRA" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			<cffile output="!ENDTRNS" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			
			<!--- Order --->
			<cfset var order_transid = order.getOrderNumber() />
			<cfset var order_date = dateFormat(order.getOrderOpenDateTime(), "MM/DD/YYYY") />
			<cfset var order_amount = numberFormat(order.getTotal(),"0.00") />
			<cfset var order_docnum = order.getOrderNumber() />
			
			<cfif len(order.getOrderPayments()[1].getBillingAddress().getStreet2Address())>
				<cfset var order_addr1 = order.getOrderPayments()[1].getBillingAddress().getName() />
				<cfset var order_addr2 = order.getOrderPayments()[1].getBillingAddress().getStreetAddress() />
				<cfset var order_addr3 = order.getOrderPayments()[1].getBillingAddress().getStreet2Address() />
				<cfset var order_addr4 = "#order.getOrderPayments()[1].getBillingAddress().getCity()#, #order.getOrderPayments()[1].getBillingAddress().getStateCode()# #order.getOrderPayments()[1].getBillingAddress().getPostalCode()#" />
				<cfset var order_addr5 = order.getOrderPayments()[1].getBillingAddress().getCountryCode() />
			<cfelse>
				<cfset var order_addr1 = order.getOrderPayments()[1].getBillingAddress().getName() />
				<cfset var order_addr2 = order.getOrderPayments()[1].getBillingAddress().getStreetAddress() />
				<cfset var order_addr3 = "#order.getOrderPayments()[1].getBillingAddress().getCity()#, #order.getOrderPayments()[1].getBillingAddress().getStateCode()# #order.getOrderPayments()[1].getBillingAddress().getPostalCode()#" />
				<cfset var order_addr4 = order.getOrderPayments()[1].getBillingAddress().getCountryCode() />
				<cfset var order_addr5 = "" />
			</cfif>
			
			<cfset var order_duedate = dateFormat(order.getOrderCloseDateTime(), "MM/DD/YYYY") />
			<cfset var order_paymeth = order.getOrderPayments()[1].getCreditCardType() />
			<cfset var order_shipdate = dateFormat(order.getOrderCloseDateTime(), "MM/DD/YYYY") />
			
			<cfif len(order.getOrderFulfillments()[1].getShippingAddress().getStreet2Address())>
				<cfset var order_saddr1 = order.getOrderFulfillments()[1].getShippingAddress().getName() />
				<cfset var order_saddr2 = order.getOrderFulfillments()[1].getShippingAddress().getStreetAddress() />
				<cfset var order_saddr3 = order.getOrderFulfillments()[1].getShippingAddress().getStreet2Address() />
				<cfset var order_saddr4 = "#order.getOrderFulfillments()[1].getShippingAddress().getCity()#, #order.getOrderFulfillments()[1].getShippingAddress().getStateCode()# #order.getOrderFulfillments()[1].getShippingAddress().getPostalCode()#" />
				<cfset var order_saddr5 = order.getOrderFulfillments()[1].getShippingAddress().getCountryCode() />
			<cfelse>
				<cfset var order_saddr1 = order.getOrderFulfillments()[1].getShippingAddress().getName() />
				<cfset var order_saddr2 = order.getOrderFulfillments()[1].getShippingAddress().getStreetAddress() />
				<cfset var order_saddr3 = "#order.getOrderFulfillments()[1].getShippingAddress().getCity()#, #order.getOrderFulfillments()[1].getShippingAddress().getStateCode()# #order.getOrderFulfillments()[1].getShippingAddress().getPostalCode()#" />
				<cfset var order_saddr4 = order.getOrderFulfillments()[1].getShippingAddress().getCountryCode() />
				<cfset var order_saddr5 = "" />
			</cfif>
						
			<cffile output="TRNS#chr(9)##order_transid##chr(9)#CASH SALE#chr(9)##order_date##chr(9)#Undeposited Funds#chr(9)#7.62 Design Web Sales V2#chr(9)#WEB SALES#chr(9)##order_amount##chr(9)##order_docnum##chr(9)#N#chr(9)##order_docnum##chr(9)#N#chr(9)#Y#chr(9)##order_addr1##chr(9)##order_addr2##chr(9)##order_addr3##chr(9)##order_addr4##chr(9)##order_addr5##chr(9)##order_duedate##chr(9)#Y#chr(9)##order_paymeth##chr(9)##chr(9)##order_shipdate##chr(9)##order_saddr1##chr(9)##order_saddr2##chr(9)##order_saddr3##chr(9)##order_saddr4##chr(9)##order_saddr5##chr(9)#N#chr(9)#N" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			
			<!--- Lines --->
			<cfset var line_splid = 1 />
			<cfloop array="#order.getOrderItems()#" index="item">
				
				<cfset var line_invitem = item.getSku().getRemoteID() />
				<cfset var line_amount = numberFormat(item.getExtendedPriceAfterDiscount()*-1,"0.00") />
				<cfset var line_qnty = item.getQuantity()*-1 />
				<cfset var line_price = item.getPrice() />
				
				<cffile output="SPL#chr(9)##line_splid##chr(9)#CASH SALE#chr(9)##order_date##chr(9)#Income Account#chr(9)##chr(9)#WEB SALES#chr(9)##line_amount##chr(9)##order_docnum##chr(9)#N#chr(9)##line_qnty##chr(9)##line_price##chr(9)##line_invitem##chr(9)##order_paymeth##chr(9)#Y#chr(9)#N#chr(9)#" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
				
				<cfset line_splid += 1 />
			</cfloop>
			
			<!--- Add Shipping Line --->
			<cfset var shipping_price = order.getOrderFulfillments()[1].getFulfillmentCharge() />
			<cfset var shipping_amount = numberFormat(order.getOrderFulfillments()[1].getFulfillmentCharge()*-1,"0.00") />
			<cffile output="SPL#chr(9)##line_splid##chr(9)#CASH SALE#chr(9)##order_date##chr(9)#Income Account#chr(9)#Shipping#chr(9)#WEB SALES#chr(9)##shipping_amount##chr(9)##order_docnum##chr(9)#N#chr(9)##chr(9)##shipping_price##chr(9)#Shipping#chr(9)##order_paymeth##chr(9)#N#chr(9)#N#chr(9)#" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			<cfset line_splid += 1 />
			
			<!--- Add Tax Line --->
			<cfif order.getOrderFulfillments()[1].getShippingAddress().getCountryCode() eq "US" and order.getOrderFulfillments()[1].getShippingAddress().getStateCode() eq "CA">
				<cfset var order_taxamount = numberFormat(order.getTaxTotal()*-1,"0.00") />
				<cffile output="SPL#chr(9)##line_splid##chr(9)#CASH SALE#chr(9)##order_date##chr(9)##chr(9)#California Sales Tax#chr(9)#WEB SALES#chr(9)##order_taxamount##chr(9)##order_docnum##chr(9)#N#chr(9)##chr(9)#7.75%#chr(9)#Sales Tax#chr(9)##order_paymeth##chr(9)#N#chr(9)#N#chr(9)#AUTOSTAX" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			<cfelse>
				<cffile output="SPL#chr(9)##line_splid##chr(9)#CASH SALE#chr(9)##order_date##chr(9)##chr(9)#Out of State#chr(9)#WEB SALES#chr(9)#0#chr(9)##order_docnum##chr(9)#N#chr(9)##chr(9)#0.0%#chr(9)#Sales Tax#chr(9)##order_paymeth##chr(9)#N#chr(9)#N#chr(9)#AUTOSTAX" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			</cfif>
			
			<!--- End Trasaction --->
			<cffile output="ENDTRNS" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
			
			<!--- Set Order Remote ID --->
			<cfset order.setRemoteID("#orderExportID#_#order.getOrderNumber()#") />
			<cfset ormFlush() />
		</cfloop>
		
		<!--- Make sure that there is at least one line in the file --->
		<cffile output="" action="append" file="#exportDirectory#OrderExport_#orderExportID#.iif" addnewline="yes">
		
		<!--- Stream the file to the client. --->		
		<cfheader name="content-disposition" value="attachment; filename=OrderExport_#orderExportID#.iif" />
		<cfcontent type="text/plain" file="#exportDirectory#OrderExport_#orderExportID#.iif" /> 
		
		<cfset getFW().setView("quickbooks:main.default") />
	</cffunction>
</cfcomponent>