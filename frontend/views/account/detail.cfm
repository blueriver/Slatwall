<cfdump var="THIS IS MY TEST" />
<cfabort />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<div class="svofrontendaccountdetail">
		<h3>#rc.Account.getFirstName()# #rc.Account.getLastName()#</h3>
		<dl>
			<cf_PropertyDisplay object="#rc.Account#" property="primaryEmail" edit="#rc.edit#">
		</dl>
	</div>
</cfoutput>