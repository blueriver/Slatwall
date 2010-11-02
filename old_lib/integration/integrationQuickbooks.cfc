<cfcomponent output="false" name="integrationQuickbooks" hint="Database Connector for Celerant">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="package" output="false" retruntype="Query">
		<cfset var AllProductsQuery = querynew('empty') />
		
		<cfquery name="AllProductsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				iteminventory.listid as							'ProductID',
				iteminventory.isactive as						'Active',
				iteminventory.ManufacturerPartNumber as 		'ProductCode',
				iteminventory.name as 							'ProductName',
				'' as											'BrandID',
				'' as											'BrandName',
				'' as											'DefaultImageID',
				'' as											'ProductDescription',
				'' as											'ProductExtendedDescription',
				'' as											'DateCreated',
				'' as 											'DateAddedToWeb',
				'' as											'DateLastUpdated',
				'' as		 									'DateFirstReceived',
				'' as		 									'DateLastReceived',
				0 as											'OnTermSale',
				0 as 											'OnClearanceSale',
				0 as 											'NonInventoryItem',
				0 as											'CallToOrder',
				0 as											'OnlyInStore',
				0 as											'DropShips',
				0 as											'AllowBackorder',
				0 as											'AllowPreorder',
				0 as											'Weight',
				'' as											'ProductYear',
				'' as											'Gender',
				'' as											'SizeChart',
				'' as											'Ingredients',				
				'' as 											'Material',
				0 as 											'LivePrice',
				iteminventory.quantityonhand as 				'ListPrice',
				0 as 											'OriginalPrice',
				0 as											'MiscPrice',
				iteminventory.quantityonhand as					'QOH',
				iteminventory.quantityonsalesorder as 			'QC',
				iteminventory.quantityonorder as 				'QOO'
			FROM
				iteminventory
		</cfquery>
		
		<cfreturn AllProductsQuery />
		
	</cffunction>
	
	<cffunction name="getProductQuery" access="package" output="false" retruntype="Query">
		<cfargument name="ProductID" type="string" />
		
		<cfset var ProductQuery = querynew('empty') />
		
		<cfquery name="ProductQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
			SELECT
				iteminventory.listid as							'ProductID',
				iteminventory.isactive as						'Active',
				iteminventory.ManufacturerPartNumber as 		'ProductCode',
				iteminventory.name as 							'ProductName',
				'' as											'BrandID',
				'' as											'BrandName',
				'' as											'DefaultImageID',
				'' as											'ProductDescription',
				'' as											'ProductExtendedDescription',
				'' as											'DateCreated',
				'' as 											'DateAddedToWeb',
				'' as											'DateLastUpdated',
				'' as		 									'DateFirstReceived',
				'' as		 									'DateLastReceived',
				0 as											'OnTermSale',
				0 as 											'OnClearanceSale',
				0 as 											'NonInventoryItem',
				0 as											'CallToOrder',
				0 as											'OnlyInStore',
				0 as											'DropShips',
				0 as											'AllowBackorder',
				0 as											'AllowPreorder',
				0 as											'Weight',
				'' as											'ProductYear',
				'' as											'Gender',
				'' as											'SizeChart',
				'' as											'Ingredients',				
				'' as 											'Material',
				0 as 											'LivePrice',
				iteminventory.quantityonhand as 				'ListPrice',
				0 as 											'OriginalPrice',
				0 as											'MiscPrice',
				iteminventory.quantityonhand as					'QOH',
				iteminventory.quantityonsalesorder as 			'QC',
				iteminventory.quantityonorder as 				'QOO'
			FROM
				iteminventory
			<cfif isDefined('arguments.SkuID')>
				WHERE
					iteminventory.listid = '#arguments.SkuID#'
			<cfelseif isDefined('arguments.ProductID')>
				WHERE
					iteminventory.parentlistid = '#arguments.ProductID#'
			</cfif>
			GROUP By
				tb_skus.sku_id
		</cfquery>
		
		<cfreturn SkuQuery />
	</cffunction>
	
	<cffunction name="getCouponQuery" access="public" returntype="any" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfset var CouponQuery = querynew('empty') />
		<!---
		<cfquery name="CouponQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_coupon.coupon_id as		'CouponID',
				tb_coupon.lookup as			'CouponCode',
				tb_coupon.typ as			'CouponTypeID',
				tb_coupon.amount_off as		'Amount',
				tb_coupon.label as			'Description',
				tb_coupon.act_date as		'StartDate',				<!--- Deactivation Criteria --->
				tb_coupon.deact_date as		'EndDate',					<!--- Deactivation Criteria --->
				tb_coupon.active_days as	'ValidDays',				<!--- Deactivation Criteria --->
				tb_coupon.min_items as		'MinimumCartItemsQuantity',
				tb_coupon.min_spend as		'MinimumCartItemsValue',
				0 as						'SelectedProductsOnly',
				0 as						'OneUsePerCustomer',
				0 as						'OneUsePerSite'
			FROM
				tb_coupon
			WHERE
				tb_coupon.coupon_id = '#arguments.CouponID#'
		</cfquery>
		--->
		<cfreturn CouponQuery />
	</cffunction>
	
	<cffunction name="getCouponProductsQuery" access="public" returntype="any" output="false">
		<cfargument name="CouponID" type="String" />
		
		<cfset var CouponProducts = querynew('empty') />
		<!---
		<cfquery name="CouponProducts" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT DISTINCT
				tb_couponitems.style_id as	'ProductID',
			FROM
				tb_couponitems
			WHERE
				tb_couponitems.coupon_id = '#arguments.CouponID#'
		</cfquery>
		--->
		<cfreturn CouponProducts />
	</cffunction>
	
	<cffunction name="getAllCouponsQuery" access="public" returntype="query" output="false">
	
		<cfset var AllCoupons = querynew('empty') />
		
		<cfquery name="AllCoupons" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_coupon.coupon_id as		'CouponID',
				tb_coupon.lookup as			'CouponCode',
				tb_coupon.typ as			'CouponTypeID',
				tb_coupon.amount_off as		'Amount',
				tb_coupon.label as			'Description',
				tb_coupon.act_date as		'StartDate',
				tb_coupon.deact_date as		'EndDate',
				tb_coupon.active_days as	'ValidDays',
				tb_coupon.min_items as		'MinimumCartItemsQuantity',
				tb_coupon.min_spend as		'MinimumCartItemsValue',
				0 as						'SelectedProductsOnly',
				0 as						'OneUsePerCustomer',
				0 as						'OneUsePerSite'
			FROM
				tb_coupon
		</cfquery>
		
		<cfreturn AllCoupons />
	</cffunction>
	
	<cffunction name="getVendorsQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" required="false">
		<cfset var VendorsQuery = querynew('empty') />
		
		<cfquery name="VendorsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				vendor.listid as 'VendorID',
				vendor.accountnumber as 'AccountNumber',
				'' as 'VendorWebsite',
				vendor.firstname as 'FirstName',
				vendor.lastname as 'LastName',
				'Vendor' as 'ContactType',
				vendor.companyname as 'Company',
				vendor.vendoraddress_addr1 as 'StreetAddress',
				vendor.vendoraddress_addr2 as 'Street2Address',
				vendor.vendoraddress_city as 'City',
				vendor.vendoraddress_state as 'State',
				'' as 'Locality',
				vendor.vendoraddress_postalcode as 'PostalCode',
				vendor.vendoraddress_country as 'Country',
				vendor.phone as 'PrimaryPhone',
				vendor.email as 'PrimaryEmail'
			FROM
				vendor
			<cfif isDefined('arguments.VendorID')>
			WHERE
				vendor.listid = <cfqueryparam value="#arguments.VendorID#" />
			</cfif>
		</cfquery>
		
		<cfreturn VendorsQuery />
	</cffunction>
	
	<cffunction name="getVendorBrandsQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" required="false">
		<cfargument name="BrandID" required="false">
		
		<cfset var VendorBrands = querynew('VendorID,BrandID') />
		<!---
		<cfquery name="VendorBrands" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_brand_vendor.contact_id as 'VendorID',
				tb_brand_vendor.brand as 'BrandID'
			FROM
				tb_brand_vendor
			WHERE
				<cfif isDefined('arguments.VendorID')>
					tb_brand_vendor.contact_id = <cfqueryparam value="#arguments.VendorID#" />
				<cfelse>
					tb_brand_vendor.brand = <cfqueryparam value="#arguments.BrandID#" />
				</cfif>
		</cfquery>
		--->
		<cfreturn VendorBrands />
	</cffunction>
	
	<cffunction name="getBrandsQuery" access="public" returntype="query" output="false">
		<cfargument name="BrandID" required="false" />
		
		<cfset var BrandsQuery = querynew('BrandID,BrandName,BrandWebsite') />
		<!---
		<cfquery name="BrandsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_inet_names.orig_text as 'BrandID',
				tb_inet_names.web_text as 'BrandName',
				'' as 'BrandWebsite'
			FROM
				tb_inet_names
			WHERE
				tb_inet_names.field_name = <cfqueryparam value="BRAND" />
			<cfif isDefined('arguments.BrandID')>
			  AND
				tb_inet_names.orig_text = <cfqueryparam value="#arguments.BrandID#" />
			</cfif>
		</cfquery>
		--->
		<cfreturn BrandsQuery />
	</cffunction>
	
	<cffunction name="getDirectoryQuery" access="public" returntype="query" output="false">
		<cfargument name="DirectoryID" type="string" reqired="false" />
		
		<cfset var DirectoryQuery = querynew('DirectoryID') />
		
		<!---
		<cfquery name="DirectoryQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_contacts.contact_id as 'DirectoryID',
				tb_contacts.contact_name as 'FirstName',
				'' as 'LastName',
				tb_contact_categories.contact_cat_label as 'ContactType',
				tb_contacts.company as 'Company',
				tb_address.address1 as 'StreetAddress',
				tb_address.address2 as 'Street2Address',
				tb_address.city as 'City',
				tb_address.state as 'State',
				tb_address.locality as 'Locality',
				tb_address.zip as 'PostalCode',
				tb_address.country as 'Country',
				tb_address.phone1 as 'PrimaryPhone',
				tb_address.email1 as 'PrimaryEmail'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			  LEFT JOIN
			  	tb_contact_categories on tb_contacts.contact_cat_id = tb_contact_categories.contact_cat_id
			WHERE
				tb_contacts.is_vendor <> <cfqueryparam value="Y" />
			<cfif isDefined('arguments.DirectoryID')>
			  AND
				tb_contacts.contact_id = <cfqueryparam value="#arguments.DirectoryID#" />
			</cfif>
		</cfquery>
		--->
		<cfreturn DirectoryQuery />
	</cffunction>
	
	<cffunction name="getCustomerQuery" access="public" returntype="query" output="false">
		<cfargument name="CustomerID" type="string" reqired="false" />
		
		<cfset var CustomerQuery = querynew('empty') />
		
		<cfquery name="CustomerQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				customer.listid as 'CustomerID',
				customer.firstname as 'FirstName',
				customer.lastname as 'LastName',
				'Customer' as 'ContactType',
				customer.companyname as 'Company',
				customer.billaddress_addr2 as 'StreetAddress',
				customer.billaddress_addr3 as 'Street2Address',
				customer.billaddress_city as 'City',
				customer.billaddress_state as 'State',
				'' as 'Locality',
				customer.billaddress_postalcode as 'PostalCode',
				customer.billaddress_country as 'Country',
				customer.phone as 'PrimaryPhone',
				customer.email as 'PrimaryEmail'
			FROM
				customer
			<cfif isDefined('arguments.CustomerID')>
			WHERE
				customer.listid = <cfqueryparam value="#arguments.CustomerID#" />
			</cfif>
		</cfquery>
		
		<cfreturn CustomerQuery />
	</cffunction>
	
	<cffunction name="getVendorDirectoryQuery" access="public" returntype="query" output="false">
		<cfargument name="VendorID" type="string" required="false" />
		<cfargument name="DirectoryID" type="string" reqired="false" />
		
		<cfset var VendorDirectoryQuery = querynew('DirectoryID,VendorID') />
		<!---
		<cfquery name="VendorDirectoryQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				tb_vendor_remit.vendor_num as 'DirectoryID',
				tb_vendor_remit.remitto_num as 'VendorID'
			FROM
			  	tb_vendor_remit
			WHERE
				<cfif isDefined('arguments.DirectoryID')>
					tb_vendor_remit.vendor_num = <cfqueryparam value="#arguments.DirectoryID#" />
				<cfelse>
					tb_vendor_remit.remitto_num = <cfqueryparam value="#arguments.VendorID#" />
				</cfif>
		</cfquery>
		--->
		<cfreturn VendorDirectoryQuery />
	</cffunction>

	<cffunction name="getOrderQuery" access="public" returntype="query" output="false">
		<cfargument name="OrderID" type="string" reqired="false" />
		<cfargument name="IsOpen" type="string" reqired="false" />
		
		<cfset var OrderQuery = querynew('empty') />
		<cfset var CelerantStoreReceiptNum = "" />
		<cfset var CelerantStoreID = "" />
		
		<cfif isDefined('arguments.OrderID')>
			<cfset CelerantStoreReceiptNum = Left(arguments.OrderID,find('-',arguments.OrderID)-1) />
			<cfset CelerantStoreID = Right(arguments.OrderID,len(arguments.OrderID)-find('-',arguments.OrderID)) />
		</cfif>
		
		<cfquery name="OrderQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
			SELECT
				convert(varchar(10), tb_store_receipts.store_receipt_num) + '-' + convert(varchar(10), tb_store_receipts.store_id) as 'OrderID',
				tb_receipt.date_time as 'DatePlaced',
				tb_receipt.dlu as 'DateLastUpdated',
				CASE
					WHEN tb_receipt.closed = 'Y' THEN 0
					ELSE 1
				END as 'isOpen',
				tb_receipt.total as 'OrderTotal',
				tb_receipt.shipping_charge as 'TotalShipping',
				tb_receipt.tax1 + tb_receipt.tax2 as 'TotalTax',
				tb_receipt.line_disc_amount as 'TotalSavings',
				0 as 'TotalAuthorized',
				tb_receipt.paid as 'TotalCharged',
				tb_store_receipts.store_id as 'WarehouseID',
				tb_receipt.machine_id as 'TerminalID',
				CASE
					WHEN tb_receipt.category3 = 'AMAZON ORDERS' THEN 'Amazon'
					WHEN tb_receipt.category3 = 'RRS ORDERS' THEN 'RRS'
					WHEN tb_receipt.machine_id = '9907' THEN 'Web'
					WHEN tb_receipt.machine_id = '9916' THEN 'Mail Order'
					WHEN tb_receipt.machine_id = '9905' THEN 'Mail Order'
					WHEN tb_receipt.typ = '1' THEN 'Service'
					WHEN tb_receipt.typ = '0' THEN 'Receipt'
					WHEN tb_receipt.typ = '2' THEN 'Special Order'
					ELSE 'SCV'
				END as 'OrderType',
				CASE
					WHEN tb_receipt.current_state_id = '1' THEN 'New'
					WHEN tb_receipt.current_state_id = '2' THEN 'BO'
					WHEN tb_receipt.current_state_id = '3' THEN 'RTP'
					WHEN tb_receipt.current_state_id = '4' THEN 'RTPP'
					WHEN tb_receipt.current_state_id = '5' THEN 'Shiped'
					WHEN tb_receipt.current_state_id = '6' THEN 'Hold'
					WHEN tb_receipt.current_state_id = '7' THEN 'PP'
					WHEN tb_receipt.current_state_id = '8' THEN 'Cancel'
					ELSE 'None'
				END as 'OrderStatus',
				tb_customers.first_name + ' ' + tb_customers.last_name as 'CustomerName',
				tb_customers.customer_id as 'CustomerID',
				tb_receipt.comments as 'Notes'
			FROM
				tb_receipt
			  INNER JOIN
			  	tb_store_receipts on tb_receipt.receipt_num = tb_store_receipts.receipt_num
			  INNER JOIN
			  	tb_customers on tb_receipt.customer_id = tb_customers.customer_id
			<cfif isDefined('arguments.OrderID')>
				WHERE
					tb_store_receipts.store_receipt_num = <cfqueryparam value="#CelerantStoreReceiptNum#" />
				  AND
				  	tb_store_receipts.store_id = <cfqueryparam value="#CelerantStoreID#" />
			<cfelseif isDefined('arguments.IsOpen')>
				WHERE
					tb_receipt.closed <> <cfqueryparam value="Y" cfsqltype="varchar" />
			</cfif>
			ORDER BY
				tb_receipt.receipt_num DESC
		</cfquery>

		<cfreturn OrderQuery />
	</cffunction>
	
	<cffunction name="getOrderItemsQuery" access="public" returntype="query" output="false">
		<cfargument name="OrderID" type="string" reqired="false" />
		<cfargument name="IsOpen" type="numeric" reqired="false" />
		
		<cfset var OrderItemsQuery = querynew('empty') />
		
		<cfquery name="OrderItemsQuery" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
			SELECT
				convert(varchar(10), max(tb_store_receipts.store_receipt_num)) + '-' + convert(varchar(10), max(tb_store_receipts.store_id)) as 'OrderID',
				tb_receiptline.receiptline_id as		'OrderItemID',
				max(tb_receiptline.quantity) as			'OrderQuantity',
				max(tb_receiptline.quantity) as			'OrderOriginalQuantity',
				max(tb_receiptline.shipped) as			'OrderQuantityShipped',
				0 as									'TotalTaxCharge',
				0 as									'TotalTaxRate',
				'' as									'ExpectedShipDate',
				max(tb_receiptline.notes) as			'Notes',
				max(tb_skus.sku_id) as	 				'SkuID',
				max(tb_skus.style_id) as 				'ProductID',
				min(tb_styles.picture_id) as 			'ImageID',
				(select top 1 lookup from tb_sku_lookups where tb_sku_lookups.sku_id = max(tb_skus.sku_id) and tb_sku_lookups.prime = 'Y') as 				'SkuCode',
				CASE
					WHEN min(tb_term_sale_entries.term_sale_id) IS NULL THEN min(tb_sku_buckets.price)
					ELSE 
						CASE
							WHEN max(tb_term_sale_entries.TYP) = 2 THEN max(tb_term_sale_entries.amount)
							ELSE
								CASE max(tb_term_sale_entries.rounding)
									WHEN 0 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.01
									WHEN 1 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)
									WHEN 3 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.02
									WHEN 4 THEN round(round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2),0)-.03
									ELSE round((100-max(tb_term_sale_entries.amount))*.01*min(tb_sku_buckets.price),2)
								END
						END
				END as 									'LivePrice',
				min(tb_sku_buckets.Sugg_Price) as 		'ListPrice',
				min(tb_sku_buckets.price) as	 		'OriginalPrice',
				min(tb_sku_buckets.first_price) as 		'MiscPrice',
				'Size' as 								'Attr1Name',
				max(tb_size_entries.siz) as 			'Attr1Value',
				'Color' as 								'Attr2Name',
				max(tb_attr1_entries.attr1) as 			'Attr2Value',
				'Attr2' as 								'Attr3Name',
				max(tb_attr2_entries.attr2) as 			'Attr3Value',
				sum(tb_sku_buckets.qoh) as 				'QOH',
				sum(tb_sku_buckets.qc)*-1 as 			'QC',
				sum(tb_sku_buckets.qoo) as 				'QOO',
				(
					Select top 1 
						tb_purchase_orders.vendor_po
					from
						tb_purchase_orders
					  inner join
						tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
					  inner join
						tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
					where
						b.sku_id = max(tb_skus.sku_id)
					  and
						tb_purchase_orders.closed='N'
				) as									'NextOrderID',
				(
					Select top 1 
						tb_purchase_orders.arrival_date
					from
						tb_purchase_orders
					  inner join
						tb_po_skus on tb_po_skus.purchase_order_id = tb_purchase_orders.purchase_order_id
					  inner join
						tb_sku_buckets b on tb_po_skus.sku_bucket_id = b.sku_bucket_id
					where
						b.sku_id = max(tb_skus.sku_id)
					  and
						tb_purchase_orders.closed='N'
				) as									'NextArrivalDate',
				0 as									'DaysToOrder',
				0 as									'AdditionalDaysToShip',
				1 as									'isTaxable',
				1 as									'isDiscountable'
			FROM
				tb_receiptline
			  inner join
			  	tb_receipt on tb_receiptline.receipt_num = tb_receipt.receipt_num
			  inner join
			  	tb_store_receipts on tb_receipt.receipt_num = tb_store_receipts.receipt_num
			  inner join
			  	tb_sku_buckets on tb_receiptline.sku_bucket_id = tb_sku_buckets.sku_bucket_id
			  inner join
				tb_skus on tb_sku_buckets.sku_id = tb_skus.sku_id
			  inner join
				tb_styles on tb_skus.style_id = tb_styles.style_id
			  left join
			  	tb_size_entries on tb_skus.scale_entry_id = tb_size_entries.scale_entry_id
			  left join
			  	tb_attr1_entries on tb_skus.attr1_entry_id = tb_attr1_entries.attr1_entry_id
			  left join
			  	tb_attr2_entries on tb_skus.attr2_entry_id = tb_attr2_entries.attr2_entry_id
			  left join
			  	tb_term_sale_entries on tb_styles.style_id = tb_term_sale_entries.style_id
			  		and tb_term_sale_entries.store_id = 99
					and tb_term_sale_entries.start_date < GetDate()
					and tb_term_sale_entries.end_date > GetDate()
					and exists (select tb_term_sales.approved from tb_term_sales where tb_term_sales.term_sale_id = tb_term_sale_entries.term_sale_id and tb_term_sales.approved = 'Y')
			WHERE
				<cfif isDefined('arguments.OrderID')>
					tb_receiptline.receipt_num = '#getActualReceiptNum(arguments.OrderID)#'
				<cfelse>
					tb_receipt.closed <> 'Y'
				</cfif>
			GROUP By
				tb_receiptline.receiptline_id
		</cfquery>
		
		<cfreturn OrderItemsQuery />
	</cffunction>
</cfcomponent>
