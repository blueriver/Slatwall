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
component extends="BaseDAO" {
	
	// @hint checks if the passed if the option code of the passed in option is already in use within its option group
	public any function isDuplicateOptionCode( required any option ) {
		return arrayLen(ormExecuteQuery("from SlatwallOption where optionCode = :code and optionGroup = :group and optionID != :id", {code=arguments.option.getOptionCode(), group=arguments.option.getOptionGroup(), id=arguments.option.getOptionID()}));
	}
	
	public array function getMaximumOptionSortOrders() {
		return ormExecuteQuery("Select max(o.sortOrder), max(og.sortOrder) from SlatwallOption o inner join o.optionGroup og")[1];
	}
	
	public any function getUnusedProductOptions(required string productID){
		var q = new Query();
		var sql = "SELECT 
				DISTINCT slatwallOption.optionID,slatwallOption.optionName, slatwallOptionGroup.optionGroupName
				FROM
					slatwallOption
				INNER JOIN slatwallOptionGroup on slatwallOptionGroup.optionGroupID = slatwallOption.optionGroupID
				WHERE
					slatwallOption.optionID NOT IN (		
							SELECT slatwallOption.optionID FROM slatwallSku
								INNER JOIN slatwallSkuOption on slatwallSku.skuID = slatwallSkuOption.skuID
								INNER JOIN slatwallOption on slatwallSkuOption.optionID = slatwallOption.optionID
							WHERE
								slatwallSku.productID=:productID	
				)
				AND
					slatwallOption.optionGroupID IN (
						SELECT slatwallOptionGroup.optionGroupID  FROM slatwallSku
								INNER JOIN slatwallSkuOption on slatwallSku.skuID = slatwallSkuOption.skuID
								INNER JOIN slatwallOption on slatwallSkuOption.optionID = slatwallOption.optionID
								INNER JOIN slatwallOptionGroup on slatwallOption.optionGroupID = slatwallOptionGroup.optionGroupID
							WHERE
								slatwallSku.productID=:productID	
					)
				ORDER BY 
					slatwallOptionGroup.optionGroupName, slatwallOption.optionName
				";
		q.addParam(name="productID",value="#arguments.productID#",cfsqltype="cf_sql_varchar");		
		q.setSQL(sql);
		
		var records = q.execute().getResult();
		var result = [];

		for(var i=1;i<=records.recordCount;i++) {
			arrayAppend(result, {
				"name" = records.optionGroupName[i] & ' - ' & records.optionName[i],
				"value" = records.optionID[i]
			});
		}
		return result;		
	}

	public any function getUnusedProductOptionGroups(required string productID){
		var q = new Query();
		var sql = "SELECT 
				DISTINCT slatwallOptionGroup.optionGroupID, slatwallOptionGroup.optionGroupName
				FROM
					slatwallOptionGroup
				WHERE
					slatwallOptionGroup.optionGroupID NOT IN (		
							SELECT slatwallOptionGroup.optionGroupID  FROM slatwallSku
								INNER JOIN slatwallSkuOption on slatwallSku.skuID = slatwallSkuOption.skuID
								INNER JOIN slatwallOption on slatwallSkuOption.optionID = slatwallOption.optionID
								INNER JOIN slatwallOptionGroup on slatwallOption.optionGroupID = slatwallOptionGroup.optionGroupID
							WHERE
								slatwallSku.productID=:productID	
				)	
				ORDER BY 
					slatwallOptionGroup.optionGroupName
				";
		q.addParam(name="productID",value="#arguments.productID#",cfsqltype="cf_sql_varchar");		
		q.setSQL(sql);
		
		var records = q.execute().getResult();
		var result = [];

		for(var i=1;i<=records.recordCount;i++) {
			arrayAppend(result, {
				"name" = records.optionGroupName[i],
				"value" = records.optionGroupID[i]
			});
		}
		return result;		
	}
	
		
}
