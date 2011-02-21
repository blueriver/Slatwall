<cfparam name="rc.brand" type="any" />

<cfoutput>
	<dl class="ItemDetailMain oneColumn">
		<cf_PropertyDisplay object="#rc.Brand#" property="BrandName" first="true">
		<cf_PropertyDisplay object="#rc.Brand#" property="BrandWebsite">
	</dl>
</cfoutput>