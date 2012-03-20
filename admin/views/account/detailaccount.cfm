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
<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />
<!---<cfset local.attributeSets = rc.account.getAttributeSets(["astAccount"]) />--->

<cf_SlatwallDetailForm object="#rc.account#" edit="#rc.edit#">
	<cf_SlatwallActionBar type="detail" object="#rc.account#" edit="#rc.edit#" />
	
	<cf_SlatwallDetailHeader>
		<cf_SlatwallPropertyList>
			<cf_SlatwallPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
		</cf_SlatwallPropertyList>
	</cf_SlatwallDetailHeader>
	
	<cf_SlatwallTabGroup>
		<cf_SlatwallTab view="admin:account/accounttabs/addresses" />
		<cf_SlatwallTab view="admin:account/accounttabs/login" />
		<cf_SlatwallTab view="admin:account/accounttabs/orders" />
<!---		<cf_SlatwallTab view="admin:account/accounttabs/carts" />--->
		<cf_SlatwallTab view="admin:account/accounttabs/productreviews" />
		<cf_SlatwallTab view="admin:account/accounttabs/pricegroups" />	
	</cf_SlatwallTabGroup>
	
</cf_SlatwallDetailForm>

<!---<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:account.list" type="list">
	<cfif !rc.edit>
	<cf_SlatwallActionCaller action="admin:account.edit" queryString="accountID=#rc.account.getAccountID()#" type="list">
	</cfif>
</ul>

<cfoutput>
	<div class="svoadminaccountdetail">
		<cfif rc.edit>
			<form name="accountEdit" action="#buildURL(action='admin:account.save')#" method="post">
				<input type="hidden" name="accountID" value="#rc.account.getAccountID()#" />
		</cfif>
		<dl class="twoColumn">
			<cf_SlatwallPropertyDisplay object="#rc.Account#" property="lastName" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.Account#" property="firstName" edit="#rc.edit#" first="true">
			<cf_SlatwallPropertyDisplay object="#rc.Account#" property="company" edit="#rc.edit#">
		</dl>

		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all clear">
			<ul>
				<li><a href="##tabAddresses" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.addresses")#</span></a></li>
				<li><a href="##tabLogin" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.login")#</span></a></li>
				<li><a href="##tabOrders" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.orders")#</span></a></li>
				<li><a href="##tabCarts" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.carts")#</span></a></li>
				<li><a href="##tabProductReviews" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.productReviews")#</span></a></li>
				<li><a href="##tabPriceGroups" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.account.detail.tab.PriceGroups")#</span></a></li>
				<cfloop array="#rc.attributeSets#" index="local.attributeSet">
					<li><a href="##tabCustomAttributes_#local.attributeSet.getAttributeSetID()#" onclick="return false;"><span>#local.attributeSet.getAttributeSetName()#</span></a></li>
				</cfloop>
			</ul>
		
			<div id="tabAddresses">
				#view("admin:account/accounttabs/addresses")#
			</div>
			<div id="tabLogin">
				#view("admin:account/accounttabs/login")#
			</div>
			<div id="tabOrders">
				#view("admin:account/accounttabs/orders")#
			</div>
			<div id="tabCarts">
				#view("admin:account/accounttabs/carts")#
			</div>
			<div id="tabProductReviews">
				#view("admin:account/accounttabs/productreviews")#
			</div>
			<div id="tabPriceGroups">
				#view("admin:account/accounttabs/pricegroups")#
			</div>
			#view("account/accounttabs/customattributes")#
		</div>
		
		<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:account.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cf_SlatwallActionCaller action="admin:account.save" type="submit" class="button">
			</div>
			</form>
		</cfif>
	</div>
</cfoutput>--->