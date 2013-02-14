<cfif thisTag.executionMode eq "start">
	<cfparam name="attributes.sectionID" />
	<cfparam name="attributes.sectionName" />
	<cfparam name="attributes.sectionTagline" />
	<cfparam name="attributes.sectionType" />
		
<cfelseif thisTag.executionMode eq "end">
	<cfparam name="thistag.items" default="#arrayNew(1)#" />
	
	<cfoutput>
		<header class="jumbotron subhead #attributes.sectionType#" id="#attributes.sectionID#">
			<div class="container">
				<h1>#attributes.sectionName#</h1>
				<p class="lead">#attributes.sectionTagline#</p>
			</div>
		</header>
		<div class="container">
			<div class="row doc-section">
				<div class="span3 bs-docs-sidebar">
					<ul class="nav nav-tabs nav-stacked bs-docs-sidenav" data-spy="affix" data-offset-top="0">
						<cfloop array="#thistag.items#" index="item">
							<li><a href="###item.itemID#">#item.itemName#</a></li>
						</cfloop>
					</ul>
				</div>
				<div class="span9">
					<cfloop array="#thistag.items#" index="item">
						<div id="#item.itemID#">
							<div class="page-header">
								<h2>#item.itemName#</h2>
							</div>
							<cfinclude template="item/#item.itemID#.cfm" />
						</div>
					</cfloop>
				</div>
			</div>
		</div>
		<hr />
	</cfoutput>
</cfif>