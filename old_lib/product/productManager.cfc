<cfcomponent output="false" name="productManager" hint="">
	
	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="productDAO" type="any" required="yes"/>
		<cfargument name="productGateway" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.productDAO />
		<cfset variables.Gateway=arguments.productGateway />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="ProductID" type="String" />		
	
		<cfreturn variables.DAO.read(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getAllProductsQuery" access="public" returntype="any" output="false">
		<cfreturn application.slat.integrationManager.getAllProductsQuery() />
	</cffunction>
	
	<cffunction name="getQueryOrganizer" access="public" returntype="any" output="false"> 
		<cfset var QueryOrganizer = application.slat.utilityManager.getNewQueryOrganizer() />
		<cfset QueryOrganizer.addKeywordColumn('ProductCode', 9) />
		<cfset QueryOrganizer.addKeywordColumn('ProductName', 4) />
		<cfset QueryOrganizer.addKeywordColumn('BrandID', 6) />
		<cfset QueryOrganizer.addKeywordColumn('BrandName', 6) />
		<cfset QueryOrganizer.addKeywordColumn('ProductDescription', 1) />
		<cfreturn QueryOrganizer />
	</cffunction>

	<cffunction name="getProductsInCategory" access="public" returntype="any" output="false">
		<cfargument name="ContentID" type="String" required="true" />	
		<cfargument name="ContentPath" type="String" required="true" />
		<cfargument name="getChildCategoryProducts" type="boolean" default=1 />
		<cfargument name="OrderColumn" type="string" default="LIVEPRICE" />
		<cfargument name="OrderDirection" type="string" default="A" />
		<cfargument name="ActiveOnly" type="boolean" default=1 />
			
		<cfreturn variables.Gateway.getProductsInCategory(
			ContentID = arguments.ContentID,
			ContentPath = arguments.ContentPath,
			getChildCategoryProducts = arguments.getChildCategoryProducts,
			OrderColumn = arguments.OrderColumn,
			OrderDirection = arguments.OrderDirection,
			ActiveOnly = arguments.ActiveOnly
		) />
	</cffunction>
	
	<cffunction name="getProductsByFilter" access="public" returntype="any" output="false">
		<cfargument name="CategoryProductsQuery" type="Query" required="true" />
		<cfargument name="Filter" type="struct" required="true" />
		<cfargument name="Range" type="struct" required="true" />
		<cfargument name="Keyword" type="string" default="" />
		<cfargument name="OrderColumn" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="ActiveOnly" type="boolean" default=1 />
	
		<cfreturn variables.Gateway.getProductsByFilter(
			CategoryProductsQuery = arguments.CategoryProductsQuery,
			Filter = arguments.Filter,
			Range = arguments.Range,
			Keyword = arguments.Keyword,
			OrderColumn = arguments.OrderColumn,
			OrderDirection = arguments.OrderDirection,
			ActiveOnly = arguments.ActiveOnly
		) />
	</cffunction>
	
	<cffunction name="getFilterOptions" access="public" returntype="query" output="false">
		<cfargument name="Query" type="query" required="true" />
		<cfargument name="Filter" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" default="A" />
		<cfargument name="OrderByCount" type="numeric" default=0 />
	
		<cfreturn variables.Gateway.getFilterOptions(arguments.Query, arguments.Filter, arguments.OrderDirection, arguments.OrderByCount) />
	</cffunction>
	
	<cffunction name="getSubContentFilterOptions" access="public" returntype="query" output="false">
		<cfargument name="ContentID" type="string" default="A" />
		
		<cfreturn variables.Gateway.getSubContentFilterOptions(arguments.ContentID) />
	</cffunction>

	<cffunction name="getContentByProductID" access="public" returntype="query" output="false">
		<cfargument name="ProductID" type="string" required="true" />
	
		<cfreturn variables.Gateway.getContentByProductID(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="addProductToContent" access="public" output="true">
		<cfargument name="ProductID" required="true" type="string" >
		<cfargument name="ContentID" required="true" type="string" >
		
		<cfset variables.Gateway.addProductToContent(ContentID=arguments.ContentID, ProductID=arguments.productID)>
	</cffunction>
	
	<cffunction name="removeProductFromContent" access="remote" output="false" returntype="String">
		<cfargument name="ProductID" type="string" required="true" >
		<cfargument name="ContentID" type="string" required="true" >
		
		<cfset variables.Gateway.removeProductFromContent(arguments.ProductID, arguments.ContentID)>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="getProductIterator" access="public" output="false" returntype="any">
		<cfargument name="ProductQuery" type="any" required="true">
		
		<cfset var productIterator=createObject("component","productIterator").init() />
		<cfset productIterator.setQuery(arguments.ProductQuery, 100) />
		<cfreturn productIterator />
	</cffunction>
	
	<cffunction name="getFilterLink" access="public" returntype="string" output="false">
		<cfargument name="FilterColumn" type="string" required="true" />
		<cfargument name="FilterValue" type="string" required="true" />
		
		<cfset NewQuery = "" />
		
		<cfif cgi.query_string eq "" >
			<cfset NewQuery = "?F_#UCASE(arguments.FilterColumn)#=#arguments.FilterValue#" />
		<cfelse>
			<cfset isfirst = 1>
			<cfloop collection="#url#" item="ValuePair">
				<cfif find("F_#UCASE(arguments.FilterColumn)#",ValuePair) or (find("F_",ValuePair) and #StructFind(url,ValuePair)# neq "") or (find("O_",ValuePair) and #StructFind(url,ValuePair)# neq "")>
					<cfif isfirst>
						<cfset NewQuery = "?" />
						<cfset isfirst = 0 />
					<cfelse>
						<cfset NewQuery = "#NewQuery#&" />
					</cfif>
					
					<cfif find("F_#UCASE(arguments.FilterColumn)#",ValuePair)>
						<cfset NewQuery = "#NewQuery#F_#UCASE(arguments.FilterColumn)#=#arguments.FilterValue#" /> 
					<cfelse>
						<cfset NewQuery = "#NewQuery##ValuePair#=#StructFind(url,ValuePair)#" />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset FilterLink = "#cgi.script_name##cgi.path_info##NewQuery#" />
		
		<cfreturn FilterLink />
	</cffunction>
	
	<cffunction name="getOrderLink" access="public" returntype="string" output="false">
		<cfargument name="OrderColumn" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		
		<cfset NewQuery = "" />
		
		<cfif cgi.query_string eq "">
			<cfset NewQuery = "?O_Column=#arguments.OrderColumn#&O_Direction=#arguments.OrderDirection#" />
		<cfelse>	
			<cfset isfirst = 1>
			
			<cfloop collection="#url#" item="ValuePair">
				<cfif find("F_",ValuePair) and #StructFind(url,ValuePair)# neq "">
					<cfif isfirst>
						<cfset NewQuery = "?" />
						<cfset isfirst = 0 />
					<cfelse>
						<cfset NewQuery = "#NewQuery#&" />
					</cfif>
					
					<cfset NewQuery = "#NewQuery##ValuePair#=#StructFind(url,ValuePair)#" />
				</cfif>
			</cfloop>
			
			<cfif isfirst>
				<cfset NewQuery = "?" />
				<cfset isfirst = 0 />
			<cfelse>
				<cfset NewQuery = "#NewQuery#&" />
			</cfif>
			
			<cfset NewQuery = "#NewQuery#O_Column=#arguments.OrderColumn#&" />
			<cfset NewQuery = "#NewQuery#O_Direction=#arguments.OrderDirection#" />
		</cfif>	
			
		<cfset OrderLink = "#cgi.script_name##cgi.path_info##NewQuery#" />
		
		<cfreturn OrderLink />
	</cffunction>
	
	<cffunction name="getPageLink" access="public" returntype="string" output="false">
		<cfargument name="PageNumber" type="string" required="true" />
		
		<cfset NewQuery = "" />
		
		<cfset LinkSpID = (request.Slat.Pager.ProductsPerPage*(arguments.PageNumber-1))+1 />
		
		<cfif cgi.query_string eq "">
			<cfset NewQuery = "?P_Start=#LinkSpID#" />
		<cfelse>
			<cfset isfirst = 1>
			
			<cfloop collection="#url#" item="ValuePair">
				<cfif (find("F_",ValuePair) and #StructFind(url,ValuePair)# neq "") or (find("O_",ValuePair) and #StructFind(url,ValuePair)# neq "")>
					<cfif isfirst>
						<cfset NewQuery = "?" />
						<cfset isfirst = 0 />
					<cfelse>
						<cfset NewQuery = "#NewQuery#&" />
					</cfif>
					
					<cfset NewQuery = "#NewQuery##ValuePair#=#StructFind(url,ValuePair)#" />
				</cfif>
			</cfloop>

			<cfif isfirst>
				<cfset NewQuery = "?" />
				<cfset isfirst = 0 />
			<cfelse>
				<cfset NewQuery = "#NewQuery#&" />
			</cfif>
			
			<cfset NewQuery = "#NewQuery#P_Start=#LinkSpID#" />
		</cfif>
		
		<cfset PageLink = "#cgi.script_name##cgi.path_info##NewQuery#" />
		
		<cfreturn PageLink />
	</cffunction>
	<!---
	<cffunction name="dspCategoryPagingNav" access="public" returntype="string" output="false">
		<cfargument name="MaxDisplayPages" default="10" />
		<cfargument name="PreviousIcon" default="<" />
		<cfargument name="NextIcon" default=">" />
		<cfargument name="SpacerIcon" default="" />
		<cfargument name="MoreIcon" default="..." />

		<cfset CategoryPageingNav = "" />
		
		<cfsavecontent variable="CategoryPageingNav">
			<cfoutput>
				<cfif #Request.Slat.Pager.TotalPages# gt 1>
					<cfif Request.Slat.Pager.CurrentPage eq 1>
						<cfset PreviousLink = "" />
					<cfelse>
						<cfset PreviousLink = getPageLink(Request.Slat.Pager.CurrentPage - 1) />
					</cfif>
					
					<cfif Request.Slat.Pager.CurrentPage eq Request.Slat.Pager.TotalPages>
						<cfset NextLink = "" />
					<cfelse>
						<cfset NextLink = getPageLink(Request.Slat.Pager.CurrentPage + 1) />
					</cfif>

					<cfset PageListingStart = 1 />
					<cfset PageListingEnd = Request.Slat.Pager.TotalPages />
					
					<cfif PageListingEnd gt arguments.MaxDisplayPages>
						<cfset PageListingStart = (Request.Slat.Pager.CurrentPage - round(arguments.MaxDisplayPages/2))>
						
						<cfif PageListingStart lt 1>
							<cfset PageListingStart = 1 />
						</cfif>
						
						<cfset PageListingEnd = PageListingStart + (arguments.MaxDisplayPages - 1) />
						
						<cfif PageListingEnd gt Request.Slat.Pager.TotalPages>
							<cfset PageListingEnd = Request.Slat.Pager.TotalPages />
							<cfset PageListingStart = PageListingEnd - (arguments.MaxDisplayPages - 1) />
						</cfif>
					</cfif>

					<ul class="CategoryPager">
						<li class="Previous"><a href="#PreviousLink#">#arguments.PreviousIcon#</a></li>
						<cfif PageListingStart gt 1>
							<li class="MorePrevious"><a href="#getPageLink(1)#">#MoreIcon#</a></li>
						</cfif>
						<cfloop From="#PageListingStart#" To="#PageListingEnd#" Index="I">
							<cfset Link = getPageLink(I)>
							<cfif I eq Request.Slat.Pager.CurrentPage>
								<li class="current">
							<cfelse>
								<li>
							</cfif>
								<a href="#Link#">#I#</a>
							</li>
						</cfloop>
						<cfif PageListingEnd lt Request.Slat.Pager.TotalPages>
							<li class="MoreNext"><a href="#getPageLink(Request.Slat.Pager.TotalPages)#">#MoreIcon#</a></li>
						</cfif>
						<li class="Next"><a href="#NextLink#">#arguments.NextIcon#</a></li>
					</ul>
					
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn CategoryPageingNav /> 
	</cffunction>
	--->
	<cffunction name="dspRating" returnType="string" output="false" access="remote">
		<cfargument name="productid" required="true">
		<cfargument name="userid" default=0>
		<cfargument name="userRating" default=0>
		<cfargument name="averageRating" default=0>
		
		<cfset var  NoStar = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/NoStar.png" />
		<cfset var UserStar = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/UserStar.png" />
		<cfset var RankStarFull = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/RankStarFull.png" />
		<cfset var RankStarQuart = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/RankStarQuart.png" />
		<cfset var RankStarHalf = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/RankStarHalf.png" />
		<cfset var RankStarTQuart = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/RankStarTQuart.png" />
		<cfset var Star1 = NoStar />
		<cfset var Star2 = NoStar />
		<cfset var Star3 = NoStar />
		<cfset var Star4 = NoStar />
		<cfset var Star5 = NoStar />
		<cfset var return = "" />
		
		<cfif arguments.userRating neq 0>
			<cfset Star1 = UserStar />
			<cfif arguments.userRating gt 1>
				<cfset Star2 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 2>
				<cfset Star3 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 3>
				<cfset Star4 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 4>
				<cfset Star5 = UserStar />
			</cfif>
		<cfelse>
			<cfif arguments.averageRating gt .01>
				<cfset Star1 = RankStarFull />
			</cfif>
			<cfif arguments.averageRating gt 1.75>
				<cfset Star2 = RankStarFull />
			<cfelseif arguments.averageRating gt 1.50>
				<cfset Star2 = RankStarTQuart />
			<cfelseif arguments.averageRating gt 1.25>
				<cfset Star2 = RankStarHalf />
			<cfelseif arguments.averageRating gt 1.00>
				<cfset Star2 = RankStarQuart />
			</cfif>
			<cfif arguments.averageRating gt 2.75>
				<cfset Star3 = RankStarFull />
			<cfelseif arguments.averageRating gt 2.50>
				<cfset Star3 = RankStarTQuart />
			<cfelseif arguments.averageRating gt 2.25>
				<cfset Star3 = RankStarHalf />
			<cfelseif arguments.averageRating gt 2.00>
				<cfset Star3 = RankStarQuart />
			</cfif>
			<cfif arguments.averageRating gt 3.75>
				<cfset Star4 = RankStarFull />
			<cfelseif arguments.averageRating gt 3.5>
				<cfset Star4 = RankStarTQuart />
			<cfelseif arguments.averageRating gt 3.25>
				<cfset Star4 = RankStarHalf />
			<cfelseif arguments.averageRating gt 3>
				<cfset Star4 = RankStarQuart />
			</cfif>
			<cfif arguments.averageRating gt 4.75>
				<cfset Star5 = RankStarFull />
			<cfelseif arguments.averageRating gt 4.5>
				<cfset Star4 = RankStarTQuart />	
			<cfelseif arguments.averageRating gt 4.25>
				<cfset Star5 = RankStarHalf />
			<cfelseif arguments.averageRating gt 4.00>
				<cfset Star4 = RankStarQuart />
			</cfif>
		</cfif>
		
		<cfsavecontent variable="return">
			<cfoutput>
				<div class="ProductRating" onmouseout="rateProductOut('#arguments.productid#');">
					<img src="#Star1#" rating="#Star1#" user="#UserStar#" blank="#NoStar#" onClick="rateProduct('#arguments.productid#', '1', '#arguments.userID#');" onmouseover="rateProductOver('#arguments.productid#', 1);" class="#arguments.productid#_Star1">
					<img src="#Star2#" rating="#Star2#" user="#UserStar#" blank="#NoStar#" onClick="rateProduct('#arguments.productid#', '2', '#arguments.userID#');" onmouseover="rateProductOver('#arguments.productid#', 2);" class="#arguments.productid#_Star2">
					<img src="#Star3#" rating="#Star3#" user="#UserStar#" blank="#NoStar#" onClick="rateProduct('#arguments.productid#', '3', '#arguments.userID#');" onmouseover="rateProductOver('#arguments.productid#', 3);" class="#arguments.productid#_Star3">
					<img src="#Star4#" rating="#Star4#" user="#UserStar#" blank="#NoStar#" onClick="rateProduct('#arguments.productid#', '4', '#arguments.userID#');" onmouseover="rateProductOver('#arguments.productid#', 4);" class="#arguments.productid#_Star4">
					<img src="#Star5#" rating="#Star5#" user="#UserStar#" blank="#NoStar#" onClick="rateProduct('#arguments.productid#', '5', '#arguments.userID#');" onmouseover="rateProductOver('#arguments.productid#', 5);" class="#arguments.productid#_Star5">
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn return />	
	</cffunction>
	
	<cffunction name="dspUserRating" returnType="string" output="false" access="remote">
		<cfargument name="userRating" default=0>
		
		<cfset var NoStar = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/NoStar.png" />
		<cfset var UserStar = "#application.SlatSettings.getSetting('PluginPath')#/images/rating/RankStarFull.png" />
		<cfset var Star1 = NoStar />
		<cfset var Star2 = NoStar />
		<cfset var Star3 = NoStar />
		<cfset var Star4 = NoStar />
		<cfset var Star5 = NoStar />
		<cfset var return = "" />
		
		<cfif arguments.userRating neq 0>
			<cfset Star1 = UserStar />
			<cfif arguments.userRating gt 1>
				<cfset Star2 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 2>
				<cfset Star3 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 3>
				<cfset Star4 = UserStar />
			</cfif>
			<cfif arguments.userRating gt 4>
				<cfset Star5 = UserStar />
			</cfif>
		</cfif>
		
		<cfsavecontent variable="return">
			<cfoutput>
				<div class="UserRating">
					<img src="#Star1#">
					<img src="#Star2#">
					<img src="#Star3#">
					<img src="#Star4#">
					<img src="#Star5#">
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn return />	
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfset var DebugStruct = structNew() />
		<cfset DebugStruct.Variables = variables />
		<cfset DebugStruct.DAO = variables.DAO.getDebug() />
		<cfset DebugStruct.Gateway = variables.gateway.getDebug() />
		<cfreturn DebugStruct />
	</cffunction>
</cfcomponent>