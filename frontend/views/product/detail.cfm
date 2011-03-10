<cfparam name="rc.product" type="any" />

<cfoutput>
	<div class="svofrontendproductdetail">
		<div class="image">
			Image Here
		</div>
		<cf_PropertyDisplay object="#rc.Product#" property="productCode">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear">
		<div class="description">#rc.product.getProductDescription()#</div>
		<form action="#buildURL(action='frontend:product.addtocart')#" method="post">
			<input type="hidden" name="productID" value="#rc.product.getProductID()#" />
			<cfset local.productOptionGroups = rc.product.getOptionGroupsStruct() />
			<cfloop collection="#local.productOptionGroups#" item="local.groupID">
				<dt>#local.productOptionGroups[local.groupID].getOptionGroupName()#</dt>
				<dd>
				<select name="selectedOptions">
					<cfset local.availableOptions = rc.product.getAvailableGroupOptionsBySelectedOptions(optionGroupID=local.groupID) />
					<cfloop collection="#local.availableOptions#" item="local.optionID">
						<option selected="selected" value="#local.availableOptions[local.optionID].getOptionID()#">#local.availableOptions[local.optionID].getOptionName()#</option>
					</cfloop>
				</select>
				</dd>
			</cfloop>
			<button type="submit">Add To Cart</button>
		</form>
	</div>
</cfoutput>