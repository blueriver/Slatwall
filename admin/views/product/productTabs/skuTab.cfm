<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfoutput>
<cfif rc.edit>
<div id="buttons">
	<cfif rc.Product.getOptionGroupCount() gt 0>
	<a class="button" id="addSKU">#rc.$.Slatwall.rbKey("admin.product.edit.addsku")#</a>
	</cfif>
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