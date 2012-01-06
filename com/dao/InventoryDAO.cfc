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
<cfcomponent extends="BaseDAO">
	
	<cfscript>
		public numeric function getQOH(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT NEW MAP(sum(inventory.quantityIn) as quantityIn, sum(inventory.quantityOut) as quantityOut) FROM SlatwallInventory inventory WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "inventory.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "inventory.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "inventory.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			var quantityIn = 0;
			var quantityOut = 0;
			
			if(structKeyExists(results, "quantityIn")) {
				quantityIn = results[ "quantityIn" ];
			}
			if(structKeyExists(results, "quantityOut")) {
				quantityOut = results[ "quantityOut" ];
			}
			
			return quantityIn - quantityOut;
		}
		
		public numeric function getQOSH(string stockID, string skuID, string productID) {
			// TODO: Setup Sales Hold
			return 0;
		}
		
		public numeric function getQNDOO(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
		
		public numeric function getQNDORVO(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
		
		public numeric function getQNDSA(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
		
		public numeric function getQNRORO(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
		
		public numeric function getQNROVO(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
		
		public numeric function getQNROSA(string stockID, string skuID, string productID) {
			throw("impliment me");
		}
	</cfscript>
	
</cfcomponent>
