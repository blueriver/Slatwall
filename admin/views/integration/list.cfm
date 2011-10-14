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
<cfparam name="rc.integrationSmartList" type="any" />

<cfoutput>
<div class="svoadminintegrationlist">
	<ul id="navTask">
		<li><a href="?slatAction=integration.list">Show All Integrations</a></li>
    	<li><a href="?slatAction=integration.list&F:dataReadyFlag=1">Show Data Integrations</a></li>
		<li><a href="?slatAction=integration.list&F:paymentReadyFlag=1">Show Payment Integrations</a></li>
		<li><a href="?slatAction=integration.list&F:shippingReadyFlag=1">Show Shipping Integrations</a></li>
	</ul>
	
	<table class="mura-table-grid">
		<thead>
			<tr>
				<th class="varWidth">Integration Service Name</th>
				<th>Enabled</th>
				<th class="administration">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#rc.integrationSmartList.getRecords()#" index="local.integration">
				<tr>
					<td class="varWidth"><a href="#buildURL(action='admin:integration.detail', queryString='integrationPackage=#local.integration.getIntegrationPackage()#')#">#local.integration.getIntegrationName()#</a></td>
					<td>
						<cfif local.integration.getActiveFlag()>
							<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.check_green.png" with="16" height="16" alt="#rc.$.Slatwall.rbkey('sitemanager.yes')#" title="#rc.$.Slatwall.rbkey('sitemanager.yes')#" />
						<cfelse>
							<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.cross_red.png" with="16" height="16" alt="#rc.$.Slatwall.rbkey('sitemanager.no')#" title="#rc.$.Slatwall.rbkey('sitemanager.no')#" />
						</cfif>
					</td>
					<td class="administration">
						<ul class="one">
							<cf_SlatwallActionCaller action="admin:integration.edit" querystring="integrationPackage=#local.integration.getIntegrationPackage()#" class="edit" type="list">
						</ul>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</div>
</cfoutput>