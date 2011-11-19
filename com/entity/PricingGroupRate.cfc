/*

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

*/
component displayname="Pricing Group Rate" entityname="SlatwallPricingGroupRate" table="SlatwallPricingGroupRate" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="pricingGroupRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="percentageOff" ormType="big_decimal";
	property name="amountOff" ormType="big_decimal";
	property name="amount" ormType="big_decimal";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
		
	// Related Object Properties (many-to-one)
	property name="pricingGroup" cfc="PricingGroup" fieldtype="many-to-one" fkcolumn="pricingGroupID";
	
	// Related Object Properties (many-to-many)
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPricingGroupRateProductType" fkcolumn="pricingGroupRateID" inversejoincolumn="productTypeID" cascade="save-update";
	
	/*
	These properties are commented out, until Brian / Greg / Sumit can talk about it (comments by greg :) )
	
	We might also want brand and option like in promotion reward
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPricingGroupRateProduct" fkcolumn="pricingGroupRateID" inversejoincolumn="productID" cascade="save-update";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPricingGroupRateSku" fkcolumn="pricingGroupRateID" inversejoincolumn="skuID" cascade="save-update";
	
	*/
	
	public Brand function init(){
	   // set default collections for association management methods
	   if(isNull(variables.pricingGroupRates)) {
	   	   variables.pricingGroupRates = [];
	   }
	   if(isNull(variables.productTypes)) {
	   	   variables.productTypes = [];
	   }
	   
	   return super.init();
	}
 
	/******* Association management methods for bidirectional relationships **************/
	
	
	// Pricing Group (many-to-one)
	public void function setPricingGroup(required any pricingGroup) {
	   variables.pricingGroup = arguments.pricingGroup;
	   if(isNew() or !arguments.pricingGroup.hasPricingGroupRate(this)) {
	       arrayAppend(arguments.pricingGroup.getPricingGroupRates(),this);
	   }
	}
	
	public void function removePricingGroup(required any pricingGroup) {
       var index = arrayFind(arguments.pricingGroup.getPricingGroupRates(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.pricingGroup.getPricingGroupRates(),index);
       }
       structDelete(variables,"pricingGroup");
    }
	
    /************   END Association Management Methods   *******************/
}
