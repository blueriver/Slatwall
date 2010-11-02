<cfcomponent extends="slat.com.dao.productDAO">

	<cffunction name="read">
		<cfargument name="ID" type="string" />
		<cfargument name="EntityName" default="product" />
		
		<cfset var rs = querynew('empty') />
		<cfset var Product = EntityNew('#arguments.entityname#') />
		
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
			SELECT
				tb_styles.style_id as											'ProductID',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebRetail',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebWholesale',
				0 as															'VendorDiscontinued',
				tb_styles.style as 												'ProductCode',
				CASE
					WHEN LEN(tb_styles.web_desc) > 0 THEN tb_styles.web_desc
					ELSE tb_styles.description
				END	 as 														'ProductName',
				tb_styles.web_long_desc as										'ProductDescription',
				tb_styles.date_entered as										'DateCreated',
				tb_styles.dlu as												'DateLastUpdated',
				tb_Styles.first_rcvd as											'DateFirstReceived',
				tb_Styles.last_rcvd as											'DateLastReceived',
				CASE tb_styles.non_invt 
					WHEN 'Y' THEN 1
					ELSE 0 
				END as 															'NonInventoryItem',
				CASE tb_styles.of19
					WHEN 'TELEPHONE' THEN 1
					ELSE 0
				END as															'CallToOrder',
				CASE tb_styles.of19
					WHEN 'IN STORE ONLY' THEN 1
					ELSE 0
				END as															'InStoreOnly',
				CASE tb_styles.of19
					WHEN 'DROP SHIP' THEN 1
					ELSE 0
				END as															'AllowDropship',
				CASE tb_styles.of19
					WHEN 'SPECIAL ORDER' THEN 1
					ELSE 0
				END as															'AllowBackorder',
				1 as															'AllowPreorder',
				tb_styles.weight as												'ShippingWeight',
				tb_styles.of2 as												'ProductYear',
				tb_styles.brand as												'Brand_BrandID',
				brandtext.web_text as											'Brand_BrandName',
				tb_styles.of1 as												'GenderType_TypeID',
				gendertext.web_text as											'GenderType_Type'
			FROM
				tb_styles
			  inner join
			  	tb_inet_names brandtext on tb_styles.brand = brandtext.orig_text
			  		and brandtext.field_name = 'BRAND'
			  left join
			  	tb_inet_names gendertext on tb_styles.of1 = gendertext.orig_text
			  		and gendertext.field_name = 'OF1'
			WHERE
				tb_styles.style_id= <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.ID#">
		</cfquery>
		
		<cfif rs.recordcount>
			<cfset Product.set(rs) />
		</cfif>

		<cfreturn Product />
	</cffunction>
	
	<cffunction name="getListCache">
		<cfset var rs = querynew('empty') />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				tb_styles.style_id as											'ProductID',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebRetail',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebWholesale',
				0 as															'VendorDiscontinued',
				tb_styles.style as 												'ProductCode',
				CASE
					WHEN LEN(tb_styles.web_desc) > 0 THEN tb_styles.web_desc
					ELSE tb_styles.description
				END	 as 														'ProductName',
				tb_styles.web_long_desc as										'ProductDescription',
				tb_styles.date_entered as										'DateCreated',
				tb_styles.dlu as												'DateLastUpdated',
				tb_Styles.first_rcvd as											'DateFirstReceived',
				tb_Styles.last_rcvd as											'DateLastReceived',
				CASE tb_styles.non_invt 
					WHEN 'Y' THEN 1
					ELSE 0 
				END as 															'NonInventoryItem',
				CASE tb_styles.of19
					WHEN 'TELEPHONE' THEN 1
					ELSE 0
				END as															'CallToOrder',
				CASE tb_styles.of19
					WHEN 'IN STORE ONLY' THEN 1
					ELSE 0
				END as															'InStoreOnly',
				CASE tb_styles.of19
					WHEN 'DROP SHIP' THEN 1
					ELSE 0
				END as															'AllowDropship',
				CASE tb_styles.of19
					WHEN 'SPECIAL ORDER' THEN 1
					ELSE 0
				END as															'AllowBackorder',
				1 as															'AllowPreorder',
				tb_styles.weight as												'ShippingWeight',
				tb_styles.of2 as												'ProductYear',
				tb_styles.brand as												'Brand_BrandID',
				brandtext.web_text as											'Brand_BrandName',
				tb_styles.of1 as												'GenderType_TypeID',
				gendertext.web_text as											'GenderType_Type'
			FROM
				tb_styles
			  inner join
			  	tb_inet_names brandtext on tb_styles.brand = brandtext.orig_text
			  		and brandtext.field_name = 'BRAND'
			  left join
			  	tb_inet_names gendertext on tb_styles.of1 = gendertext.orig_text
			  		and gendertext.field_name = 'OF1'
		</cfquery>
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="fillSmartList">
		<cfargument name="SmartList" type="any" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfset var ListCache = getListCache() />
		
		<cfquery name="rs" dbtype="query">
			SELECT
				*
			FROM
				ListCache
			  #arguments.SmartList.getSQLWhere(false)#
		</cfquery>
		
		<cfset arguments.SmartList.setQueryRecords(rs) />

		<cfreturn arguments.SmartList />
	</cffunction>

</cfcomponent>