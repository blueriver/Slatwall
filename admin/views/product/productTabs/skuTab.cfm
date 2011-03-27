<cfoutput>
<cfif rc.edit>
<div id="buttons">
	<a class="button" id="addSKU">Add SKU</a>
    <a class="button" id="addOption">Add Option</a>
</div>
</cfif>
	<table id="skuTable" class="stripe">
		<thead>
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.sku.isDefault")#</th>
				<cfset local.optionGroups = rc.Product.getOptionGroupsStruct() />
				<cfloop collection="#local.optionGroups#" item="local.i">
					<th>#local.optionGroups[local.i].getOptionGroupName()#</th>
				</cfloop>
				<th>#rc.$.Slatwall.rbKey("entity.sku.skuCode")#</th>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.sku.imagePath")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.price")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.listPrice")#</th>
				<cfif rc.product.getSetting("trackInventory")>
				<th>#rc.$.Slatwall.rbKey("entity.sku.QOH")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.QEXP")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.QC")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.QIA")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.sku.QEA")#</th>
				</cfif>
				<cfif rc.edit>
				  <th class="administration">&nbsp;</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
		<cfloop array="#rc.Product.getSkus(sortby='skuCode')#" index="local.sku">
			<tr>
				<cfif rc.edit>
					<td><input type="radio" name="defaultSku" value="#local.sku.getSkuID()#"<cfif local.sku.getIsDefault()> checked="checked"</cfif> /></td>
				<cfelse>
					<td><cfif local.sku.getIsDefault()>#rc.$.Slatwall.rbKey("sitemanager.yes")#</cfif></td>
				</cfif>
				<cfloop collection="#local.optionGroups#" item="local.i">
					<td>#local.sku.getOptionByOptionGroupID(local.optionGroups[local.i].getOptionGroupID()).getOptionName()#</td>
				</cfloop>
				<td>
					<cfif rc.edit>
						<input type="text" name="skuStruct.#local.sku.getSkuID()#.skuCode" value="#local.sku.getSkuCode()#" />
					<cfelse>
						#local.sku.getSkuCode()#
					</cfif>
				</td>
				<td class="varWidth">#local.sku.getImagePath()#</td>
				<td>
					<cfif rc.edit>
						$<input type="text" size="6" name="skuStruct.#local.sku.getSkuID()#.price" value="#local.sku.getPrice()#" />
					<cfelse>
						#DollarFormat(local.sku.getPrice())#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						 $<input type="text" size="6" name="skuStruct.#local.sku.getSkuID()#.listPrice" value="#local.sku.getListPrice()#" />         
					<cfelse>
						#DollarFormat(local.sku.getListPrice())#
					</cfif>
				</td>
				<cfif rc.product.getSetting("trackInventory")>
				<td>#local.sku.getQOH()#</td>
				<td>#local.sku.getQEXP()#</td>
				<td>#local.sku.getQC()#</td>
				<td>#local.sku.getQIA()#</td>
				<td>#local.sku.getQEA()#</td>
				</cfif>
				<cfif rc.edit>
					<td class="administration">
						<ul class="two">
							<cfset local.deleteDisabled = arrayLen(rc.product.getSkus()) eq 1 />
							<cf_ActionCaller action="admin:product.editSku" querystring="skuID=#local.sku.getSkuID()#" class="edit" type="list">
							<cf_ActionCaller action="admin:product.deleteSku" querystring="skuID=#local.sku.getSkuID()#" class="delete" type="list" disabled="#local.deleteDisabled#" disabledText="#rc.$.Slatwall.rbKey('entity.sku.delete_validateOneSku')#" confirmrequired="true">
						</ul>
					</td>
				</cfif>
			</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>