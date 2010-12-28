<cfset local.Directory = application.slatwall.directoryManager.read(DirectoryID=rc.DirectoryID) />
<cfoutput>
<div class="svoVendorDetail">
	<div class="ItemDetailMain">
		<dl class="HeaderItem">
			<dt>Name</dt>
			<dd>#local.Directory.getFirstName()# #local.Directory.getLastName()#</dd>
		</dl>
		<dl>
			<dt>Company</dt>
			<dd>#local.Directory.getCompany()#</dd>
		</dl>
		<dl>
			<dt>Primary Phone</dt>
			<dd>#local.Directory.getPrimaryPhone()#</dd>
		</dl>
		<dl>
			<dt>Primary E-Mail</dt>
			<dd><a href="mailto:#local.Directory.getPrimaryEmail()#">#local.Directory.getPrimaryEmail()#</a></dd>
		</dl>
		<dl>
			<dt>Address</dt>
			<dd>
				#local.Directory.getStreetAddress()#<br />
				<cfif len(local.Directory.getStreet2Address())>#local.Directory.getStreet2Address()#<br /></cfif>
				#local.Directory.getCity()#, #local.Directory.getState()# #local.Directory.getPostalCode()#<br />
			</dd>
		</dl>
	</div>
</div>
</cfoutput>