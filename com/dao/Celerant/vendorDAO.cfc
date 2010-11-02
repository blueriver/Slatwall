<cfcomponent extends="slat.com.dao.vendorDAO">

	<cffunction name="read">
		<cfargument name="ID" type="string" />
		<cfargument name="EntityName" default="product" />
		
		<cfset var rs = querynew('empty') />
		<cfset var Vendor = EntityNew('#arguments.entityname#') />
		
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#">
			SELECT
				tb_contacts.contact_id as 'VendorID',
				tb_contacts.company as 'VendorName',
				tb_address.account_num as 'AccountNumber',
				tb_address.web_site as 'VendorWebsite'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
			  AND
				tb_contacts.contact_id = <cfqueryparam value="#arguments.ID#" />
		</cfquery>
		
		<cfif rs.recordcount>
			<cfset Vendor.set(rs) />
		</cfif>

		<cfreturn Vendor />
	</cffunction>
	
	<cffunction name="getListCache">
		<cfset var rs = querynew('empty') />
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				tb_contacts.contact_id as 'VendorID',
				tb_contacts.company as 'VendorName',
				tb_address.account_num as 'AccountNumber',
				tb_address.web_site as 'VendorWebsite'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
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
	
	<cffunction name="getVendorEmails">
		<cfargument name="VendorID" />
		
		<cfset var rs = querynew('empty') />
		
		<cfquery name="rs" datasource="#application.slatsettings.getSetting('IntegrationDSN')#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				tb_address.address_id as 'VendorEmailID',
				tb_contacts.po_email as 'EmailAddress',
				'PRIMARY' as 'EmailType_Type'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
			  AND
			  	tb_contacts.contact_id = <cfqueryparam value="#arguments.VendorID#" />
			  AND
			  	tb_address.email1 IS NOT NULL
			  AND
			  	tb_address.email1 <> ''
		UNION
			SELECT
				tb_address.address_id as 'VendorEmailID',
				tb_address.email1 as 'EmailAddress',
				'MISC' as 'EmailType_Type'
			FROM
				tb_contacts
			  INNER JOIN
			  	tb_contact_address on tb_contacts.contact_id = tb_contact_address.contact_id
			  INNER JOIN
			  	tb_address on tb_contact_address.address_id = tb_address.address_id
			WHERE
				tb_contacts.is_vendor = <cfqueryparam value="Y" />
			  AND
			  	tb_contacts.contact_id = <cfqueryparam value="#arguments.VendorID#" />
			  AND
			  	tb_address.email1 IS NOT NULL
			  AND
			  	tb_address.email1 <> ''
		</cfquery>
		
		<cfreturn QueryToEntityArray(rs, 'vendoremail') />
	</cffunction>

</cfcomponent>