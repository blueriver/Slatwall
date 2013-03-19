/*

    Slatwall - An Open Source eCommerce Platform
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
component persistent="false" accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiController" {

	property name="accountService" type="any";
	property name="brandService" type="any";
	property name="dataService" type="any";
	property name="orderService" type="any";
	property name="productService" type="any";
	property name="promotionService" type="any";
	property name="vendorService" type="any";
	property name="vendorOrderService" type="any";
	property name="hibachiService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateListingDisplay');
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateGlobalSearchResults');
	this.anyAdminMethods=listAppend(this.anyAdminMethods,'updateSortOrder');
	
	this.secureMethods='';
	
	public void function before(required struct rc) {
		getFW().setView("admin:ajax.default");
	}
	
	public void function updateListingDisplay(required struct rc) {
		var entityService = getHibachiService().getServiceByEntityName( entityName=rc.entityName );
		var smartList = entityService.invokeMethod( "get#getHibachiService().getProperlyCasedShortEntityName( rc.entityName )#SmartList", {1=rc} );
		
		var smartListPageRecords = smartList.getPageRecords();
		var piArray = listToArray(rc.propertyIdentifiers);

		rc.ajaxResponse[ "recordsCount" ] = smartList.getRecordsCount();
		rc.ajaxResponse[ "pageRecords" ] = [];
		rc.ajaxResponse[ "pageRecordsCount" ] = arrayLen(smartList.getPageRecords());
		rc.ajaxResponse[ "pageRecordsShow"] = smartList.getPageRecordsShow();
		rc.ajaxResponse[ "pageRecordsStart" ] = smartList.getPageRecordsStart();
		rc.ajaxResponse[ "pageRecordsEnd" ] = smartList.getPageRecordsEnd();
		rc.ajaxResponse[ "currentPage" ] = smartList.getCurrentPage();
		rc.ajaxResponse[ "totalPages" ] = smartList.getTotalPages();
		rc.ajaxResponse[ "savedStateID" ] = smartList.getSavedStateID();
		
		for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
			var thisRecord = {};
			for(var p=1; p<=arrayLen(piArray); p++) {
				var value = smartListPageRecords[i].getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
				if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
					thisRecord[ piArray[p] ] = value & " ";
				} else {
					thisRecord[ piArray[p] ] = value;
				}
			}
			arrayAppend(rc.ajaxResponse[ "pageRecords" ], thisRecord);
		}
	}
	
	public void function updateGlobalSearchResults(required struct rc) {
		
		rc['P:Show'] = 10;
		
		var smartLists = {};
		smartLists['product'] = getProductService().getProductSmartList(data=rc);
		smartLists['productType'] = getProductService().getProductTypeSmartList(data=rc);
		smartLists['brand'] = getBrandService().getBrandSmartList(data=rc);
		smartLists['promotion'] = getPromotionService().getPromotionSmartList(data=rc);
		smartLists['order'] = getOrderService().getOrderSmartList(data=rc);
		smartLists['account'] = getAccountService().getAccountSmartList(data=rc);
		smartLists['vendorOrder'] = getVendorOrderService().getVendorOrderSmartList(data=rc);
		smartLists['vendor'] = getVendorService().getVendorSmartList(data=rc);
		
		for(var key in smartLists) {
			rc.ajaxResponse[ key ] = {};
			rc.ajaxResponse[ key ][ 'records' ] = [];
			rc.ajaxResponse[ key ][ 'recordCount' ] = smartLists[key].getRecordsCount();
			
			for(var i=1; i<=arrayLen(smartLists[key].getPageRecords()); i++) {
				var thisRecord = {};
				thisRecord['value'] = smartLists[key].getPageRecords()[i].getPrimaryIDValue();
				thisRecord['name'] = smartLists[key].getPageRecords()[i].getSimpleRepresentation();
				
				arrayAppend(rc.ajaxResponse[ key ][ 'records' ], thisRecord);
			}
		}
	}
	
	public function updateSortOrder(required struct rc) {
		getDataService().updateRecordSortOrder(argumentCollection=rc);
	}
	
}