<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=product.update" method="post">
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
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
		<!---
		#rc.Product.getPropertyDisplay('ProductCode', true)#
		#rc.Product.getPropertyDisplay('ProductYear', true)#
		#rc.Product.getPropertyDisplay('ProductDescription', true)#
		#rc.Product.getPropertyDisplay('ManufactureDiscontinued', true)#
		#rc.Product.getPropertyDisplay('ShowOnWebRetail', true)#
		#rc.Product.getPropertyDisplay('ShowOnWebWholesale', true)#
		#rc.Product.getPropertyDisplay('NonInventoryItem', true)#
		#rc.Product.getPropertyDisplay('CallToOrder', true)#
		#rc.Product.getPropertyDisplay('AllowShipping', true)#
		#rc.Product.getPropertyDisplay('AllowPreorder', true)#
		#rc.Product.getPropertyDisplay('AllowDropship', true)#
		#rc.Product.getPropertyDisplay('ShippingWeight', true)#
		#rc.Product.getPropertyDisplay('PublishedWeight', true)#
		--->
		<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>