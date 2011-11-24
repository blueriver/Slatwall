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
	<div class="svoadminpriceGroupdetail">
		<cfif rc.edit>
		<form name="PriceGroupEdit" action="#buildURL('admin:priceGroup.save')#" method="post">
			<input type="hidden" name="PriceGroupID" value="#rc.PriceGroup.getPriceGroupID()#" />
		</cfif>
			<dl class="oneColumn">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupName" edit="#rc.edit#" first="true">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupCode" edit="#rc.edit#" >
			</dl>
			<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:priceGroup.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.priceGroup.isNew()>
				<cf_SlatwallActionCaller action="admin:priceGroup.delete" querystring="priceGroupid=#rc.priceGroup.getPriceGroupID()#" class="button" type="link" confirmrequired="true">
				</cfif>
				<cf_SlatwallActionCaller action="admin:priceGroup.save" type="submit" class="button">
			</div>
			</cfif>
		</form>
	</div>
</cfoutput>
