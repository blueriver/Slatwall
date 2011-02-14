<cfoutput>
<div class="svoadminaccountlist">
	<table class="listtable stripe">
		<tr>
			<th>Name</th>
			<th>Primary Email</th>
			<th>Administration</th>
		</tr>
		<cfset local.rowcounter = 1 />
		<cfloop array="#rc.accountSmartList.getPageRecords()#" index="local.account">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<td class="varWidth"><a href="#buildURL(action='admin:account.detail', queryString='AccountID=#local.account.getAccountID()#')#">#local.account.getFirstName()# #local.account.getLastName()#</a></td>
				<td class="varWidth">
					<a href="mailto:#local.account.getPrimaryEmail()#" title="Email #local.account.getFirstName()# #local.account.getLastName()# (#local.account.getPrimaryEmail()#)">#local.account.getPrimaryEmail()#</a>
				</td>
				<td class="administration">
					<ul class="two">
						<li class="edit">
							<a href="#buildURL(action='admin:account.edit', queryString='accountID=#local.account.getAccountID()#')#" title="Edit">Edit</a>
						</li>
						<li class="preview">
							<a href="#buildURL(action='admin:account.detail', queryString='accountID=#local.account.getAccountID()#')#" title="Edit">View</a>
						</li>
					</ul>
				</td>
			</tr>
			<cfset local.rowcounter++ />
		</cfloop>
	</table>
</div>
</cfoutput>