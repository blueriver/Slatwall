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
<cfparam name="rc.shippingMethod" type="any" />
<cfparam name="rc.shippingServices" type="any" />
<cfparam name="rc.addressZones" type="array" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.blankShippingRate" type="any" />

<cfoutput>
	<div class="svoadmindetailshippingmethod">
		<ul id="navTask">
	    	<cf_ActionCaller action="admin:setting.listshippingmethods" type="list">
			<cf_ActionCaller action="admin:setting.listshippingservices" type="list">
		</ul>
		
		<form name="ShippingMethodEdit" action="#buildURL('admin:setting.saveshippingmethod')#" method="post">
			<input type="hidden" name="shippingMethodID" value="#rc.shippingMethod.getShippingMethodID()#" />
			<dl class="oneColumn">
				<cf_PropertyDisplay object="#rc.shippingMethod#" property="shippingMethodName" edit="#rc.edit#" first="true">
				<dt class="spdshippingprovider">
					#rc.$.slatwall.rbKey('entity.shippingmethod.shippingprovider')#
				</dt>
				<dd id="spdshippingprovider">
					<cfif rc.edit>
						<select id="shippingProvider" name="shippingProvider">
							<option value="Rate">Rate Table</option>
							<cfloop collection="#rc.shippingServices#" item="local.shippingServicePackage">
								<cfset local.shippingService = rc.shippingServices[local.shippingServicePackage] />
								<cfset local.shippingServiceMetaData = getMetaData(local.shippingService) />
								<option value="#local.shippingServicePackage#" <cfif rc.shippingMethod.getShippingProvider() eq local.shippingServicePackage>selected="selected"</cfif>>#local.shippingServiceMetaData.displayName#</option>
							</cfloop>
						</select>
					<cfelse>
						#rc.shippingMethod.getShippingProvider()#
					</cfif>
				</dd>
				<cfif rc.edit>
					<dt class="spdshippingprovidermethod">#rc.$.slatwall.rbKey('entity.shippingmethod.shippingprovidermethod')#</dt>
					<dd id="spdshippingprovidermethod">&nbsp;</dd>
				<cfelse>
					<cf_PropertyDisplay object="#rc.shippingMethod#" property="shippingMethodName">
				</cfif>
			</dl>
	<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_ActionCaller action="admin:setting.listshippingmethods" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.shippingMethod.isNew()>
					<cf_ActionCaller action="admin:setting.deleteshippingmethod" querystring="shippingMethodID=#rc.shippingMethod.getShippingMethodID()#" class="button" type="link" confirmRequired="true">
				</cfif>
				<cf_ActionCaller action="admin:setting.saveshippingmethod" type="submit">
			</div>
		</form>
	</cfif>
		
		<!--- This area generates the content that gets used based upon shipping provider --->
		<div style="display:none;">
			<cfloop collection="#rc.shippingServices#" item="local.shippingServicePackage">
				<cfset local.shippingService = rc.shippingServices[local.shippingServicePackage] />
				<cfset local.shippingServiceMethods = local.shippingService.getShippingMethods() />
				<cfset local.shippingServiceMetaData = getMetaData(local.shippingService) />
				<dd class="spm#local.shippingServicePackage#">
					<select name="shippingProviderMethod">
						<cfloop collection="#local.shippingServiceMethods#" item="local.shippingMethodID">
							<option value="#shippingMethodID#" <cfif rc.shippingMethod.getShippingProvider() eq local.shippingServicePackage and rc.shippingMethod.getShippingProviderMethod() eq local.shippingMethodID>selected="selected"</cfif>>#local.shippingServiceMethods[shippingMethodID]#</option>
						</cfloop>
					</select>
				</dd>
			</cfloop>
			<dd class="spmRate">
				<table class="stripe" id="shippingRates">
					<thead>
					<tr>
						<th class="varWidth">#rc.$.slatwall.rbKey('entity.shippingrate.shippingZone')#</th>
						<th>#rc.$.slatwall.rbKey('entity.shippingrate.minWeight')#</th>
						<th>#rc.$.slatwall.rbKey('entity.shippingrate.maxWeight')#</th>
						<th>#rc.$.slatwall.rbKey('entity.shippingrate.minPrice')#</th>
						<th>#rc.$.slatwall.rbKey('entity.shippingrate.maxPrice')#</th>
						<th>#rc.$.slatwall.rbKey('entity.shippingrate.cost')#</th>
						<th class="administration">&nbsp;</th>
					</tr>
					</thead>
					<tbody>
					<cfset local.shippingRates = rc.shippingMethod.getShippingRates() />
					<cfloop array="#local.shippingRates#" index="local.shippingRate">
						<tr>
							<td class="varWidth">&nbsp;</td>
							<td><cfif rc.edit><input name="shippingRates.#local.shippingRate.getShippingRateID()#.minWeight" value="#local.shippingRate.getMinWeight()#"><cfelse>#local.shippingRate.getMinWeight()#</cfif></td>
							<td><cfif rc.edit><input name="shippingRates.#local.shippingRate.getShippingRateID()#.maxWeight" value="#local.shippingRate.getMaxWeight()#"><cfelse>#local.shippingRate.getMaxWeight()#</cfif></td>
							<td><cfif rc.edit><input name="shippingRates.#local.shippingRate.getShippingRateID()#.minPrice" value="#local.shippingRate.getMinPrice()#"><cfelse>#local.shippingRate.getMinPrice()#</cfif></td>
							<td><cfif rc.edit><input name="shippingRates.#local.shippingRate.getShippingRateID()#.maxPrice" value="#local.shippingRate.getMaxPrice()#"><cfelse>#local.shippingRate.getMaxPrice()#</cfif></td>
							<td><cfif rc.edit><input name="shippingRates.#local.shippingRate.getShippingRateID()#.cost" value="#local.shippingRate.getCost()#"><cfelse>#local.shippingRate.getCost()#</cfif></td>
							<td class="administration">&nbsp;</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
				<a class="button" id="addRate">Add Rate</a>
			</dd>
		</div>
		
		<table style="display:none;">
			<tbody class="template">
				<tr>
					<td class="varWidth"><cf_propertyDisplay object="#rc.blankShippingRate#" property="shippingZone" edit="true" /></td>
					<td><input type="text" name="shippingRates.new.minWeight"></td>
					<td><input type="text" name="shippingRates.new.maxWeight"></td>
					<td><input type="text" name="shippingRates.new.minPrice"></td>
					<td><input type="text" name="shippingRates.new.maxPrice"></td>
					<td><input type="text" name="shippingRates.new.cost"></td>
					<td class="administration">&nbsp;</td>
				</tr>
			</tbody>
		</table>
		
		<script type="text/javascript">
			var currentNewRate = 1;
			$(document).ready(function(){
				swapShippingMethods( '#rc.shippingMethod.getShippingProvider()#' );
				
				$("##shippingProvider").change(function(){
					swapShippingMethods($("##shippingProvider option:selected").text());
				});
				
				$("##addRate").click(function(){
					var appendContent = $(".template").html();
					appendContent = appendContent.replace(/.new./g, ".new" + currentNewRate + ".")
					$("##shippingRates > tbody:last").append(appendContent);
					currentNewRate++;
				});
			});
			
			function swapShippingMethods( selectionName ) {
				if(selectionName == "") {
					selectionName = "Rate";
				}
				var selector = ".spm" + selectionName;
				$("##spdshippingprovidermethod").html($(selector).html());
			}
			
			function addRateRow() {
				$(".rateTemplate").clone(true).appendTo("##ratesTable");
			}
		</script>
	</div>
</cfoutput>
