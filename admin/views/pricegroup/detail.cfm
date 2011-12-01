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
<cfparam name="rc.priceGroup" type="any">
<cfparam name="rc.newPriceGroupRate" type="any">	<!--- This will be empty, and will be used by the "template" --->
<cfparam name="rc.edit" type="boolean">

<cfif rc.edit>
	<!---<cfset getAssetWire().addJSVariable("getProductTypeTreeAPIKey", $.slatwall.getAPIKey('productservice/getproductyypetree','post')) />--->
</cfif>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:priceGroup.list" type="list">
	<cfif !rc.edit>
		<cf_SlatwallActionCaller action="admin:priceGroup.edit" queryString="priceGroupID=#rc.priceGroup.getPriceGroupID()#" type="list">
	</cfif>
</ul>

<cfoutput>
	<div class="svoadminpricegroupdetail">
		<cfif rc.edit>
			<form name="PriceGroupEdit" action="#buildURL('admin:priceGroup.save')#" method="post">
				<input type="hidden" name="PriceGroupID" value="#rc.PriceGroup.getPriceGroupID()#" />
		</cfif>
		
		<dl class="twoColumn">
			<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="activeFlag" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupName" edit="#rc.edit#" first="true">
			<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupCode" edit="#rc.edit#" >
		</dl>
			<!---<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:priceGroup.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.priceGroup.isNew()>
					<cf_SlatwallActionCaller action="admin:priceGroup.delete" querystring="priceGroupid=#rc.priceGroup.getPriceGroupID()#" class="button" type="link" confirmrequired="true">
				</cfif>
				<cf_SlatwallActionCaller action="admin:priceGroup.save" type="submit" class="button">
			</div>
			</cfif>
		</form>--->

	
	
		
		<cfif not rc.priceGroup.isNew()>
			<strong>#$.slatwall.rbKey('admin.pricegroup.edit.priceGroupRates')#</strong>
		
			<table id="priceGroupRates" class="mura-table-grid stripe">
				<thead>
					<tr>
						<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateType")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateAmount")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateAppliesTo")#</th>
						<cfif rc.edit><th class="administration">&nbsp;</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#rc.priceGroup.getPriceGroupRates()#" index="local.priceGroupRate" >
						<tr>
							<td class="varWidth">#$.Slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.' & local.priceGroupRate.getType())#</td>
							<td>#local.priceGroupRate.getAmountRepresentation()#</td>
							<td>#local.priceGroupRate.getAppliesToRepresentation()#</td>
							<cfif rc.edit>
								<td class="administration">
									<ul class="one">
										<cfif not local.priceGroupRate.isNew()>
											<cf_SlatwallActionCaller action="admin:pricegroup.deletePriceGroupRate" querystring="priceGroupID=#rc.priceGroup.getPriceGroupID()#&priceGroupRateId=#local.priceGroupRate.getPriceGroupRateId()#" class="delete" type="list">
										</cfif>
									</ul>
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif rc.edit>
				<div id="priceGroupRateInputs" class="ui-helper-hidden">
					<strong>#rc.$.Slatwall.rbKey("admin.pricegroup.edit.addPriceGroupRate")#</strong>
					<cf_SlatwallPriceGroupRateDisplay priceGroupRate="#entityNew('SlatwallPriceGroupRate')#" edit="true" />
				</div>
				<!---<button type="submit" name="addPriceGroupRate" value="true">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.addPriceGroupRate")#</button><br /><br />--->
				<input type="hidden" name="addPriceGroupRate" id="addPriceGroupRateHidden" value=""/>
				
				<button type="button" id="addPriceGroupRateButton" value="true">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.addPriceGroupRate")#</button><br /><br />
			</cfif>
		</cfif>
		<cfif rc.edit>
			<cf_SlatwallActionCaller action="admin:pricegroup.list" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="admin:pricegroup.save" type="submit" class="button">
			</form>
		</cfif>
		
	</div>	
		
</cfoutput>
