<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=admin:product.update" method="post">
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
		<dl class="oneColumn">
		<cf_PropertyDisplay object="#rc.Product#" property="Active" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductName" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="Filename" edit="true">
		<dl>
			<dt>Product Template</dt>
			<dd>
				<select name="Template">
					<option value="" <cfif rc.Product.getTemplate() eq ''>selected="selected"</cfif>>Global</option>
					<cfloop query="rc.ProductTemplatesQuery">
						<option value="#rc.ProductTemplatesQuery.Name#" <cfif rc.Product.getTemplate() eq rc.ProductTemplatesQuery.Name>selected="selected"</cfif>>#rc.ProductTemplatesQuery.Name#</option>	
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
	</div>
</cfoutput>