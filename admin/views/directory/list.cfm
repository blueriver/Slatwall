<cfif isDefined('args.Vendor')>
	<cfset local.DirectoryIterator = addURLPaging(args.Vendor.getDirectoryIterator()) />
<cfelse>
	<cfset local.DirectoryIterator = addURLPaging(application.Slatwall.directoryManager.getDirectoryIterator(request.slatwall.queryOrganizer.organizeQuery(application.Slatwall.directoryManager.getEntireDirectoryQuery()))) />
</cfif>

<cfoutput>
<div class="svoContactList">
	<h3 class="tableheader">Directory</h3>
	<table class="listtable">
		<tr>
			<th>Company</th>
			<th>Name</th>
			<th>Primary Phone</th>
			<th>Primary EMail</th>
		</tr>
		<cfloop condition="#local.DirectoryIterator.hasNext()#">
			<cfset local.Directory = local.DirectoryIterator.Next() />
			<tr>
				<td>#local.Directory.getCompany()#</td>
				<td><a href="#buildURL(action='directory.detail', querystring='DirectoryID=#local.Directory.getDirectoryID()#')#">#local.Directory.getFirstName()# #local.Directory.getLastName()#</a></td>
				<td>#local.Directory.getPrimaryPhone()#</td>
				<td><a href="mailto:#local.Directory.getPrimaryEMail()#">#local.Directory.getPrimaryEMail()#</a></td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>