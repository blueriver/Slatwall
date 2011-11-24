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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	public any function save(required any PriceGroup,required struct data) {
		// populate bean from values in the data Struct
		arguments.PriceGroup.populate(arguments.data);
		
		/*if(structKeyExists(arguments.data.structuredData,"priceGroupRates")){
			savePriceGroupRates(arguments.priceGroup,arguments.data.structuredData.priceGroupRates);
		} */

		
		arguments.PriceGroup = super.save(arguments.PriceGroup);
		
		return arguments.PriceGroup;
	}
	
	public any function delete(required any PriceGroup){
		return Super.delete(arguments.PriceGroup);
	}
	
	public any function getPriceGroupRateSmartList(string priceGroupID, struct data={}){
		arguments.entityName = "SlatwallPriceGroupRate";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		if( structKeyExists(arguments,"priceGroupID") ) {
			smartList.addFilter(propertyIdentifier="priceGroup_priceGroupID", value=arguments.priceGroupID);
		}
		
		return smartList;
	}
	
	public any function deletePriceGroupRate(required any priceGroupRate) {
		
	}
	
	public void function savePriceGroupRates(required any priceGroup, required array priceGroupRates){
		
	}
	
	public any function savePriceGroupRate(required any priceGroupRate, required struct data, string priceGroupRateList){
		
	}
	
	public void function validatePriceGroupRate( required any priceGroupRate, string priceGroupRateList ) {
		
	}
		
}
