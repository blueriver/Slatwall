<cfif isDefined('args.Vendor')>
	<cfset local.DirectoryIteratory = args.Vendor.getDirectoryIterator() />
<cfelse>
	<cfset local.DirectoryIteratory = application.Slat.directoryManager.getDirectoryIterator(request.slat.queryOrganizer.organizeQuery(application.Slat.directoryManager.getEntireDirectoryQuery())) />
</cfif>
<cfoutput>
<div class="svoDirectoryCards">
	<cfloop condition="#local.DirectoryIteratory.hasNext()#">
		<cfset local.Directory = local.DirectoryIteratory.Next() />
		<dl class="DirectoryCard">
			<dt>#local.Directory.getFirstName()# #local.Directory.getLastName()#</dt>
			<dd>#local.Directory.getContactType()#</dd>
			<dd>#local.Directory.getCompany()#</dd>
			<dd>#local.Directory.getPrimaryPhone()#</dd>
			<dd><a href="mailto:#local.Directory.getPrimaryEmail()#">#local.Directory.getPrimaryEmail()#</a></dd>
		</dl>
	</cfloop>
</div>
</cfoutput>