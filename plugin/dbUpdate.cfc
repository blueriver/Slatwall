<cfcomponent output="false" name="dbUpdate" hint="">

	<cfset variables.instance.ChangeLog = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="Any" output="false">
		<cfargument name="ConfigDirectory" required="true" />
		<cfargument name="RemoveTables" default="0" />
		
		<!--- List XML Directories --->
		<cfset var newIndex = 0 />
		<cfset var newIndexTwo = 0 />
		<cfset var SchemeDirectoryQuery = "" />
		<cfset var SchemeDirectoryPath = "#arguments.ConfigDirectory#\DBScheme" />
		<cfset var DataDirectoryQuery = "" />
		<cfset var DataDirectoryPath = "#arguments.ConfigDirectory#\DBData" />
		
		<cfset var XmlFile = "" />
		<cfset var ColumnsArray = arraynew(1) />
		<cfset var ColumnStruct = structnew() />
		
		<cfset var DataKeysQuery = querynew('DataKey') />
		<cfset var DataRowsQuery = querynew('empty') />
		
		<cftry>
			<cfdirectory action="list" directory="#SchemeDirectoryPath#" listinfo="all" name="SchemeDirectoryQuery" />
			<cfdirectory action="list" directory="#DataDirectoryPath#" listinfo="all" name="DataDirectoryQuery" />
			
			<cfloop query="SchemeDirectoryQuery">	<!--- Loop Over Each Scheme File --->
				<cfset XmlFile=XMLParse("#SchemeDirectoryQuery.Directory#\#SchemeDirectoryQuery.name#")>
				
				<cfif arguments.RemoveTables>
					<cfset DropTable(TableName=XmlFile.DataTable.TableName.XmlText) />
				<cfelse>
					<cfset ColumnsArray = arraynew(1) />
					<cfloop from="1" to="#arrayLen(XmlFile.DataTable.Columns.XmlChildren)#" index="newIndex">
						<cfset ColumnStruct = structnew() />
						<cfset ColumnStruct.Name = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.name />
						<cfset ColumnStruct.DataType = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.DataType />
						<cfset ColumnStruct.DataLength = "" />
						<cfset ColumnStruct.IsIdentity = False />
						<cfset ColumnStruct.IdentitySeed = 1 />
						<cfset ColumnStruct.IdentityIncrement = 1 />
						<cfset ColumnStruct.NullOK = "YES" />
						
						<cfif structKeyExists(XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes, "DataLength")>
							<cfif XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.DataLength eq "max">
								<cfset ColumnStruct.DataLength = "-1" />
							<cfelse>
								<cfset ColumnStruct.DataLength = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.DataLength />
							</cfif>
						</cfif>
						<cfif structKeyExists(XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes, "IsIdentity")>
							<cfset ColumnStruct.IsIdentity = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.IsIdentity />
						</cfif>
						<cfif structKeyExists(XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes, "IdentitySeed")>
							<cfset ColumnStruct.IdentitySeed = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.IdentitySeed />
						</cfif>
						<cfif structKeyExists(XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes, "IdentityIncrement")>
							<cfset ColumnStruct.IdentityIncrement = XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.IdentityIncrement />
						</cfif>
						<cfif structKeyExists(XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes, "NullOK")>
							<cfif XmlFile.DataTable.Columns.XmlChildren[newIndex].XmlAttributes.NullOK>
								<cfset ColumnStruct.NullOK = "YES" />
							<cfelse>
								<cfset ColumnStruct.NullOK = "NO" />
							</cfif>
						</cfif>
						
						<cfset ArrayAppend(ColumnsArray, ColumnStruct) />
						
					</cfloop>
					
					<cfset VUTableScheme(TableName=XmlFile.DataTable.TableName.XmlText,Columns=ColumnsArray) />
				</cfif>
			</cfloop>
			
			<cfif not arguments.RemoveTables>
				<cfloop query="DataDirectoryQuery">	<!--- Loop Over Each Data File --->
				
					<cfset DataKeysQuery = querynew('DataKey') />
					<cfset DataRowsQuery = querynew('empty') />
				
					<cfset XmlFile=XMLParse("#DataDirectoryQuery.Directory#\#DataDirectoryQuery.name#")>
					
					<cfset queryAddRow(DataKeysQuery, arrayLen(XmlFile.TableData.Keys.XmlChildren)) />
					<cfloop from="1" to="#arrayLen(XmlFile.TableData.Keys.XmlChildren)#" index="newIndex">
						<cfset querySetCell(DataKeysQuery, "DataKey", XmlFile.TableData.Keys.XmlChildren[newIndex].XmlText, newIndex) />
					</cfloop>
					
					<cfloop from="1" to="#arrayLen(XmlFile.TableData.Rows.XmlChildren)#" index="newIndex">
						<cfset AddLog("Verify Record: #XmlFile.TableData.TableName.XmlText#") />
						<cfset AURecord(TableName=XmlFile.TableData.TableName.XmlText,KeysQuery=DataKeysQuery,RecordStruct=XmlFile.TableData.Rows.XmlChildren[newIndex].XmlAttributes) />
					</cfloop>
					
				</cfloop>
			</cfif>
			
			<cfcatch>
				<cfset AddLog("Error: #cfcatch.message#") />
				<cfdump var="#variables.instance.ChangeLog#" />
				<cfdump var="#cfcatch#" /><cfabort />
			</cfcatch>
		</cftry>
		
		<cfreturn getLog() />
	</cffunction>
	
	<cffunction name="VUTableScheme" access="private" returntype="any" output="false" >
		<cfargument name="TableName" type="string" required="true" />
		<cfargument name="Columns" type="Array" required="true" />
		
		<cfset var rs = querynew('empty') />
		<cfset var rsAfter = querynew('empty') />
		<cfset var newIndex = 0 />
		<cfset var ThisColumn = structNew() />
		<cfset var DBColumnExists = 0 />
		<cfset var XMLColumnExists = 0 />
		
		<cfset AddLog("Table Scheme Verification Start: #arguments.TableName#") />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				INFORMATION_SCHEMA.TABLES
			  LEFT JOIN
				INFORMATION_SCHEMA.COLUMNS on INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME
			WHERE
				INFORMATION_SCHEMA.TABLES.TABLE_NAME = <cfqueryparam cfsqltype="varchar(50)" value="#arguments.TableName#" />
		</cfquery>
		
		<cfif rs.recordcount eq 0>		<!--- IF Table Doesn't Exist then Create IT --->
			<cfset AddLog("Add Table: #arguments.TableName#") />
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				CREATE TABLE #arguments.TableName#(
					<cfloop from="1" to="#arrayLen(arguments.Columns)#" index="newIndex">
						#Arguments.Columns[newIndex].Name# #Arguments.Columns[newIndex].DataType#<cfif Arguments.Columns[newIndex].DataLength eq '-1'>(max)<cfelseif Arguments.Columns[newIndex].DataLength neq ''>(#Arguments.Columns[newIndex].DataLength#)</cfif> <cfif Arguments.Columns[newIndex].NullOK eq 'YES'>NULL<cfelse>NOT NULL</cfif><cfif Arguments.Columns[newIndex].IsIdentity> IDENTITY (#Arguments.Columns[newIndex].IdentitySeed#,#Arguments.Columns[newIndex].IdentityIncrement#)</cfif><cfif newIndex lt arrayLen(arguments.Columns)>,</cfif>
					</cfloop>
				)
			</cfquery>
		<cfelse>						<!--- Otherwise Check Each of the Columns --->
			<cfloop from="1" to="#arrayLen(arguments.Columns)#" index="newIndex">
				<cfset DBColumnExists = 0 />
				<cfset ThisColumn = DUPLICATE(arguments.Columns[newIndex]) />
				<cfloop query="rs">
					<cfif rs.COLUMN_NAME eq ThisColumn.Name>
						<cfset DBColumnExists = 1 />
						<cfif rs.CHARACTER_MAXIMUM_LENGTH neq ThisColumn.DataLength or 
								rs.CHARACTER_OCTET_LENGTH neq ThisColumn.DataLength or
								rs.IS_NULLABLE neq ThisColumn.NullOK or
								rs.DATA_TYPE neq ThisColumn.DataType
								>
							<cfset AddLog("Table Scheme Column Modified: #ThisColumn.Name#") />
							<cfset AADColumn(TableName=Arguments.TableName,Column=ThisColumn,Action="ALTER COLUMN") />
						<cfelse>
							<cfset AddLog("Table Scheme Column OK: #ThisColumn.Name#") />
						</cfif>
					</cfif>
				</cfloop>
				<cfif not DBColumnExists>
					<cfset AddLog("Table Scheme Column Added: #ThisColumn.Name#") />
					<cfset AADColumn(TableName=Arguments.TableName,Column=ThisColumn,Action="ADD") />
				</cfif>
			</cfloop>
			<cfloop query="rs">
				<cfset XMLColumnExists = 0 />
				<cfloop from="1" to="#arrayLen(arguments.Columns)#" index="newIndex">
					<cfset ThisColumn = DUPLICATE(arguments.Columns[newIndex]) />
					<cfif rs.COLUMN_NAME eq ThisColumn.Name>
						<cfset XMLColumnExists = 1 />
					</cfif>
				</cfloop>
				<cfif not XMLColumnExists>
					<cfset DropColumn = StructNew() />
					<cfset DropColumn.Name = #rs.COLUMN_NAME# />
					<cfset AddLog("Table Scheme Column Dropped: #rs.COLUMN_NAME#") />
					<cfset AADColumn(TableName=Arguments.TableName,Column=DropColumn,Action="DROP COLUMN") />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset AddLog("Table Scheme Verification End: #TableName#") />
		
		<cfreturn rsAfter />
	</cffunction>
	
	<cffunction name="DropTable" access="private" returntype="any" output="false" >
		<cfargument name="TableName" type="string" required="true" />
		
		<cfset var rs = querynew('empty') />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			DROP TABLE #arguments.TableName#
		</cfquery>
	</cffunction>
	
	<cffunction name="AADColumn" access="private" returntype="any" output="false">
		<cfargument name="TableName" type="string" />
		<cfargument name="Column" type="struct" />
		<cfargument name="Action" type="string" />
		
		<cfset var SQLCommand = "" />
		<cfset var rs = querynew('empty') />
		
		<cfsavecontent variable="SQLCommand">
			<cfoutput>
				<cfif Action eq "DROP COLUMN">
					ALTER TABLE #Arguments.TableName# DROP COLUMN #Arguments.Column.Name#
				<cfelse>
					ALTER TABLE #Arguments.TableName# #Arguments.Action# #Arguments.Column.Name# #Arguments.Column.DataType#<cfif Arguments.Column.DataLength eq '-1'>(max)<cfelseif Arguments.Column.DataLength neq ''>(#Arguments.Column.DataLength#)</cfif> <cfif Arguments.Column.NullOK eq 'YES'>null<cfelse>NOT NULL</cfif>;
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfset AddLog("Table Scheme Column Modified Detail: #SQLCommand#") />
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			 #SQLCommand#
		</cfquery>
		
		<cfreturn 1 />
	</cffunction>
	
	<cffunction name="AURecord" access="private" returntype="any" output="false">
		<cfargument name="TableName" type="string" />
		<cfargument name="KeysQuery" type="query" />
		<cfargument name="RecordStruct" type="struct" />
		
		<cfset var newIndex = 0 />
		<cfset var LoopCount = 0 />
		<cfset var rs = querynew('empty') />
		
		<!---
		<cfif arguments.TableName eq "tslatcountries">
			<cfdump var="#arguments#" />
			<cfabort />
		</cfif>
		--->
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				*
			FROM
				#arguments.TableName#
			WHERE
				<cfloop query="KeysQuery">
					#arguments.TableName#.#arguments.KeysQuery.DataKey# = <cfqueryparam value="#arguments.RecordStruct[arguments.KeysQuery.DataKey]#">
					<cfif arguments.KeysQuery.CurrentRow lt arguments.KeysQuery.recordcount>and </cfif>
				</cfloop>
		</cfquery>
		
		<cfif rs.recordCount> 
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				UPDATE
					#arguments.TableName#
				SET
					<cfset LoopCount = 0 />
					<cfloop list="#structKeyList(arguments.RecordStruct)#" index="newIndex" delimiters=",">
						<cfset LoopCount = LoopCount + 1 />
						#arguments.TableName#.#newIndex# = <cfqueryparam value="#arguments.RecordStruct[newIndex]#"><cfif LoopCount lt listLen(structKeyList(arguments.RecordStruct))>, </cfif>
					</cfloop>
				WHERE
					<cfloop query="KeysQuery">
						#arguments.TableName#.#arguments.KeysQuery.DataKey# = <cfqueryparam value="#arguments.RecordStruct[arguments.KeysQuery.DataKey]#">
						<cfif arguments.KeysQuery.CurrentRow lt arguments.KeysQuery.recordcount>and </cfif>
					</cfloop>
			</cfquery>
		<cfelse>
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				INSERT INTO
					#arguments.TableName# (
					<cfset LoopCount = 0 />
					<cfloop list="#structKeyList(arguments.RecordStruct)#" index="newIndex" delimiters=",">
						<cfset LoopCount = LoopCount + 1 />
						#newIndex#<cfif LoopCount lt listLen(structKeyList(arguments.RecordStruct))>, </cfif>
					</cfloop>
					)
				VALUES
					(
					<cfset LoopCount = 0 />
					<cfloop list="#structKeyList(arguments.RecordStruct)#" index="newIndex" delimiters=",">
						<cfset LoopCount = LoopCount + 1 />
						<cfqueryparam value="#arguments.RecordStruct[newIndex]#"><cfif LoopCount lt listLen(structKeyList(arguments.RecordStruct))>, </cfif>
					</cfloop>
					)
			</cfquery>
		</cfif>
		
		<cfreturn 1 />
	</cffunction>
	
	<cffunction name="XMLDataToQuery" access="private" returntype="string" output="false">
		
	</cffunction>
	
	<cffunction name="GetDBbyDS" access="public" returntype="string" output="false">
		<cfargument name="ds" type="string" required="Yes">
		<cfset res="">
		<cfif fileexists("#Server.Coldfusion.rootdir#\lib\neo-datasource.xml")>
			<cfset res="YES">
			<CFFILE action="read" file="#Server.Coldfusion.rootdir#\lib\neo-datasource.xml" variable="wds">
			<CFWDDX action="wddx2cfml" input="#wds#" output="resds">
			<CFLOOP collection="#resds[1]#" item="c">
				<cfif c is ARGUMENTS.ds>
					<CFSET curdts=structfind(resds[1],c)>
					<CFSET keystostruct=structkeyarray(curdts)>
					<CFLOOP from="1" to="#ArrayLen(keysToStruct)#" index="i">
						<cfif isstruct(curdts[keysToStruct[i]])>
							<cfset res=curdts[keysToStruct[i]]["database"]>
							<cfreturn res>
						</cfif>
					</CFLOOP>
				</cfif>
			</CFLOOP>
		<cfelse>
			<cfset res="NO">
		</cfif>
		<cfreturn res>
	</cffunction>
	
	<cffunction name="AddLog" access="private" returntype="string" output="false">
		<cfargument name="LogText" type="string" />
		<cfset variables.instance.ChangeLog = "#variables.instance.ChangeLog##Arguments.LogText#<br />" />
	</cffunction>
	<cffunction name="GetLog" access="private" returntype="string" output="false">
		<cfreturn variables.instance.ChangeLog />
	</cffunction>
</cfcomponent>
