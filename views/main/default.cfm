<!---
<cfparam name="url.Keyword" default="" />
<cfset local.queryOrganizer = application.slat.customerManager.getQueryOrganizer() />
<cfset local.queryOrganizer.setKeyword(url.Keyword) />
<cfset request.CountA = getTickCount() />
<cfset AllCustomersQuery = application.slat.customerManager.getAllCustomersQuery() />
<cfset request.CountB = getTickCount() />
<cfset CustomersSearch = local.queryOrganizer.organizeQuery(AllCustomersQuery) />
<cfset request.CountC = getTickCount() />
<cfoutput>
	#request.CountB - request.CountA#<br />
	#request.CountC - request.CountB#<br />
	<cfloop query="CustomersSearch">
		#CustomersSearch.Company#-#CustomersSearch.FirstName#-#CustomersSearch.LastName#-#CustomersSearch.QOKScore#<br />
	</cfloop>
</cfoutput>
--->
<!---
<cfset Local.Campaign = application.slat.campaignManager.getBean() />
<cfdump var="#Local.Campaign#" />

<cfset Campaign = application.slat.campaignManager.getBean() />
<cfset Campaign.setLandingPageContentID('57EF8DBB-237D-9C1A-03EE3025F4835734') />
<cfdump var="#Campaign.getLink()#" />
--->
