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

<cfset local.scriptHasErrors = false />
<!--- Move filename to urltitle for products. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="index" table="SlatwallProduct" name="local.indexes" />
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProduct" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'filename'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProduct">
			UPDATE SlatwallProduct
			SET urlTitle = fileName
		</cfquery>
		<!--- If field updated, then try to remove the fileName field --->
		<cfquery name="getConstraint" dbtype="query">
			SELECT INDEX_NAME 
			FROM indexes
			WHERE COLUMN_NAME = 'filename'
		</cfquery>
		<cfif getConstraint.recordcount>
			<cfquery name="dropConstraint">
				ALTER TABLE SlatwallProduct
				DROP <cfif application.configBean.getDbType() eq "MySQL">INDEX<cfelse>CONSTRAINT</cfif> #getConstraint.INDEX_NAME#
			</cfquery>
		</cfif>
		<cfquery name="dropFileName">
			ALTER TABLE SlatwallProduct
			DROP COLUMN fileName
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move displayTemplate to productDisplayTemplate for products. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProduct" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'displayTemplate'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProduct">
			UPDATE SlatwallProduct
			SET productDisplayTemplate = displayTemplate
		</cfquery>
		<!--- If field updated, then try to remove it --->
		<cfquery name="dropDisplayTemplate">
			ALTER TABLE SlatwallProduct
			DROP COLUMN displayTemplate
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<!--- Move displayTemplate to productDisplayTemplate for productTypes. --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallProductType" name="local.columns" />
	<cfquery name="getColumnInfo" dbtype="query">
		SELECT * 
		FROM columns
		WHERE COLUMN_NAME = 'displayTemplate'
	</cfquery>
	<cfif getColumnInfo.RecordCount>
		<cfquery name="updateProductType">
			UPDATE SlatwallProductType
			SET productDisplayTemplate = displayTemplate
		</cfquery>
		<!--- If field updated, then try to remove it --->
		<cfquery name="dropDisplayTemplate">
			ALTER TABLE SlatwallProductType
			DROP COLUMN displayTemplate
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfquery name="oldProductTemplate">
	SELECT settingValue FROM SlatwallSetting WHERE settingName = 'product_defaultTemplate'
</cfquery>

<cfif oldProductTemplate.recordcount>
	<cfquery name="updateSetting">
		UPDATE SlatwallSetting
		SET settingValue = '#oldProductTemplate.settingValue#'
		WHERE settingName = 'product_productDefaultTemplate'
	</cfquery>
	
	<cfquery name="deleteSetting">
		DELETE SlatwallSetting
		WHERE settingName = 'product_defaultTemplate'
	</cfquery>
</cfif>

<cfif local.scriptHasErrors>
	<cfthrow detail="Part of Script v1_4 had errors when running">
</cfif>
