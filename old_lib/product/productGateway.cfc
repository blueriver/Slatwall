<cfcomponent output="false" name="productGateway" hint="This is the gateway function that does all of the product searching and filtering, typically for the category pages">
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllProductXCategory" access="package" output="false" retruntype="query">
		<cfset var AllProductContentAssign = querynew('empty') />
		
		<cfquery name="AllProductContentAssign" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT DISTINCT
				tslatproductcontentassign.ContentID as 'ContentID',
				tslatproductcontentassign.ProductID as 'ProductID',
				tcontent.Path as 'Path',
				SUBSTRING(tcontent.path, 1, 35) as 'Path1',
				SUBSTRING(tcontent.path, 37, 35) as 'Path37',
				SUBSTRING(tcontent.path, 73, 35) as 'Path73',
				SUBSTRING(tcontent.path, 109, 35) as 'Path109',
				SUBSTRING(tcontent.path, 145, 35) as 'Path145',
				SUBSTRING(tcontent.path, 181, 35) as 'Path181',
				SUBSTRING(tcontent.path, 217, 35) as 'Path217',
				SUBSTRING(tcontent.path, 253, 35) as 'Path253'
			FROM
				tslatproductcontentassign
			  INNER JOIN
			  	tcontent on tslatproductcontentassign.ContentID = tcontent.ContentID
		</cfquery>
		
		<cfreturn AllProductContentAssign />
	</cffunction>
	
	<cffunction name="getProductsInCategory" access="package" output="false" retruntype="query" hint="This Function returns the products that are related to any ContentID">
		<cfargument name="ContentID" type="string" hint="This is the ContentID that the products are related to" />
		<cfargument name="ContentPath" type="string" hint="This is the content's path so that child product relations can be called in" />
		<cfargument name="getChildCategoryProducts" type="boolean" required="true" />
		<cfargument name="OrderColumn" type="string" required="true"  />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="ActiveOnly" type="boolean" required="true" />
		
		<cfset var ReturnQuery = querynew('empty') />
		<cfset var ProductXChildCategoriesQuery = querynew('empty') />
		<cfset var ProductDataInCategoryWithChildren = querynew('empty') />
		<cfset var AllProductXCategory = querynew('empty') />
		<cfset var AllProductData = querynew("empty") />
		<cfset var PathColumn = "" />
		
		<cfset AllProductXCategory = getAllProductXCategory() />
		<cfset AllProductData = application.Slat.integrationManager.getAllProductsQuery() />
		
		<cfif arguments.getChildCategoryProducts>
			
			<cfset PathColumn = "Path#len(arguments.ContentPath)-34#" />
			
			<cfquery name="ProductXChildCategoriesQuery" dbtype="query">
				SELECT DISTINCT
					AllProductXCategory.ProductID
				FROM
					AllProductXCategory
				WHERE
					AllProductXCategory.#PathColumn# = '#arguments.ContentID#'					
			</cfquery>
			
			<cfquery name="ProductDataInCategoryWithChildren" dbtype="query">
				SELECT
					AllProductData.ProductID,
					AllProductData.Active,
					AllProductData.ProductCode,
					AllProductData.ProductName,
					AllProductData.BrandID,
					AllProductData.BrandName,
					AllProductData.DefaultImageID,
					AllProductData.ProductDescription,
					AllProductData.ProductExtendedDescription,
					AllProductData.DateCreated,
					AllProductData.DateAddedToWeb,
					AllProductData.DateLastUpdated,
					AllProductData.DateFirstReceived,
					AllProductData.OnTermSale,
					AllProductData.OnClearanceSale,
					AllProductData.NonInventoryItem,
					AllProductData.CallToOrder,
					AllProductData.OnlyInStore,
					AllProductData.DropShips,
					AllProductData.AllowBackorder,
					AllProductData.AllowPreorder,
					AllProductData.Weight,
					AllProductData.ProductYear,
					AllProductData.Gender,
					AllProductData.SizeChart,
					AllProductData.Ingredients,				
					AllProductData.Material,
					AllProductData.LivePrice,
					AllProductData.ListPrice,
					AllProductData.OriginalPrice,
					AllProductData.MiscPrice,
					AllProductData.QOH,
					AllProductData.QC,
					AllProductData.QOO
				FROM
					ProductXChildCategoriesQuery, AllProductData
				WHERE
				    AllProductData.ProductID = ProductXChildCategoriesQuery.ProductID
				<cfif arguments.ActiveOnly>
				  AND
				  	AllProductData.Active = '#arguments.ActiveOnly#'
				</cfif>
			</cfquery>
			
			<cfset ReturnQuery = ProductDataInCategoryWithChildren />
		<cfelse>
			<cfquery dbtype="query" name="ProductDataInCategory">
				SELECT DISTINCT
					AllProductData.ProductID,
					AllProductData.Active,
					AllProductData.ProductCode,
					AllProductData.ProductName,
					AllProductData.BrandID,
					AllProductData.BrandName,
					AllProductData.DefaultImageID,
					AllProductData.ProductDescription,
					AllProductData.ProductExtendedDescription,
					AllProductData.DateCreated,
					AllProductData.DateAddedToWeb,
					AllProductData.DateLastUpdated,
					AllProductData.DateFirstReceived,
					AllProductData.OnTermSale,
					AllProductData.OnClearanceSale,
					AllProductData.NonInventoryItem,
					AllProductData.CallToOrder,
					AllProductData.OnlyInStore,
					AllProductData.DropShips,
					AllProductData.AllowBackorder,
					AllProductData.AllowPreorder,
					AllProductData.Weight,
					AllProductData.ProductYear,
					AllProductData.Gender,
					AllProductData.SizeChart,
					AllProductData.Ingredients,				
					AllProductData.Material,
					AllProductData.LivePrice,
					AllProductData.ListPrice,
					AllProductData.OurPrice,
					AllProductData.MiscPrice,
					AllProductData.QOH,
					AllProductData.QC,
					AllProductData.QOO
				FROM
					AllProductXCategory, ProductData
				WHERE
				    AllProductData.ProductID = AllProductXCategory.ProductID
				<cfif arguments.ActiveOnly>
				  AND
				  	AllProductData.Active = '1'
				</cfif>
				  AND
					AllProductXCategory.CategoryID = '#arguments.CategoryID#'
			</cfquery>
			<cfset ReturnQuery = "" />
			<cfset ReturnQuery = ProductDataInCategory />
		</cfif>
		
		<cfreturn ReturnQuery />
	</cffunction>

	<cffunction name="getProductsByFilter" access="package" output="false" retruntype="query">
		<cfargument name="CategoryProductsQuery" type="query" required="true" />
		<cfargument name="Filter" type="struct" required="true" />
		<cfargument name="Range" type="struct" required="true" />
		<cfargument name="Keyword" type="string" required="true" />
		<cfargument name="OrderColumn" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="ActiveOnly" type="boolean" required="true" />
		
		
		<cfset var I = 0 />
		<cfset var Lower = 0 />
		<cfset var ThisIsFirst = 0 />
		<cfset var FilterValue = "" />
		<cfset var ThisFilter = "" />
		<cfset var RangeValue = "" />
		<cfset var ThisRange = "" />
		<cfset var TotalScore = 0 />
		<cfset var CountProductCode = 0/>
		<cfset var CountBrand = 0/>
		<cfset var CountProductName = 0/>
		<cfset var CountProductYear = 0/>
		<cfset var CountGender = 0/>
		<cfset var CountProductDescription = 0 />
		<cfset var FindBrand = 0 />
		<cfset var FindProductName = 0 />
		<cfset var FindProductDescription = 0 />
		<cfset var FinishedProductData = queryNew('empty') />
		<cfset var ContentProductData = queryNew('empty') />
		<cfset var ProductDataAfterFilter = querynew('empty') />
		<cfset var ProductDataFilteredAndScored = querynew('empty') />
		<cfset var ActualOrderColumn = "" />
		
		<cfset arguments.Keyword = Replace(arguments.Keyword," ",",","all") />
		<cfset ContentProductData = arguments.CategoryProductsQuery />
		
		<cfif arguments.OrderDirection eq "A">
			<cfset arguments.OrderDirection = "ASC" />
		<cfelse>
			<cfset arguments.OrderDirection = "DESC" />
		</cfif>
		
		<cfquery dbtype="query" name="ProductDataAfterFilter">
			SELECT
				ContentProductData.ProductID,
				ContentProductData.Active,
				ContentProductData.ProductCode,
				ContentProductData.ProductName,
				ContentProductData.BrandID,
				ContentProductData.BrandName,
				ContentProductData.DefaultImageID,
				ContentProductData.ProductDescription,
				ContentProductData.ProductExtendedDescription,
				ContentProductData.DateCreated,
				ContentProductData.DateAddedToWeb,
				ContentProductData.DateLastUpdated,
				ContentProductData.DateFirstReceived,
				ContentProductData.OnTermSale,
				ContentProductData.OnClearanceSale,
				ContentProductData.NonInventoryItem,
				ContentProductData.CallToOrder,
				ContentProductData.OnlyInStore,
				ContentProductData.DropShips,
				ContentProductData.AllowBackorder,
				ContentProductData.AllowPreorder,
				ContentProductData.Weight,
				ContentProductData.ProductYear,
				ContentProductData.Gender,
				ContentProductData.SizeChart,
				ContentProductData.Ingredients,				
				ContentProductData.Material,
				ContentProductData.LivePrice,
				ContentProductData.ListPrice,
				ContentProductData.OriginalPrice,
				ContentProductData.MiscPrice,
				ContentProductData.QOH,
				ContentProductData.QC,
				ContentProductData.QOO,
				.01 as SearchScore
			FROM
				ContentProductData
			WHERE
			<cfloop collection="#arguments.Filter#" item="ThisFilter">
				<cfset FilterValue = arguments.Filter[#ThisFilter#] />
			  	<cfif find("^", #FilterValue#)>
			  		(
			  		<cfloop list="#FilterValue#" delimiters="^" index="I">
			  				#ThisFilter# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#"> or
			  		</cfloop>
					1=0)
				<cfelse>
			  			#ThisFilter# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FilterValue#">
				</cfif>
				 AND 
			</cfloop>
			<cfloop collection="#arguments.Range#" item="ThisRange">
				<cfset RangeValue = arguments.Range[#ThisRange#] />
				<cfset lower= 1>
				<cfloop list="#RangeValue#" delimiters="^" index="i">
					<cfif lower>
						<cfset lower=0>
						#ThisRange# > <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#"> AND			
					<cfelse>
						#ThisRange# < <cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#i#">	
					</cfif>
			  	</cfloop>
				 AND 
			</cfloop>
				1=1
				<cfif arguments.ActiveOnly>
				  AND
				  	ContentProductData.Active = '1'
				</cfif>
			ORDER BY
				<cfset thisisfirst = 1>
				<cfloop list="#OrderColumn#" delimiters="^" index="I" >
					<cfif thisisfirst>
						<cfset thisisfirst = 0>
					<cfelse>
						,
					</cfif>
					<cfset ActualOrderColumn = "#I#" />
					#ActualOrderColumn# #arguments.orderdirection#
				</cfloop>
		</cfquery>
		
		<cfif len(arguments.Keyword) gt 1 and ProductDataAfterFilter.recordcount gt 1>
			<cfset arguments.Keyword = Replace(arguments.Keyword,"+",",","all") />
			<cfset arguments.Keyword = Replace(arguments.Keyword," ",",","all") />
			<cfloop query="ProductDataAfterFilter">
				<cfset TotalScore = 0 />
				<cfset CountProductCode = 0/>
				<cfset CountBrand = 0/>
				<cfset CountProductName = 0/>
				<cfset CountProductYear = 0/>
				<cfset CountGender = 0/>
				<cfset CountProductDescription = 0 />
				
				<cfset TempGender = REReplace(Replace(UCASE(ProductDataAfterFilter.Gender),"S",""), "[^0-9a-zA-Z_]", "", "ALL") />

				<cfloop list="#arguments.Keyword#" index="I">
					<cfif I eq ProductDataAfterFilter.ProductCode>
						<cfset CountProductCode = 1 />
					</cfif>
					<cfif I eq ProductDataAfterFilter.ProductYear>
						<cfset CountProductYear = 1 />
					</cfif>
					<cfset TempGenderKeyword = REReplace(Replace(UCASE(I),"S",""), "[^0-9a-zA-Z_]", "", "ALL") />
					<cfif TempGenderKeyword eq TempGender>
						<cfset CountGender = 1 />
					</cfif>
					
					<cfset FindBrand = FindNoCase(I,ProductDataAfterFilter.BrandName,0) />
					<cfset FindProductName = FindNoCase(I,ProductDataAfterFilter.ProductName,0) />
					<cfset FindProductDescription = FindNoCase(I,ProductDataAfterFilter.ProductDescription,0) />
					<cfloop condition="#FindBrand# gt 0 or #FindProductName# gt 0 or #FindProductDescription# gt 0">
						<cfif FindBrand gt 0>
							<cfset CountBrand = CountBrand+1 />
							<cfset FindBrand = FindNoCase(I,ProductDataAfterFilter.BrandName,#FindBrand#+1) />
						</cfif>
						<cfif FindProductName gt 0>
							<cfset FindProductName = FindNoCase(I,ProductDataAfterFilter.ProductName,#FindProductName#+1) />
							<cfset CountProductName = CountProductName+1 />
						</cfif>
						<cfif FindProductDescription gt 0>
							<cfset CountProductDescription = CountProductDescription+1 />
							<cfset FindProductDescription = FindNoCase(I,ProductDataAfterFilter.ProductDescription,#FindProductDescription#+1) />
						</cfif>
					</cfloop>
					
				</cfloop>

				<cfset TotalScore = TotalScore + (CountProductCode * .9) + (CountBrand * .5) + (CountProductName * .2) + (CountProductYear * .4) + (CountGender * .4) + (CountProductDescription * .05) />
				<cfset QuerySetCell(ProductDataAfterFilter, 'SearchScore', '#TotalScore#', #ProductDataAfterFilter.currentRow#) />
				
			</cfloop>
			
			<cfquery dbtype="query" name="ProductDataFilteredAndScored">
				Select
					*
				From
					ProductDataAfterFilter
				Where
					ProductDataAfterFilter.SearchScore > 0.01
				Order By
					ProductDataAfterFilter.SearchScore Desc
			</cfquery>
			
			<cfset FinishedProductData = ProductDataFilteredAndScored />
		<cfelse>
			<cfset FinishedProductData = ProductDataAfterFilter />
		</cfif>
		
		<cfreturn FinishedProductData />
	</cffunction>

	<cffunction name="getSubContentFilterOptions" access="package" output="false" retruntype="query">
		<cfargument name="ContentID" type="string" required="true">
		
		<cfset var AllProductXCategory = getAllProductXCategory() />
		<cfset var CurrentFilterProducts = Duplicate(request.Slat.Content.ProductsByFilterQuery) />
		
		<cfset var SubContentQuery = querynew('empty') />
		<cfset var ProductXSubContentQuery = querynew('empty') />
		<cfset var ProductXSubContentFilterQuery = querynew('empty') />
		<cfset var PathColumn = "" />
		
		
		<cfquery name="SubContentQuery" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT DISTINCT
				tcontent.contentid as 'ContentID',
				tcontent.parentid as 'ParentID',
				tcontent.path as 'Path',
				tcontent.MenuTitle as 'MenuTitle',
				tcontent.filename as 'Filename'
			FROM
				tcontent
			WHERE
				tcontent.parentid = '#arguments.ContentID#'
			ORDER BY
				MenuTitle ASC
		</cfquery>
		
		<cfif not SubContentQuery.recordcount eq 0>
			<cfset PathColumn = "Path#len(SubContentQuery.Path)-34#" />
			
			<cfquery name="ProductXSubContentQuery" dbtype="query">
				SELECT DISTINCT
					SubContentQuery.ContentID,
					SubContentQuery.ParentID,
					SubContentQuery.Path,
					SubContentQuery.MenuTitle,
					SubContentQuery.Filename,
					AllProductXCategory.ProductID
				FROM
					SubContentQuery, AllProductXCategory
				WHERE
					AllProductXCategory.#PathColumn# = SubContentQuery.ContentID
			</cfquery>
			
			<cfquery name="ProductXSubContentFilterQuery" dbtype="query">
				SELECT
					ProductXSubContentQuery.ContentID,
					ProductXSubContentQuery.ParentID,
					ProductXSubContentQuery.Path,
					ProductXSubContentQuery.MenuTitle,
					ProductXSubContentQuery.Filename,
					COUNT(ProductXSubContentQuery.ProductID) as ProductCount
				FROM
					ProductXSubContentQuery, CurrentFilterProducts
				WHERE
					ProductXSubContentQuery.ProductID = CurrentFilterProducts.ProductID
				GROUP BY
					ProductXSubContentQuery.ContentID,
					ProductXSubContentQuery.ParentID,
					ProductXSubContentQuery.Path,
					ProductXSubContentQuery.MenuTitle,
					ProductXSubContentQuery.Filename
			</cfquery>
			
		</cfif>
		
		<cfreturn ProductXSubContentFilterQuery />
	</cffunction>

	<cffunction name="getFilterOptions" access="package" output="false" retruntype="query">
		<cfargument name="ProductsQuery" type="query" required="true" />
		<cfargument name="Filter" type="string" required="true" />
		<cfargument name="OrderDirection" type="string" required="true" />
		<cfargument name="OrderByCount" type="numeric" required="true" />
		
		<cfset var ThisCategoryProductsQuery = arguments.ProductsQuery />
		<cfset var FilterOptionsByColumn = querynew('empty') />
		<cfset var FilterOptionsByCount = querynew('empty') />
		<cfset var FinalFilterOptionsQuery = querynew('empty') />
		
		<cfif arguments.OrderDirection eq "A">
			<cfset arguments.OrderDirection = "ASC" />
		<cfelse>
			<cfset arguments.OrderDirection = "DESC" />
		</cfif>

		<cfquery dbtype="query" name="FilterOptionsByColumn">
			SELECT
				ThisCategoryProductsQuery.#Filter#,
				count(ThisCategoryProductsQuery.#Filter#)
			FROM
				ThisCategoryProductsQuery
			GROUP BY
				ThisCategoryProductsQuery.#Filter#
			ORDER BY
				ThisCategoryProductsQuery.#Filter# #arguments.OrderDirection#
		</cfquery>

		<cfif OrderByCount>
			<cfquery dbtype="query" name="FilterOptionsByCount">
				SELECT
					FilterOptionsByColumn.#Filter#,
					FilterOptionsByColumn.COLUMN_1
				FROM
					FilterOptionsByColumn
				ORDER BY
					FilterOptionsByColumn.COLUMN_1 #arguments.OrderDirection#
			</cfquery>
			
			<cfset FinalFilterOptionsQuery = FilterOptionsByCount />
		<cfelse>
			<cfset FinalFilterOptionsQuery = FilterOptionsByColumn />
		</cfif>
		
		<cfreturn FinalFilterOptionsQuery />
	</cffunction>
	
	<cffunction name="getContentByProductID" access="package" output="false" retruntype="query">
		<cfargument name="ProductID" type="string" required="true" />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				ContentID as 'ContentID',
				ProductID as 'ProductID'
			FROM
				tslatproductcontentassign
			WHERE
				ProductID = '#arguments.ProductID#'
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="addProductToContent" access="package" output="false">
		<cfargument name="ProductID" type="string" required="true" >
		<cfargument name="ContentID" type="string" required="true" >
		
		<cfset var ExistingContent = getContentByProductID(ProductID=arguments.ProductID) />
		
		<cfset AddAssociation = 1>
		
		<cfloop query="ExistingContent">
			<cfif ExistingContent.ContentID eq arguments.ContentID>
				<cfset AddAssociation = 0>
			</cfif>
		</cfloop>
		
		<cfif AddAssociation>
			<cfquery name="insertProductInCategory" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				INSERT INTO 
					tslatproductcontentassign (ContentID, ProductID) 
				VALUES 
					('#arguments.ContentID#', '#arguments.ProductID#')
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="removeProductFromContent" access="package" output="false">
		<cfargument name="ProductID" type="string" required="true" >
		<cfargument name="ContentID" type="string" required="true" >
		
		<cfquery name="deleteProductFromCategory" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
			DELETE FROM
				tslatproductcontentassign 
			WHERE
				ContentID = '#arguments.ContentID#' AND ProductID = '#arguments.ProductID#'
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>