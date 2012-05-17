/*

    Slatwall - An Open Source eCommerce Platform
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

*/
component extends="BaseService" output="false" {

	public any function init() {
		variables.permissions = '';
		
		return super.init();
	}
	
	// Uses the current mura user to check security against a given action
	public boolean function secureDisplay(required string action) {
		return true;
	}
	
	public struct function getPermissions(){
		var stPermissions={};
		var i = 1;
		var dirList = directoryList( expandPath("/plugins/Slatwall/admin/controllers") );

		if(!isStruct(variables.permissions)){		
			for(i=1; i <= arrayLen(dirList); i++){
				obj = createObject('component',replace(replace(replace(replace(dirList[i],getSlatwallRootDirectory(),''),'/','.','all' ),'.cfc',''),'.',''));
				
				if(StructKeyExists(obj,'secureMethods')){
					
					methods=obj.secureMethods;
					
					for(j=1; j <= listLen(methods); j++){
						section = replace(listgetat(dirList[i],listLen(dirList[i],'/'),'/'),'.cfc','');
						
						if(!StructKeyExists(stPermissions,section)){
							stPermissions[section] = [];
						}
						
						arrayAppend(stPermissions[section],rbKey('permission.' & section & '.' & listgetat(methods,j)));
					}	
					
					ArraySort(stPermissions[section],"textnocase" );	
				}
			}
			
			variables.permissions = stPermissions;
		}
		return variables.permissions;
	}
	
	public function getPublicMethods(required string subsystem, required string controller){
		if(arguments.subsystem == "admin" || arguments.subsystem == "frontend") {
			var obj = createObject('component', 'Slatwall.' & arguments.subsystem & '.controllers.' & arguments.controller);
		} else {
			var obj = createObject('component', 'Slatwall.integrationServices.' & arguments.subsystem & '.controllers.' & arguments.controller);	
		}
		
		var stResponse = {};
		
		if(structKeyExists(obj,'publicMethods')){
			for(i=1; i <= listLen(obj.publicMethods); i++){
				stResponse[listgetat(obj.publicMethods,i)]='';
			}
		}
		
		return structKeyList(stResponse);
	}
	
	public function getSecureMethods(required string subsystem, required string controller){
		var obj = createObject('component', arguments.subsystem & '.controllers.' & arguments.controller);
		var stResponse = {};
		
		if(structKeyExists(obj,'secureMethods')){
			for(i=1; i <= arrayLen(obj.secureMethods); i++){
				stResponse[obj.secureMethods[i]]='';
			}
		}
		return structKeyList(stResponse);
	}
	
	public function setupDefaultPermissions(){
		var accounts = getDAO().getMissingUserAccounts();
		var permissionGroup = get('PermissionGroup',{permissionGroupID='4028808a37037dbf01370ed2001f0074'});
		
		for(i=1; i <= accounts.recordcount; i++){
			account = get('Account',{accountID=accounts.accountID[i]});
			account.addPermissionGroup(permissionGroup);
		}
		getDAO().FlushORMSession();
	}
	
}