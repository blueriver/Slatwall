<cfcomponent output="false" name="queryOrganizer" hint="">

	<cfset variables.instance.Filter = structNew() />
	<cfset variables.instance.Range = structNew() />
	<cfset variables.instance.Order = structNew() />
	<cfset variables.instance.KeywordWeight = structNew() />
	<cfset variables.instance.Keyword = "" />

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFilter" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Filter />
    </cffunction>
    <cffunction name="setFilter" access="public" output="false" hint="">
    	<cfargument name="Filter" type="struct" required="true" />
    	<cfset variables.instance.Filter = trim(arguments.Filter) />
    </cffunction>
	<cffunction name="addFilter" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		<cfif isDefined('variables.instance.Filter.#arguments.Column#')>
			<cfset 'variables.instance.Filter.#arguments.Column#' = '#structFind(variables.instance.Filter, arguments.Column)#^#arguments.Value#' />
		<cfelse>
			<cfset 'variables.instance.Filter.#arguments.Column#' = arguments.Value />
		</cfif>
    </cffunction>
    
	<cffunction name="getRange" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Range />
    </cffunction>
    <cffunction name="setRange" access="public" output="false" hint="">
    	<cfargument name="Range" type="struct" required="true" />
    	<cfset variables.instance.Range = trim(arguments.Range) />
    </cffunction>
	<cffunction name="addRange" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		<cfif isDefined('variables.instance.Range.#arguments.Column#')>
			<cfset 'variables.instance.Range.#arguments.Column#' = '#structFind(variables.instance.Range, arguments.Column)#^#arguments.Value#' />
		<cfelse>
			<cfset 'variables.instance.Range.#arguments.Column#' = arguments.Value />
		</cfif>
    </cffunction>
	
	<cffunction name="getOrder" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.Order />
    </cffunction>
    <cffunction name="setOrder" access="public" output="false" hint="">
    	<cfargument name="Order" type="struct" required="true" />
    	<cfset variables.instance.Order = trim(arguments.Order) />
    </cffunction>
	<cffunction name="addOrder" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" required="true" />
		<cfif arguments.Value eq "A">
			<cfset arguments.Value = "ASC" />
		<cfelseif argument.Value eq "D">
			<cfset arguments.Value = "DESC" />
		</cfif>
    	<cfif isDefined('variables.instance.Order.#arguments.Column#')>
			<cfset 'variables.instance.Order.#arguments.Column#' = '#structFind(variables.instance.Order, arguments.Column)#^#arguments.Value#' />
		<cfelse>
			<cfset 'variables.instance.Order.#arguments.Column#' = arguments.Value />
		</cfif>
    </cffunction>
    
	<cffunction name="getKeywordColumn" returntype="struct" access="public" output="false" hint="">
    	<cfreturn variables.instance.KeywordWeight />
    </cffunction>
    <cffunction name="setKeywordColumn" access="public" output="false" hint="">
    	<cfargument name="KeywordWeight" type="struct" required="true" />
    	<cfset variables.instance.KeywordWeight = trim(arguments.KeywordWeight) />
    </cffunction>
	<cffunction name="addKeywordColumn" access="public" output="false" hint="">
    	<cfargument name="Column" type="string" required="true" />
		<cfargument name="Value" type="string" default="1" />
    	<cfset 'variables.instance.KeywordWeight.#arguments.Column#' = arguments.Value />
    </cffunction>
    
    <cffunction name="getKeyword" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Keyword />
    </cffunction>
    <cffunction name="setKeyword" access="public" output="false" hint="">
    	<cfargument name="Keyword" type="string" required="true" />
		<cfset arguments.Keyword = replace(arguments.Keyword," ","^","all") />
		<cfset arguments.Keyword = replace(arguments.Keyword,"+","^","all") />
		<cfset arguments.Keyword = replace(arguments.Keyword,",","^","all") />

    	<cfset variables.instance.Keyword = trim(arguments.Keyword) />
    </cffunction>
    
	<cffunction name="setFromCollection" access="public" output="false">
		<cfargument name="Collection" type="struct" required="true">
		
		<cfset var ValuePair = "" />
		<cfset var OrderDirection = "" />
		
		<cfloop collection="#arguments.Collection#" item="ValuePair">
			<cfif find("F_",ValuePair)>
				<cfset FilterProperty = Replace(ValuePair,"F_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset "variables.instance.Filter.#FilterProperty#" = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("R_",ValuePair)>
				<cfset RangeProperty = Replace(ValuePair,"R_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset "variables.instance.Range.#RangeProperty#" = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
				</cfif>
			</cfif>
			<cfif find("O_",ValuePair)>
				<cfset OrderProperty = Replace(ValuePair,"O_", "") />
				<cfif JavaCast("string", StructFind(arguments.Collection,ValuePair)) neq "">
					<cfset OrderDirection = JavaCast("string", StructFind(arguments.Collection,ValuePair)) />
					<cfif OrderDirection eq "A">
						<cfset OrderDirection = "ASC" />
					<cfelseif OrderDirection eq "D">
						<cfset OrderDirection = "DESC" />
					</cfif>
					<cfset "variables.instance.Order.#OrderProperty#" = #OrderDirection# />
				</cfif>
			</cfif>
		</cfloop>
	
		<cfif isDefined("arguments.Collection.Keyword")>
			<cfset variables.instance.Keyword = Replace(Collection.Keyword," ","^","all") />
			<cfset variables.instance.Keyword = Replace(variables.instance.Keyword,"%20","^","all") />
			<cfset variables.instance.Keyword = Replace(variables.instance.Keyword,"+","^","all") />
		</cfif>
	</cffunction>
	
	<cffunction name="OrganizeQuery" access="public" returntype="Query" output="false">
		<cfargument name="Query" type="query" required="true" />
		
		<cfset var ThisFilter = "" />
		<cfset var FilterValue = "" />
		<cfset var ThisRange = "" />
		<cfset var RangeValue = "" />
		<cfset var ThisOrder = "" />
		<cfset var OrderValue = "" />
		<cfset var CollectionLoop = 0 />
		<cfset var CurrentLoop = 0 />
		<cfset var I = 0 />
		<cfset var RecordScore = 0 />
		<cfset var II = 0 />
		<cfset var FindValue = 0 />
		<cfset var ResetKeywordWeight = 0 />
		<cfset var FilteredQuery = queryNew('empty') />
		<cfset var FilteredScoredQuery = queryNew('empty') />
		<cfset var FinishedQuery = queryNew('empty') />
		
		<cfquery dbtype="query" name="FilteredQuery">
			SELECT
				*,
				.01 as QOKScore
			FROM
				arguments.Query
			<cfif ListLen(structKeyList(variables.instance.Filter)) or ListLen(structKeyList(variables.instance.Range)) or (ListLen(variables.instance.keyword,"^") gt 0 and structCount(variables.instance.KeywordWeight) gt 0)>
				WHERE
				<cfset CollectionLoop = 0 />
				<cfloop collection="#variables.instance.Filter#" item="ThisFilter">
					<cfset CollectionLoop = CollectionLoop + 1 />
					<cfset FilterValue = variables.instance.Filter[#ThisFilter#] />
					(
					<cfset CurrentLoop = 0 />
			  		<cfloop list="#FilterValue#" delimiters="^" index="I">
			  			<cfset CurrentLoop = CurrentLoop+1 />
						<cfif isNumeric(I)>
			  				#ThisFilter# = <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#I#"><cfif ListLen(FilterValue,"^") gt CurrentLoop> or </cfif>
						<cfelse>
							#ThisFilter# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"><cfif ListLen(FilterValue,"^") gt CurrentLoop> or </cfif>
						</cfif>
					</cfloop>
					) <cfif structCount(variables.instance.filter) gt CollectionLoop> AND </cfif>
				</cfloop>
				<cfif ListLen(structKeyList(variables.instance.Filter)) and ListLen(structKeyList(variables.instance.Range))> AND </cfif>
				<cfset CollectionLoop = 0 />
				<cfloop collection="#variables.instance.Range#" item="ThisRange">
					<cfset CollectionLoop = CollectionLoop + 1 />
					<cfset RangeValue = variables.instance.Range[#ThisRange#] />
					<cfset lower= 1>
					<cfloop list="#RangeValue#" delimiters="^" index="i">
						<cfif lower>
							<cfset lower=0>
							#ThisRange# > <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#"> AND			
						<cfelse>
							#ThisRange# < <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#">	
						</cfif>
				  	</cfloop>
					<cfif structCount(variables.instance.range) gt CollectionLoop> AND </cfif>
				</cfloop>
				<cfif (ListLen(structKeyList(variables.instance.Filter)) or ListLen(structKeyList(variables.instance.Range))) and Len(variables.instance.keyword) gt 0 and structCount(variables.instance.KeywordWeight) gt 0> AND </cfif>
				<cfif ListLen(variables.instance.keyword,"^") gt 0 and structCount(variables.instance.KeywordWeight) gt 0>
					(
					<cfset CollectionLoop = 0 />
					<cfloop collection="#variables.instance.KeywordWeight#" item="II">
						<cfset CollectionLoop = CollectionLoop + 1 />
						<cfset CurrentLoop = 0 />
						<cfloop list="#variables.instance.Keyword#" index="I" delimiters="^">
							<cfset CurrentLoop = CurrentLoop+1 />
							#UCASE(II)# LIKE '%#UCASE(I)#%' <cfif ListLen(variables.instance.Keyword,"^") gt CurrentLoop> OR </cfif>
						</cfloop>
						<cfif structCount(variables.instance.KeywordWeight) gt CollectionLoop> OR </cfif>
					</cfloop>
					)
				</cfif>
			</cfif>
			<cfif ListLen(structKeyList(variables.instance.Order))>
				ORDER BY
				<cfset CurrentLoop = 0 />
				<cfloop collection="#variables.instance.Order#" item="ThisOrder">
					<cfset CurrentLoop = CurrentLoop+1 />
					<cfset OrderValue = variables.instance.Order[#ThisOrder#] />
					
					#ThisOrder# #OrderValue# <cfif ListLen(structKeyList(variables.instance.Order)) gt CurrentLoop>, </cfif>
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfif ListLen(variables.instance.Keyword,"^") gt 0 and FilteredQuery.recordcount gt 0 and structCount(variables.instance.KeywordWeight) gt 0>
			
			<!--- Score Each Redcord --->
			<cfloop query="FilteredQuery">
				<cfset RecordScore = 0 />
				
				<cfloop collection="#variables.instance.KeywordWeight#" item="II">
					<cfloop list="#variables.instance.Keyword#" index="I" DELIMITERS="^">
						<cfset FindValue = FindNoCase(I,evaluate('FilteredQuery.#II#'),0) />
						<cfloop condition="#FindValue# gt 0">
							<cfif FindValue gt 0>
								<cfset RecordScore = RecordScore + variables.instance.KeywordWeight[II] />
								<cfset FindValue = FindNoCase(I,evaluate('FilteredQuery.#II#'),FindValue+1) />
							</cfif>
						</cfloop>
					</cfloop>
				</cfloop>
					
				<cfset QuerySetCell(FilteredQuery, 'QOKScore', '#RecordScore#', #FilteredQuery.currentRow#) />
			</cfloop>
			
			<!--- Reorder based on search score --->
			<cfquery dbtype="query" name="FilteredScoredQuery">
				Select
					*
				From
					FilteredQuery
				Where
					FilteredQuery.QOKScore > 0.01
				Order By
					FilteredQuery.QOKScore Desc
			</cfquery>
			
			<cfset FinishedQuery = FilteredScoredQuery />
		<cfelse>
			<cfset FinishedQuery = FilteredQuery />
		</cfif>
		
		<cfreturn FinishedQuery />
	</cffunction>
	
	<cffunction name="getDebug">
		<cfreturn variables />
	</cffunction>
</cfcomponent>
