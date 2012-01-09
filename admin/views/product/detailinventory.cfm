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
<cfparam name="rc.product" type="any">
<cfparam name="rc.locations" type="array">

<cfoutput>
	<div class="svoinventorydetailproduct">
		<table class="listing-grid stripe">
			<tr>
				<th class="varWidth" colspan="2">Product Name / Sku / Location</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qoh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qosh.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndoo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndorvo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qndosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnroro.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrovo.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnrosa.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qr.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qs.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qe.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qnc.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qats.full')#</th>
				<th style="white-space:normal; vertical-align: text-bottom;">#$.slatwall.rbKey('define.qiats.full')#</th>
			</tr>
			<tr class="product">
				<td class="varWidth" colspan="2">#rc.product.getProductName()#</td>
				<td>#rc.product.getQOH()#</td>
				<td>#rc.product.getQOSH()#</td>
				<td>#rc.product.getQNDOO()#</td>
				<td>#rc.product.getQNDORVO()#</td>
				<td>#rc.product.getQNDOSA()#</td>
				<td>#rc.product.getQNRORO()#</td>
				<td>#rc.product.getQNROVO()#</td>
				<td>#rc.product.getQNROSA()#</td>
				<td>#rc.product.getQR()#</td>
				<td>#rc.product.getQS()#</td>
				<td>#rc.product.getQC()#</td>
				<td>#rc.product.getQE()#</td>
				<td>#rc.product.getQNC()#</td>
				<td>#rc.product.getQATS()#</td>
				<td>#rc.product.getQIATS()#</td>
			</tr>
			<cfloop array="#rc.product.getSkus()#" index="local.sku">
				<tr class="sku">
					<td style="text-align:left;">#local.sku.getSkuCode()#</td>
					<td class="varWidth">#local.sku.displayOptions()#</td>
					<td>#local.sku.getQOH()#</td>
					<td>#local.sku.getQOSH()#</td>
					<td>#local.sku.getQNDOO()#</td>
					<td>#local.sku.getQNDORVO()#</td>
					<td>#local.sku.getQNDOSA()#</td>
					<td>#local.sku.getQNRORO()#</td>
					<td>#local.sku.getQNROVO()#</td>
					<td>#local.sku.getQNROSA()#</td>
					<td>#local.sku.getQR()#</td>
					<td>#local.sku.getQS()#</td>
					<td>#local.sku.getQC()#</td>
					<td>#local.sku.getQE()#</td>
					<td>#local.sku.getQNC()#</td>
					<td>#local.sku.getQATS()#</td>
					<td>#local.sku.getQIATS()#</td>
				</tr>
				<cfif arrayLen(rc.locations) gt 1>
					<cfloop array="#rc.locations#" index="local.location">
						<tr class="stock">
							<td>&nbsp;</td>
							<td class="varWidth">#local.location.getLocationName()#</td>
							<td>#local.sku.getQOH(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQOSH(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNDOO(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNDORVO(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNDOSA(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNRORO(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNROVO(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNROSA(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQR(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQS(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQC(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQE(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQNC(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQATS(locationID=local.location.getLocationID())#</td>
							<td>#local.sku.getQIATS(locationID=local.location.getLocationID())#</td>
						</tr>
					</cfloop>
				</cfif>
			</cfloop>
		</table>
	</div>
</cfoutput>
















