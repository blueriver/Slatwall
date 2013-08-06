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
component extends="Slatwall.org.Hibachi.HibachiController" {

	this.secureMethods="default,syncpush,syncpull,syncall";

	public void function syncPush() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();

		var responseBean = syncUtility.syncPush();
		
		if( !responseBean.hasErrors() ) {
			showMessage("Pushing endicia update files executed sucessfully!", "success");
		} else {
			responseBean.showErrorMessages();
		}
			
		getFW().setView("endicia:main.default");
	}
	
	public void function syncPull() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();
		
		var responseBean = syncUtility.syncPull();
		
		if( !responseBean.hasErrors() ) {
			showMessage("Pulling endicia update files executed sucessfully!", "success");
		} else {
			responseBean.showErrorMessages();
		}
		
		getFW().setView("endicia:main.default");
	}
	
	public void function syncAll() {
		
		var syncUtility = new Slatwall.integrationServices.endicia.model.SyncUtility();
		
		var pullResult = syncUtility.syncPull();
		
		if( !pullResult.hasErrors() ) {
			showMessage("Pulling endicia update files executed sucessfully!", "success");
			
			var pushResult = syncUtility.syncPush();
			
			if( !pushResult.hasErrors() ) {
				showMessage("Pulling endicia update files executed sucessfully!", "success");
			} else {
				pushResult.showErrorMessages();
			}
		
		} else {
			pullResult.showErrorMessages();
		}
		
		getFW().setView("endicia:main.default");
	}
	
	
	
}