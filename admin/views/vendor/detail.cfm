<cfoutput>
<div class="svoVendorDetail">
	<div class="TCLeftTThird">	
		<div class="ItemDetailMain">
			<dl class="HeaderItem">
				<dt>Vendor</dt>
				<dd>#rc.Vendor.getVendorName()#</dd>
			</dl>
			<dl>
				<dt>Account Number</dt>
				<dd>#rc.Vendor.getAccountNumber()#</dd>
			</dl>
			<!---
			<dl>
				<dt>Primary Phone</dt>
				<dd>#rc.Vendor.getPhoneNumbers().getDefaultPhone()#</dd>
			</dl>
			--->
			<!---
			<dl>
				<dt>Primary E-Mail</dt>
				<dd><a href="mailto:#rc.Vendor.getPrimaryEmail()#">#rc.Vendor.getPrimaryEmail()#</a></dd>
			</dl>
			--->
			<dl>
				<dt>Vendor Website</dt>
				<dd><a href="#getExternalSiteLink('#rc.Vendor.getVendorWebsite()#')#">#rc.Vendor.getVendorWebsite()#</a></dd>
			</dl>
			<!---
			<dl>
				<dt>Address</dt>
				<dd>
					#rc.Vendor.getStreetAddress()#<br />
					<cfif len(rc.Vendor.getStreet2Address())>#rc.Vendor.getStreet2Address()#<br /></cfif>
					#rc.Vendor.getCity()#, #rc.Vendor.getState()# #rc.Vendor.getPostalCode()#<br />
				</dd>
			</dl>
			--->
		</div>
		<div class="ItemDetailBar">
			<dl>
				<dt>Items On Order</dt>
				<dd>##</dd>
			</dl>
		</div>
		<!---
		<cfset local.args = structNew() />
		<cfset args.Vendor = rc.Vendor />
		
		<cfif rc.Vendor.getBrandsQuery().recordcount>
			<cfset args.HiddenColumns = "DateLastReceived" />
			#view('product/list', args)#
			#view('brand/list', args)#
		</cfif>
		--->
	</div>
	<div class="TCRightThird">
		<!--- #view('directory/cards', args)# --->
	</div>
	<cfdump var="#rc.Vendor.getEmailAddresses()#" />
</div>
</cfoutput>