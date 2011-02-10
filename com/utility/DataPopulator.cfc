component displayname="Data Populator" {
	
	public any function init() {
		return this;
	}
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
		
		for(var i=1; i<= arrayLen(dirList); i++) {
			var xmlRaw = FileRead(dirList[i]);
			loadDataFromXMLRaw(xmlRaw);
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
					insertValues &= " '#value#',";
				} else {
					updateSetString &= " #thisColumn#='#value#',";
					insertColumns &= " #thisColumn#,";
					insertValues &= " '#value#',";
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
