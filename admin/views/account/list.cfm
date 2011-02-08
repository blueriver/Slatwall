<cfoutput>
<div class="svoadminaccountlist">
	<h3 class="tableheader">Accounts</h3>
	<table class="listtable stripe">
		<tr>
			<th>Name</th>
			<th>Primary Email</th>
			<th>Administration</th>
		</tr>
		<cfset local.rowcounter = 1 />
		<cfloop array="#rc.accountSmartList.getPageRecords()#" index="local.account">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<td><a href="#buildURL(action='admin:account.detail', queryString='AccountID=#local.account.getAccountID()#')#">#local.account.getFirstName()# #local.account.getLastName()#</a></td>
				<td></td>
				<td></td>
			</tr>
			<cfset local.rowcounter++ />
		</cfloop>
	</table>
	<!---
	<table class="listtable stripe">
		<tr>
			<th>Brand</th>
			<th>Brand Website</th>
			<th>Administration</th>
		</tr>
		<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
		<cfset local.rowcounter = 1 />
		<cfloop array="#rc.BrandSmartList.getPageRecords()#" index="Local.Brand">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<td><a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td><a href="#Local.Brand.getBrandWebsite()#" target="_blank">#local.Brand.getBrandWebsite()#</a></td>
				<td><a href="#buildURL(action='admin:brand.edit', queryString='BrandID=#local.Brand.getBrandID()#')#">Edit</a></td>
			</tr>
			<cfset local.rowcounter++ />
		</cfloop>
	</table>
	<div style="float:right;"><a href="#buildURL(action='admin:brand.edit')#">Add Brand</a></div>
	--->
</div>
</cfoutput>