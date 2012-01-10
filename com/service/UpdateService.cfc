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
<cfcomponent extends="BaseService" accessors="true">
	<cfproperty name="utilityFileService" type="any" />
	
	<cffunction name="update">
		<cfargument name="branch" type="string" default="master">
		
		<!--- this could take a while... --->
		<cfsetting requesttimeout="600" />
		
		<cfset var downloadURL = {} />
		<cfset downloadURL["master"] = "https://github.com/ten24/Slatwall/zipball/master" />	
		<cfset downloadURL["develop"] = "https://github.com/ten24/Slatwall/zipball/develop" />
		<cfset var slatwallRootPath = getSlatwallRootDirectory() />
		<cfset var downloadFileName = "slatwall.zip" />
		
		<!--- before we do anything, make a backup --->
		<!---<cfzip action="zip" file="#pluginRootPath#/slatwall_bak.zip" source="#slatwallRootPath#" recurse="yes" overwrite="yes" />--->
		
		<!--- start download --->
		<cfhttp url="#downloadURL[arguments.branch]#" method="get" path="#getTempDirectory()#" file="#downloadFileName#" />
		
		<!--- now read and unzip the downloaded file --->
		<cfset var dirList = "" />
		<cfzip action="unzip" destination="#getTempDirectory()#" file="#getTempDirectory()##downloadFileName#" >
		<cfzip action="list" file="#getTempDirectory()##downloadFileName#" name="dirList" >
		<cfset var sourcePath = getTempDirectory() & "#listFirst(dirList.name[1],'/')#" />
		<cfset getUtilityFileService().duplicateDirectory(source=sourcePath, destination=getSlatwallRootDirectory(), overwrite=true, recurse=true, copyContentExclusionList=".svn,.gitignore", deleteDestinationContent=true, deleteDestinationContentExclusionList="integrationServices" ) />
		
	</cffunction>
	
	<cffunction name="runScripts">
		<!--- TODO: Impliment Me! --->
	</cffunction>
</cfcomponent>
