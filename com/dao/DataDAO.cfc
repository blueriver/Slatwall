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
	
	<cffunction name="deleteAllOrders">
		<cfquery datasource="#application.configBean.getDataSource()#">
			UPDATE SlatwallSession SET orderID = null;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallAttributeValue WHERE attributeValueType = 'orderItem';
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderDeliveryItem;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderDelivery;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallTaxApplied;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallPromotionApplied;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderPromotionCode;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderItem;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderShippingMethodOption;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderFulfillment;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallCreditCardTransaction;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrderPayment;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOrder;
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAllProducts">
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallAttributeValue WHERE attributeValueType = 'product';
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallPromotionReward WHERE rewardType='product';
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallAttributeSetAssignment WHERE attributeSetAssignmentType='product';
		</cfquery>
		
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductContent;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductCategory;
		</cfquery>
		
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductReview;
		</cfquery>
		
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductRelationshipProductType;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductRelationshipProduct;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductRelationshipSku;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductRelationship;
		</cfquery>
		
		<cfquery datasource="#application.configBean.getDataSource()#">
			UPDATE SlatwallProduct SET defaultSkuID = null;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallSkuOption;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallSku;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProduct;
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAllBrands">
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallBrand;
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAllProductTypes">
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallAttributeSetAssignment WHERE attributeSetAssignmentType='productType';
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallProductType;
		</cfquery>
	</cffunction>
	
	<cffunction name="deleteAllOptions">
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOption;
		</cfquery>
		<cfquery datasource="#application.configBean.getDataSource()#">
			DELETE FROM SlatwallOptionGroup;
		</cfquery>
	</cffunction>
	
	<cffunction name="recordExists" returntype="boolean">
		<cfargument name="tableName" />
		<cfargument name="idColumn" />
		<cfargument name="idValue" />
		
		<cfset var sqlResult = "" />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult"> 
			SELECT * FROM #arguments.tableName# WHERE #arguments.idColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.idValue#">
		</cfquery>
		
		<cfif sqlResult.recordCount>
			<cfreturn true />
		</cfif>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="recordUpdate" returntype="void">
		<cfargument name="tableName" />
		<cfargument name="idColumn" />
		<cfargument name="idValue" />
		<cfargument name="updateColumns" />
		<cfargument name="updateValues" />
		
		<cfset var i = 1 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult">
			UPDATE
				#arguments.tableName#
			SET
				<cfloop from="1" to="#arrayLen(updateColumns)#" index="i">
					<cfif isNumeric(updateValues[i])>
						#updateColumns[i]# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#updateValues[i]#">
					<cfelse>
						#updateColumns[i]# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#updateValues[i]#">
					</cfif>
					<cfif arrayLen(updateColumns) gt i>,</cfif> 
				</cfloop>
			WHERE
				#arguments.idColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.idValue#"> 
		</cfquery>
	</cffunction>
	
	<cffunction name="recordInsert" returntype="void">
		<cfargument name="tableName" />
		<cfargument name="insertColumns" />
		<cfargument name="insertValues" />
		
		<cfset var i = 1 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult"> 
			INSERT INTO	#arguments.tableName# (
				#arrayToList(insertColumns, ",")#
			) VALUES (
				<cfloop from="1" to="#arrayLen(insertValues)#" index="i">
					<cfif isNumeric(insertValues[i])>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertValues[i]#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#insertValues[i]#">
					</cfif>
					<cfif arrayLen(insertValues) gt i>,</cfif>
				</cfloop>
			)
		</cfquery>
	</cffunction>
	
	<!--- hint: This method is for doing validation checks to make sure a property value isn't already in use --->
	<cffunction name="isUniqueProperty">
		<cfargument name="propertyName" required="true" />
		<cfargument name="entity" required="true" />
		
		<cfset var property = arguments.entity.getPropertyMetaData( arguments.propertyName ).name />  
		<cfset var entityName = arguments.entity.getEntityName() />
		<cfset var entityID = arguments.entity.getPrimaryIDValue() />
		<cfset var entityIDproperty = arguments.entity.getPrimaryIDPropertyName() />
		<cfset var propertyValue = arguments.entity.getValueByPropertyIdentifier( arguments.propertyName ) />
		
		<cfset var results = ormExecuteQuery(" from #entityName# e where e.#property# = :propertyValue and e.#entityIDproperty# != :entityID", {propertyValue=propertyValue, entityID=entityID}) />
		
		<cfif arrayLen(results)>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />		
	</cffunction>
	
	<cffunction name="toBundle">
		<cfargument name="bundle" />
		
	</cffunction>
	
	<cffunction name="fromBundle">
		<cfargument name="bundle" />
		
	</cffunction>
	
	<!---
	bundle.setValue('queryKey', query)
	bundle.getValue('queryKey')
	keyFactory.get(uuid)
	--->
</cfcomponent>