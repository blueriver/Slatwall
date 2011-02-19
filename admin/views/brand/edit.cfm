<cfparam name="rc.brand" type="any">

<cfoutput>
	<div class="svobrandedit">
		<form name="BrandEdit" action="#buildURL('admin:brand.save')#" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandName" edit="true">
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite" edit="true">
			<cf_ActionCaller action="admin:brand.save" type="submit">
		</form>
		<cfif !rc.brand.isNew()>
		<form name="BrandDelete" action="#buildURL('admin:brand.delete')#" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
            <cf_ActionCaller action="admin:brand.delete" querystring="brandid=#rc.brand.getBrandID()#" type="submit" confirmrequired=true>
		</form>
		</cfif>
	</div>
</cfoutput>