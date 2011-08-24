<cfcomponent accessors="true">

	<cfproperty name="fw" />
	<cfproperty name="brandService" />
	<cfproperty name="optionService" />
	<cfproperty name="productService" />
	<cfproperty name="skuService" />
	
	<cffunction name="init">
		<cfargument name="fw" />
		
		<cfset setFW(arguments.fw) />
	</cffunction>

	<cffunction name="productImport" returntype="void">
		<cfargument name="rc" type="struct" />
		
		<cfset var newFilename = createUUID() & ".txt" />
		<cfset var importDirectory = expandPath(rc.$.siteConfig('assetPath')) & '/assets/file/' />
		
		<cffile action="upload" filefield="inventoryImport" destination="#importDirectory#" nameConflict="makeunique" result="uploadedFile">
		<cffile action="rename" destination="#importDirectory##newFilename#" source="#importDirectory##uploadedFile.serverFile#" >
		
		<cfloop file="#importDirectory##newFilename#" index="fileLine">
			<cfset var lineArray = listToArray(fileLine, chr(9)) />
			
			<cfif arrayLen(lineArray) gt 1
				and lineArray[1] eq "INVITEM"
				and (listLen(lineArray[2], ":") eq 4 OR ( listLen(lineArray[2], ":") eq 3 and listGetAt(lineArray[2], 2, ":") neq "ALL OVER PRINTS" and listGetAt(lineArray[2], 2, ":") neq "MEN'S PREMIUM T'S"))
				and (listGetAt(lineArray[2], 1, ":") eq "WEBSTORE" or listGetAt(lineArray[2], 1, ":") eq "WEB STORE")>
				
				<cfif listLen(lineArray[2], ":") eq 4>
					<cfset var hasOptions = true>
					<cfset var remoteSkuID = listGetAt(lineArray[2], 4, ":") />
				<cfelse>
					<cfset var hasOptions = false>
					<cfset var remoteSkuID = listGetAt(lineArray[2], 3, ":") />
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
				</cfif>
				
				<cfset var sku = getSkuService().getSkuByRemoteID(remoteSkuID) />
				
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
				
				<!--- Update the Skus Image --->
				<cfset sku.setImageFile( getSkuService().generateImageFileName(sku) ) />
				
				<cfset entitySave( product ) />
				<cfset ormFlush() />
			</cfif>
		</cfloop>
		
		<cfset getFW().setView("quickbooks:main.default") />
	</cffunction>
		
</cfcomponent>