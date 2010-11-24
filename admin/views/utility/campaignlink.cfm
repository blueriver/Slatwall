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
									<cfset Local.CampaignNameOptions = application.Slat.campaignManager.getExistingCampaignNames() />
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
										<cfset Local.CampaignSourceOptions = application.Slat.campaignManager.getExistingCampaignSources() />
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
