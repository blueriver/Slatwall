<cfcomponent displayname="SmartList" entityname="smartlist" accessors="true" persistent="false" >

	<cfproperty name="EntityName" type="string" />
	
	<cfproperty name="Filter" type="struct" />
	<cfproperty name="Range" type="struct" />
	<cfproperty name="Order" type="struct" />
	<cfproperty name="KeywordColumn" type="struct" />
	<cfproperty name="Keyword" type="array" />
	
	<cfproperty name="QueryRecords" type="query" />
	<cfproperty name="EntityRecords" type="array" />
	
	<cfproperty name="EntityStart" type="numeric"  />
	<cfproperty name="EntityEnd" type="numeric" />
	<cfproperty name="EntityShow" type="numeric" />
	<cfproperty name="CurrentPage" type="numeric" />
	<cfproperty name="TotalPage" type="numeric" />
	
	<cfproperty name="EntityArray" type="array" />
		
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfargument name="EntityName" type="string" required="true" />
		<cfargument name="RC" type="struct" required="true" />
		
		<cfset setEntityName(arguments.EntityName) />
		
		<cfset setFilter(structNew()) />
		<cfset setRange(structNew()) />
		<cfset setOrder(structNew()) />
		<cfset setKeywordColumn(structNew()) />
		<cfset setKeyword(arrayNew(1)) />
		
		<cfset setQueryRecords(queryNew('empty')) />
		<cfset setEntityRecords(arrayNew(1)) />
		
		<cfset setEntityStart(1) />
		<cfset setEntityShow(100) />
		<cfset setCurrentPage(1) />
		<cfset setTotalPage(1) />
		
		<cfset setRC(arguments.RC) />
		
		<cfset setEntityArray(arrayNew(1)) />
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addFilter" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		
		<cfif structKeyExists(variables.Filter, arguments.Column)>
			<cfset arguments.Value = "#variables.Filter[arguments.Column]##arguments.Value#" />
		</cfif>
		
		<cfset structInsert(variables.Filter, arguments.Column, arguments.Value) />
    </cffunction>
	
	<cffunction name="addRange" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		
		<cfif structKeyExists(variables.Range, arguments.Column)>
			<cfset arguments.Value = "#variables.Range[arguments.Column]##arguments.Value#" />
		</cfif>
		
		<cfset structInsert(variables.Range, arguments.Column, arguments.Value) />
    </cffunction>
	
	<cffunction name="addOrder" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		
		<cfif structKeyExists(variables.Order, arguments.Column)>
			<cfset arguments.Value = "#variables.Order[arguments.Column]##arguments.Value#" />
		</cfif>
		
		<cfset structInsert(variables.Order, arguments.Column, arguments.Value) />
    </cffunction>
	
	<cffunction name="addKeywordColumn" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		
		<cfif structKeyExists(variables.KeywordColumn, arguments.Column)>
			<cfset arguments.Value = "#variables.KeywordColumn[arguments.Column]##arguments.Value#" />
		</cfif>
		
		<cfset structInsert(variables.KeywordColumn, arguments.Column, arguments.Value) />
    </cffunction>
	
	<cffunction name="getEntityEnd">
		<cfset variables.EntityEnd = (variables.EntityStart + variables.EntityShow) - 1 />
		
		<cfif arrayLen(variables.EntityRecords) and variables.EntityEnd gt arrayLen(variables.EntityRecords)>
			<cfset variables.EntityEnd = arrayLen(variables.EntityRecords) />
		<cfelseif variables.QueryRecords.recordcount and variables.EntityEnd gt variables.QueryRecords.recordcount>
			<cfset variables.EntityEnd = variables.QueryRecords.recordcount />
		</cfif>
		
		<cfreturn variables.EntityEnd />
	</cffunction>
	
	<cffunction name="setRC">
		<cfargument name="rc" />
		
		<cfset var ValuePair = "" />
		<cfset var OrderDirection = "" />
		
		<cfloop collection="#arguments.rc#" item="ValuePair">
		
			<cfif find("F_",ValuePair)>
				<cfset addFilter(Replace(ValuePair,"F_", ""), StructFind(arguments.rc,ValuePair)) />
			</cfif>
			<cfif find("R_",ValuePair)>
				<cfset addRange(Replace(ValuePair,"R_", ""), StructFind(arguments.rc,ValuePair)) />
			</cfif>
		
			<cfif find("O_",ValuePair)>
				<cfif StructFind(arguments.rc,ValuePair) eq "A">
					<cfset OrderDirection = "ASC" />
				<cfelseif StructFind(arguments.rc,ValuePair) eq "A">
					<cfset OrderDirection = "DESC" />
				<cfelse>
					<cfset OrderDirection = StructFind(arguments.rc,ValuePair) />
				</cfif>
				<cfset addOrder(Replace(ValuePair,"O_", ""), OrderDirection) />
			</cfif>
		
			<cfif ValuePair eq "P_Show">
				<cfset setEntityShow(StructFind(arguments.rc,ValuePair)) />
			</cfif>
			<cfif ValuePair eq "P_Start">
				<cfset setEntityStart(StructFind(arguments.rc,ValuePair)) />
			</cfif>
		
		</cfloop>
		
		<cfif isDefined("arguments.rc.Keyword")>
		
			<cfset arguments.rc.Keyword = Replace(arguments.rc.Keyword," ","^","all") />
			<cfset arguments.rc.Keyword = Replace(arguments.rc.Keyword,"%20","^","all") />
			<cfset arguments.rc.Keyword = Replace(arguments.rc.Keyword,"+","^","all") />
		
			<cfloop list="#arguments.rc.Keyword#" index="I" delimiters="^">
				<cfset arrayAppend(variables.Keyword, I) />
			</cfloop>
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="getSQLWhere">
		<cfargument name="SuppressWhere" type="boolean" default="false" />
		
		<cfset var WhereReturn = "" />
		<cfset var I = "" />
		<cfset var II = "" />
		<cfset var LC = 0 />
		<cfset var LLC = 0 />
		<cfset var ColumnName = "" />
		<cfset var ColumnValue = "" />
		
		<cfsavecontent variable="WhereReturn">
			<cfoutput>
				<cfif structCount(variables.Filter) or structCount(variables.Range) or (arrayLen(variables.Keyword) and structCount(variables.KeywordColumn))>
					<cfif not arguments.SuppressWhere>
						WHERE
					<cfelse>
						AND
					</cfif>
					<cfset LC = 0 />
					<cfloop collection="#variables.Filter#" item="I">
						<cfset LC = LC + 1 />
						(
						<cfset LLC = 0 />
				  		<cfloop list="#variables.Filter[I]#" delimiters="^" index="II">
				  			<cfset LLC = LLC+1 />
							<cfset ColumnName = I />
							<cfset ColumnValue = II />
							#UCASE(ColumnName)# = <cfif isNumeric(ColumnValue)>#ColumnValue#<cfelse>'#UCASE(ColumnValue)#'</cfif><cfif ListLen(#variables.Filter[I]#,"^") gt LLC> or </cfif>
						</cfloop>
						) <cfif structCount(Filter) gt LC> AND </cfif>
					</cfloop>
					
					<cfif structCount(variables.Filter) and structCount(variables.Range)> AND </cfif>
					
					<cfset LC = 0 />
					<cfloop collection="#variables.Range#" item="I">
						<cfset LC = LC + 1 />
						<cfset RangeValue = variables.instance.Range[#I#] />
						<cfset LLC= 1>
						<cfloop list="#RangeValue#" delimiters="^" index="II">
							<cfif LLC>
								<cfset LLC=0>
								#ThisRange# > <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#II#"> AND			
							<cfelse>
								#ThisRange# < <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#II#">	
							</cfif>
					  	</cfloop>
						<cfif structCount(variables.instance.range) gt CollectionLoop> AND </cfif>
					</cfloop>
					
					<cfif (structCount(variables.Filter) or structCount(variables.Range)) and arrayLen(variables.keyword) and structCount(variables.KeywordColumn)> AND </cfif>
					
					<cfif arrayLen(variables.Keyword) and structCount(variables.KeywordColumn)>
						(
						<cfset LC = 0 />
						<cfloop collection="#variables.KeywordColumn#" item="I">
							<cfset LC = LC + 1 />
							<cfset LLC = 0 />
							<cfloop array="#variables.Keyword#" index="II">
								<cfset LLC = LLC+1 />
								#UCASE(I)# LIKE '%#UCASE(II)#%' <cfif arrayLen(variables.Keyword) gt LLC> OR </cfif>
							</cfloop>
							<cfif structCount(variables.KeywordColumn) gt LC> OR </cfif>
						</cfloop>
						)
					</cfif>
				</cfif>
				
				<cfif structCount(variables.Order)>
					ORDER BY
					<cfset LC = 0 />
					<cfloop collection="#variables.Order#" item="I">
						<cfset LC = LC+1 />
						<cfset OrderValue = variables.Order[#I#] />
						#I# #OrderValue# <cfif structCount(variables.Order) gt LC>, </cfif>
					</cfloop>
				</cfif>
				
			</cfoutput>
		</cfsavecontent>

		<cfreturn WhereReturn />
	</cffunction>
	
	<cffunction name="getHQLWhere">
		<cfargument name="SuppressWhere" type="boolean" default="false" />
		<cfargument name="EntityName" />
		
		<cfset var WhereReturn = "" />
		<cfset var I = "" />
		<cfset var II = "" />
		<cfset var LC = 0 />
		<cfset var LLC = 0 />
		<cfset var ColumnName = "" />
		<cfset var ColumnValue = "" />
		
		<cfsavecontent variable="WhereReturn">
			<cfoutput>
				<cfif structCount(variables.Filter) or structCount(variables.Range) or (arrayLen(variables.Keyword) and structCount(variables.KeywordColumn))>
					<cfif not arguments.SuppressWhere>
						WHERE
					<cfelse>
						AND
					</cfif>
					<cfset LC = 0 />
					<cfloop collection="#variables.Filter#" item="I">
						<cfset LC = LC + 1 />
						(
						<cfset LLC = 0 />
				  		<cfloop list="#variables.Filter[I]#" delimiters="^" index="II">
				  			<cfset LLC = LLC+1 />
							<cfset ColumnName = I />
							<cfset ColumnValue = II />
							#arguments.EntityName#.#UCASE(Replace(ColumnName,"_",".","all"))# = <cfif isNumeric(ColumnValue)>#ColumnValue#<cfelse>'#UCASE(ColumnValue)#'</cfif><cfif ListLen(#variables.Filter[I]#,"^") gt LLC> or </cfif>
						</cfloop>
						) <cfif structCount(Filter) gt LC> AND </cfif>
					</cfloop>
					
					<cfif structCount(variables.Filter) and structCount(variables.Range)> AND </cfif>
					
					<cfset LC = 0 />
					<cfloop collection="#variables.Range#" item="I">
						<cfset LC = LC + 1 />
						<cfset RangeValue = variables.instance.Range[#I#] />
						<cfset LLC= 1>
						<cfloop list="#RangeValue#" delimiters="^" index="II">
							<cfif LLC>
								<cfset LLC=0>
								#arguments.EntityName#.#ThisRange# > <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#II#"> AND			
							<cfelse>
								#arguments.EntityName#.#ThisRange# < <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#II#">	
							</cfif>
					  	</cfloop>
						<cfif structCount(variables.instance.range) gt CollectionLoop> AND </cfif>
					</cfloop>
					
					<cfif (structCount(variables.Filter) or structCount(variables.Range)) and arrayLen(variables.keyword) and structCount(variables.KeywordColumn)> AND </cfif>
					
					<cfif arrayLen(variables.Keyword) and structCount(variables.KeywordColumn)>
						(
						<cfset LC = 0 />
						<cfloop collection="#variables.KeywordColumn#" item="I">
							<cfset LC = LC + 1 />
							<cfset LLC = 0 />
							<cfloop array="#variables.Keyword#" index="II">
								<cfset LLC = LLC+1 />
								#arguments.EntityName#.#UCASE(I)# LIKE '%#UCASE(II)#%' <cfif arrayLen(variables.Keyword) gt LLC> OR </cfif>
							</cfloop>
							<cfif structCount(variables.KeywordColumn) gt LC> OR </cfif>
						</cfloop>
						)
					</cfif>
				</cfif>
				
				<cfif structCount(variables.Order)>
					ORDER BY
					<cfset LC = 0 />
					<cfloop collection="#variables.Order#" item="I">
						<cfset LC = LC+1 />
						<cfset OrderValue = variables.Order[#I#] />
						#I# #OrderValue# <cfif structCount(variables.Order) gt LC>, </cfif>
					</cfloop>
				</cfif>
				
			</cfoutput>
		</cfsavecontent>
				
		<cfreturn WhereReturn />
	</cffunction>
	
	<cffunction name="getHQLParams">
		<cfset HQLParams = structNew() />
		<cfset HQLParmas = getFilter() />
		
		<cfreturn HQLParams />
	</cffunction>
	
	<cffunction name="ApplyQuerySearchScore">
		<cfargument name="QueryRecords" type="Query" />
		
		<cfset var RecordScore = 0 />
		<cfset var ThisKeyword = "" />
		<cfset var FindValue = 0 />
		<cfset var OriginalQuery = arguments.QueryRecords />
		<cfset var ScoredQuery = "" />
		
		<cfset QueryAddColumn(OriginalQuery, "SearchScore", "Integer", arrayNew(1)) />
		<cfset ScoredQuery = queryNew(OriginalQuery.columnlist) />
		

		<cfloop query="OriginalQuery">
			<cfset RecordScore = 0 />
			
			<cfloop collection="#variables.KeywordColumn#" item="II">
				<cfloop array="#variables.Keyword#" index="ThisKeyword">
					<cfset FindValue = FindNoCase(ThisKeyword,evaluate('OriginalQuery.#II#'),0) />
					<cfloop condition="#FindValue# gt 0">
						<cfif FindValue gt 0>
							<cfset RecordScore = RecordScore + variables.KeywordColumn[II] />
							<cfset FindValue = FindNoCase(ThisKeyword,evaluate('OriginalQuery.#II#'),FindValue+1) />
						</cfif>
					</cfloop>
				</cfloop>
			</cfloop>
				
			<cfset QuerySetCell(OriginalQuery, 'SearchScore', '#RecordScore#', #OriginalQuery.currentRow#) />
		</cfloop>
			
		<!--- Reorder based on search score --->
		<cfquery dbtype="query" name="ScoredQuery">
			Select
				*
			From
				OriginalQuery
			Where
				OriginalQuery.SearchScore > 0
			Order By
				OriginalQuery.SearchScore Desc
		</cfquery>
		
		<cfreturn ScoredQuery />
	</cffunction>
	
	<cffunction name="ApplyEntitySearchScore">
		<cfargument name="EntityRecords" type="array" />
		
		<cfreturn arguments.EntityRecords />
	</cffunction>
	
	<cffunction name="setQueryRecords">
		<cfargument name="QueryRecords" type="query" />
		
		<cfif arrayLen(variables.Keyword)>
			<cfset variables.QueryRecords = ApplyQuerySearchScore(Duplicate(arguments.QueryRecords)) />
		<cfelse>
			<cfset variables.QueryRecords = Duplicate(arguments.QueryRecords) />
		</cfif>
	</cffunction>
	
	<cffunction name="setEntityRecords">
		<cfargument name="EntityRecords" type="array" required />
		<cfif arrayLen(variables.Keyword)>
			<cfset variables.EntityRecords = ApplyEntitySearchScore(arguments.EntityRecords) />
		<cfelse>
			<cfset variables.EntityRecords = arguments.EntityRecords />
		</cfif>
	</cffunction>
	
	<cffunction name="getEntityArray">
		<cfset var Entity = "" />
		<cfset var CurrentRow = 1 />
		
		<cfif not arrayLen(variables.EntityArray)>
			<cfif arrayLen(variables.EntityRecords)>
				<cfloop from="#getEntityStart()#" to="#getEntityEnd()#" index="CurrentRow">
					<cfset arrayAppend(variables.EntityArray, variables.EntityRecords[CurrentRow]) />
				</cfloop>
			<cfelseif variables.QueryRecords.recordcount>
				<cfset CurrentRow = #getEntityStart()# />
				<cfloop query="variables.QueryRecords" startrow="#getEntityStart()#" endrow="#getEntityEnd()#">
					<cfset Entity = EntityNew('#getEntityName()#') />
					<cfset Entity.Set(queryRowToStruct(variables.QueryRecords, CurrentRow)) />
					<cfset arrayAppend(variables.EntityArray, Entity) />
					<cfset CurrentRow = CurrentRow + 1 />
				</cfloop>
			</cfif>
		</cfif>
		
		<cfreturn variables.EntityArray />
	</cffunction>
	
	<cffunction name="queryRowToStruct" access="public" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			var row = 1;
			var ii = 1;
			var cols = listToArray(qry.columnList);
			var stReturn = structnew();
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			return stReturn;
		</cfscript>
	</cffunction>	
</cfcomponent>
