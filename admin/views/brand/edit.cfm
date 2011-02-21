<cfparam name="rc.brand" type="any">

<cfoutput>
	<div class="svobrandedit">
		<form name="BrandEdit" action="#buildURL('admin:brand.save')#" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<dl class="oneColumn">
				<cf_PropertyDisplay object="#rc.Brand#" property="BrandName" edit="true" first="true">
				<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite" edit="true">
			</dl>
				<a href="javascript: history.go(-1)" class="button">#rc.$.Slatwall.rbKey("admin.nav.back")#</a>
				<cfif !rc.brand.isNew()>
				<cf_ActionCaller action="admin.brand.delete" querystring="brandid=#rc.brand.getBrandID()#" class="button" type="link" confirmrequired="true">
				</cfif>
				<cf_ActionCaller action="admin:brand.save" type="submit">
		</form>
	</div>
</cfoutput>