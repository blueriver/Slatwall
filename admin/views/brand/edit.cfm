<cfoutput>
	<div class="svobrandedit">
		<form name="BrandEdit" action="?action=brand.update" method="post">
		<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
		#rc.Brand.getPropertyDisplay('BrandName', true)#
		#rc.Brand.getPropertyDisplay('BrandWebsite', true)#
		<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>