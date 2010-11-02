<cfcomponent output="false" name="utilityManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSecureCardNumber" access="public" returntype="string" output="false">
		<cfargument name="CardNumber" required="true" />
		<cfargument name="ReplaceWith" default="*" />
		
		<cfset ReturnString = "">
		<cfset DigitsToSecure = round(len(CardNumber)*.75) />
		<cfloop From="1" To="#DigitsToSecure#" Index="I">
			<cfset ReturnString = "#ReturnString##arguments.ReplaceWith#" />
		</cfloop>
		<cfif DigitsToSecure lt 2 or len(arguments.CardNumber) lt 2>
			<cfset ReturnString = "#ReturnString#" />
		<cfelse>
			<cfset ReturnString = "#ReturnString##Right(arguments.CardNumber, len(arguments.CardNumber)-DigitsToSecure)#" />
		</cfif>
		<cfreturn ReturnString />
	</cffunction>
	
	<cffunction name="maxStringLength" access="public" returntype="string">
		<cfargument name="thisString" type="string" required="true">
		<cfargument name="maxLength" type="numeric" required="true">
		
		<cfif len(arguments.thisString) gt arguments.maxLength>
			<cfset arguments.thisString = "#left(arguments.thisString, arguments.maxLength-3)#...">
		</cfif>
		
		<cfreturn arguments.thisString />
	</cffunction>
	
	<cffunction name="getProductCFKOPRLink" access="package" returntype="string" output="false" hint="CFKOPR Stands for Content, Filter, Keyword, Order, Page, Range">
		<cfargument name="CFKOPR" reqired="true" />
		<cfargument name="Column" default="" />
		<cfargument name="Value" default="" />
		
		<cfset var returnLink = "">
		<cfset var InQS = 0>
		<cfset var NewQS = "">
		<cfset var NewPath = "">
		<cfset var I = 0>
		
		<cfif arguments.CFKOPR eq "C">
			<cfset InQS = 1 />
			<cfset NewPath = "#cgi.script_name#/#arguments.Value#/" />
		<cfelse>
			<cfset NewPath = "#cgi.script_name##cgi.path_info#" />
		</cfif>
			
		<cfloop collection="#url#" item="I">
			<cfif I neq "path" and I neq "returnURL">
				<cfif find("P_",I) lt 1>
					<cfif "#arguments.CFKOPR#_#arguments.Column#" eq I or (arguments.CFKOPR eq "O" and find("O_",I))>
						<cfset InQS = 1 />
						<cfset NewQS = "#NewQS##arguments.CFKOPR#_#arguments.Column#=#arguments.value#&">
					<cfelse>
						<cfset NewQS = "#NewQS##I#=#StructFind(url,I)#&">
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfif InQS eq 0>
			<cfset NewQS = "#NewQS##arguments.CFKOPR#_#arguments.Column#=#arguments.value#&">
		</cfif>
		
		<cfif len(NewQS) gt 0>
			<cfset NewQS = Left(NewQS,(len(NewQS)-1)) />
			<cfset returnLink = "#NewPath#?#NewQS#">
		<cfelse>
			<cfset returnLink = "#NewPath#">
		</cfif>
		
		<cfreturn returnLink />
	</cffunction>
	
	<cffunction	name="CSVToQuery" access="public" returntype="query" output="true"	hint="Converts the given CSV string to a query.">
		<cfargument	name="CSV" type="string" required="true" hint="This is the CSV string that will be manipulated." />
		<cfargument	name="Delimiter" type="string" required="false" default=","	hint="This is the delimiter that will separate the fields within the CSV value." />
		<cfargument	name="Qualifier" type="string" required="false"	default="""" hint="This is the qualifier that will wrap around fields that have special characters embeded."/>
		<cfargument	name="FirstRowHeader" type="boolean" required="false" default="true" hint="Set this to false if the first row of your CSV string doesn't containe header info."/>
	
		<cfset var LOCAL = StructNew() />
		<cfset var HIndex = 0 />
	 
		<cfset ARGUMENTS.Delimiter = Left( ARGUMENTS.Delimiter, 1 ) />
	 
	 	<cfif Len( ARGUMENTS.Qualifier )>
	 		<cfset ARGUMENTS.Qualifier = Left( ARGUMENTS.Qualifier, 1 ) />
	 	</cfif>
	 
	 	<cfset LOCAL.LineDelimiter = Chr( 10 ) />
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll("\r?\n", LOCAL.LineDelimiter) />
	 	<cfset LOCAL.Delimiters = ARGUMENTS.CSV.ReplaceAll("[^\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]+","").ToCharArray()	/>
		<cfset ARGUMENTS.CSV = (" " & ARGUMENTS.CSV) />
		<cfset ARGUMENTS.CSV = ARGUMENTS.CSV.ReplaceAll("([\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1})","$1 ") />
		<cfset LOCAL.Tokens = ARGUMENTS.CSV.Split("[\#ARGUMENTS.Delimiter#\#LOCAL.LineDelimiter#]{1}") />
		<cfset LOCAL.Rows = ArrayNew( 1 ) />
	 
		<cfset ArrayAppend(LOCAL.Rows,ArrayNew(1)) />
	 
		<cfset LOCAL.RowIndex = 1 />
	 	<cfset LOCAL.IsInValue = false />
	 
		<cfloop	index="LOCAL.TokenIndex" from="1" to="#ArrayLen( LOCAL.Tokens )#" step="1">
	 		<cfset LOCAL.FieldIndex = ArrayLen(LOCAL.Rows[ LOCAL.RowIndex ]) />
	 		<cfset LOCAL.Token = LOCAL.Tokens[ LOCAL.TokenIndex ].ReplaceFirst("^.{1}","") />
	 		<cfif Len( ARGUMENTS.Qualifier )>
	 			<cfif LOCAL.IsInValue>
					<cfset LOCAL.Token = LOCAL.Token.ReplaceAll("\#ARGUMENTS.Qualifier#{2}","{QUALIFIER}") />
					<cfset LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = (LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] & LOCAL.Delimiters[ LOCAL.TokenIndex - 1 ] & LOCAL.Token) />
					<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 					<cfset LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ] = LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ].ReplaceFirst( ".{1}$", "" ) />
	 					<cfset LOCAL.IsInValue = false />
	 				</cfif>
	 			<cfelse>
	 				<cfif (Left( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 					<cfset LOCAL.Token = LOCAL.Token.ReplaceFirst("^.{1}","") />
	 					<cfset LOCAL.Token = LOCAL.Token.ReplaceAll("\#ARGUMENTS.Qualifier#{2}","{QUALIFIER}") />
	 					<cfif (Right( LOCAL.Token, 1 ) EQ ARGUMENTS.Qualifier)>
	 						<cfset ArrayAppend(LOCAL.Rows[ LOCAL.RowIndex ],LOCAL.Token.ReplaceFirst(".{1}$","")) />
	 					<cfelse>
							<cfset LOCAL.IsInValue = true />
							<cfset ArrayAppend(LOCAL.Rows[ LOCAL.RowIndex ],LOCAL.Token) />
	 					</cfif>
	 				<cfelse>
	 					<cfset ArrayAppend(LOCAL.Rows[ LOCAL.RowIndex ],LOCAL.Token) />
	 				</cfif>
	 			</cfif>
				<cfset LOCAL.Rows[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] ) ] = Replace(
					LOCAL.Rows[ LOCAL.RowIndex ][ ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] ) ],
					"{QUALIFIER}",
					ARGUMENTS.Qualifier,
					"ALL"
					) />
	 		<cfelse>
	 			<cfset ArrayAppend(
					LOCAL.Rows[ LOCAL.RowIndex ],
					LOCAL.Token
					) />
	 		</cfif>
	
			<cfif ((NOT LOCAL.IsInValue) AND (LOCAL.TokenIndex LT ArrayLen( LOCAL.Tokens )) AND (LOCAL.Delimiters[ LOCAL.TokenIndex ] EQ LOCAL.LineDelimiter))>
				<cfset ArrayAppend(LOCAL.Rows,ArrayNew( 1 )) />
	 			<cfset LOCAL.RowIndex = (LOCAL.RowIndex + 1) />
	 		</cfif>
	 	</cfloop>
	 
		<cfset LOCAL.MaxFieldCount = 0 />
		<cfset LOCAL.EmptyArray = ArrayNew( 1 ) />
		
		<cfloop	index="LOCAL.RowIndex" from="1" to="#ArrayLen( LOCAL.Rows )#" step="1">
	 		<cfset LOCAL.MaxFieldCount = Max(LOCAL.MaxFieldCount,ArrayLen(LOCAL.Rows[ LOCAL.RowIndex ])) />
	 		<cfset ArrayAppend(LOCAL.EmptyArray,"") />
	 	</cfloop>
		
		<cfif FirstRowHeader>
			<cfset HIndex = 0 />
			<cfloop from="1" to="#arrayLen(LOCAL.Rows[1])#" index="HIndex">
				<cfset LOCAL.Rows[1][HIndex] = Replace(LOCAL.Rows[1][HIndex],"-","","all") />
			</cfloop>
						
			<cfset LOCAL.RowHeader = LOCAL.Rows[1] />
			<cfset ArrayDeleteAt(LOCAL.EmptyArray, ArrayLen(LOCAL.EmptyArray)) />
			<cfset ArrayDeleteAt(LOCAL.Rows, 1) />
		</cfif>
		
		<cfset LOCAL.Query = QueryNew('') />
	 
	 	<cfloop	index="LOCAL.FieldIndex" from="1" to="#LOCAL.MaxFieldCount#" step="1">
	 		<cfset QueryAddColumn(LOCAL.Query,"COLUMN_#LOCAL.FieldIndex#","CF_SQL_VARCHAR",LOCAL.EmptyArray) />
	 	</cfloop>
	 	<cfloop index="LOCAL.RowIndex" from="1" to="#ArrayLen( LOCAL.Rows )#" step="1"> 
			<cfloop	index="LOCAL.FieldIndex" from="1" to="#ArrayLen( LOCAL.Rows[ LOCAL.RowIndex ] )#" step="1">
	 			<cfset LOCAL.Query[ "COLUMN_#LOCAL.FieldIndex#" ][ LOCAL.RowIndex ] = JavaCast("string",LOCAL.Rows[ LOCAL.RowIndex ][ LOCAL.FieldIndex ]) />
	 		</cfloop>
		</cfloop>
		
		<cfif FirstRowHeader>
			<cfset Local.Query.setColumnNames(LOCAL.RowHeader) />
		</cfif>
	
		<cfreturn LOCAL.Query />
	</cffunction>
	
	<cffunction name="getQueryOrganizerFromCollection" access="public" returntype="Any" output="false">
		<cfargument name="Collection" type="struct" />
		
		<cfset queryOrganizer = getNewQueryOrganizer() />
		<cfset queryOrganizer.setFromCollection(Collection=arguments.Collection) />
		<cfreturn queryOrganizer />
	</cffunction> 
	
	<cffunction name="getNewQueryOrganizer" access="public" returntype="Any" output="false">
		<cfset queryOrganizer = createObject("component","queryOrganizer").init() />
		<cfreturn queryOrganizer />
	</cffunction>
	
	<cffunction name="getNewPager" access="public" returntype="Any" output="false">
		<cfreturn createObject("component","pager").init() />
	</cffunction>
	
</cfcomponent>