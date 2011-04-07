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
<!---
	Filename: QueryTreeSorter.cfc
	Author: Tony Garcia
	Purpose: Component that sorts queries from adjacency model tree table and can display a nested simple list, html list, select box, or padded html table
	Created: 27 Sept. 2007
	
	This code was adapted from a series of blog posts by Rick Osborne http://rickosborne.org/blog/?p=3 
--->
<cfcomponent displayname="QueryTreeSorter" output="false"cache="true" cachetimeout="0" hint="I sort queries from parent-child adjacency list tables without using recursion">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="TitleColumn" type="String" default="Name" hint="the name of the column in the table containing the item name" />
		<cfargument name="ItemID" type="string" default="ItemID" hint="the name of the column in the table containing the item's ID (primary key)" />
		<cfargument name="ParentID" type="string" default="ParentID" hint="the name of the column in the table containing the ID of the item's parent" />
		<cfargument name="PathColumn" type="string" default="" hint="the name of the column containing the values to use to build paths to the items in the tree" />
        <cfargument name="PathDelimiter" type="string" default="," />
		<cfargument name="pathSuffix" type="string" default="" />
		
		<cfset variables.titleColumn=arguments.TitleColumn />
		<cfset variables.itemID=arguments.ItemID />
		<cfset variables.parentID=arguments.ParentID />
		<cfset variables.PathColumn = arguments.pathColumn />
        <cfset variables.PathDelimiter = arguments.PathDelimiter />
		<cfset variables.PathSuffix = arguments.PathSuffix />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="SortQuery" access="public" output="false" returntype="query">
		<cfargument name="theQuery" type="query" required="true" hint="the query to sort" />
		<cfargument name="rootID" type="numeric" default="0" hint="the ID of the item to use as the root, defaults to the tree root" />
		<cfargument name="levels" type="numeric" default="0" hint="how many levels to return, defaults to all levels when set to 0" />
		<cfargument name="BaseDepth" type="numeric" default="0" hint="the number to use as the base depth" />
		<cfargument name="pathSuffix" type="string" default="#variables.pathSuffix#" />
		
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
		<cfset var i ="" />
		<cfset var ColName="" /> <!--- loop index variable for building query --->
		<cfset var altRet="" /> <!--- variable for filtered query if number of levels is passed in --->
        <cfset var AddColumns="TreeDepth,NewOrder,Lineage" />
        <cfset var RetColList=ListAppend(arguments.theQuery.ColumnList,AddColumns) />
        <cfset var Ret="" />
        
		<cfif len(variables.pathColumn)>
			<cfset retColList=ListAppend(retColList,"Path") />
		</cfif>
		<!--- set up the return query --->
        <cfset Ret=QueryNew(RetColList) />
		
		<!--- Set up all of our indexing --->
		<cfloop query="arguments.theQuery">
			<!--- an index of ID to row in "raw" order (not sorted by parent) --->
			<cfset RowFromID[theQuery[variables.ItemID][theQuery.CurrentRow]]=CurrentRow />
			<cfif NOT StructKeyExists(ChildrenFromID, theQuery[variables.ParentID][theQuery.CurrentRow])>
				<!--- only create a new parentID array within the ChildrenFromID struct for every new ParentID --->
				<cfset ChildrenFromID[theQuery[variables.ParentID][theQuery.CurrentRow]]=ArrayNew(1) />
			</cfif>
			<!--- add the ItemID to it's ParentID array within the ChildrenFromID struct --->
			<cfset ArrayAppend(ChildrenFromID[theQuery[variables.ParentID][theQuery.CurrentRow]], theQuery[variables.ItemID][theQuery.CurrentRow]) />
		</cfloop>
        
		<!--- Find root items --->
		<cfif not arguments.rootID><!--- if a rootID wasn't specified, use the absolute root --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID does not exist in the rowfromID struct (parent ID isn't an ID of another item)  --->
				<cfif NOT StructKeyExists(RowFromID, theQuery[variables.ParentID][theQuery.CurrentRow])>
					<cfset ArrayAppend(RootItems, theQuery[variables.ItemID][theQuery.CurrentRow]) />
					<cfset ArrayAppend(Depth, arguments.baseDepth) />
					<cfset ArrayAppend(Order, RootOrder) />
					<cfset RootOrder++ />
				</cfif>
			</cfloop>
		<cfelse><!--- use the value of the rootID argument, if passed in, as the root of the tree --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID matches the rootID argument  --->
				<cfif theQuery[variables.ParentID][theQuery.CurrentRow] eq arguments.rootID>
					<cfset ArrayAppend(RootItems, theQuery[variables.ItemID][theQuery.CurrentRow]) />
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
                <cfif StructKeyExists(Lineages, theQuery[variables.ParentID][RowID])>
                    <cfset ThisLineage=Lineages[theQuery[variables.ParentID][RowID]] />
                <cfelse>
                    <cfset ThisLineage="" /><!--- no grandparents --->
                </cfif>
                <!--- Add the parent if there is one --->
                <cfif structKeyExists(NewRowFromID, theQuery[variables.ParentID][RowID])> 
                    <cfset ThisLineage=ListAppend(ThisLineage, NewRowFromID[theQuery[variables.ParentID][RowID]]) />
                </cfif>
                <cfset Lineages[ThisID]=ThisLineage />
                
				<cfset QuerySetCell(Ret, "TreeDepth", ThisDepth) /> <!--- set depth info in column --->
				<cfset QuerySetCell(Ret, "NewOrder", ThisOrder) /> <!--- set order info in column --->
				<!--- set Tree lineage in cell --->
				<cfset QuerySetCell(Ret,"Lineage", ThisLineage)>
                <cfif len(variables.pathColumn)>
                	<!--- set up path to item to set in path cell --->
                    <cfloop list="#thisLineage#" index="i">
                    	<cfset thisPath = listAppend(thisPath,Ret[variables.pathColumn][i],variables.pathDelimiter) />
                    </cfloop>
					<!--- add current item to path --->
					<cfset thisPath = listAppend(thisPath,theQuery[variables.pathColumn][RowID],variables.pathDelimiter) />
                    <cfset querySetCell(Ret,"Path", thisPath & arguments.pathSuffix) />
                    <cfset thispath = "" /> <!--- resets variable for the next item --->
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
		
</cfcomponent>
