/*

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

*/
component output="false" {
	
	public any function init() {
		return this;
	}
	
	public any function read(required string ID, required string entityName) {
		return entityLoad(arguments.entityName, arguments.ID, true);
	}
	
	public any function readByFilename(required string filename, required string entityName){
		return ormExecuteQuery(" from #arguments.entityName# where filename = :filename", {filename=arguments.filename}, true);
	}
	
	public array function list(required string entityName,struct filterCriteria=structNew(),string sortBy="") {
		if(structIsEmpty(arguments.filterCriteria) and !len("arguments.sortby")) {
			return entityLoad(arguments.entityName);
		} else {
			return entityLoad(arguments.entityName,arguments.filterCriteria,arguments.sortby);
		}
	}
	
	public any function getSmartList(required struct rc, required string entityName){
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName);
	
		return smartList;
	}
	
	public void function delete(required any entity) {
		EntityDelete(arguments.entity);
	}
	
	public any function save(required any entity) {
		EntitySave(arguments.entity);
		return arguments.entity;
	}
}
