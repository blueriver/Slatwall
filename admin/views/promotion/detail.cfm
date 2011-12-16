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
<cfparam name="rc.promotion" type="any">
<cfparam name="rc.edit" type="boolean">

<!---
<cfif rc.edit>
	<cfset getAssetWire().addJSVariable("getProductTypeTreeAPIKey", $.slatwall.getAPIKey('productservice/getproductyypetree','post')) />
</cfif>
--->

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:promotion.list" type="list">
	<cfif !rc.edit>
	<cf_SlatwallActionCaller action="admin:promotion.edit" queryString="promotionID=#rc.promotion.getPromotionID()#" type="list">
	</cfif>
</ul>

<cfoutput>
	<div class="svoadminpromotiondetail">
		<cfif rc.edit>
		<form name="PromotionEdit" action="#buildURL('admin:promotion.save')#" method="post">
			<input type="hidden" name="PromotionID" value="#rc.Promotion.getPromotionID()#" />
		</cfif>
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="promotionName" edit="#rc.edit#" first="true">
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="startDateTime" value="#dateFormat(rc.promotion.getStartDateTime(),"MM/DD/YYYY")# #timeFormat(rc.promotion.getStartDateTime(),$.Slatwall.setting('advanced_timeFormat'))#" edit="#rc.edit#" class="dateTime">
				<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="endDateTime" value="#dateFormat(rc.promotion.getEndDateTime(),"MM/DD/YYYY")# #timeFormat(rc.promotion.getEndDateTime(),$.Slatwall.setting('advanced_timeFormat'))#" edit="#rc.edit#" class="dateTime">
				
				<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
					<ul>
						<li><a href="##tabPromotionRewards" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.promotion.detail.tabPromotionRewards')#</span></a></li>
						<li><a href="##tabPromotionCodes" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.promotion.detail.tabPromotionCodes')#</span></a></li>
						<li><a href="##tabDescription" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.promotion.detail.tabDescription')#</span></a></li>
						<li><a href="##tabSummary" onclick="return false;"><span>#rc.$.Slatwall.rbKey('admin.promotion.detail.tabSummary')#</span></a></li>
					</ul>
					<div id="tabPromotionRewards">
						#view("promotion/promotiontabs/promotionrewards")#
					</div>
					<div id="tabPromotionCodes">
						#view("promotion/promotiontabs/promotioncodes")#
					</div>
					<div id="tabDescription">
						<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="PromotionDescription" edit="#rc.edit#" fieldType="wysiwyg" displayType="plain">
					</div>
					<div id="tabSummary">
						<cf_SlatwallPropertyDisplay object="#rc.Promotion#" property="PromotionSummary" edit="#rc.edit#" fieldType="wysiwyg" displayType="plain">
					</div>
				</div>
			</dl>
			<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:promotion.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif Not rc.promotion.isNew()>
					<cf_SlatwallActionCaller action="admin:promotion.delete" querystring="promotionid=#rc.promotion.getPromotionID()#" class="button" type="link" disabled="#rc.promotion.isNotDeletable()#" disabledText="#rc.$.Slatwall.rbKey('entity.promotion.delete_validateisDeletable')#" confirmrequired="true">
				</cfif>
				<cf_SlatwallActionCaller action="admin:promotion.save" type="submit" class="button">
			</div>
			</cfif>
		</form>
	</div>
</cfoutput>
