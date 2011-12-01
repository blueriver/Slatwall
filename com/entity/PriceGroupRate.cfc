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
component displayname="Price Group Rate" entityname="SlatwallPriceGroupRate" table="SlatwallPriceGroupRate" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="priceGroupRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="percentageOff" ormType="big_decimal";
	property name="amountOff" ormType="big_decimal";
	property name="amount" ormType="big_decimal";
	property name="globalFlag" ormType="boolean" default="false";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
		
	// Related Object Properties (many-to-one)
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
	
	// Related Object Properties (many-to-many)
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateProductType" fkcolumn="priceGroupRateID" inversejoincolumn="productTypeID" cascade="save-update";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateProduct" fkcolumn="priceGroupRateID" inversejoincolumn="productID" cascade="save-update";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateSku" fkcolumn="priceGroupRateID" inversejoincolumn="skuID" cascade="save-update";
	property name="excludedProductTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateExcludedProductType" fkcolumn="priceGroupRateID" inversejoincolumn="productTypeID" cascade="save-update";
	property name="excludedProducts" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateExcludedProduct" fkcolumn="priceGroupRateID" inversejoincolumn="productID" cascade="save-update";
	property name="excludedSkus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateExcludedSku" fkcolumn="priceGroupRateID" inversejoincolumn="skuID" cascade="save-update";
	
	
	public PriceGroupRate function init(){
	   // set default collections for association management methods
	   if(isNull(variables.productTypes)) {
	   	   variables.productTypes = [];
	   }
	   if(isNull(variables.products)) {
	   	   variables.products = [];
	   }
	   if(isNull(variables.SKUs)) {
	   	   variables.SKUs = [];
	   }
	   
	   return super.init();
	}
 
	/******* Association management methods for bidirectional relationships **************/
	
	
	// Price Group (many-to-one)
	public void function setPriceGroup(required any priceGroup) {
	   variables.priceGroup = arguments.priceGroup;
	   if(isNew() or !arguments.priceGroup.hasPriceGroupRate(this)) {
	       arrayAppend(arguments.priceGroup.getPriceGroupRates(),this);
	   }
	}
	
	public void function removePriceGroup(required any priceGroup) {
       var index = arrayFind(arguments.priceGroup.getPriceGroupRates(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.priceGroup.getPriceGroupRates(),index);
       }
       structDelete(variables,"priceGroup");
    }
	
    /************   END Association Management Methods   *******************/
    
    public string function getType(){
    	if(!isNull(variables.percentageOff))
    		return "percentageOff";
    	else if(!isNull(variables.amountOff))
    		return "amountOff";
    	else if(!isNull(variables.amount))
    		return "amount";
    	
    	// Provide a default case.
    	else    		
    		return "percentageOff";
    	//else
    		//throw("getType() was called but percentageOff, amountOff and amount were all null! Thus, unable to determine type.");
    }
    
     public string function getValue(){
    	if(getType() EQ "percentageOff")
    		return getPercentageOff();
    	else if(getType() EQ "amountOff")
    		return getAmountOff();
    	else if(getType() EQ "amount")
    		return getAmount();
    }
    
    public string function getAppliesToRepresentation(){
    	var rep = "";
    	var products = "";
    	var productTypes = "";
    	var SKUs = "";
    	
    	if(getGlobalFlag())
    		return rbKey('admin.pricegroup.edit.priceGroupRateAppliesToAllProducts');
    	
    	if(arrayLen(getProducts()))
    		products = "#arrayLen(getProducts())# Product" & IIF(arrayLen(getProducts()) GT 1, DE('s'), DE(''));
    	if(arrayLen(getProductTypes()))
    		producTypes = "#arrayLen(getProductTypes())# Product Type" & IIF(arrayLen(getProductTypes()) GT 1, DE('s'), DE(''));
    	if(arrayLen(getSKUs()))
    		SKUs = "#arrayLen(getSKUs())# SKU" & IIF(arrayLen(getSKUs()) GT 1, DE('s'), DE(''));
    	
    	rep = ListAppend(rep, products);
    	rep = ListAppend(rep, productTypes);
    	rep = ListAppend(rep, SKUs);
    	
    	// TODO: handle proper sentence construction.
    	return rep;
    }
    
    public string function getAmountRepresentation(){
    	if(getType() EQ "percentageOff")
			return variables.percentageOff & "% " & rbKey('entity.priceGroupRate.priceGroupRateType.percentageOffShort');
		if(getType() EQ "amountOff")
			return DollarFormat(variables.amountOff) & " " & rbKey('entity.priceGroupRate.priceGroupRateType.amountOffShort');
		if(getType() EQ "amount")
			return DollarFormat(variables.amount);
    }
    
}
