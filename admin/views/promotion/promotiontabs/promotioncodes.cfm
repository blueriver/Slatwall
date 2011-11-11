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
<div class="buttons">
	<a class="button" id="addPromotionCode">#rc.$.Slatwall.rbKey("admin.promotion.edit.addPromotionCode")#</a>
	<a class="button" id="remPromotionCode" style="display:none;">#rc.$.Slatwall.rbKey("admin.promotion.edit.removePromotionCode")#</a>
</div>
</cfif>
	<table id="promotionCodeTable" class="mura-table-grid stripe">
		<thead>
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.promotionCode.promotionCode")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionCode.startDateTime")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionCode.endDateTime")#</th>
				<cfif rc.edit>
				  <th class="administration">&nbsp;</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
		<cfloop from="1" to="#arrayLen(rc.promotionCodeSmartList.getPageRecords())#" index="local.promotionCodeCount">
			<cfset local.thisPromotionCode = rc.promotionCodeSmartList.getPageRecords()[local.promotionCodeCount] />
			<tr id="PromotionCode#local.promotionCodeCount#" class="promotionCodeRow">
				<input type="hidden" name="promotionCodes[#local.promotionCodeCount#].promotionCodeID" value="#local.thisPromotionCode.getPromotionCodeID()#" />
				<td class="alignLeft">
					<cfif rc.edit>
						<input type="text" size="40" name="promotionCodes[#local.promotionCodeCount#].promotionCode" value="#local.thisPromotionCode.getPromotionCode()#" />
						<cfif local.thisPromotionCode.hasErrors()>
							<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("promotionCode")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionCode.getPromotionCode()#
					</cfif>
				</td>
				<td>
					<cfset local.startDateTime = "#dateFormat(local.thisPromotionCode.getStartDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.thisPromotionCode.getStartDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#" />
					<cfif rc.edit>
						<input type="text" size="30" name="promotionCodes[#local.promotionCodeCount#].startDateTime" value="#trim(local.startDateTime)#" class="dateTime" />
						<cfif local.thisPromotionCode.hasErrors()>
							<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("startDateTime")#</span>
						</cfif>
					<cfelse>
						#local.startDateTime#
					</cfif>
				</td>
				<td>
					<cfset local.endDateTime = "#dateFormat(local.thisPromotionCode.getEndDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.thisPromotionCode.getEndDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#" />
					<cfif rc.edit>
						 <input type="text" size="30" name="promotionCodes[#local.promotionCodeCount#].endDateTime" value="#trim(local.endDateTime)#" class="dateTime" />         
						<cfif local.thisPromotionCode.hasErrors()>
							<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("endDateTime")#</span>
						</cfif>
					<cfelse>
						#local.endDateTime#
					</cfif>
				</td>
				<cfif rc.edit>
					<td class="administration">
						<cfif !local.thisPromotionCode.isNew()>
							<cfset local.disabledText = "" />
							<ul class="one">
								<cfset local.deleteDisabled = local.thisPromotionCode.isAssigned() />
								<cfif local.deleteDisabled>
									<cfset local.disabledText = rc.$.Slatwall.rbKey('entity.promotionCode.delete_validateAssigned') />
								</cfif>
								<cf_SlatwallActionCaller action="admin:promotion.deletePromotionCode" querystring="promotionCodeID=#local.thisPromotionCode.getPromotionCodeID()#" class="delete" type="list" disabled="#local.deleteDisabled#" disabledText="#local.disabledText#" confirmrequired="true">
							</ul>
						</cfif>
					</td>
				</cfif>
			</tr>
		</cfloop>
		<cfif rc.edit>
			<cfloop from="1" to="#arrayLen(rc.promotion.getPromotionCodes())#" index="local.promotionCodeCount">
				<cfset local.thisPromotionCode = rc.promotion.getPromotionCodes()[local.promotionCodeCount] />
				<cfif rc.promotion.isNew() OR local.thisPromotionCode.isNew()>
					<tr id="PromotionCode#local.promotionCodeCount#" class="promotionCodeRow">
						<input type="hidden" name="promotionCodes[#local.promotionCodeCount#].promotionCodeID" value="" />
						<td class="alignLeft">
							<input type="text" size="40" name="promotionCodes[#local.promotionCodeCount#].promotionCode" value="#local.thisPromotionCode.getPromotionCode()#" />
							<cfif local.thisPromotionCode.hasErrors()>
								<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("promotionCode")#</span>
							</cfif>
						</td>
						<td>
							<cfset local.startDateTime = "#dateFormat(local.thisPromotionCode.getStartDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.thisPromotionCode.getStartDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#" />
							<input type="text" size="30" name="promotionCodes[#local.promotionCodeCount#].startDateTime" value="#trim(local.startDateTime)#" class="dateTime" />
							<cfif local.thisPromotionCode.hasErrors()>
								<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("startDateTime")#</span>
							</cfif>
						</td>
						<td>
							<cfset local.endDateTime = "#dateFormat(local.thisPromotionCode.getEndDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.thisPromotionCode.getEndDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#" />
							 <input type="text" size="30" name="promotionCodes[#local.promotionCodeCount#].endDateTime" value="#trim(local.endDateTime)#" class="dateTime" />         
							<cfif local.thisPromotionCode.hasErrors()>
								<br><span class="formError">#local.thisPromotionCode.getErrorBean().getError("endDateTime")#</span>
							</cfif>
						</td>
						<td class="administration">
						</td>
					</tr>
				</cfif>
			</cfloop>
		</cfif>
	</tbody>
</table>

<cf_SlatwallSmartListPager smartList="#rc.PromotionCodeSmartList#">

<cfif rc.edit>
<table id="promotionCodeTableTemplate" class="hideElement">
<tbody>
    <tr id="temp">
        <td class="alignLeft">
            <input type="text" size="40" name="promotionCode" value="" />
			<input type="hidden" name="promotionCodeID" value="" />
        </td>
        <td>
            <input type="text" size="30" name="startDateTime" value="" />
        </td>
        <td>
            <input type="text" size="30" name="endDateTime" value="" />         
        </td>
        <td class="administration">
        </td>
    </tr>
</tbody>
</table>
</cfif>
</cfoutput>