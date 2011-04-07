<cfoutput>
<cfif rc.edit>
<div id="buttons">
	<a class="button" id="addSKU">#rc.$.Slatwall.rbKey("admin.product.edit.addsku")#</a>
	<a class="button" id="remSKU" style="display:none;">#rc.$.Slatwall.rbKey("admin.product.edit.removesku")#</a>
    <a class="button" id="addOption">#rc.$.Slatwall.rbKey("admin.product.edit.addoption")#</a>
</div>
</cfif>
<cfset local.skus = rc.product.getSkus(sortby='skuCode') />
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
				<cfif rc.product.getSetting("trackInventoryFlag")>
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
		<cfloop from="1" to="#arrayLen(local.skus)#" index="local.skuCount">
			<cfset local.thisSku = local.skus[local.skuCount] />
			<tr id="Sku#local.skuCount#" class="skuRow">
				<input type="hidden" name="skus[#local.skuCount#].skuID" value="#local.thisSku.getSkuID()#" />
				<cfif rc.edit>
					<td><input type="radio" name="defaultSku" value="#local.thisSku.getSkuID()#"<cfif local.thisSku.getDefaultFlag()> checked="checked"</cfif> /></td>
				<cfelse>
					<td><cfif local.thisSku.getDefaultFlag()>#rc.$.Slatwall.rbKey("sitemanager.yes")#</cfif></td>
				</cfif>
				<cfloop collection="#local.optionGroups#" item="local.i">
					<td>#local.thisSku.getOptionByOptionGroupID(local.optionGroups[local.i].getOptionGroupID()).getOptionName()#</td>
				</cfloop>
				<td>
					<cfif rc.edit>
						<input type="text" name="skus[#local.skuCount#].skuCode" value="#local.thisSku.getSkuCode()#" />
					<cfelse>
						#local.thisSku.getSkuCode()#
					</cfif>
				</td>
				<td class="varWidth">#local.thisSku.getImagePath()#</td>
				<td>
					<cfif rc.edit>
						$<input type="text" size="6" name="skus[#local.skuCount#].price" value="#local.thisSku.getPrice()#" />
					<cfelse>
						#DollarFormat(local.thisSku.getPrice())#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						 $<input type="text" size="6" name="skus[#local.skuCount#].listPrice" value="#local.thisSku.getListPrice()#" />         
					<cfelse>
						#DollarFormat(local.thisSku.getListPrice())#
					</cfif>
				</td>
				<cfif rc.product.getSetting("trackInventoryFlag")>
				<td>#local.thisSku.getQOH()#</td>
				<td>#local.thisSku.getQEXP()#</td>
				<td>#local.thisSku.getQC()#</td>
				<td>#local.thisSku.getQIA()#</td>
				<td>#local.thisSku.getQEA()#</td>
				</cfif>
				<cfif rc.edit>
					<td class="administration">
						<ul class="two">
							<cfset local.deleteDisabled = arrayLen(rc.product.getSkus()) eq 1 />
							<cf_ActionCaller action="admin:product.editSku" querystring="skuID=#local.thisSku.getSkuID()#" class="edit" type="list">
							<cf_ActionCaller action="admin:product.deleteSku" querystring="skuID=#local.thisSku.getSkuID()#" class="delete" type="list" disabled="#local.deleteDisabled#" disabledText="#rc.$.Slatwall.rbKey('entity.sku.delete_validateOneSku')#" confirmrequired="true">
						</ul>
					</td>
				</cfif>
			</tr>
		</cfloop>
	</tbody>
</table>

<cfif rc.edit>
<table id="tableTemplate" class="hideElement">
<tbody>
    <tr id="temp">
        <td><input type="radio" name="defaultSku" value="" /></td>
        <cfloop collection="#local.optionGroups#" item="local.i">
            <td>
			   <select name="options">
                    <cfset local.options = local.optionGroups[local.i].getOptions() />
                    <cfloop array="#local.options#" index="local.thisOption">
                        <option value="#local.thisOption.getOptionID()#">#local.thisOption.getOptionName()#</option>
                    </cfloop>
                </select>
			</td>
        </cfloop>
        <td>
            <input type="text" name="skuCode" value="" />
			<input type="hidden" name="skuID" value="" />
        </td>
        <td class="varWidth"></td>
        <td>
            $<input type="text" size="6" name="price" value="#rc.product.getDefaultSku().getPrice()#" />
        </td>
        <td>
            $<input type="text" size="6" name="listPrice" value="#rc.product.getDefaultSku().getListPrice()#" />         
        </td>
        <cfif rc.product.getSetting("trackInventoryFlag")>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        </cfif>
            <td class="administration">
            </td>
        </tr>
</tbody>
</table>
</cfif>
</cfoutput>