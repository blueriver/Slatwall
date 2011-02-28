<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<div class="svofrontendaccountdetail">
		<h3>#rc.Account.getFirstName()# #rc.Account.getLastName()#</h3>
		<dl>
			<cf_PropertyDisplay object="#rc.Account#" property="primaryEmail" edit="#rc.edit#">
		</dl>
		<form method="post" action="#buildURL(action='frontend:account.save')#">
			<input type="hidden" name="GT" value="Yes" />
			<input type="text" name="GTT" />
			<button type="submit">Submit</button>
		</form>
	</div>
</cfoutput>