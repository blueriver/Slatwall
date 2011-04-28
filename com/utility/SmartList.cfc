/*
	Copyright (c) 2010, Greg Moser
	
	Version: 1.1
	Documentation: http://www.github.com/gregmoser/entitySmartList/wiki

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/
component displayname="Smart List" accessors="true" persistent="false" output="false" {
	
	property name="baseEntityName" type="string";
	
	property name="entities" type="struct";
	property name="selects" type="struct" hint="This struct holds any selects that are to be used in creating the records array";
	property name="whereGroups" type="array" hint="this holds all filters and ranges";
	property name="orders" type="array" hint="This struct holds the display order specification based on property";
	
	property name="keywordProperties" type="struct" hint="This struct holds the properties that searches reference and their relative weight";
	property name="keywords" type="array" hint="This array holds all of the keywords that were searched for";

	property name="hqlParams" type="struct";
	
	property name="recordStart" type="numeric" hint="This represents the first record to display and it is used in paging.";
	property name="recordShow" type="numeric" hint="This is the total number of entities to display";

	property name="searchTime" type="numeric";
	
	// Delimiter Settings
	variables.subEntityDelimiter = "_";
	variables.valueDelimiter = ",";
	variables.orderDirectionDelimiter = "|";
	variables.orderPropertyDelimiter = ",";
	variables.dataKeyDelimiter = ":";
	
	public any function init(required string entityName, struct data, numeric recordStart=1, numeric recordShow=10) {
		// Set defaults for the main properties
		setSelects({});
		setWhereGroups([]);
		setOrders([]);
		setKeywordProperties({});
		setKeywords([]);
		setSearchTime(0);
		setEntities({});
		setHQLParams({});
		
		// Set paging defaults
		setRecordStart(arguments.recordStart);
		setRecordShow(arguments.recordShow);
		
		var baseEntity = entityNew("#arguments.entityName#");
		var baseEntityMeta = getMetaData(baseEntity);
		
		setBaseEntityName(arguments.entityName);
		
		addEntity(
			entityName=arguments.entityName,
			entityAlias=getAliasFromEntityName(arguments.entityName),
			entityFullName=baseEntityMeta.fullName,
			entityProperties=getPropertiesStructFromMetaArray(baseEntityMeta.properties)
		);
		
		if(structKeyExists(arguments, "data")) {
			applyData(data=arguments.data);	
		}
				
		return this;
	}
		
	public void function confirmWhereGroup(required numeric whereGroup) {
		for(var i=1; i<=arguments.whereGroup; i++) {
			if(arrayLen(variables.whereGroups) < i) {
				arrayAppend(variables.whereGroups, {filters={},ranges={}});
			}
		}
	}
	
	public string function getAliasFromEntityName(required string entityName) {
		return "a#lcase(arguments.entityName)#";
	}
	
	public struct function getPropertiesStructFromMetaArray(required array properties) {
		var propertyStruct = {};
		
		for(var i=1; i<=arrayLen(arguments.properties); i++) {
			propertyStruct[arguments.properties[i].name] = duplicate(arguments.properties[i]);
		}
		
		return propertyStruct;
	}
	
	public string function joinRelatedProperty(required string parentEntityName, required string relatedProperty, string joinType="", boolean fetch) {
		var parentEntityFullName = variables.entities[ arguments.parentEntityName ].entityFullName;
		if(listLen(variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].cfc,".") < 2) {
			var newEntityCFC = Replace(parentEntityFullName, listLast(parentEntityFullName,"."), variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].cfc);	
		} else {
			var newEntityCFC = variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].cfc;
		}
		var newEntity = createObject("component","#newEntityCFC#");
		var newEntityMeta = getMetaData(newEntity);
		
		if(structKeyExists(newEntityMeta, "entityName")) {
			var newEntityName = newEntityMeta.entityName;
		} else {
			var newEntityName = listLast(newEntityMeta.fullName,".");
		}
		
		if(!structKeyExists(variables.entities,newEntityName)) {
			if(variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].fieldtype == "many-to-one" && !structKeyExists(arguments, "fetch")) {
				arguments.fetch = true;
			} else if(!structKeyExists(arguments, "fetch")) {
				arguments.fetch = false;
			}
			
			addEntity(
				entityName=newEntityName,
				entityAlias=getAliasFromEntityName(newEntityName),
				entityFullName=newEntityMeta.fullName,
				entityProperties=getPropertiesStructFromMetaArray(newEntityMeta.properties),
				parentAlias=variables.entities[ arguments.parentEntityName ].entityAlias,
				parentRelationship=variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].fieldtype,
				parentRelatedProperty=variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].name,
				fkColumn=variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].fkcolumn,
				joinType=arguments.joinType,
				fetch=arguments.fetch
			);
		} else {
			if(arguments.joinType != "") {
				variables.entities[newEntityName].joinType = arguments.joinType;
			}
			if(structKeyExists(arguments, "fetch")) {
				variables.entities[newEntityName].fetch = arguments.fetch;
			}
		}
		
		return newEntityName;
	}
	
	public void function addEntity(required string entityName, required string entityAlias, required string entityFullName, required struct entityProperties, string parentAlias="", string parentRelationship="",string parentRelatedProperty="", string fkColumn="", string joinType="") {
		variables.entities[arguments.entityName] = duplicate(arguments);
	}
	
	public string function getAliasedProperty(required string propertyIdentifier) {
		var entityName = getBaseEntityName();
		var entityAlias = variables.entities[getBaseEntityName()].entityAlias;
		for(var i=1; i<listLen(arguments.propertyIdentifier, variables.subEntityDelimiter); i++) {
			entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=listGetAt(arguments.propertyIdentifier, i, variables.subEntityDelimiter));
			entityAlias = variables.entities[entityName].entityAlias;
		}
		return "#entityAlias#.#variables.entities[entityName].entityProperties[listLast(propertyIdentifier, variables.subEntityDelimiter)].name#";
	}
	
	public void function addSelect(required string propertyIdentifier, required string alias) {
		variables.selects[getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier)] = arguments.alias;
	}
	
	public void function addFilter(required string propertyIdentifier, required string value, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		
		if(structKeyExists(variables.whereGroups[arguments.whereGroup].filters, aliasedProperty)) {
			variables.whereGroups[arguments.whereGroup].filters[aliasedProperty] &= "#variables.valueDelimiter##arguments.value#";
		} else {
			variables.whereGroups[arguments.whereGroup].filters[aliasedProperty] = "#arguments.value#";
		}
	}
	
	public void function addRange(required string propertyIdentifier, required string value, numeric filterGroup) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		
		variables.whereGroups[arguments.whereGroup].filters[aliasedProperty] = "#arguments.value#";
	}
	
	public void function addOrder(required string orderStatement, numeric position) {
		var propertyIdentifier = listFirst(arguments.orderStatement, variables.orderDirectionDelimiter);
		var orderDirection = listLast(arguments.orderStatement, variables.orderDirectionDelimiter);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=propertyIdentifier);
		
		if(orderDirection == "A") {
			orderDirection == "ASC";
		} else if (orderDirection == "D") {
			orderDirection == "DESC";
		}
		arrayAppend(variables.orders, {property=aliasedProperty, direction=orderDirection});
	}

	public void function addKeywordProperty(required string propertyIdentifier, required numeric weight) {
		variable.keywordProperties[getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier)] = arguments.weight;
	}
	
	public void function applyData(required struct data) {
		var currentPage = 1;
		
		for(var i in arguments.data) {
			if(left(i,2) == "F#variables.dataKeyDelimiter#") {
				addFilter(propertyIdentifier=right(i, len(i)-2), value=arguments.data[i]);
			} else if(left(i,2) == "R#variables.dataKeyDelimiter#") {
				addRange(propertyIdentifier=right(i, len(i)-2), value=arguments.data[i]);
			} else if(i == "OrderBy") {
				for(var ii=1; ii <= listLen(arguments.data[i], variables.orderPropertyDelimiter); ii++ ) {
					addOrder(orderStatement=listGetAt(arguments.data[i], ii, variables.orderPropertyDelimiter));
				}
			} else if(i == "P#variables.dataKeyDelimiter#Show" && isNumeric(arguments.data[i])) {
				setRecordShow(arguments.data[i]);
			} else if(i == "P#variables.dataKeyDelimiter#Start" && isNumeric(arguments.data[i])) {
				setRecordStart(arguments.data[i]);
			} else if(i == "P#variables.dataKeyDelimiter#Current" && isNumeric(arguments.data[i])) {
				currentPage = arguments.data[i];
			}
		}
		if(structKeyExists(arguments.data, "keyword")){
			var KeywordList = Replace(arguments.data.Keyword," ","^","all");
			KeywordList = Replace(KeywordList,"%20","^","all");
			KeywordList = Replace(KeywordList,"+","^","all");
			for(var i=1; i <= listLen(KeywordList, "^"); i++) {
				arrayAppend(variables.Keywords, listGetAt(KeywordList, i, "^"));
			}
		}
		
		if(currentPage gt 1) {
			setRecordStart((((currentPage-1)*getRecordShow()) + 1));
		}
	}
	
	public void function addHQLParam(required string paramName, required string paramValue) {
		variables.hqlParams[ arguments.paramName ] = arguments.paramValue;
	}
	
	public struct function getHQLParams() {
		return duplicate(variables.hqlParams);
	}

	public string function getHQLSelect () {
		var hqlSelect = "";
		
		if(structCount(variables.selects)) {
			hqlSelect = "SELECT new map(";
			for(var select in variables.selects) {
				hqlSelect &= " #select# as #variables.selects[select]#,";
			}
			hqlSelect = left(hqlSelect, len(hqlSelect)-1) & ")";
		}
		
		return hqlSelect;
	}
	
	public string function getHQLFrom(boolean supressFrom=false) {
		var hqlFrom = "";
		if(!arguments.supressFrom) {
			hqlFrom &= " FROM";	
		}
		hqlFrom &= " #getBaseEntityName()# as #variables.entities[getBaseEntityName()].entityAlias#";
		for(var i in variables.entities) {
			if(i != getBaseEntityName()) {
				var joinType = variables.entities[i].joinType;
				if(!len(joinType)) {
					joinType = "inner";
				}
				var fetch = "";
				if(variables.entities[i].fetch) {
					fetch = "fetch";
				}
				hqlFrom &= " #joinType# join #fetch# #variables.entities[i].parentAlias#.#variables.entities[i].parentRelatedProperty# as #variables.entities[i].entityAlias#";
			}
		}
		return hqlFrom;
	}

	public string function getHQLWhere(boolean suppressWhere=false) {
		var hqlWhere = "";
		
		// Loop over where groups
		for(var i=1; i<=arrayLen(variables.whereGroups); i++) {
			if( structCount(variables.whereGroups[i].filters) || structCount(variables.whereGroups[i].ranges) ) {
				if(len(hqlWhere) == 0) {
					if(!arguments.suppressWhere) {
						hqlWhere &= " WHERE";
					}
					hqlWhere &= " (";
				} else {
					hqlWhere &= " OR";
				}
				
				// Open A Where Group
				hqlWhere &= " (";
				
				// Add Where Group Filters
				for(var filter in variables.whereGroups[i].filters) {
					if(listLen(variables.whereGroups[i].filters[filter], variables.valueDelimiter) gt 1) {
						hqlWhere &= " (";
						for(var ii=1; ii<=listLen(variables.whereGroups[i].filters[filter], variables.valueDelimiter); ii++) {
							var paramID = "F_#replace(filter, ".", "", "all")##i##ii#";
							addHQLParam(paramID, listGetAt(variables.whereGroups[i].filters[filter], ii, variables.valueDelimiter));
							hqlWhere &= " #filter# = :#paramID# OR";
						}
						hqlWhere = left(hqlWhere, len(hqlWhere)-2) & ") AND";
					} else {
						var paramID = "F#replace(filter, ".", "", "all")##i#";
						addHQLParam(paramID, variables.whereGroups[i].filters[filter]);
						hqlWhere &= " #filter# = :#paramID# AND";
					}
				}
				
				// Add Where Group Ranges
				for(var range in variables.whereGroups[i].ranges) {
					var paramIDupper = "R#replace(filter, ".", "", "all")##i#upper";
					var paramIDlower = "R#replace(filter, ".", "", "all")##i#lower";
					addHQLParam(paramIDlower, listGetAt(variables.whereGroups[i].ranges[range], 1, variables.valueDelimiter));
					addHQLParam(paramIDupper, listGetAt(variables.whereGroups[i].ranges[range], 2, variables.valueDelimiter));
					
					hqlWhere &= " #range# > :#paramIDlower# AND #range# < :#paramIDupper# AND";
					
				}
				
				// Close Where Group
				hqlWhere = left(hqlWhere, len(hqlWhere)-3)& ")";
				if( i == arrayLen(variables.whereGroups)) {
					hqlWhere &= " )";
				}
			}
		}
		
		if( arrayLen(variables.Keywords) && structCount(variables.keywordProperties) ) {
			if(len(hqlWhere) == 0) {
				if(!arguments.suppressWhere) {
					hqlWhere &= " WHERE";
				}
			} else {
				hqlWhere &= " AND";
			}
			hqlWhere &= " (";
			for(var keywordProperty in variables.keywordProperties) {
				for(var ii=1; ii<=arrayLen(variables.Keywords); ii++) {
					var paramID = "K#replace(keywordProperty, ".", "", "all")##ii#";
					addHQLParam(paramID, "%#variables.Keywords[ii]#%");
					hqlWhere &= " #keywordProperty# LIKE :#paramID# AND";
				}
			}
			hqlWhere = left(hqlWhere, len(hqlWhere)-3 ) & ")";
		}
		
		return hqlWhere;
	}
	
	public string function getHQLOrder(boolean supressOrderBy=false) {
		var hqlOrder = "";
		if(arrayLen(variables.orders)){
			if(!arguments.supressOrderBy) {
				var hqlOrder &= " ORDER BY";
			}
			for(var i=1; i<=arrayLen(variables.orders); i++) {
				var hqlOrder &= " #variables.orders[i].property# #variables.orders[i].direction#,";
			}
			hqlOrder = left(hqlOrder, len(hqlOrder)-1);
		}
		return hqlOrder;
	}
	
	public string function getHQL() {
		return "#getHQLSelect()##getHQLFrom()##getHQLWhere()##getHQLOrder()#";
	}

	/* This Needs To Be Refactored
	public void function applySearchScore(){
		var searchStart = getTickCount();
		var structSort = structNew();
		var randomID = 0;
		
		for(var i=1; i <= arrayLen(variables.records); i++) {
			var score = 0;
			for(property in keywordProperties) {
				var propertyArray = listToArray(property, ".");
				var evalString = "variables.records[i]";
				for(var pi=2; pi <= arrayLen(propertyArray); pi++) {
					evalString &= ".get#propertyArray[pi]#()";
				}
				var data = evaluate("#evalString#");
				for(var ki=1; ki <= arrayLen(variables.keywords); ki++) {
					var findValue = FindNoCase(variables.keywords[ki], data, 0);
					while(findValue > 0) {
						var score = score + (len(variables.keywords[ki]) * variables.keywordProperties[property]);
						findValue = FindNoCase(variables.keywords[ki],  data, findValue+1);
					}
				}
			}
			variables.records[i].setSearchScore(score);
			randomID = rand();
			if(find(".", score)) {
				randomID = right(randomID, len(randomID)-2);
			}
			structSort[ score & randomID ] = variables.records[i];
		}
		var scoreArray = structKeyArray(structSort);
		
		arraySort(scoreArray, "numeric", "desc");
		variables.records = arrayNew(1);
		for(var i=1; i <= arrayLen(scoreArray); i++) {
			arrayAppend(variables.records, structSort[scoreArray[i]]);
		}
		
		setSearchTime(getTickCount()-searchStart);
	}
	*/
	
	public void function setRecords(required any records) {
		variables.records = arrayNew(1);
		
		if(isArray(arguments.records)) {
			variables.records = arguments.records;
		} else if (isQuery(arguments.records)) {
			// TODO: add the ability to pass in a query.
			throw("Passing in a query is a feature that hasn't been finished yet");
		} else {
			throw("You must either pass an array of records, or a query or records");
		}
		
		// Apply Search Score to Entites
		if(arrayLen(variables.keywords)) {
			applySearchScore();
		}
	}
	
	public numeric function getRecordEnd() {
		variables.recordEnd = getRecordStart() + getRecordShow() - 1;
		if(variables.recordEnd > arrayLen(getRecords())) {
			variables.recordEnd = arrayLen(getRecords());
		}
		return variables.recordEnd;
	}
	
	public numeric function getCurrentPage() {
		return ceiling(getRecordStart() / getRecordEnd());
	}
	
	public numeric function getTotalRecords() {
		return arrayLen(getRecords());
	}
	
	public numeric function getTotalPages() {
		return ceiling(getTotalRecords() / setRecordShow());
	}
	
	public array function getRecords(boolean refresh=false) {
		if( !structKeyExists(variables, "records") || arguments.refresh == true) {
			variables.records = ormExecuteQuery(getHQL(), getHQLParams(), false, {ignoreCase="true"});
		}
		return variables.records;
	}

	public array function getPageRecords(boolean refresh=false) {
		if( !structKeyExists(variables, "pageRecords")) {
			var records = getRecords(arguments.refresh);
			variables.pageRecords = arrayNew(1);
			for(var i=getRecordStart(); i<=getRecordEnd(); i++) {
				arrayAppend(variables.pageRecords, records[i]);
			}
		}
		return variables.pageRecords;
	}
}