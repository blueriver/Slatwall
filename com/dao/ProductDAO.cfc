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
component extends="slatwall.com.dao.BaseDAO" {

	public any function getSmartList(required struct rc, required string entityName){
		
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName, entityPerfix="Slatwall");
		
		smartList.addKeywordProperty(rawProperty="productCode", weight=9);
		smartList.addKeywordProperty(rawProperty="productName", weight=3);
		smartList.addKeywordProperty(rawProperty="productYear", weight=6);
		smartList.addKeywordProperty(rawProperty="productDescription", weight=1);
		smartList.addKeywordProperty(rawProperty="brand_brandName", weight=3);
		
		return smartList;	
	}
	
	public any function getProductContentSmartList(required struct rc, required string entityName, required string contentID) {
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName="SlatwallProductContent", entityPerfix="Slatwall");
		
		smartList.addKeywordProperty(rawProperty="product_productCode", weight=9);
		smartList.addKeywordProperty(rawProperty="product_productName", weight=3);
		smartList.addKeywordProperty(rawProperty="product_productYear", weight=6);
		smartList.addKeywordProperty(rawProperty="product_productDescription", weight=1);
		smartList.addKeywordProperty(rawProperty="product_brand_brandName", weight=3);
		
		var HQL = "Select product from SlatwallProductContent aSlatwallProductContent where aSlatwallProductContent.contentID = :contentID #smartList.getHQLWhereOrder(true)#";
		smartList.addHQLWhereParam("contentID", arguments.contentID);
		smartList.setRecords(ormExecuteQuery(HQL, smartList.getHQLWhereParams(), false, {ignoreCase="true"}));
		
		return smartList;
	}
	
	public any function clearProductContent(required any product) {
		ORMExecuteQuery("Delete from SlatwallProductContent WHERE productID = '#arguments.product.getProductID()#'");
		//arguments.product.setProductContent(arrayNew(1));
	}
}
