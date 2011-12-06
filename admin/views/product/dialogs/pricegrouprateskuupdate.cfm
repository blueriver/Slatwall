<style>
	.dialog p {padding-bottom:5px;}
	.dialog form {width:280px;}
	
</style>

<cfoutput>
	<!--- These are DIVs used by the modal dialog for the SKUs price grid. We can't put this into skus.cfm since we need to avoid nested forms. --->
	<div id="updatePriceGroupSKUSettingsDialog" class="ui-helper-hidden dialog" title="#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.title')#">
		<form id="updatePriceGroupSKUSettingsForm" action="#buildURL('admin:product.updatePriceGroupSKUSettings')#" method="post">
			<input type="hidden" id="updatePriceGroupSKUSettingsForm_priceGroupId" name="priceGroupId">
			<input type="hidden" id="updatePriceGroupSKUSettingsForm_skuId" name="skuId">
			
			<strong>#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.groupname')#: </strong> 
			
			<cfloop from="1" to="#arrayLen(rc.priceGroupSmartList.getPageRecords())#" index="local.i">
				<cfset local.thisPriceGroup = rc.priceGroupSmartList.getPageRecords()[local.i]>
				<span class="ui-helper-hidden" id="updatePriceGroupSKUSettings_GroupName[#local.thisPriceGroup.getPriceGroupId()#]">#local.thisPriceGroup.getPriceGroupName()#</span>
			</cfloop>
			
			<p>#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.selectrate')#:</p>
			
			<!--- So that we don't have to rely on ajax, simply populate all of the PriceGroupRates here and show the one that is relevent --->
			<cfloop from="1" to="#arrayLen(rc.priceGroupSmartList.getPageRecords())#" index="local.i">
				<cfset local.thisPriceGroup = rc.priceGroupSmartList.getPageRecords()[local.i]>
				<div id="updatePriceGroupSKUSettings_PriceGroupRateInputs[#local.thisPriceGroup.getPriceGroupId()#]" class="ui-helper-hidden">
					<cfif ArrayLen(local.thisPriceGroup.getPriceGroupRates()) EQ 0>
						<p>No rates were defined for this price group.</p>
					<cfelse>	
						<select name="updatePriceGroupSKUSettings_PriceGroupRateId[#local.thisPriceGroup.getPriceGroupId()#]_PriceGroupId" id="updatePriceGroupSKUSettings_PriceGroupRateSelect[#local.thisPriceGroup.getPriceGroupId()#]">
							<cfloop array="#local.thisPriceGroup.getPriceGroupRates()#" index="local.thisPriceGroupRate">
								<option value="#local.thisPriceGroupRate.getPriceGroupRateId()#">#local.thisPriceGroupRate.getAmountRepresentation()#</option>
							</cfloop>	
							<option value="new amount">New Amount</option>	
						</select>
						<!---<cfloop array="#local.thisPriceGroup.getPriceGroupRates()#" index="local.thisPriceGroupRate">
							<p><input type="radio" name="updatePriceGroupSKUSettings_PriceGroupId[#local.thisPriceGroup.getPriceGroupId()#]_PriceGroupId" value="#local.thisPriceGroupRate.getPriceGroupRateId()#"> #local.thisPriceGroupRate.getAmountRepresentation()# </p>
						</cfloop>--->
					</cfif>
					
					<div id="updatePriceGroupSKUSettings[#local.thisPriceGroup.getPriceGroupId()#]_newAmount" class="ui-helper-hidden">
						<p>#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.newamount')#: <input type="text" name="updatePriceGroupSKUSettings_PriceGroupId[#local.thisPriceGroup.getPriceGroupId()#]_NewAmount"></p>
					</div>
				</div>
			</cfloop>
		</form>
	</div>
</cfoutput>