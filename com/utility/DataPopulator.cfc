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
component displayname="Data Populator" {
	
	public any function init() {
		return this;
	}
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
		
		for(var i=1; i<= arrayLen(dirList); i++) {
			if(listLast(dirList[i],".") == "xml"){
				var xmlRaw = FileRead(dirList[i]);
				loadDataFromXMLRaw(xmlRaw);
			}
		}
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
			var updateSetString = "";
			var insertColumns = "";
			var insertValues = "";
			
			for(var rp = 1; rp <= listLen(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes)); rp ++) {
				
				var thisColumn = listGetAt(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes), rp);
				var columnAttributes = columns[thisColumn];
				var value = xmlData.Table.Records.xmlChildren[r].xmlAttributes[thisColumn];
				
				if(idColumn == thisColumn){
					idColumnValue = value;
				}
				
				if(isDefined("columnAttributes.update") && columnAttributes.update == false) {
					insertColumns &= " #thisColumn#,";
					if(isNumeric(value)) {
						insertValues &= " #value#,";	
					} else {
						insertValues &= " '#value#',";
					}
				} else {
					if(isNumeric(value)) {
						updateSetString &= " #thisColumn#=#value#,";
					} else {
						updateSetString &= " #thisColumn#='#value#',";
					}
					insertColumns &= " #thisColumn#,";
					if(isNumeric(value)) {
						insertValues &= " #value#,";	
					} else {
						insertValues &= " '#value#',";
					}
				}
			}
			if(len(updateSetString)) {
				updateSetString = left(updateSetString, len(updateSetString)-1);
			}
			if(len(insertColumns)) {
				insertColumns = left(insertColumns, len(insertColumns)-1);
			}
			if(len(insertValues)) {
				insertValues = left(insertValues, len(insertValues)-1);
			}
			
			var dataQuery = new Query();
			dataQuery.setDataSource(application.configBean.getDatasource());
			dataQuery.setUsername(application.configBean.getUsername());
			dataQuery.setPassword(application.configBean.getPassword());
			dataQuery.setSql("
				SELECT * FROM #xmlData.table.xmlAttributes.tableName# WHERE #idColumn# = '#idColumnValue#';
			");
			var exists = dataQuery.execute().getResult().recordcount;
			if(exists) {
				dataQuery.setSql("
					UPDATE #xmlData.table.xmlAttributes.tableName# SET #updateSetString# WHERE #idColumn# = '#idColumnValue#'
				");
				dataQuery.execute();
			} else {
				dataQuery.setSql("
					INSERT INTO #xmlData.table.xmlAttributes.tableName# (#insertColumns#) VALUES (#insertValues#)
				");
				dataQuery.execute();
			}
		}
	}
	
}