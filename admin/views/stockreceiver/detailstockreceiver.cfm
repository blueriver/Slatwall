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

<!--- Generic properties for all StockReceivers --->
<cfparam name="rc.stockReceiver">
<cfparam name="rc.backAction">
<cfparam name="rc.locationSmartList">

<cfoutput>
	<ul id="navTask">
		<cf_SlatwallActionCaller action="#rc.backAction#" queryString="#rc.backQueryString#" type="list">
	</ul>
	
	<!--- For now, there is no basic order info, but in future, we might want to make this section dynamic like the bellow table, based on the type provided --->


	<form name="detailStockReceiver" id="detailStockReceiver" action="#BuildURL(rc.action)#" method="post">

		<div class="clear">
			<!--- These are common fields to all StockReceivers --->
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay title="#$.Slatwall.rbKey("entity.stockReceiver.boxCount")#" object="#rc.StockReceiver#" property="boxCount" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay title="#$.Slatwall.rbKey("entity.stockReceiver.packingSlipNumber")#" object="#rc.StockReceiver#" property="packingSlipNumber" edit="#rc.edit#">
				
				<dt class="title"><label>#$.Slatwall.rbKey("admin.stockReceiver.receiveForLocation")#</strong></label></dt> 
				<dd class="value">
					<cf_SlatwallFormField fieldType="select" fieldName="receiveForLocationID" valueOptions="#rc.locationSmartList.getRecords()#" fieldClass="receiveForLocationID">
				</dd>
				
			</dl>
	
			<!--- The receiver table bellow is chosen dynamically based on the type of stock receiver --->
			#view("stockreceiver/receivertypes/#rc.stockReceiver.getReceiverType()#")# 
			
			<!---<cf_SlatwallActionCaller action="" type="link" class="cancel button" queryString="#rc.backQueryString#" text="#rc.$.Slatwall.rbKey('admin.nav.back')#">--->
			
			<cf_SlatwallActionCaller action="#rc.backAction#" type="link" class="cancel button" queryString="vendorOrderId=#rc.vendorOrder.getVendorOrderID()#" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="#rc.action#" type="submit" class="button">
		</div>
	</form>
</cfoutput>