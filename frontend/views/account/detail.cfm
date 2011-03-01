<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<div class="svofrontendaccountdetail">
		<h3>#rc.Account.getFirstName()# #rc.Account.getLastName()#</h3>
		<dl>
			<cf_PropertyDisplay object="#rc.Account#" property="primaryEmail" edit="#rc.edit#">
		</dl>
		<ul>
			<cf_ActionCaller type="list" action="frontend:account.edit" />
			<cf_ActionCaller type="list" action="frontend:account.editpassword" />
			<cf_ActionCaller type="list" action="frontend:account.listorders" />
		</ul>
	</div>
</cfoutput>