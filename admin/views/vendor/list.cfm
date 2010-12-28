<cfoutput>
<div class="svoVendorList">
	<h3 class="tableheader">Vendors</h3>
	<table class="listtable">
		<tr>
			<th>Vendor Name</th>
			<th>Account Number</th>
			<th>Website</th>
		</tr>
		<cfloop array="#rc.VendorSmartList.getEntityArray()#" index="Local.Vendor">
			<tr>
				<td><a href="#BuildURL(action='vendor.detail', querystring='VendorID=#local.Vendor.getVendorID()#')#">#local.Vendor.getVendorName()#</a></td>
				<td>#Local.Vendor.getAccountNumber()#</td>
				<td><a href="#getExternalSiteLink(local.Vendor.getVendorWebsite())#">#local.Vendor.getVendorWebsite()#</a></td>
			</tr>
			
		</cfloop>
	</table>
</div>
</cfoutput>
<!---
<cfif isDefined('args.Brand')>
	<cfset local.VendorsIterator = args.Brand.getVendorsIterator() />
<cfelse>
	<cfset local.VendorOrganizer = application.slatwall.vendorManager.getQueryOrganizer() />
	<cfset local.VendorOrganizer.setFromCollection(url) />
	<cfset local.VendorsIterator = application.slatwall.vendorManager.getVendorIterator(local.VendorOrganizer.organizeQuery(application.Slatwall.vendorManager.getAllVendorsQuery())) />
</cfif>

<cfoutput>
<div class="svoVendorList">
	<h3 class="tableheader">Vendors</h3>
	<table class="listtable">
		<tr>
			<th>Company</th>
			<th>Primary Phone</th>
			<th>Primary EMail</th>
			<th>Website</th>
		</tr>
		<cfloop condition="#local.vendorsIterator.hasNext()#">
			<cfset local.Vendor = local.vendorsIterator.Next() />
			
			<tr>
				 <td><a href="#BuildURL(action='vendor.detail', querystring='VendorID=#local.Vendor.getVendorID()#')#">#local.Vendor.getCompany()#</a></td>
				<td>#local.Vendor.getPrimaryPhone()#</td>
				<td>#local.Vendor.getPrimaryEMail()#</td>
				<td><a href="#getExternalSiteLink(local.Vendor.getVendorWebsite())#">#local.Vendor.getVendorWebsite()#</a></td>
			</tr>
			
		</cfloop>
	</table>
</div>
</cfoutput>
--->