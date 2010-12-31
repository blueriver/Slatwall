<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=admin:product.update" method="post">
			<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
			<dl class="oneColumn">
			<cf_PropertyDisplay object="#rc.Product#" property="Active" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ProductName" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="Filename" edit="true">
			<dl>
				<dt>Brand</dt>
				<dd>
					<select name="Brand_BrandID">
						<cfset Local.BrandOptions = rc.Product.getBrandOptions() />
						<cfloop array="#Local.BrandOptions#" index="Local.Option">
							<option value="#Local.Option.getBrandID()#" <cfif rc.Product.getBrand().getBrandID() eq Local.Option.getBrandID()>selected="selected"</cfif>>#Local.Option.getBrandName()#</option>	
						</cfloop>
					</select>
				</dd>
			</dl>
			<dl>
				<dt>Product Template</dt>
				<dd>
					<select name="Template">
						<option value="" <cfif rc.Product.getTemplate() eq ''>selected="selected"</cfif>>Global</option>
						<cfset Local.TemplateOptions = rc.Product.getTemplateOptions() />
						<cfloop query="Local.TemplateOptions">
							<option value="#Local.TemplateOptions.Name#" <cfif rc.Product.getTemplate() eq Local.TemplateOptions.Name>selected="selected"</cfif>>#Local.TemplateOptions.Name#</option>	
						</cfloop>
					</select>
				</dd>
			</dl>
			<cf_PropertyDisplay object="#rc.Product#" property="ProductCode" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ProductYear" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ProductDescription" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ManufactureDiscontinued" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ShowOnWebRetail" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ShowOnWebWholesale" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="NonInventoryItem" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="CallToOrder" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="AllowShipping" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="AllowPreorder" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="AllowDropship" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="ShippingWeight" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="PublishedWeight" edit="true">
			</dl>
			<button type="submit">Save</button>
		</form>
		<form name="ProductEdit" action="?action=admin:product.delete" method="post">
			<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
			<button type="submit">Delete</button>
		</form>
	</div>
</cfoutput>