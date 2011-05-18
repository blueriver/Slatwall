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
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.shippingMethod" type="any" />
<cfparam name="rc.shippingServices" type="any" />
<cfparam name="rc.blankShippingRate" />

<cfoutput>
	<div class="svoadmindetailshippingmethod">
		<ul id="navTask">
	    	<cf_ActionCaller action="admin:setting.listshippingmethods" type="list">
			<cf_ActionCaller action="admin:setting.listshippingservices" type="list">
		</ul>
		
		<cfif rc.edit>
		<form name="ShippingMethodEdit" action="#buildURL('admin:setting.saveshippingmethod')#" method="post">
			<input type="hidden" name="shippingMethodID" value="#rc.shippingMethod.getShippingMethodID()#" />
		</cfif>
			<dl class="oneColumn">
				<cf_PropertyDisplay object="#rc.shippingMethod#" property="shippingMethodName" edit="#rc.edit#" first="true">
				<dt class="spdshippingprovider">
					#rc.$.slatwall.rbKey('entity.shippingmethod.shippingprovider')#
				</dt>
				<dd id="spdshippingprovider">
					<cfif rc.edit and rc.shippingMethod.isNew()>
						<select id="shippingProvider" name="shippingProvider">
							<option value="RateTable">Rate Table</option>
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
				<cfif rc.shippingMethod.isNew() or rc.shippingMethod.getShippingProvider() eq "RateTable">
					<dt class="spdshippingmethod">Shipping Rates</dt>
					<dd id="spdshippingmethod">
						<cfset local.shippingRates = rc.shippingMethod.getShippingRates() />
						<table class="stripe" id="shippingRateTable" <cfif not arrayLen(local.shippingRates)>style="display:none;"</cfif>>
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
								<cfloop from="1" to="#arrayLen(local.shippingRates)#" index="local.rateCount">
									<tr id="ShippingRate#local.rateCount#" class="rateRow">
										<td class="varWidth">
											<cfif rc.edit>
												<input type="hidden" name="shippingRates[#local.rateCount#].shippingRateID" value="#local.shippingRates[rateCount].getShippingRateID()#" />
												<cf_propertyDisplay object="#local.shippingRates[rateCount]#" property="addressZone" edit="#rc.edit#" displaytype="plain" />
											<cfelse>
												#local.shippingRates[rateCount].getAddressZone().getAddressZoneName()#
											</cfif>
										</td>
										<td><cfif rc.edit><input name="shippingRates[#local.rateCount#].minWeight" value="#local.shippingRates[rateCount].getMinWeight()#"><cfelse>#local.shippingRates[rateCount].getMinWeight()#</cfif></td>
										<td><cfif rc.edit><input name="shippingRates[#local.rateCount#].maxWeight" value="#local.shippingRates[rateCount].getMaxWeight()#"><cfelse>#local.shippingRates[rateCount].getMaxWeight()#</cfif></td>
										<td><cfif rc.edit><input name="shippingRates[#local.rateCount#].minPrice" value="#local.shippingRates[rateCount].getMinPrice()#"><cfelse>#local.shippingRates[rateCount].getMinPrice()#</cfif></td>
										<td><cfif rc.edit><input name="shippingRates[#local.rateCount#].maxPrice" value="#local.shippingRates[rateCount].getMaxPrice()#"><cfelse>#local.shippingRates[rateCount].getMaxPrice()#</cfif></td>
										<td><cfif rc.edit><input name="shippingRates[#local.rateCount#].cost" value="#local.shippingRates[rateCount].getCost()#"><cfelse>#local.shippingRates[rateCount].getCost()#</cfif></td>
										<td class="administration">&nbsp;</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
						<cfif rc.edit><a class="button" id="addShippingRate">Add Shipping Rate</a></cfif>
					</dd>
				<cfelse>
					<dt class="spdshippingprovidermethod">Shipping Provider Method</dt>
					<cfset local.shippingService = rc.shippingServices[rc.shippingMethod.getShippingProvider()] />
					<cfset local.shippingServiceMethods = local.shippingService.getShippingMethods() />
					<cfif rc.edit>
						<dd id="spdshippingprovidermethod">
							<select name="shippingProviderMethod">
								<cfloop collection="#local.shippingServiceMethods#" item="local.shippingMethodID">
									<option value="#local.shippingMethodID#" <cfif rc.shippingMethod.getShippingProviderMethod() eq local.shippingMethodID>selected="selected"</cfif>>#local.shippingServiceMethods[shippingMethodID]#</option>
								</cfloop>
							</select>
						</dd>
					<cfelse>
						<dd id="spdshippingprovidermethod">#local.shippingServiceMethods[rc.shippingMethod.getShippingProviderMethod()]#</dd>	
					</cfif>
				</cfif>
			</dl>
	<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_ActionCaller action="admin:setting.listshippingmethods" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.shippingMethod.isNew()>
					<cf_ActionCaller action="admin:setting.deleteshippingmethod" querystring="shippingMethodID=#rc.shippingMethod.getShippingMethodID()#" class="button" type="link" confirmRequired="true">
				</cfif>
				<cf_ActionCaller action="admin:setting.saveshippingmethod" type="submit" class="button">
			</div>
		</form>
	</cfif>
		
		<cfif rc.edit>
			<table id="tableTemplate" class="hideElement">
				<tbody>
				    <tr id="temp">
				        <td><input type="hidden" name="shippingRateID" value="" /><cf_propertyDisplay object="#rc.blankShippingRate#" property="addressZone" edit="true" displaytype="plain" /></td>
				        <td><input type="text" name="minWeight"></td>
						<td><input type="text" name="maxWeight"></td>
						<td><input type="text" name="minPrice"></td>
						<td><input type="text" name="maxPrice"></td>
						<td><input type="text" name="cost"></td>
						<td class="administration">&nbsp;</td>
					</tr>
				</tbody>
			</table>
		</cfif>
		
		<!--- This area generates the content that gets used based upon shipping provider --->
		<div class="hideElement">
			<cfloop collection="#rc.shippingServices#" item="local.shippingServicePackage">
				<cfset local.shippingService = rc.shippingServices[local.shippingServicePackage] />
				<cfset local.shippingServiceMethods = local.shippingService.getShippingMethods() />
				<select name="shippingProviderMethod" id="#local.shippingServicePackage#">
					<cfloop collection="#local.shippingServiceMethods#" item="local.shippingMethodID">
						<option value="#shippingMethodID#" <cfif rc.shippingMethod.getShippingProvider() eq local.shippingServicePackage and rc.shippingMethod.getShippingProviderMethod() eq local.shippingMethodID>selected="selected"</cfif>>#local.shippingServiceMethods[shippingMethodID]#</option>
					</cfloop>
				</select>
			</cfloop>
		</div>
	</div>
</cfoutput>
