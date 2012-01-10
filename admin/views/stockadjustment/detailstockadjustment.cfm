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

<!--- Generic properties for all stockAdjustments --->
<cfparam name="rc.stockAdjustment">
<cfparam name="rc.locationSmartList">
<cfparam name="rc.stockAdjustmentTypeSmartList">

<cfoutput>
	<ul id="navTask">
		<cf_SlatwallActionCaller action="admin:stockadjustment.listStockAdjustments" type="list">
	</ul>
	
	<cfif rc.edit>
		
		#$.slatwall.getValidateThis().getValidationScript(theObject=rc.stockAdjustment, formName="StockAdjustmentDetail")#
		
		<form name="StockAdjustmentDetail" id="StockAdjustmentDetail" action="#buildURL('admin:StockAdjustment.saveStockAdjustment')#" method="post">
			<input type="hidden" name="StockAdjustmentID" value="#rc.StockAdjustment.getStockAdjustmentID()#" />
	</cfif>
	
	<dl class="twoColumn">
		
		<cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="stockAdjustmentType" edit="#rc.stockAdjustment.isNew()#" valueOptions="#rc.stockAdjustmentTypeSmartList.getRecords()#" fieldClass="stockAdjustmentTypeID">
		
	
		<div id="fromLocationDiv"><cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="fromLocation" fieldName="fromLocation.locationID" edit="#rc.stockAdjustment.isNew()#"></div>
		<div id="toLocationDiv"><cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="toLocation" fieldName="toLocation.locationID" edit="#rc.stockAdjustment.isNew()#"></div>
		
		
		<cfif rc.edit && !rc.stockAdjustment.isNew()>
			<dt class="title"><label>#$.Slatwall.rbKey("admin.stockadjustment.edit.product")#</strong></label></dt> 
				<dd class="value">
	
					<cf_SlatwallFormField fieldType="select" fieldName="productID" valueOptions="#rc.productSmartList.getRecords()#" fieldClass="productID">

					
					<!--- This is temporary 
					<select name="productId" id="productID">
						<option value="4028e6893463040e01346f7b520501b1">New Prod</option>
					</select>--->
					
					<!---<button type="button" id="addProductButton" value="true">#rc.$.Slatwall.rbKey("admin.stockadjustment.edit.addProduct")#</button>--->
						<cf_SlatwallActionCaller action="admin:StockAdjustment.editStockAdjustmentItems" type="link" class="button addProductButton" text="#rc.$.Slatwall.rbKey('admin.stockadjustment.edit.addProduct')#">
				</dd>
			</dt>
		</cfif>	
			
			
		
		
		
		<!---<cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="activeFlag" edit="#rc.edit#">
		<cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="StockAdjustmentName" edit="#rc.edit#" first="true">
		<cf_SlatwallPropertyDisplay object="#rc.StockAdjustment#" property="StockAdjustmentCode" edit="#rc.edit#" >--->

	</dl>
	

	<cfif arrayLen(rc.StockAdjustment.getStockAdjustmentItems()) GT 0>
		<!---<strong>#$.slatwall.rbKey('admin.StockAdjustment.edit.StockAdjustmentRates')#</strong>
	
		<table id="StockAdjustmentRates" class="listing-grid stripe">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.StockAdjustmentRate.StockAdjustmentRateType")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.StockAdjustmentRate.StockAdjustmentRateAmount")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.StockAdjustmentRate.StockAdjustmentRateAppliesTo")#</th>
					<cfif rc.edit><th class="administration">&nbsp;</th></cfif>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.StockAdjustment.getStockAdjustmentRates()#" index="local.StockAdjustmentRate">
					<cfif not local.StockAdjustmentRate.hasErrors()>
						<tr>
							<td class="varWidth">#$.Slatwall.rbKey('entity.StockAdjustmentRate.StockAdjustmentRateType.' & local.StockAdjustmentRate.getType())#</td>
							<td>#local.StockAdjustmentRate.getAmountRepresentation()#</td>
							<td>#local.StockAdjustmentRate.getAppliesToRepresentation()#</td>
							<cfif rc.edit>
								<td class="administration">
									<ul class="two">
										<cf_SlatwallActionCaller action="admin:StockAdjustment.editStockAdjustment" querystring="StockAdjustmentID=#rc.StockAdjustment.getStockAdjustmentID()#&StockAdjustmentRateId=#local.StockAdjustmentRate.getStockAdjustmentRateId()#" class="edit" type="list">
										<cf_SlatwallActionCaller action="admin:StockAdjustment.deleteStockAdjustmentRate" querystring="StockAdjustmentID=#rc.StockAdjustment.getStockAdjustmentID()#&StockAdjustmentRateId=#local.StockAdjustmentRate.getStockAdjustmentRateId()#" class="delete" type="list" confirmrequired="true">
									</ul>
								</td>
							</cfif>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
		--->
		
		
	<!--- No stock adjustment items defined --->	
	<cfelseif !rc.StockAdjustment.isNew()>
		
		#rc.$.Slatwall.rbKey("admin.stockadjustment.noStockAdjustmentItemsDefined")#
		
		<br /><br />	
	</cfif>
	
	<!--- The modal dialog div is placed inside of the form, so when it posts, it posts this form, so that we can update the StockAdjustment AND items simultaniously.  --->
	<div id="addEditStockAdjustmentItems" class="ui-helper-hidden"></div>

	<cfif rc.edit>
		<cf_SlatwallActionCaller action="admin:StockAdjustment.listStockAdjustments" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
		<cf_SlatwallActionCaller action="admin:StockAdjustment.saveStockAdjustment" type="submit" class="button">
		<cfif !rc.StockAdjustment.isNew()><cf_SlatwallActionCaller action="admin:StockAdjustment.processStockAdjustment" type="button" class="button"></cfif>
		</form>
	</cfif>	

	
</cfoutput>