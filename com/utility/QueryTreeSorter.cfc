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

	<cffunction name="HTMLListFromQueryTree" access="public" output="false" returntype="string">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="rootID" type="numeric" default="0" />
		<cfargument name="displayColumn" type="string" default="#variables.TitleColumn#" />
		<cfargument name="linkColumn" type="string" default="" hint="query column containing text to be used as links" />
		<cfargument name="DepthPrefix" default="depth" type="String" required="false" />
		<cfargument name="innerTag" type="string" default="" />
        <cfargument name="linkPrefix" type="string" default="" />
        <cfargument name="linkSuffix" type="string" default="" />
		<cfargument name="activeItems" type="string" default="" />
		<cfargument name="homelink" type="string" default="" />
		<cfargument name="activeClass" type="string" default="active" />
		<cfargument name="ListTag" default="ul" type="String" required="false" />
		<cfargument name="baseURL" type="string" default="/" />
		
		<cfset var Ret = "" />
		<cfset var MinDepth = 999 />
		<cfset var Q = arguments.theQuery />
		<cfset var LastDepth = 0 />
		<cfset var ThisDepth = 0 />
		<cfset var d = 0 />
		<cfset var itemTag = "" />
		<cfset var thislink = "" />
        <cfset var innerTagOpen = trim(arguments.innerTag) />
        <cfset var innerTagClose = "" />
        
        <cfif len(arguments.innerTag)>
        	<cfset innerTagClose = insert("/",arguments.innerTag,"1") />
        </cfif>
		
		<!--- Find the minimum depth of the tree --->
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth />
			<cfif ThisDepth LT MinDepth>
				<cfset MinDepth = ThisDepth>
			</cfif>
		</cfloop>
		<cfset LastDepth = MinDepth - 1>
		
		<!--- Main loop to  generate list --->
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth /><!--- Get Depth of current item in the query --->
			<!--- If the depth of the  current item is greater than the previous one, open a new list --->
			<cfif LastDepth LT ThisDepth>
				<cfloop from="#IncrementValue(LastDepth)#" to="#ThisDepth#" index="d">
					<cfset Ret = Ret & '<#arguments.ListTag# class="#Arguments.DepthPrefix##d-MinDepth+1#">'><!--- add as many UL tags as depth of item --->
				</cfloop>
			<cfelse>
				<!--- if the last item was deeper, we need to close off the lists in between --->
				<cfif LastDepth GT ThisDepth>
					<cfset Ret = Ret & RepeatString("</li></#Arguments.ListTag#>",LastDepth-ThisDepth) />
				</cfif>
				<!--- either way (if the depths are the same or last item was deeper), just close off the current list item --->
				<cfset Ret = Ret & "</li>" />
			</cfif>
			<!--- set up li tag for whether it's active or not (a list of active items can be passed in)--->
			<cfif not listfindnocase(arguments.activeItems,Q[variables.pathColumn][Q.CurrentRow])>
				<cfset itemTag = '<li>' />
			<cfelse>
				<cfset itemTag = '<li class="' & arguments.activeClass & '">' />
			</cfif>
			<!--- associate list items with links if a linkcolumn was given --->
			<cfif len(arguments.linkColumn)>
				<!--- set if current link is the home page, set empty link (to go to site root) --->
                <cfif (Q[arguments.linkColumn][Q.CurrentRow] neq arguments.homelink)>
                    <cfset thislink = "/" & arguments.linkPrefix & HTMLEditFormat(Q[arguments.linkColumn][Q.CurrentRow]) & arguments.linkSuffix />
                <cfelse>
                    <cfset thislink = arguments.baseURL />
                </cfif>
				<cfset Ret = Ret & itemTag & '<a href="' &  thislink & '">' & innerTagOpen & HTMLEditFormat(Q[arguments.displayColumn][Q.CurrentRow]) & innerTagClose & '</a>' /><!--- item will be closed in later loop iteration --->
			<cfelse>
				<cfset Ret = Ret & itemTag & innerTagOpen & HTMLEditFormat(Q[arguments.displayColumn][Q.CurrentRow]) & innerTagClose /><!--- item will be closed in later loop iteration --->
			</cfif>
			<cfset LastDepth = ThisDepth />
		</cfloop>
		
		<!--- Close off all items at once (there must be at least one)--->
		<cfif Q.RecordCount GT 0>
			<cfset Ret = Ret & RepeatString("</li></#Arguments.ListTag#>",LastDepth-(MinDepth-1)) />
		</cfif>
		<cfreturn Ret>
		
	</cffunction>

	<cffunction name="SimpleListFromQueryTree" access="public" output="false" returntype="string">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="rootID" type="numeric" default=0 />
		<cfargument name="levels" type="numeric" default=0 />
		<cfargument name="Separator" type="string" required="no" default="-" />
		
		<cfset var ThisDepth=0 />
		<cfset var Ret="" />
		<cfset var tab="" />
		<cfset var Q=arguments.theQuery />
		<cfset var ColID=0 />
		
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth />
			<cfif ThisDepth><cfset tab="<sup>L</sup>"><cfelse><cfset tab=""></cfif>
			<cfset Ret=Ret & '#RepeatString(Arguments.separator,ThisDepth)##tab##Q[variables.TitleColumn][Q.CurrentRow]#<br />'>
		</cfloop>
		
		<cfreturn Ret>
	</cffunction>

	<cffunction name="TableFromQueryTree" access="public" output="false" returntype="string">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="rootID" type="numeric" default=0 />
		<cfargument name="Columns" type="array" required="Yes" />
		<cfargument name="Titles" type="array" required="Yes" />
		<cfargument name="Classes" type="array" required="No" />
		<cfargument name="SpannedColumn" type="string" required="Yes" default="#variables.TitleColumn#" />
		<cfargument name="EvenOdd" type="array" required="No" default="#ListToArray('even,odd')#" />
		
		<cfset var MinDepth=999 />
		<cfset var MaxDepth=0 />
		<cfset var Ret="" />
		<cfset var Levels=0 />
		<cfset var Q=arguments.theQuery />
		<cfset var ColID=0 />
		
		<!--- Loop over query to determine depth range --->
		<cfloop query="Q">
			<cfif Q.TreeDepth GT MaxDepth>
				<cfset MaxDepth=Q.TreeDepth />
			</cfif>
			<cfif Q.TreeDepth LT MinDepth>
				<cfset MinDepth=Q.TreeDepth>
			</cfif>
		</cfloop>
		<cfset Levels=MaxDepth-MinDepth+1>
		
		<!--- Table header --->
		<cfsavecontent variable="Ret">
			<cfoutput>
		<table>
			<thead>
				<tr>
					<cfloop from="1" to="#ArrayLen(Columns)#" index="ColID">
					<th<cfif Classes[ColID] NEQ ""> class="#Classes[ColID]#"</cfif><cfif (Columns[ColID] EQ Arguments.SpannedColumn) AND (Levels GT 1)> colspan="#Levels#"</cfif>><cfif Titles[ColID] NEQ "">#Titles[ColID]#<cfelse>#Columns[ColID]#</cfif></th>
					</cfloop>
				</tr>
			</thead>
		
		<!--- Table body --->
		<tbody>
				<cfloop query="Q">
		<tr class="#Arguments.EvenOdd[IncrementValue(Q.CurrentRow MOD 2)]#">
					<cfloop from="1" to="#ArrayLen(Columns)#" index="ColID">
			<cfif (Columns[ColID] EQ Arguments.SpannedColumn)><cfloop from="#IncrementValue(MinDepth)#" to="#Q.TreeDepth#" index="i"><td>&nbsp;&gt;&nbsp;</td></cfloop></cfif>
			<td<cfif Classes[ColID] NEQ ""> class="#Classes[ColID]#"</cfif><cfif (Columns[ColID] EQ Arguments.SpannedColumn) AND (Int(MaxDepth - Q.TreeDepth) GT 0)> colspan="#IncrementValue(MaxDepth-Q.TreeDepth)#"</cfif>>#HTMLEditFormat(Q[Columns[ColID]][Q.CurrentRow])#</td>
					</cfloop>
		</tr>
				</cfloop>
		</tbody>
		</table>
			</cfoutput>
		</cfsavecontent>
		<cfreturn Ret />
	</cffunction>
	
	<cffunction name="SelectBoxTree" access="public" output="false" returntype="string">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="rootID" type="numeric" default=0 />
		<cfargument name="levels" type="numeric" default=0 />
	    <cfargument name="SelectBoxName" type="string" default="ParentID" /><!--- name attribute of select box --->
	    <cfargument name="SelectBoxID" type="string" default="ParentID" /><!--- id attribute of select box --->
	    <cfargument name="SelectedValue" type="string" default="" /><!--- selected value --->
	    <cfargument name="Size" type="numeric" default="1" /><!--- size of select box --->
	    <cfargument name="tab" type="string" default="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" />
		<cfargument name="RootLabel" type="string" default="None" /><!--- label for root option --->
		
		<cfset var bullet="" />
		<cfset var Q=arguments.theQuery />
		<cfset var ThisDepth = "" />
		
		<cfif arguments.theQuery neq getTree()>
			<cfset Q = sortQuery(arguments.theQuery, arguments.rootID, arguments.levels) />
		</cfif>
	    
	    <cfsavecontent variable="Ret">
	    <cfoutput>
	    <select name="#Arguments.SelectBoxName#" id="#Arguments.SelectBoxID#" size="#Arguments.Size#">
	        <option value="0"<cfif (len(Arguments.SelectedValue) and (Arguments.SelectedValue eq 0))> selected</cfif>>#Arguments.RootLabel#</option>
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth />
	 		<cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
			<option value="#Q[variables.ItemID][Q.CurrentRow]#" <cfif len(Arguments.SelectedValue) and (Arguments.SelectedValue eq Q[variables.ItemID][Q.CurrentRow])>selected</cfif>>
	            &nbsp;&nbsp;&nbsp;#RepeatString(Arguments.tab,ThisDepth)##bullet##Q[variables.TitleColumn][Q.CurrentRow]#
	        </option>
		</cfloop>
	    </select>
	    </cfoutput>
	    </cfsavecontent>
	    <cfreturn Ret />
	</cffunction>
		
</cfcomponent>