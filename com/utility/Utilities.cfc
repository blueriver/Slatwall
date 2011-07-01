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

<cfcomponent extends="Slatwall.com.utility.BaseObject">

	<!---
	QueryTreeSort takes a query and efficiently (O(n)) resorts it hierarchically (parent-child), adding a Depth column that can then be used when displaying the data.
	
	@return Returns a query.
	@author Rick Osborne (deliver8r@gmail.com)
	@version 1, April 9, 2007
	@ http://cflib.org/udf/queryTreeSort
	@ modified by Tony Garcia September 27, 2007
	--->
	<cffunction name="queryTreeSort" access="public" output="false" returntype="query">
		<cfargument name="theQuery" type="query" required="true" hint="the query to sort" />
		<cfargument name="ParentID" type="string" default="ParentID" hint="the name of the column in the table containing the ID of the item's parent" />
		<cfargument name="ItemID" type="string" default="ItemID" hint="the name of the column in the table containing the item's ID (primary key)" />
		<cfargument name="rootID" type="numeric" default="0" hint="the ID of the item to use as the root, defaults to the tree root" />
		<cfargument name="levels" type="numeric" default="0" hint="how many levels to return, defaults to all levels when set to 0" />
		<cfargument name="BaseDepth" type="numeric" default="0" hint="the number to use as the base depth" />
		<cfargument name="PathColumn" type="string" default="" hint="the name of the column containing the values to use to build paths to the items in the tree" />
        <cfargument name="PathDelimiter" type="string" default="," />
		
		<cfset var RowFromID=StructNew() /> <!--- indexing structure that contains the query row for each ID key --->
		<cfset var ChildrenFromID=StructNew() /> <!--- indexing struct that contains an array of children ID for each ID key --->
		<cfset var RootItems=ArrayNew(1) /> <!--- an array of root items (items that don't have parents --->
		<cfset var Depth=ArrayNew(1) /> <!--- an array that keeps track of the depth of each sorted item --->
		<cfset var Order=ArrayNew(1) /> <!--- array that keeps track of the generated order of items within each parent when the tree is sorted (can be used to "clean" the order) --->
		<cfset var ThisID=0 />
		<cfset var ThisDepth=0 />
		<cfset var ThisOrder=0 />
		<cfset var RootOrder=1 /> <!--- keeps track of the order of the root items in the Order array, used to build the order array --->
		<cfset var RowID=0 />
		<cfset var ChildrenIDs="" />
        <cfset var NewRowFromID=StructNew() />
        <cfset var Lineages=StructNew() />
        <cfset var ThisLineage="" />
        <cfset var ThisParentRowID="" />
		<cfset var thisPath = "" />
		<cfset var thisIDPath = "" />
		<cfset var i ="" />
		<cfset var ColName="" /> <!--- loop index variable for building query --->
		<cfset var altRet="" /> <!--- variable for filtered query if number of levels is passed in --->
        <cfset var AddColumns="TreeDepth,NewOrder,Lineage,idPath" />
        <cfset var RetColList=ListAppend(arguments.theQuery.ColumnList,AddColumns) />
        <cfset var Ret="" />
        
		<cfif len(arguments.pathColumn)>
			<cfset retColList=ListAppend(retColList,"#arguments.pathColumn#Path") />
		</cfif>
		<!--- set up the return query --->
        <cfset Ret=QueryNew(RetColList) />
		
		<!--- Set up all of our indexing --->
		<cfloop query="arguments.theQuery">
			<!--- an index of ID to row in "raw" order (not sorted by parent) --->
			<cfset RowFromID[theQuery[arguments.itemID][theQuery.CurrentRow]]=CurrentRow />
			<cfif NOT StructKeyExists(ChildrenFromID, theQuery[arguments.parentID][theQuery.CurrentRow])>
				<!--- only create a new parentID array within the ChildrenFromID struct for every new ParentID --->
				<cfset ChildrenFromID[theQuery[arguments.parentID][theQuery.CurrentRow]]=ArrayNew(1) />
			</cfif>
			<!--- add the ItemID to it's ParentID array within the ChildrenFromID struct --->
			<cfset ArrayAppend(ChildrenFromID[theQuery[arguments.parentID][theQuery.CurrentRow]], theQuery[arguments.itemID][theQuery.CurrentRow]) />
		</cfloop>
        
		<!--- Find root items --->
		<cfif not arguments.rootID><!--- if a rootID wasn't specified, use the absolute root --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID does not exist in the rowfromID struct (parent ID isn't an ID of another item)  --->
				<cfif NOT StructKeyExists(RowFromID, theQuery[arguments.parentID][theQuery.CurrentRow])>
					<cfset ArrayAppend(RootItems, theQuery[arguments.itemID][theQuery.CurrentRow]) />
					<cfset ArrayAppend(Depth, arguments.baseDepth) />
					<cfset ArrayAppend(Order, RootOrder) />
					<cfset RootOrder++ />
				</cfif>
			</cfloop>
		<cfelse><!--- use the value of the rootID argument, if passed in, as the root of the tree --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID matches the rootID argument  --->
				<cfif theQuery[arguments.parentID][theQuery.CurrentRow] eq arguments.rootID>
					<cfset ArrayAppend(RootItems, theQuery[arguments.itemID][theQuery.CurrentRow]) />
					<cfset ArrayAppend(Depth, arguments.baseDepth) />
					<cfset ArrayAppend(Order, RootOrder) />
					<cfset RootOrder++ />
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Sort the Tree --->
		<cfloop condition="ArrayLen(RootItems) GT 0">
			<cfset ThisID=RootItems[1] />
			<cfset ArrayDeleteAt(RootItems, 1) />
			<cfset ThisDepth=Depth[1] />
			<cfset ArrayDeleteAt(Depth, 1) />
			<cfset ThisOrder=Order[1] />
			<cfset ArrayDeleteAt(Order, 1) />
			
			<cfif StructKeyExists(RowFromID, ThisID)><!--- If the current ID exists --->
				<!--- Add this row to the query we're building --->
				<cfset RowID=RowFromID[ThisID] /><!--- get appropriate query row --->
				<cfset QueryAddRow(Ret) />
                
                <cfset NewRowFromID[ThisID]=Ret.recordCount />
				<!--- Try to find the parent's lineage --->
                <cfif StructKeyExists(Lineages, theQuery[arguments.parentID][RowID])>
                    <cfset ThisLineage=Lineages[theQuery[arguments.parentID][RowID]] />
                <cfelse>
                    <cfset ThisLineage="" /><!--- no grandparents --->
                </cfif>
                <!--- Add the parent if there is one --->
                <cfif structKeyExists(NewRowFromID, theQuery[arguments.parentID][RowID])> 
                    <cfset ThisLineage=ListAppend(ThisLineage, NewRowFromID[theQuery[arguments.parentID][RowID]]) />
                </cfif>
                <cfset Lineages[ThisID]=ThisLineage />
                
				<cfset QuerySetCell(Ret, "TreeDepth", ThisDepth) /> <!--- set depth info in column --->
				<cfset QuerySetCell(Ret, "NewOrder", ThisOrder) /> <!--- set order info in column --->
				<!--- set Tree lineage in cell --->
				<cfset QuerySetCell(Ret,"Lineage", ThisLineage)>
                <cfif len(arguments.pathColumn)>
                	<!--- set up path to item to set in path cell --->
                    <cfloop list="#thisLineage#" index="i">
                    	<cfset thisPath = listAppend(thisPath,Ret[arguments.pathColumn][i],arguments.pathDelimiter) />
						<cfset thisIDPath = listAppend(thisIDPath,Ret[arguments.itemID][i],arguments.pathDelimiter) />
                    </cfloop>
					<!--- add current item to path --->
					<cfset thisPath = listAppend(thisPath,theQuery[arguments.pathColumn][RowID],arguments.pathDelimiter) />
					<cfset thisIDPath = listAppend(thisIDPath,theQuery[arguments.itemID][RowID],arguments.pathDelimiter) />
                    <cfset querySetCell(Ret,"#arguments.PathColumn#Path", thisPath) />
					<cfset querySetCell(Ret,"idPath", thisIDPath) />
                    <cfset thispath = "" /> <!--- resets variable for the next item --->
					<cfset thisIDPath = "" />
                </cfif>
				<cfloop list="#theQuery.ColumnList#" index="ColName"><!--- loop over the original querys columns to copy the data to our return query --->
					<cfset QuerySetCell(Ret, ColName, theQuery[ColName][RowID]) />
				</cfloop>
			</cfif>
			
			<cfif StructKeyExists(ChildrenFromID, ThisID)>
				<!--- Push children into the stack --->
				<cfset ChildrenIDs=ChildrenFromID[ThisID]>
				<cfloop from="#ArrayLen(ChildrenIDs)#" to="1" step="-1" index="i">
					<cfset ArrayPrepend(RootItems, ChildrenIDs[i])>
					<cfset ArrayPrepend(Depth, ThisDepth + 1)>
					<cfset ArrayPrepend(Order, i) />
				</cfloop>
			</cfif>
			
		</cfloop>
		<cfif not arguments.levels>
			<cfreturn Ret />
		<cfelse>
			<cfquery dbtype="query" name="altRet"> 
				SELECT *
				FROM Ret
				WHERE TreeDepth <= <cfqueryparam value="#(arguments.levels)#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfreturn altRet />
		</cfif>
	</cffunction>
	
	

	<cfscript>
	/**
	 * Makes a row of a query into a structure.
	 * 
	 * @param query 	 The query to work with. 
	 * @param row 	 Row number to check. Defaults to row 1. 
	 * @return Returns a structure. 
	 * @author Nathan Dintenfass (nathan@changemedia.com) 
	 * @version 1, December 11, 2001
	 * http://cflib.org/index.cfm?event=page.udfbyid&udfid=358
	 */
	function queryRowToStruct(query){
		//by default, do this to the first row of the query
		var row = 1;
		//a var for looping
		var ii = 1;
		//the cols to loop over
		var cols = listToArray(query.columnList);
		//the struct to return
		var stReturn = structnew();
		//if there is a second argument, use that for the row number
		if(arrayLen(arguments) GT 1)
			row = arguments[2];
		//loop over the cols and build the struct from the query row	
		for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
			stReturn[cols[ii]] = query[cols[ii]][row];
		}		
		//return the struct
		return stReturn;
	}

	/**
	* exports the given query/array to file.
	* 
	* @param data      Data to export. (Required) (Currently only supports query).
	* @param columns      list of columns to export. (optional, default: all)
	* @param columnNames      list of column headers to export. (optional, default: none)
	* @param fileName      file name for export. (default: guid)
	* @param fileType      file type for export. (default: csv)
	* @param download      download the file. (default: true)
	* @return struct with file info. 
	*/
	public struct function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv', boolean download = true ) {
		var result = {};
		var supportedFileTypes = "csv,txt";
		if(!structKeyExists(arguments,"fileName")){
			arguments.fileName = createUUID() ;
		}
		if(!listFindNoCase(supportedFileTypes,arguments.fileType)){
			throw("File type not supported in export. Only supported file types are #supportedFileTypes#");
		}
		var fileNameWithExt = arguments.fileName & "." & arguments.fileType;
		if(structKeyExists(application,"tempDir")){
			var filePath = application.tempDir & "/" & fileNameWithExt;
		} else {
			var filePath = GetTempDirectory() & fileNameWithExt;
		}
		if(isQuery(data) && !structKeyExists(arguments,"columns")){
			arguments.columns = arguments.data.columnList;
		}
		if(structKeyExists(arguments,"columns") && !structKeyExists(arguments,"columnNames")){
			arguments.columnNames = arguments.columns;
		}
		var columnArray = listToArray(arguments.columns);
		var columnCount = arrayLen(columnArray);
		
		var listQualifier = "";
		var delimiter = "";
		if(arguments.fileType == 'csv'){
			delimiter = chr(44);
			listQualifier = '"';
		} else if(arguments.fileType == 'txt'){
			delimiter = chr(9);
		}
		
		var dataArray=[listChangeDelims(arguments.columnNames,delimiter,",")];
		for(var i=1; i <= data.recordcount; i++){
			var row = [];
			for(var j=1; j <= columnCount; j++){
				arrayAppend(row,'#listQualifier##data[columnArray[j]][i]##listQualifier#');
			}
			arrayAppend(dataArray,arrayToList(row));
		}
		var outputData = arrayToList(dataArray,"#chr(13)##chr(10)#");
		fileWrite(filePath,outputData);
		
		if(arguments.download){
			downloadFile(fileNameWithExt,filePath,"application/#arguments.fileType#",true);
		} else{
			result.fileName = fileNameWithExt;
			result.fileType = fileType;
			result.filePath = filePath;
			return result;
		}
	}
	
	</cfscript>	
	
	<cffunction name="downloadFile" access="public" returntype="void" output="false">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="filePath" type="string" required="true" />
		<cfargument name="contentType" type="string" required="false" default="application/unknown" />
		<cfargument name="deleteFile" type="boolean" required="false" default="false" />
	
		<cfheader name="Content-Disposition" value="inline; filename=#arguments.fileName#" />
		<cfcontent type="#arguments.contentType#" file="#arguments.filePath#" deletefile="#arguments.deleteFile#" />
	</cffunction>
	
</cfcomponent>