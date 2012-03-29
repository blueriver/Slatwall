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
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.allSettings" type="struct" />
<cfparam name="rc.productTemplateOptions" type="any" />
<cfparam name="rc.shippingWeightUnitCodeOptions" type="any" />
<cfparam name="rc.customIntegrations" type="array" />

<cfsilent>
	<cfset local.yesNoValueOptions = [{name=$.slatwall.rbKey('define.yes'), value=1},{name=$.slatwall.rbKey('define.no'), value=0}] />
	<cfset local.localeOptions = ['Chinese (China)','Chinese (Hong Kong)','Chinese (Taiwan)','Dutch (Belgian)','Dutch (Standard)','English (Australian)','English (Canadian)','English (New Zealand)','English (UK)','English (US)','French (Belgian)','French (Canadian)','French (Standard)','French (Swiss)','German (Austrian)','German (Standard)','German (Swiss)','Italian (Standard)',
									'Italian (Swiss)','Japanese','Korean','Norwegian (Bokmal)','Norwegian (Nynorsk)','Portuguese (Brazilian)','Portuguese (Standard)','Spanish (Mexican)','Spanish (Modern)','Spanish (Standard)','Swedish'] />
</cfsilent>

<cfoutput>
	<cfif rc.edit>
		<form action="#buildURL(action='admin:setting.savesetting')#" method="post">
	</cfif>
	
		<div class="actionnav well well-small">
			<div class="row-fluid">
				<div class="span4"><h1>#replace(rc.$.Slatwall.rbKey('admin.define.detail'), "${itemEntityName}", rc.$.Slatwall.rbKey('entity.setting'))#</h1></div>
				<div class="span8">
					<div class="btn-toolbar">
						<div class="btn-group">
							<cfif rc.edit>
							<a href="#buildURL(action='admin:setting.detailsetting')#" class="btn btn-inverse">Cancel</a>
							<button class="btn btn-success" type="submit">Save</button>
							<cfelse>
								<a href="#buildURL(action='admin:setting.editsetting')#" class="btn btn-primary">Edit</a>
							</cfif>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<cf_SlatwallTabGroup>
			<cf_SlatwallTab view="admin:setting/settingtabs/general" />
			<cf_SlatwallTab view="admin:setting/settingtabs/order" />
			<cf_SlatwallTab view="admin:setting/settingtabs/advanced" />
		</cf_SlatwallTabGroup>
		
	<cfif rc.edit>
		</form>
	</cfif>
</cfoutput>