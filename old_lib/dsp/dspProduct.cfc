<cfcomponent output="false" name="dspProduct" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProductContentSubNav" access="package" returntype="string" output="false">
		<cfargument name="ContentID" type="string" required="true" />
		<cfargument name="Title" type="string" required="true" />
		
		<cfset var optionCount = 0 />
		<cfset var FilterOptions = querynew('empty') />
		<cfset var FilterLink = "" />
		<cfset var returnHTML = "" />
		
		<cfset FilterOptions = application.Slat.productManager.getSubContentFilterOptions(arguments.ContentID) />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductFilter">
					<h3 class="title">#arguments.Title#</h3>
					<ul>
						<cfloop query="FilterOptions">
							<cfif FilterOptions.ProductCount gt 1>
								<cfset optionCount = optionCount + 1>
								
								<cfset FilterLink = getProductCFKOPRLink(CFKOPR="C", Value=FilterOptions.FileName) />
								
								<li><a href="#FilterLink#">#FilterOptions.MenuTitle# <span class="productcount">(#FilterOptions.ProductCount#)</span></a></li>
							</cfif>
						</cfloop>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfif optionCount lt 2>
			<cfset returnHTML = "" />
		</cfif>
		
		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getProductSortNav" access="public" returntype="string" output="false">
		
		<cfset var returnHTML = "" />
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductSortNav">
					<h3 class="title">Sort By</h3>
					<ul>
						<cfif request.slat.Order.Column eq "DateFirstReceived"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','DateFirstReceived', 'D')#">Newest Products</a></li>
						<cfif request.slat.Order.Column eq "LivePrice" and request.slat.Order.Direction eq "A"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','LivePrice', 'A')#">Lowest Price</a></li>
						<cfif request.slat.Order.Column eq "LivePrice" and request.slat.Order.Direction eq "D"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','LivePrice', 'D')#">Highest Price</a></li>
						<cfif request.slat.Order.Column eq "ProductName"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','ProductName', 'A')#">Sort By Product Name</a></li>
						<cfif request.slat.Order.Column eq "Brand"><li class="current"><cfelse><li></cfif><a href="#getProductCFKOPRLink('O','Brand', 'A')#">Sort By Brand Name</a></li>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn returnHTML /> 
	</cffunction>
	
	<cffunction name="getProductPagingNav" access="public" returntype="string" output="false">
		<cfargument name="MaxDisplayPages" default="10" />
		<cfargument name="PreviousIcon" default="<" />
		<cfargument name="NextIcon" default=">" />
		<cfargument name="SpacerIcon" default="" />
		<cfargument name="MoreIcon" default="..." />
		
		<cfset var returnHTML = "" />
		<cfset var PreviousLink = "" />
		<cfset var NextLink = "" />
		<cfset var PageListingStart = 1 />
		<cfset var PageListingEnd = 1 />
		<cfset var Link = "" />
		<cfset var I = 0 />  
		
		<cfif #Request.Slat.Pager.TotalPages# gt 1>
			<cfif Request.Slat.Pager.CurrentPage eq 1>
				<cfset PreviousLink = "" />
			<cfelse>
				<cfset PreviousLink = getProductCFKOPRLink("P","Start",request.slat.pager.startingproduct - request.Slat.Pager.ProductsPerPage) />
			</cfif>
			<cfif Request.Slat.Pager.CurrentPage eq Request.Slat.Pager.TotalPages>
				<cfset NextLink = "" />
			<cfelse>
				<cfset NextLink = getProductCFKOPRLink("P","Start",request.slat.pager.startingproduct + request.Slat.Pager.ProductsPerPage) />
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
			<cfsavecontent variable="returnHTML">
				<cfoutput>
					<div class="sdoProductPagingNav">
						<ul class="CategoryPager">
							<li class="Previous"><a href="#PreviousLink#">#arguments.PreviousIcon#</a></li>
							<cfif PageListingStart gt 1>
								<li class="MorePrevious"><a href="#getProductCFKOPRLink('P','Start',1)#">#arguments.MoreIcon#</a></li>
							</cfif>
							<cfloop From="#PageListingStart#" To="#PageListingEnd#" Index="I">
								<cfset Link = getProductCFKOPRLink("P","Start",(I*request.Slat.Pager.ProductsPerPage)-(request.Slat.Pager.ProductsPerPage-1)) />
								<cfif I eq Request.Slat.Pager.CurrentPage>
									<li class="current">
								<cfelse>
									<li>
								</cfif>
									<a href="#Link#">#I#</a>
								</li>
							</cfloop>
							<cfif PageListingEnd lt Request.Slat.Pager.TotalPages>
								<li class="MoreNext"><a href="#getProductCFKOPRLink('P','Start',(Request.Slat.Pager.TotalPages*request.Slat.Pager.ProductsPerPage)-(request.Slat.Pager.ProductsPerPage-1))#">#arguments.MoreIcon#</a></li>
							</cfif>
							<li class="Next"><a href="#NextLink#">#arguments.NextIcon#</a></li>
						</ul>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn returnHTML /> 
	</cffunction>
	
	<cffunction name="getProductFilter" access="package" returntype="string" output="false">
		<cfargument name="FilterColumn" type="string" required="true" />
		<cfargument name="Title" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="OrderByCount" type="numeric" required="true" />
		
		<cfset var optionCount = 0 />
		<cfset var FilterStruct = structnew() />
		<cfset var QueryForFilter = querynew('empty') />
		<cfset var FilterOptions = querynew('empty') />
		<cfset var FilterLink = "" />
		<cfset var returnHTML = "" />
		
		<cfset FilterStruct = structCopy(request.Slat.Filter) />
		<cfset structDelete(FilterStruct, "#arguments.FilterColumn#") />
		
		<cfset QueryForFilter = application.Slat.productManager.getProductsByFilter(request.Slat.Content.ProductsQuery, FilterStruct, request.Slat.Range, request.Slat.Keyword, request.Slat.Order.Column, request.Slat.Order.Direction) />
		<cfset FilterOptions = Application.Slat.productManager.getFilterOptions(QueryForFilter,arguments.FilterColumn,arguments.OrderDirection,arguments.OrderByCount) />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoProductFilter">
					<h3 class="title">#arguments.Title#</h3>
					<ul>
						<cfloop query="FilterOptions">
							<cfif evaluate("FilterOptions.#arguments.FilterColumn#") neq "">
								<cfset optionCount = optionCount + 1>
								
								<cfset FilterLink = getProductCFKOPRLink(CFKOPR="F", Column=arguments.FilterColumn, Value=evaluate("FilterOptions.#arguments.FilterColumn#")) />
								<cfif StructKeyExists(request.Slat.Filter,"#arguments.FilterColumn#")>
									
									<cfif Find(evaluate("FilterOptions.#arguments.FilterColumn#"), StructFind(request.Slat.Filter,#arguments.FilterColumn#))>
										<li class="current">
									<cfelse>
										<li>
									</cfif>
								<cfelse>
									<li>
								</cfif>
								<a href="#FilterLink#">#evaluate("FilterOptions.#arguments.FilterColumn#")# <span class="productcount">(#FilterOptions.COLUMN_1#)</span></a></li>
							</cfif>
						</cfloop>
					</ul>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfif optionCount lt 2>
			<cfset returnHTML = "" />
		</cfif>
		
		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getProductCFKOPRLink" access="package" returntype="string" output="false" hint="CFKOPR Stands for Content, Filter, Keyword, Order, Page, Range">
		<cfargument name="CFKOPR" reqired="true" />
		<cfargument name="Column" default="" />
		<cfargument name="Value" default="" />
		
		<cfset var returnLink = "">
		<cfset var InQS = 0>
		<cfset var NewQS = "">
		<cfset var NewPath = "">
		<cfset var I = "">
		<cfset var URLStruct = structNew()>
		
		<cfif arguments.CFKOPR eq "C">
			<cfset InQS = 1 />
			<cfset NewPath = "#cgi.script_name#/#arguments.Value#/" />
		<cfelse>
			<cfset NewPath = "#cgi.script_name##cgi.path_info#" />
		</cfif>
		
		<cfloop collection="#url#" item="I">
			<cfif I neq "path" and I neq "returnURL">
				<cfif find("P_",I) lt 1>
					<cfif "#arguments.CFKOPR#_#arguments.Column#" eq I or (arguments.CFKOPR eq "O" and find("O_",I))>
						<cfset InQS = 1 />
						<cfset NewQS = "#NewQS##arguments.CFKOPR#_#arguments.Column#=#arguments.value#&">
					<cfelse>
						<cfset NewQS = "#NewQS##I#=#StructFind(url,'#I#')#&">
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfif InQS eq 0>
			<cfset NewQS = "#NewQS##arguments.CFKOPR#_#arguments.Column#=#arguments.value#&">
		</cfif>
		
		<cfif len(NewQS) gt 0>
			<cfset NewQS = Left(NewQS,(len(NewQS)-1)) />
			<cfset returnLink = "#NewPath#?#NewQS#">
		<cfelse>
			<cfset returnLink = "#NewPath#">
		</cfif>
		
		<cfreturn returnLink />
	</cffunction>

	<cffunction name="getProductNewContentAssignment" access="public" returntype="string" output="false">
		<cfargument name="ProductID" required="true" />
		<cfargument name="CurrentLocation" default="00000000000000000000000000000000001" />
		
		<cfset this.currentLocationArray = listToArray(arguments.CurrentLocation) />
		
		<cfset this.returnHTML = "" />
		<cfsavecontent variable="this.returnHTML">
			<cfoutput>
				<div class="sdoProductNewContentAssignment">
					<form action="" name="ContentAssignment" method="post">
						<input type="hidden" name="slatProcess" value="AddProductContentAssignment" />
						<input type="hidden" name="ProductID" value="#arguments.ProductID#">
						
						<cfset this.index = "" />
						<cfset this.lastDepth = "" />
						<cfset this.loopCounter = 1 />
						<cfloop from="1" to="#arraylen(this.currentLocationArray)#" index="this.index">
							<cfset this.lastDepth = "#this.lastDepth##this.currentLocationArray[this.index]#," />
							<cfset this.DropDownQuery = "" />
							<cfquery name="this.DropDownQuery" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
					  			select distinct contentid, title from tcontent where parentid = '#this.currentLocationArray[this.index]#' order by title asc
							</cfquery>
							<cfif this.DropDownQuery.recordcount gt 0>
							<select name="Select#this.index#" onChange="ContentSelectionChange('#this.lastDepth#', $('select[name=Select#this.index#] :selected').val())">
								<cfloop query="this.DropDownQuery">
									<cfset this.selected = "" />
									<cfif this.index neq arraylen(this.currentLocationArray)>
										<cfif this.DropDownQuery.contentid eq this.currentLocationArray[this.index+1]>
											<cfset this.selected = "selected=selected" />
										</cfif>
									</cfif>
									<option value="#this.DropDownQuery.contentid#" #this.selected#>#this.DropDownQuery.title#</option>
								</cfloop>
							</select>
							<br />
							<cfelse>
								<button type="submit" name="NewContentAssignmentID" value="#this.currentLocationArray[this.index]#" class="slatButton btnSmallAdd">Add</button>
							</cfif>
						</cfloop>
					</form>
				</div>
				<script type="text/javascript">
					function ContentSelectionChange(lastDepth, currentSelection){
						var curLocation = lastDepth + currentSelection;
						var DisplaySettingsJSON = {
							"ProductID":"#arguments.ProductID#",
							"CurrentLocation":curLocation
						};
						getSlatDisplay("sdoProductNewContentAssignment", "ProductNewContentAssignment", DisplaySettingsJSON);
						updateShippingMethods();
					}
				</script>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn this.returnHTML />
	</cffunction>
	
	<cffunction name="getProductExistingAssignments" access="public" returntype="string" output="false">
		<cfargument name="ProductID" required="true" />
		
		<cfset this.variables.returnHTML = "" />
		<cfset this.variables.productCategories = application.slat.productManager.getContentByProductID(ProductID=arguments.ProductID) />
		
		<cfsavecontent variable="this.variables.returnHTML">
			<cfoutput>
				<div class="sdoProductExistingAssignments">
					<form name="AssociationRemoval" method="Post" action="">
						<input type="hidden" name="slatProcess" value="RemoveProductContentAssignment" />
						<input type="hidden" name="ProductID" value="#arguments.ProductID#">
						<input type="hidden" name="RemoveContentID" value="#arguments.ProductID#">
						<table class="stripe">
							<tbody>
								<tr>
									<th class="varWidth">Currently Located</th>
									<th class="administration">&nbsp;</th>
								</tr>
							</tbody>
							
							<cfloop query="this.variables.ProductCategories">
								<cfset this.variables.ThisContent = application.contentManager.getActiveContent(contentID='#this.variables.ProductCategories.ContentID#', siteID=session.siteid) />
								<tr>
									<td class="varWidth">
									<cfset this.variables.CrumbArray = this.variables.ThisContent.getCrumbArray() />
									<cfloop to="1" from="#arrayLen(this.variables.CrumbArray)#" step="-1" index="I">
										#this.variables.CrumbArray[I].MenuTitle#<cfif I neq 1>&nbsp;&nbsp;>&nbsp;&nbsp;</cfif>
									</cfloop>
									</td>
									<td class="administration">
										<ul class="two">
											<li class="preview" style="width:14px; clear:none; margin-bottom:0px;"><a href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(session.siteid,this.variables.CrumbArray[1].filename)#" title="Preview" target="Preview">Preview</a></li>
											<li class="delete" style="width:14px; clear:none; margin-bottom:0px;"><a href="javascript:;" onClick="$('input[name=RemoveContentID]').val('#this.variables.ProductCategories.ContentID#'); $('form[name=AssociationRemoval]').submit();" title="Delete">&nbsp;</a>
											</li>
										</ul>
									</td>
								</tr>
							</cfloop>
						</table>
					</form>
				</div>
			</cfoutput>
		</cfsavecontent> 
		
		<cfreturn this.variables.returnHTML />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>