<cfcomponent output="false" name="ajaxManager" hint="">

	<cfinclude template="../../fw1Config.cfm">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getNewAjaxHook" access="remote" returntype="string" output="false">
		<cfset NewRandom = round(rand()*1000000) />
		<cfset NewAjaxHook = "sah#NewRandom#" />
		<cfreturn NewAjaxHook />
	</cffunction>
	
	<cffunction name="getSVO" access="remote" returntype="string" output="false">
		<cfargument name="svo" type="string" required="true" />
		<cfargument name="args" type="struct" default="#structNew()#" />
		<cfargument name="svoRequestID" type="numeric" required="true" />
		
		<cfset var result = "" />
		<cfset var fw1 = createObject("component","slat.Application") />
		
		<cfset url[variables.framework.action] = Replace(arguments.svo,'/',".","all") />
		<cfset request.generateSES = false />
		<cfset request.layout = false />
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart('index.cfm') />
		<cfset fw1.onRequest('index.cfm') />
		<cfset fw1.SlatGlobalRequestStart() />
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfoutput>#fw1.view(arguments.svo, arguments.args)#</cfoutput>
		</cfsavecontent>
		
		<cfreturn 'svo#replace(arguments.svo,"/","","all")#~#arguments.svoRequestID#~#result#' />
	</cffunction>
	
	<cffunction name="doSlatAction" access="remote" returntype="string" output="false">
		<cfargument name="action" type="string" required="true" />
		<cfargument name="rc" type="struct" default="#structNew()#" />
		<cfargument name="JSRequestID" type="numeric" required="true" />
		
		<cfset var result = "" />
		<cfset var fw1 = createObject("component","slat.Application") />
		<cfset var I = "" />
		
		<cfset url.action = arguments.action />
		
		<cfset request.context = duplicate(arguments.rc) />
		<cfset request.generateSES = false />
		<cfset request.layout = false />
		<!--- call the frameworks onRequestStart --->
		<cfset fw1.onRequestStart('index.cfm') />
		<cfset fw1.SlatGlobalRequestStart() />
		<!--- call the frameworks onRequest --->
		<!--- we save the results via cfsavecontent so we can display it in mura --->
		<cfsavecontent variable="result">
			<cfoutput><cfset fw1.onRequest('index.cfm') /></cfoutput>
		</cfsavecontent>
		
		<cfreturn 'svo#replace(arguments.action,".","","all")#~#arguments.JSRequestID#~#result#' />
	</cffunction>
	
	<cffunction name="getDisplay" access="remote" returntype="string" output="false">
		<cfargument name="sah" type="string" required="true" />
		<cfargument name="Display" type="string" required="true" />
		<cfargument name="DisplaySettingsJSON" type="struct" default="#structNew()#" />
		
		<cfset var DisplayReturn = "" />
		
		<cftry>
			<cfset DisplayReturn = application.slat.dspManager.get(Display=arguments.Display, DisplaySettings=arguments.DisplaySettingsJSON) />
			<cfcatch>
				<cfmail to="greg@nytro.com" from="info@nytro.com" subject="Ajax Error - Get Display" Type="html" PORT="25" SERVER="127.0.0.1">
					<cfoutput>
						#cfcatch.message#
						<cfif isDefined("arguments")>
							<cfdump var="#arguments#" />
						</cfif>
						<cfif isDefined("request.exception")>
							<cfdump var="#request.exception#" />
						</cfif>
						<cfif isDefined("error")>
							<cfdump var="#error#" />
						</cfif>
						<cfif isDefined("cfcatch")>
							<cfdump var="#cfcatch#" />
						</cfif>
					</cfoutput>
				</cfmail>
			</cfcatch>
		</cftry>
		
		<cfreturn "#arguments.sah#~#DisplayReturn#" />
		
	</cffunction>
	
	<cffunction name="runProcess" access="remote" returntype="String" output="false">
		<cfargument name="FormValuesJSON" type="struct" required="true">
		<cfargument name="sah" type="string" required="true" />
		<cfargument name="Display" type="string" required="true" />
		<cfargument name="DisplaySettingsJSON" type="struct" default="#structNew()#" />
		
		<cftry>
			<!--- <cfinclude template="#application.slatsettings.getSetting('PluginPath')#/DefaultParams.cfm" /> --->
			
			<cfset FormValue = "">
			<cfloop collection="#arguments.FormValuesJSON#" item="FormName">
				<cfset FormValue = StructFind(arguments.FormValuesJSON, FormName) />
				<cfset "Form.#FormName#" = FormValue />
			</cfloop>
			<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/process/#Form.slatProcess#.cfm" />
			
			<cfset DisplayReturn = application.slat.dspManager.get(Display=arguments.Display, DisplaySettings=arguments.DisplaySettingsJSON) /> 
			<cfreturn "#sah#~#DisplayReturn#" />
			<cfcatch>
				<cfmail to="greg@nytro.com" from="info@nytro.com" subject="Ajax Error - Run Process" Type="html" PORT="25" SERVER="127.0.0.1">
					<cfoutput>
						#cfcatch.message#
						<cfif isDefined("arguments")>
							<cfdump var="#arguments#" />
						</cfif>
						<cfif isDefined("request.exception")>
							<cfdump var="#request.exception#" />
						</cfif>
						<cfif isDefined("error")>
							<cfdump var="#error#" />
						</cfif>
						<cfif isDefined("cfcatch")>
							<cfdump var="#cfcatch#" />
						</cfif>
					</cfoutput>
				</cfmail>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getProductSearchResults" access="remote" returntype="string">
		<cfargument name="keyword" type="string" required="true" />
		
		<cfset var productSearch = querynew('empty') />
		<cfset var contentSearch = "" />
		<cfset var infoLinks = "">
		<cfset var blogLinks = "">
		<cfset var categoryLinks = "">
		<cfset var crumbListArray = arrayNew(1) />
		<cfset var newIndex = 0>
		
		<cfset productSearch = application.Slat.productManager.getProductsByFilter(
			CategoryProductsQuery=application.Slat.integrationManager.getAllProductsQuery(), 
			Filter=structnew(), 
			Range=structnew(),
			OrderColumn="DateFirstReceived",
			OrderDirection="A",
			Keyword=arguments.Keyword) />
		
		<cfset contentSearch = application.contentManager.getPublicSearch("default","#arguments.keyword#","","") />
		
		<cfloop query="contentSearch" startrow="1" endrow="5">
			
			<cfset crumbListArray = application.contentManager.getCrumbList(#contentSearch.ContentID#, "default") />
			<cfset crumbUnderHome = arrayLen(crumbListArray)-1 />
			<cfif crumbUnderHome lt 1>
				<cfset crumbUnderHome = 1 />
			</cfif>
			<cfsavecontent variable="newLink">
				<cfoutput>
				<li>
					<a href="/index.cfm/#crumbListArray[1].FileName#">
						<span>
							
							<cfloop to="1" step="-1" from="#crumbUnderHome#" index="newIndex">
								<cfif #crumbListArray[newIndex].MenuTitle# neq "Nytro Blog">
									#application.Slat.utilityManager.maxStringLength("#crumbListArray[newIndex].MenuTitle#", 50)# <cfif newIndex gt 1> > </cfif>
								</cfif>
							</cfloop>
						</span>
					</a>
				</li>
				</cfoutput>
			</cfsavecontent>
			
			<cfif crumbListArray[crumbUnderHome].MenuTitle eq "Info">
				<cfset infoLinks = "#infoLinks# #newLink#" />
			<cfelseif crumbListArray[crumbUnderHome].MenuTitle eq "Swim" or crumbListArray[crumbUnderHome].MenuTitle eq "Bike" or crumbListArray[crumbUnderHome].MenuTitle eq "Run">
				<cfset categoryLinks = "#categoryLinks# #newLink#">
			<cfelseif crumbListArray[crumbUnderHome].MenuTitle eq "Nytro Blog">
				<cfset blogLinks = "#blogLinks# #newLink#">
			</cfif>
		</cfloop>
		
		<cfsavecontent variable="return">
			<cfif categoryLinks neq "">
				<ul class="pages">
					<li class="title">Categories</li>
					<cfoutput>#categoryLinks#</cfoutput>
				</ul>
			</cfif>
			<cfif productSearch.recordCount gt 0>
				<ul class="products">
					<li class="title">Products</li>
					<cfloop query="productSearch" startrow="1" endrow="5">
						<cfset Product = application.Slat.productmanager.read(#productSearch.ProductID#) />
						<cfoutput>
							<li>
								<a href="#Product.getProductLink()#">
									<img src="http://www.nytro.com/prodimages/#Product.getDefaultImageID()#-DEFAULT-s.jpg" width="40px" height="50px" />
									<span>#application.Slat.utilityManager.maxStringLength("#Product.getProductYear()# #Product.getBrandName()# #Product.getProductName()#", 45)#</span>
								</a>
							</li>
						</cfoutput>
					</cfloop>
				</ul>
			</cfif>
			<cfif infoLinks neq "">
				<ul class="pages">
					<li class="title">Info</li>
					<cfoutput>#infoLinks#</cfoutput>
				</ul>
			</cfif>
			<cfif blogLinks neq "">
				<ul class="pages">
					<li class="title">Nytro Blog</li>
					<cfoutput>#blogLinks#</cfoutput>
				</ul>
			</cfif>
			<cfif infoLinks eq "" and categoryLinks eq "" and blogLinks eq "" and productSearch.recordCount eq 0>
				<ul class="pages">
					<li class="title">No Results</li>
					<li><span class="noResults">No Results Found</span></li>
				</ul>
			</cfif>
			<cfoutput><div id="all_results"><a href="/index.cfm/search/?P_Show=15&Keyword=#arguments.keyword#">View All Results</a></div></cfoutput>
		</cfsavecontent>

		<cfreturn return />
	</cffunction>
	
	<cffunction name="getProductRating" access="remote" returntype="string">
		<cfargument name="productid" required="true">
		<cfargument name="rate" required="true">
		<cfargument name="userid" default="#Session.Mura.UserID#">
		<cfargument name="siteid" default="default">
		
		<cfset UserRate = application.raterManager.saveRate('ProductID_#arguments.ProductID#',arguments.siteID,arguments.userID,arguments.rate) />
		<cfset return = "#arguments.productid#~#arguments.rate#" />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getGiftCardBalance" access="remote" returntype="string">
		<cfargument name="GiftCardID" required="true">
		
		<cfset var return = "" />
		<cfset var BalanceQuery = application.Slat.integrationManager.getGiftCardBalanceQuery(arguments.GiftCardID) />

		<cfsavecontent variable="return">
			<cfif BalanceQuery.recordcount lt 1>
				<cfoutput>
					Sorry, no card number found
				</cfoutput>
			<cfelse>
				<cfoutput>
					The Balance of this card is: #DollarFormat(BalanceQuery.CardValue)#
				</cfoutput>
			</cfif>
		</cfsavecontent>
		
		<cfreturn return />
	</cffunction>

	<cffunction name="updateCartShippingMethod" access="remote" returntype="string">
		<cfargument name="CartShippingAddressID" default="1" />
		<cfargument name="Carrier" default="Custom" />
		<cfargument name="Method" default="" />
		<cfargument name="Cost" default=0 />
		<cfargument name="DeliveryTime" default="" />
		
		<cfset application.Slat.cartManager.updateCartShippingMethod(
			CartShippingAddressID=arguments.CartShippingAddressID,
			Carrier=arguments.Carrier,
			Method=arguments.Method,
			Cost=JavaCast("float",arguments.Cost),
			DeliveryTime=arguments.DeliveryTime
			) />
				  
		<cfreturn application.slat.utilityManager.getCartOrderSummary() />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>