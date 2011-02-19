<cfoutput>
	<div class="svobrandedit">
		<form name="BrandEdit" action="#buildURL('admin:brand.save')#" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandName" edit="true">
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite" edit="true">
			<cf_ActionCaller action="admin:brand.save" type="submit">
		</form>
<!---		 <cf_ActionCaller action="admin:brand.delete" querystring="brandID=#rc.brand.getBrandID()#" type="link" class="submit">--->
		<cfif !rc.brand.isNew()>
		<form name="BrandDelete" action="#buildURL('admin:brand.delete')#" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<cf_ActionCaller action="admin:brand.delete" type="submit">
		</form>
		</cfif>
	</div>
</cfoutput>