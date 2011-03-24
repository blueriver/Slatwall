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
<cfparam name="rc.Show" default=0 />
<cfparam name="rc.CampaignName" default="" />
<cfparam name="rc.CampaignSource" default="" />
<cfparam name="rc.AdMedium" default="" />
<cfparam name="rc.AdContent" default="" />
<cfparam name="rc.LandingPageContentID" default="" />
<cfparam name="rc.QueryString" default="" />
<cfparam name="rc.SaveCampaign" default=0 />

<cfset rc.CampaignName = Replace(rc.CampaignName," ","","all") />
<cfset rc.CampaignSource = Replace(rc.CampaignSource," ","","all") />
<cfset rc.AdMedium = Replace(rc.AdMedium," ","","all") />
<cfset rc.AdContent = Replace(rc.AdContent," ","","all") />

<cfif rc.Show>
	<cfoutput>
		<cfif isDefined('rc.Campaign')>
			<div class="svoutilitycampaignlink">
				<dl>
					<dt>Campaign Name</dt>
					<dd>#rc.Campaign.getCampaignName()#</dd>
				</dl>
				<dl>
					<dt>Campaign Source</dt>
					<dd>#rc.Campaign.getCampaignSource()#</dd>
				</dl>
				<dl>
					<dt>Ad Medium</dt>
					<dd>#rc.Campaign.getAdMedium()#</dd>
				</dl>
				<dl>
					<dt>Ad Content</dt>
					<dd>#rc.Campaign.getAdContent()#</dd>
				</dl>
				<dl>
					<dt>Link</dt>
					<dd>#rc.Campaign.getLink()#</dd>	
				</dl>
			</div>
		<cfelse>
			<div class="svoutilitycampaignlink">
				<form action="index.cfm?action=utility.campaignlink" onSubmit="return false;">
					<dl>
						<dt>Campaign Name</dt>
						<dd>
							<cfif rc.CampaignName eq "NewCampaign">
								<input type="text" name="CampaignName" />
								<button type="submit" onClick="updateCampaign(0);">Add</button>
							<cfelse>
								<select name="CampaignName" onChange="updateCampaign(0);">
									<cfset Local.CampaignNameOptions = application.Slatwall.campaignManager.getExistingCampaignNames() />
									<option value="">Select</option>
									<cfset Local.isSelected = 0 />
									<cfloop query="Local.CampaignNameOptions">
										<option value="#Local.CampaignNameOptions.CampaignName#" <cfif Local.CampaignNameOptions.CampaignName eq rc.CampaignName>selected="selected"<cfset Local.isSelected=1 /></cfif>>#Local.CampaignNameOptions.CampaignName#</option>
									</cfloop>
									<cfif not Local.isSelected and rc.CampaignName neq "">
										<option value="#rc.CampaignName#" selected="selected">#rc.CampaignName#</option>
									</cfif>
									<option value="NewCampaign">+ New Campaign</option>
								</select>
							</cfif>
						</dd>
					</dl>
					<cfif rc.CampaignName neq "" and rc.CampaignName neq "NewCampaign">
						<dl>
							<dt>Campaign Source</dt>
							<dd>
								<cfif rc.CampaignSource eq "NewSource">
									<input type="text" name="CampaignSource" />
									<button type="submit" onClick="updateCampaign(0);">Add</button>
								<cfelse>
									<select name="CampaignSource" onChange="updateCampaign(0);">
										<cfset Local.CampaignSourceOptions = application.Slatwall.campaignManager.getExistingCampaignSources() />
										<option value="">Select</option>
										<cfset Local.isSelected = 0 />
										<cfloop query="Local.CampaignSourceOptions">
											<option value="#Local.CampaignSourceOptions.CampaignSource#" <cfif Local.CampaignSourceOptions.CampaignSource eq rc.CampaignSource>selected="selected"<cfset Local.isSelected=1 /></cfif>>#Local.CampaignSourceOptions.CampaignSource#</option>
										</cfloop>
										<cfif not Local.isSelected and rc.CampaignSource neq "">
											<option value="#rc.CampaignSource#" selected="selected">#rc.CampaignSource#</option>
										</cfif>
										<option value="NewSource">+ New Source</option>
									</select>
								</cfif>
							</dd>
						</dl>
						<dl>
							<dt>Ad Medium</dt>
							<dd>
								<select name="AdMedium">
									<option value="AdBanner" <cfif rc.AdMedium eq "AdBanner">selected="selected"</cfif>>AdBanner</option>
									<option value="RemarketBanner" <cfif rc.AdMedium eq "RemarketBanner">selected="selected"</cfif>>RemarketBanner</option>
									<option value="Email" <cfif rc.AdMedium eq "Email">selected="selected"</cfif>>Email</option>
									<option value="SEM" <cfif rc.AdMedium eq "SEM">selected="selected"</cfif>>SEM</option>
									<option value="Print" <cfif rc.AdMedium eq "Print">selected="selected"</cfif>>Print</option>
								</select>
							</dd>
						</dl>
						<dl>
							<dt>Ad Content Description (optional)</dt>
							<dd><input type="text" name="AdContent" /></dd>
						</dl>
						<button type="submit" onClick="updateCampaign(1);" name="Add">Create</button>
					</cfif>
				</form>
				<a href="javascript:;" onClick="doSlatAction('utility.campaignlink',{'Show': 0})" style="position:absolute; top:0px; right:0px;">Close</a>
				<script type="text/javascript">
					function updateCampaign(SaveCampaign){
						rc = {
								"Show": 1,
							<cfif rc.CampaignName neq "NewCampaign">
								"CampaignName": $('select[name=CampaignName] :selected').val(),
							<cfelse>
								"CampaignName": $('input[name=CampaignName]').val(),
							</cfif>
							<cfif rc.CampaignSource neq "NewSource">
								"CampaignSource": $('select[name=CampaignSource] :selected').val(),
							<cfelse>
								"CampaignSource": $('input[name=CampaignSource]').val(),
							</cfif>
							"AdMedium": $('select[name=AdMedium] :selected').val(),
							"AdContent": $('input[name=AdContent]').val(),
							"LandingPageContentID": "#rc.LandingPageContentID#",
							"QueryString": "#rc.QueryString#",
							"SaveCampaign": SaveCampaign
						};
						doSlatAction('utility.campaignlink', rc);
					}
				</script>
			</div>
		</cfif>
	</cfoutput>
<cfelse>
	<div class="svoutilitycampaignlink" style="display:none;"></div>
</cfif>

