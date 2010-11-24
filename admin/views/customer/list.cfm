<cfset local.CustomerIterator = application.Slat.customerManager.getCustomerIterator(request.slat.queryOrganizer.organizeQuery(application.Slat.customerManager.getAllCustomersQuery())) />

<cfoutput>
<div class="svoContactList">
	<h3 class="tableheader">Customers</h3>
	<table class="listtable">
		<tr>
			<th>Company</th>
			<th>Name</th>
			<th>Primary Phone</th>
			<th>Primary EMail</th>
		</tr>
		<cfloop condition="#local.CustomerIterator.hasNext()#">
			<cfset local.Customer = local.CustomerIterator.Next() />
			<tr>
				<td><a href="#buildURL(action='customer.list',querystring='F_Company=#local.Customer.getCompany()#')#">#local.Customer.getCompany()#</td>
				<td><a href="#buildURL(action='customer.detail',querystring='CustomerID=#local.Customer.getCustomerID()#')#">#local.Customer.getFirstName()# #local.Customer.getLastName()#</a></td>
				<td>#local.Customer.getPrimaryPhone()#</td>
				<td><a href="mailto:#local.Customer.getPrimaryEMail()#">#local.Customer.getPrimaryEMail()#</a></td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>