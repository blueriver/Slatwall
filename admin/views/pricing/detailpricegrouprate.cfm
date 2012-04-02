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
<cfparam name="rc.pricegrouprate" type="any" />
<cfparam name="rc.pricegroup" type="any" default="#rc.pricegrouprate.getPricegroup()#" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.pricegrouprate#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.pricegrouprate#" edit="#rc.edit#" 
							  cancelAction="admin:pricing.detailpricegroup"
							  cancelQueryString="pricegroupID=#rc.pricegroup.getpricegroupID()#" 
							  backAction="admin:pricing.detailpricegroup" 
							  backQueryString="pricegroupID=#rc.pricegroup.getpricegroupID()#" />
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<input type="hidden" name="pricegroup.pricegroupID" value="#rc.pricegroup.getPricegroupID()#" />
				<input type="hidden" name="returnAction" value="admin:pricing.detailpricegroup&pricegroupID=#rc.pricegroup.getpricegroupID()#" />
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="globalFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="type" fieldType="select" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="percentageOff" edit="#rc.edit#" displayVisible="type:percentageOff">
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="amountOff" edit="#rc.edit#" displayVisible="type:amountOff" />
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="amount" edit="#rc.edit#" displayVisible="type:amount"  />
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="roundingRule" edit="#rc.edit#" displayVisible="type:percentageOff">
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="productTypes" edit="#rc.edit#" displayVisible="globalFlag:0" />
				<cf_SlatwallPropertyDisplay object="#rc.pricegrouprate#" property="products" edit="#rc.edit#" displayVisible="globalFlag:0" />
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		
	</cf_SlatwallDetailForm>
</cfoutput>