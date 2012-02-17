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

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="termService" type="any";
	property name="requestCacheService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:term.list");
	}

	// Common functionalty of Add/Edit/View
	public void function detail(required struct rc) {
		param name="rc.termID" default="";
		param name="rc.edit" default="false";
		
		rc.term = getTermService().getTerm(rc.termID,true);	
	}


    public void function create(required struct rc) {
		edit(rc);
    }

	public void function edit(required struct rc) {
		detail(rc);
		getFW().setView("admin:term.detail");
		rc.edit = true;
	}
	
	 
    public void function list(required struct rc) {	
		rc.terms = getTermService().listTerm();
    }

	public void function save(required struct rc) {
		// Populate Term in the rc.
		detail(rc);
		
		rc.term = getTermService().saveTerm(rc.term, rc);
		
		// If the term doesn't have any errors then redirect to detail or list
		if(!rc.term.hasErrors()) {
			getFW().redirect(action="admin:term.list",queryString="message=admin.term.save_success");
		}
		
		// This logic only runs if the entity has errors.  If it was a new entity show the create page, otherwise show the edit page
   		rc.edit = true;
		rc.itemTitle = rc.term.isNew() ? rc.$.Slatwall.rbKey("admin.term.create") : rc.$.Slatwall.rbKey("admin.term.edit") & ": #rc.term.getTermName()#";
   		getFW().setView(action="admin:term.detail");
	}
	
	public void function delete(required struct rc) {
		
		detail(rc);
		
		var deleteOK = getTermService().deleteTerm(rc.term);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.term.delete_success");
		} else {
			rc.message = rbKey("admin.term.delete_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:term.list", preserve="message,messagetype");
	}
	
}
