component displayname="Smart List" accessors="true" persistent="false" {
	
	property name="entityName" type="string" hint="This is the base entity that the list is based on.";
	property name="entityMetaData" type="struct" hint="This is the meta data of the base entity.";

	property name="filters" type="struct" hint="This struct holds any filters that are set on the entities properties";
	property name="ranges" type="struct" hint="This struct holds any ranges set on any of the entities properties";
	property name="orders" type="struct" hint="This struct holds the display order specification based on property";
	
	property name="keywordProperties" type="struct" hint="This struct holds the properties that searches reference and their relative weight";
	property name="keywords" type="array" hint="This array holds all of the keywords that were searched for";
	
	property name="entityStart" type="numeric" hint="This represents the first record to display and it is used in paging.";
	property name="entityShow" type="numeric" hint="This is the total number of entities to display";
	
	property name="entityEnd" type="numeric" hint="This represents the last record to display and it is used in paging.";
	property name="currentPage" type="numeric" hint="This is the current page that the smart list is displaying worth of entities";
	property name="totalPages" type="numeric" hint="This is the total number of pages worth of entities";
		
	property name="queryRecords" type="query" hint="This is the raw query records.  Either this is used or the entityRecords is uesed";
	property name="entityRecords" type="array" hint="This is the raw array of records.  Either this is used or the queryRecords is used";
	
	property name="entityArray" type="array" hint="This is the completed array of entities after filter, range, order, keywords and paging.";	

	public any function init(struct rc, required string entityName) {
		// Set defaults for the main properties
		setFilters(structNew());
		setRanges(structNew());
		setOrders(structNew());
		setKeywordProperties(structNew());
		setKeywords(arrayNew(1));
		setEntityStart(1);
		setEntityShow(10);
		
		setQueryRecords(queryNew('empty'));
		setEntityRecords(arrayNew(1));
		
		// Set entity name based on whatever
		setEntityName(arguments.entityName);
		
		if(isDefined("arguments.rc")) {
			applyRC(rc=arguments.RC);
		}
		
		return this;
	}
	
	public numeric function getEntityEnd() {
		variables.entityEnd = getEntityStart() + getEntityShow() - 1;
		if(variables.entityEnd > arrayLen(variables.records)) {
			variables.entityEnd = arrayLen(variables.records);
		}
		return variables.entityEnd;
	}
	
	public numeric function currentPage() {
	
	}
	
	public numeric function totalPages() {
	
	}
	
	public void function addFilter(required string property, required string value) {
		if(structKeyExists(variables.filters, arguments.property)) {
			arguments.value = "#variables.Filter[arguments.property]#^#arguments.Value#";
		}
		structInsert(variables.filters, arguments.property, arguments.value);
	}
	
	public void function addRange(required string property, required string value) {
		structInsert(variables.ranges, arguments.property, arguments.value);
	}
	
	public void function addOrder(required string property, required string value) {
		if(arguments.value == "A") {
			arguments.value = "ASC";
		} else if (arguments.value == "D") {
			arguments.value = "DESC";
		}
		structInsert(variables.orders, arguments.property, arguments.value);
	}
	
	public void function addKeywordProperty(required string property, required string value) {
		structInsert(variables.keywordProperties, arguments.property, arguments.value);
	}
	
	public void function applyRC(required struct rc) {
		for(i in arguments.rc) {
			if(find("F_",i)) {
				addFilter(property=Replace(i,"F_", ""), value=arguments.rc[i]);
			} else if(find("R_",i)) {
				addRange(property=Replace(i,"R_", ""), value=arguments.rc[i]);
			} else if(find("O_",i)) {
				addOrder(property=Replace(i,"O_", ""), value=arguments.rc[i]);
			} else if(find("E_Show",i)) {
				setEntityShow(arguments.rc[i]);
			} else if(find("E_Start",i)) {
				setEntityStart(arguments.rc[i]);
			}
		}
		if(isDefined("rc.Keyword")){
			var KeywordList = Replace(arguments.rc.Keyword," ","^","all");
			KeywordList = Replace(KeywordList,"%20","^","all");
			KeywordList = Replace(KeywordList,"+","^","all");
			for(var i=1; i <= listLen(KeywordList, "^"); i++) {
				arrayAppend(variables.Keywords, listGetAt(KeywordList, i, "^"));
			}
		}
	}
	
	
	public struct function getEntityMetaData() {
		if(!isDefined("variables.entityMetaData")) {
			variables.entityMetaData = getMetadata(entityNew(getEntityName()));
		}
		return variables.entityMetaData;
	}
	
	private string function getValidWhereProperty(required string rawProperty) {
		var entityProperties = getEntityMetaData().properties;
		var returnProperty = "";
		for(var i=1; i <= arrayLen(entityProperties); i++){
			if(entityProperties[i].name == arguments.rawProperty) {
				returnProperty = "a#getEntityName()#.#entityProperties[i].name#";
				break;	
			}
		}
		return returnProperty;
	}
	
	private string function getValidWherePropertyValue(required string rawProperty, required any value) {
		var entityProperties = getEntityMetaData().properties;
		var returnValue = "";
		for(var i=1; i <= arrayLen(entityProperties); i++){
			if(entityProperties[i].name == arguments.rawProperty) {
				if(entityProperties[i].type == "string") {
					returnValue = "'#arguments.value#'";
				} else if (entityProperties[i].type == "numeric" && isNumeric(arguments.value)) {
					returnValue = arguments.value;
				} else if (entityProperties[i].type == "boolean" && (arguments.value == 1 || arguments.value == true || arguments.value == "yes")) {
					returnValue = 1;
				} else if (entityProperties[i].type == "boolean" && (arguments.value == 0 || arguments.value == false || arguments.value == "no")) {
					returnValue = 0;
				}
				break;
			}
		}
		return returnValue;
	}
	
	public string function getHQLWhere(boolean suppressWhere) {
		
		var whereReturn = "";
		
		// Check to see if any Filters, Ranges or Keyword requirements exist.  If not, don't create a where
		if(structCount(variables.Filters) || structCount(variables.Ranges) || arrayLen(variables.Keywords)) {
			
			var CurrentFilter = 0;
			var CurrentFilterValue = 0;
			var CurrentRange = 0;
			
			if(isDefined("arguments.suppressWhere") && arguments.suppressWhere) {
				whereReturn = "AND";
			} else {
				whereReturn = "WHERE";
			}
			
			// Add any filters to the where statement
			for(filter in variables.filters) {
				
				var filterProperty = getValidWhereProperty(filter);
				
				if(filterProperty != "") {
					currentFilter = currentFilter + 1;
					
					currentFilterValue = 0;
					for(var i=1; i <= listLen(variables.filters[filter], "^"); i++) {
						var filterValue = getValidWherePropertyValue(filter, listGetAt(variables.filters[filter], i, "^"));
						if(filterValue neq "") {
							currentFilterValue = currentFilterValue + 1;
							if(currentFilter > 1 && currentFilterValue == 1) {
								whereReturn = "#whereReturn# AND (";
							} else if (currentFilterValue == 1) {
								whereReturn = "#whereReturn# (";
							} else if (currentFilterValue > 1) {
								whereReturn = "#whereReturn# OR";
							}
							whereReturn = "#whereReturn# #filterProperty# = #filterValue#";
						}
					}
					if(currentFilterValue > 0) {
						whereReturn = "#whereReturn# )";
					} else {
						currentFilter = currentFilter - 1;
					}
				}
			}
			
			// Add any ranges to the where statement
			for(range in variables.ranges) {
				
				var rangeProperty = getValidWhereProperty(range);
				
				if(rangeProperty != "") {
					if(Find("^", variables.ranges[range])) {
						var lowerRange = getValidWherePropertyValue(range, Left(variables.ranges[range], Find("^", variables.ranges[range])-1));
						var upperRange = getValidWherePropertyValue(range, Right(variables.ranges[range], Len(variables.ranges[range]) - Find("^", variables.ranges[range])));
						if(isNumeric(lowerRange) && isNumeric(upperRange) && lowerRange <= upperRange) {
							currentRange = currentRange + 1;
							if(currentRange > 1 || currentFilter > 0) {
								whereReturn = "#whereReturn# AND";
							}
							whereReturn = "#whereReturn# (#rangeProperty# >= #lowerRange# and #rangeProperty# <= #upperRange#)";
						}
					}
				}
			}
			
			if(currentRange == 0 && currentFilter == 0) {
				whereReturn = "";
			}
			
		}
	
		return whereReturn;
	}

	public void function setRecords(required any records) {
		variables.records = arrayNew(1);
		
		if(isArray(arguments.records)) {
			variables.records = arguments.records;
		} else if (isQuery(arguments.records)) {
			for(var i=1; i <= arguments.records.recordcount; i++) {
				var entity = entityNew(getEntityName());
				entity.set(arguments.records[i]);
				arrayAppend(variables.records, entity);
			}
		}
		
		// Apply Search Score to Entites
		if(arrayLen(variables.keywords)) {
			applySearchScore();
		}
		
		applyOrder();
	}
	
	public void function applySearchScore(){
		for(var i=1; i <= arrayLen(variables.records); i++) {
			var score = 0;
			for(property in keywordProperties) {
				if(!find("_", property)) {
				for(var ki=1; ki <= arrayLen(variables.keywords); ki++) {
					var findValue = FindNoCase(variables.keywords[ki], evaluate("variables.records[i].get#property#()"), 0);
					while(findValue > 0) {
						var score = score + (len(variables.keywords[ki]) * variables.keywordProperties[property]);
						findValue = FindNoCase(variables.keywords[ki],  evaluate("variables.records[i].get#property#()"), findValue+1);
					}
				}
				}
				
			}
			variables.records[i].setSearchScore(score);
		}
	}
	
	public void function applyOrder() {
		// Add Code to organize by Order & SearchScore.
	}
	
	public array function getEntityArray(boolean refresh) {
		if(!isDefined("variables.entityArray") || arrayLen(variables.entityArray) == 0 || (isDefined("arguments.refresh") && arguments.refresh == true)) {
			variables.entityArray = arrayNew(1);
			for(var i=getEntityStart(); i<=getEntityEnd(); i++) {
				arrayAppend(variables.entityArray, variables.records[i]);
			}
		}
		return variables.entityArray;
	}
}