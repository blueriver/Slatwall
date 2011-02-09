component displayname="Data Populator" {
	
	public any function init() {
		return this;
	}
	
	public boolean function loadDataFromXMLDirectory(required string xmlDirectory) {
		var dirList = directoryList(arguments.xmlDirectory);
		
		for(var i=1; i<= arrayLen(dirList); i++) {
			var xmlRaw = FileRead(dirList[i]);;
			var xmlData = xmlParse(xmlRaw);
			var currentTable = xmlData.table.xmlAttributes.tableName;
			var properties = structNew();
			var insertProperties = structNew();
			var updateProperties = structNew();
			// Loop over each column to parse xml
			for(var ii=1; ii<= arrayLen(xmlData.Table.Columns.xmlChildren); ii++) {
				properties[ "#xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name#" ] = "#xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.process#";
				if(xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.process == "id") {
					var idProperty = xmlData.Table.Columns.xmlChildren[ii].xmlAttributes.name;
				}
			}

			// Loop over each record to insert or update
			for(var r=1; r <= arrayLen(xmlData.Table.Records.xmlChildren); r++) {
				var updateSetString = "";
				var insertColumns = "";
				var insertValues = "";
				for(var rp = 1; rp <= listLen(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes)); rp ++) {
					
					var property = listGetAt(structKeyList(xmlData.Table.Records.xmlChildren[r].xmlAttributes), rp);
					var propertyProcess = properties[property];
					var value = xmlData.Table.Records.xmlChildren[r].xmlAttributes[property];
					
					if(propertyProcess == "id") {
						idPropertyValue = value;
						insertColumns &= " #property#,";
						insertValues &= " '#value#',";
					} else if (propertyProcess == "update") {
						updateSetString &= " #property#='#value#',";
						insertColumns &= " #property#,";
						insertValues &= " '#value#',";
					} else {
						insertColumns &= " #property#,";
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
					SELECT * FROM #xmlData.table.xmlAttributes.tableName# WHERE #idProperty# = '#idPropertyValue#';
				");
				var exists = dataQuery.execute().getResult().recordcount;
				if(exists) {
					dataQuery.setSql("
						UPDATE #xmlData.table.xmlAttributes.tableName# SET #updateSetString# WHERE #idProperty# = '#idPropertyValue#'
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
		return true;
	}
	
}
