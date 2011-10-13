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
<cfparam name="rc.promotions" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_SlatwallActionCaller action="admin:promotion.create" type="list">
</ul>

<div class="svoadminpromotionlist">
<cfif arrayLen(rc.promotions) gt 0>
	<table id="Promotions" class="mura-table-grid stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.promotion.promotionName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.promotion.startDateTime")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.promotion.endDateTime")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.promotion.activeFlag")#</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop array="#rc.promotions#" index="Local.Promotion">
			<tr>
				<td class="varWidth">#local.Promotion.getPromotionName()#</td>
				<td>#dateFormat(local.Promotion.getStartDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.Promotion.getStartDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#</td>
				<td>#dateFormat(local.Promotion.getEndDateTime(),rc.$.slatwall.setting('advanced_dateFormat'))# #timeFormat(local.Promotion.getEndDateTime(),rc.$.slatwall.setting('advanced_timeFormat'))#</td>
				<td>#yesNoFormat(local.Promotion.getActiveFlag())#</td>
				<td class="administration">
		          <ul class="three">
                      <cf_SlatwallActionCaller action="admin:promotion.edit" querystring="promotionID=#local.promotion.getPromotionID()#" class="edit" type="list">            
					  <cf_SlatwallActionCaller action="admin:promotion.detail" querystring="promotionID=#local.promotion.getPromotionID()#" class="viewDetails" type="list">
					  <cf_SlatwallActionCaller action="admin:promotion.delete" querystring="promotionID=#local.promotion.getPromotionID()#" class="delete" type="list" disabled="#local.promotion.isAssigned()#" disabledText="#rc.$.Slatwall.rbKey('entity.promotion.delete_validateisassigned')#" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
<cfelse>
<em>#rc.$.Slatwall.rbKey("admin.promotion.nopromotionsdefined")#</em>
</cfif>
</div>
</cfoutput>