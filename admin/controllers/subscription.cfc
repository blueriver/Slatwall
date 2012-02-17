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
	property name="subscriptionService" type="any";
	property name="requestCacheService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:subscription.listsubscriptionterms");
	}

	// subscription terms
	
	public void function detailSubscriptionTerm(required struct rc) {
		param name="rc.subscriptionTermID" default="";
		param name="rc.edit" default="false";
		
		rc.subscriptionTerm = getSubscriptionService().getSubscriptionTerm(rc.subscriptionTermID,true);	
	}


    public void function createSubscriptionTerm(required struct rc) {
		editSubscriptionTerm(rc);
    }

	public void function editSubscriptionTerm(required struct rc) {
		detailSubscriptionTerm(rc);
		getFW().setView("admin:subscription.detailsubscriptionterm");
		rc.edit = true;
	}
	
	 
    public void function listSubscriptionTerms(required struct rc) {	
		rc.subscriptionTerms = getSubscriptionService().listSubscriptionTerm();
    }

	public void function saveSubscriptionTerm(required struct rc) {
		// Populate subscription Term in the rc.
		detailSubscriptionTerm(rc);
		
		rc.subscriptionTerm = getSubscriptionService().saveSubscriptionTerm(rc.subscriptionTerm, rc);
		
		// If the term doesn't have any errors then redirect to detail or list
		if(!rc.subscriptionTerm.hasErrors()) {
			getFW().redirect(action="admin:subscription.listsubscriptionterms",queryString="message=admin.subscription.saveSubscriptionTerm_success");
		}
		
		// This logic only runs if the entity has errors.  If it was a new entity show the create page, otherwise show the edit page
   		rc.edit = true;
		rc.itemTitle = rc.subscriptionTerm.isNew() ? rc.$.Slatwall.rbKey("admin.subscription.createSubscriptionTerm") : rc.$.Slatwall.rbKey("admin.subscription.editSubscriptionTerm") & ": #rc.subscriptionTerm.getSubscriptionTermName()#";
   		getFW().setView(action="admin:subscription.detailsubscriptionterm");
	}
	
	public void function deleteSubscriptionTerm(required struct rc) {
		
		detailSubscriptionTerm(rc);
		
		var deleteOK = getSubscriptionService().deleteSubscriptionTerm(rc.subscriptionTerm);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.subscription.deleteSubscriptionTerm_success");
		} else {
			rc.message = rbKey("admin.subscription.deleteSubscriptionTerm_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:subscription.listsubscriptionterms", preserve="message,messagetype");
	}
	
	// subscription benefits
	public void function detailSubscriptionBenefit(required struct rc) {
		param name="rc.subscriptionBenefitID" default="";
		param name="rc.edit" default="false";
		
		rc.subscriptionBenefit = getSubscriptionService().getSubscriptionBenefit(rc.subscriptionBenefitID,true);	
	}


    public void function createSubscriptionBenefit(required struct rc) {
		editSubscriptionBenefit(rc);
    }

	public void function editSubscriptionBenefit(required struct rc) {
		detailSubscriptionBenefit(rc);
		getFW().setView("admin:subscription.detailsubscriptionbenefit");
		rc.edit = true;
	}
	
	 
    public void function listSubscriptionBenefits(required struct rc) {	
		rc.subscriptionBenefits = getSubscriptionService().listSubscriptionBenefit();
    }

	public void function saveSubscriptionBenefit(required struct rc) {
		// Populate subscription Benefit in the rc.
		detailSubscriptionBenefit(rc);
		
		rc.subscriptionBenefit = getSubscriptionService().saveSubscriptionBenefit(rc.subscriptionBenefit, rc);
		
		// If the benefit doesn't have any errors then redirect to detail or list
		if(!rc.subscriptionBenefit.hasErrors()) {
			getFW().redirect(action="admin:subscription.listsubscriptionbenefits",queryString="message=admin.subscription.saveSubscriptionBenefit_success");
		}
		
		// This logic only runs if the entity has errors.  If it was a new entity show the create page, otherwise show the edit page
   		rc.edit = true;
		rc.itemTitle = rc.subscriptionBenefit.isNew() ? rc.$.Slatwall.rbKey("admin.subscription.createSubscriptionBenefit") : rc.$.Slatwall.rbKey("admin.subscription.editSubscriptionBenefit") & ": #rc.subscriptionBenefit.getSubscriptionBenefitName()#";
   		getFW().setView(action="admin:subscription.detailsubscriptionbenefit");
	}
	
	public void function deleteSubscriptionBenefit(required struct rc) {
		
		detailSubscriptionBenefit(rc);
		
		var deleteOK = getSubscriptionService().deleteSubscriptionBenefit(rc.subscriptionBenefit);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.subscription.deleteSubscriptionBenefit_success");
		} else {
			rc.message = rbKey("admin.subscription.deleteSubscriptionBenefit_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:subscription.listsubscriptionbenefits", preserve="message,messagetype");
	}
	
}
