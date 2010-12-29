<cfoutput>
	<div class="svobrandedit">
		<form name="BrandEdit" action="?action=admin:brand.update" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandName" edit="true">
			<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite" edit="true">
			<button type="submit">Save</button>
		</form>
		<form name="BrandDelete" action="?action=admin:brand.delete" method="post">
			<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
			<button type="submit">Delete</button>
		</form>
	</div>
</cfoutput>