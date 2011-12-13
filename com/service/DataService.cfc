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
component displayname="Data Service" extends="BaseService" {
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
				
		// Because some records might depend on other records already being in the DB (fk constraints) we catch errors and re-loop over records
		var retryCount=0;
		var runPopulation = true;
		
		do{
			// Set to false so that it will only rerun if an error occurs
			runPopulation = false;
			
			// Loop over files, read them, and send to loadData function 
			for(var i=1; i<= arrayLen(dirList); i++) {
				if(listLast(dirList[i],".") == "xml"){
					var xmlRaw = FileRead(dirList[i]);
					try{
						loadDataFromXMLRaw(xmlRaw);	
					} catch (any e) {
						// If we haven't retried 3 times, then incriment the retry counter and re-run the population
						if(retryCount <= 3) {
							retryCount += 1;
							runPopulation = true;
						} else {
							throw(e);
						}
					}
				}
			}	
		} while (runPopulation);
		
		return true;
	}
	
	public void function loadDataFromXMLRaw(required string xmlRaw) {
		var xmlData = xmlParse(xmlRaw);
		var columns = structNew();
		var idColumn = "";
		
		// Loop over each column to parse xml
		for(var ii=1; ii<= arrayLen(xmlData.Table.Columns.xmlChildren); ii++) {
			var Attributes = structNew();
			Attributes = duplicate(xmlData.Table.Columns.xmlChildren[ii].xmlAttributes);
			columns[ "#xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name#" ] = Attributes;
			if(isDefined("Attributes.fieldtype") && Attributes.fieldtype == "id") {
				idColumn = xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name;
			}
		}

		// Loop over each record to insert or update
		for(var r=1; r <= arrayLen(xmlData.Table.Records.xmlChildren); r++) {
			
			var idColumnValue = "";
			var columnDataTypes = [];
			
			var updateColumns = [];
			var updateValues = [];
			
			var insertColumns = [];
			var insertValues = [];
			
			for(var rp = 1; rp <= listLen(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes)); rp ++) {
				
				var thisColumn = listGetAt(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes), rp);
				var columnAttributes = columns[thisColumn];
				var value = xmlData.Table.Records.xmlChildren[r].xmlAttributes[thisColumn];
				
				if(idColumn == thisColumn){
					idColumnValue = value;
				}
				
				arrayAppend(insertColumns, thisColumn);
				arrayAppend(insertValues, value);
					
				if(!isDefined("columnAttributes.update") || columnAttributes.update == true) {
					arrayAppend(updateColumns, thisColumn);
					arrayAppend(updateValues, value);
				}
				if(isDefined("columnAttributes.dataType")) {
					arrayAppend(columnDataTypes, columnAttributes.dataType);
				} else {
					arrayAppend(columnDataTypes, "varchar");
				}
			}
			
			if( getDAO().recordExists(xmlData.table.xmlAttributes.tableName, idColumn, idColumnValue) ) {
				getDAO().recordUpdate(xmlData.table.xmlAttributes.tableName, idColumn, idColumnValue, updateColumns, updateValues, columnDataTypes);
			} else {
				getDAO().recordInsert(xmlData.table.xmlAttributes.tableName, insertColumns, insertValues, columnDataTypes);
			}
		}
	}
	
	public void function deleteAllOrders() {
		getDAO().deleteAllOrders();
	}
	
	public void function deleteAllProducts(struct data={}) {
		getDAO().deleteAllOrders();
		getDAO().deleteAllProducts();
		if(structKeyExists(arguments.data, "deleteBrands") && arguments.data.deleteBrands) {
			getDAO().deleteAllBrands();
		}
		if(structKeyExists(arguments.data, "deleteProductTypes") && arguments.data.deleteProductTypes) {
			getDAO().deleteAllProductTypes();
		}
		if(structKeyExists(arguments.data, "deleteOptions") && arguments.data.deleteOptions) {
			getDAO().deleteAllOptions();
		}
	}
	
	public boolean function isUniqueProperty( required string propertyName, required any entity ) {
		return getDAO().isUniqueProperty(argumentcollection=arguments);
	}
	
	public any function toBundle(required any bundle, required string tableList) {
		getDAO().toBundle(argumentcollection=arguments);
	}
	
	public any function fromBundle(required any bundle, required string tableList) {
		getDAO().toBundle(argumentcollection=arguments);
	}
}