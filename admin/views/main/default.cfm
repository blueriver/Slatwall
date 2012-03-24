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
<cfparam name="rc.orderSmartList" type="any" />
<cfparam name="rc.productSmartList" type="any" />
<cfparam name="rc.productReviewSmartList" type="any" />
<cfparam name="rc.stockReceiverSmartList" type="any" />
<cfparam name="rc.vendorSmartList" type="any" />
<cfparam name="rc.vendorOrderSmartList" type="any" />

<cfoutput>
<div class="row-fluid">
	<div class="span6">
		<h3>#rc.$.Slatwall.rbKey("admin.main.dashboard.neworders")#</h3>
		<table class="table table-stripe table-bordered table-condensed">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.order.orderNumber")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.order.orderOpenDateTime")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.account.fullname")#</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.orderSmartList.getPageRecords()#" index="local.order">
					<tr>
						<td><a href="#buildURL(action='admin:order.detailorder', queryString='orderID=#local.order.getOrderID()#')#">#local.order.getOrderNumber()#</a></td>
						<td><a href="#buildURL(action='admin:order.detailorder', queryString='orderID=#local.order.getOrderID()#')#">#DateFormat(local.order.getOrderOpenDateTime(), "MM/DD/YYYY")# - #TimeFormat(local.order.getOrderOpenDateTime(), "short")#</a></td>
						<cfif !isNull(local.order.getAccount())>
							<td class="varWidth"><a href="#buildURL(action='admin:account.detail', queryString='accountID=#local.order.getAccount().getAccountID()#')#">#local.order.getAccount().getFullName()#</a></td>
						<cfelse>
							<td class="varWidth"></td>
						</cfif>
						<td class="administration">
							<ul class="one">
							  <cf_SlatwallActionCaller action="admin:order.detailorder" querystring="orderID=#local.order.getOrderID()#" class="detail" type="list">
							</ul>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<div class="btn-group">
			<cf_SlatwallActionCaller action="admin:order.listorder" class="btn btn-mini" />
		</div>
	</div>
	<div class="span6">
		<h3>#rc.$.Slatwall.rbKey("admin.main.dashboard.recentproductupdates")#</h3>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.product.productName")#</th>
					<th>#rc.$.Slatwall.rbKey("define.modifiedDateTime")#</th>
					<th>#rc.$.Slatwall.rbKey("define.modifiedByAccount")#</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.productSmartList.getPageRecords()#" index="local.Product">
					<tr>
						<td class="primary"><a href="#buildURL(action='admin:product.detailproduct', querystring='productID=#local.Product.getProductID()#')#">#local.Product.getProductName()#</a></td>
						<td>#DateFormat(local.product.getModifiedDateTime(), "MM/DD/YYYY")# - #TimeFormat(local.product.getModifiedDateTime(), "HH:MM:SS")#</td>
						<td></td>
						<td>
							<cf_SlatwallActionCaller action="admin:product.editproduct" querystring="productID=#local.product.getProductID()#" icon="edit" iconOnly="true" class="btn btn-mini">
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<div class="btn-group">
			<cf_SlatwallActionCaller action="admin:product.listproduct" class="btn btn-mini" />
			<cf_SlatwallActionCaller action="admin:product.createproduct" class="btn btn-mini" />
		</div>
	</div>
</div>
<br />
<br />
<div class="row-fluid">
	<div class="span6">
		<h3>#rc.$.Slatwall.rbKey("admin.main.dashboard.recentproductreviews")#</h3>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.product.productName")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.productReview.reviewerName")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.productReview.reviewTitle")#</th>
					<th class="administration">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.productReviewSmartList.getPageRecords()#" index="local.productReview">
					<tr>
						<td><a href="#buildURL(action='admin:product.detailproduct', querystring='productID=#local.productReview.getProduct().getProductID()#')#">#local.productReview.getProduct().getProductName()#</a></td>
						<td>#local.productReview.getReviewerName()#</td>
						<td>#local.productReview.getReviewTitle()#</td>
						<td>
							<ul class="btn-group">
							  <cf_SlatwallActionCaller action="admin:product.detailproduct" querystring="productID=#local.productReview.getProduct().getProductID()#" class="detail" type="list">
							</ul>     						
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<div class="btn-group">
			<cf_SlatwallActionCaller action="admin:product.listproductreview" class="btn btn-mini" />
		</div>
	</div>
	<div class="span6">
		<h3>#rc.$.Slatwall.rbKey("admin.main.dashboard.recentvendorupdates")#</h3>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.vendor.vendorName")#</th>
					<th>#rc.$.Slatwall.rbKey("define.modifiedDateTime")#</th>
					<th>#rc.$.Slatwall.rbKey("define.modifiedByAccount")#</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.vendorSmartList.getPageRecords()#" index="local.vendor">
					<tr>
						<td><cf_SlatwallActionCaller action="admin:vendor.detailvendor" querystring="vendorID=#local.vendor.getVendorID()#" text="#local.vendor.getVendorName()#" /></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<div class="btn-group">
			<cf_SlatwallActionCaller action="admin:vendor.listvendor" class="btn btn-mini" />
			<cf_SlatwallActionCaller action="admin:vendor.createvendor" class="btn btn-mini" />
		</div>
	</div>
</div>
<br />
<br />
<div class="row-fluid">
	<div class="span6">
		<h3>#rc.$.Slatwall.rbKey("admin.main.dashboard.recentvendororderupdates")#</h3>
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.vendorOrder.vendorOrderNumber")#</th>
				<th>#rc.$.Slatwall.rbKey("define.modifiedDateTime")#</th>
				<th>#rc.$.Slatwall.rbKey("define.modifiedByAccount")#</th>
				<th>&nbsp;</th>
			</tr>
			<cfloop array="#rc.vendorOrderSmartList.getPageRecords()#" index="local.vendorOrder">
				<tr>
					<td><cf_SlatwallActionCaller action="admin:vendor.detailvendororder" querystring="vendorOrderID=#local.vendorOrder.getVendorOrderID()#" text="#local.vendorOrder.getVendorOrderNumber()#" /></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</cfloop>
		</table>
		<div class="btn-group">
			<cf_SlatwallActionCaller action="admin:vendor.listvendororder" class="btn btn-mini" />
			<cf_SlatwallActionCaller action="admin:vendor.createvendororder" class="btn btn-mini" />
		</div>
	</div>
</div>

<input name="test" type="text" value="hello" data-mytest="1" />
</cfoutput>