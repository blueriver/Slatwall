<cfset local.Customer = application.slat.customerManager.read(CustomerID=rc.CustomerID) />
<cfoutput>
<div class="svoVendorDetail">
	
	<div class="ItemDetailMain">
		<dl class="HeaderItem">
			<dt>Name</dt>
			<dd>#local.Customer.getFirstName()# #local.Customer.getLastName()#</dd>
		</dl>
		<dl>
			<dt>Primary Phone</dt>
			<dd>#local.Customer.getPrimaryPhone()#</dd>
		</dl>
		<dl>
			<dt>Primary E-Mail</dt>
			<dd><a href="mailto:#local.Customer.getPrimaryEmail()#">#local.Customer.getPrimaryEmail()#</a></dd>
		</dl>
		<dl>
			<dt>Address</dt>
			<dd>
				#local.Customer.getStreetAddress()#<br />
				<cfif len(local.Customer.getStreet2Address())>#local.Customer.getStreet2Address()#<br /></cfif>
				#local.Customer.getCity()#, #local.Customer.getState()# #local.Customer.getPostalCode()#<br />
				#local.Customer.getCountry()#<br />
			</dd>
		</dl>
	</div>
	<div class="ItemDetailBar">
		<dl>
			<dt>Items On Order</dt>
			<dd>##</dd>
		</dl>
	</div>
	
	<div class="TCLeftTThird">
	</div>
	
	<div class="TCRightThird">
	</div>

</cfoutput>