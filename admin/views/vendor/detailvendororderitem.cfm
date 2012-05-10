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

<cfparam name="rc.vendorOrderItem" type="any" />
<cfparam name="rc.vendorOrder" type="any" default="#rc.vendorOrderItem.getVendorOrder()#" />
<cfparam name="rc.edit" type="boolean" />
<cfoutput>
	
	<cfscript>
		rc.vendorSkuSmartList = rc.$.slatwall.getService('SkuService').getSkuSmartList();
		rc.vendorSkuSmartList.addFilter("product.brand.vendors.vendorID", rc.VendorOrder.getVendor().getVendorID());	
		
		skus = rc.vendorSkuSmartList.getRecords();
		skuValues=[];
		
		for(i=1; i<= arrayLen(skus);i++){
			arrayAppend(skuValues,{value=skus[i].getSkuID(), 
			name=skus[i].getProduct().getProductName() & ' (' & skus[i].getSkuCode() & ') - ' & skus[i].getOptionsDisplay()
			});
		}
		
		
	</cfscript>	
	
	<cf_SlatwallDetailForm object="#rc.vendorOrderItem#" edit="#rc.edit#">
		<input type="hidden" name="vendorOrder.vendorOrderID" value="#rc.vendorOrder.getVendorOrderID()#" />
		<input type="hidden" name="returnAction" value="admin:vendor.editVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#" />
		<input type="hidden" name="stock.stockID" value="" />
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.vendorOrderItem#" property="quantity" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.vendorOrderItem#" property="cost" edit="#rc.edit#">
				<cf_SlatwallFieldDisplay fieldtype="select" fieldname="stock.sku" valueoptions="#skuValues#" edit="#rc.edit#" title="Product">
			
					<!---<cf_SlatwallListingDisplay smartList="#rc.vendorSkuSmartList#" multiselectfieldname="options" edit="true">
						<cf_SlatwallListingColumn propertyIdentifier="product.brand.brandName" filter=true />
						<cf_SlatwallListingColumn propertyIdentifier="product.productName" filter=true />
						<cf_SlatwallListingColumn propertyIdentifier="skucode" tdclass="primary" />
						<cf_SlatwallListingColumn propertyIdentifier="optionsdisplay" />
					</cf_SlatwallListingDisplay>--->
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
	</cf_SlatwallDetailForm>
</cfoutput>