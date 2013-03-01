<!---
	
    Slatwall - An Open Source eCommerce Platform
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
																								
	This template is designed to display a list of products.  In order to do that Slatwall uses	
	a utility called a "SmartList".  The SmartList allows for you to easily add do common		
	listing tasks: Search, Filter, Range Filter, Paging, ect.									
																								
	Anywhere on your site you can use the following to get the current productList:				
																								
	$.slatwall.getProductSmartList()															
																								
	The product list will always have these filters set by default:								
																								
	activeFlag = 1																				
	publishedFlag = 1																			
	(calculatedQATS > 0 or calculatedAllowBackorderFlag = 1)									
																								
	Whenever you are on a content page that has been flaged as a 'Slatwall Listing Page'		
	the $.slatwall.productList() will also include the filter to only show products that have	
	been explicitly assigned to that page in the admin.  In addition this view will be			
	automatically included on content flaged as such.											
																								
	The "SmartList" has the following API methods that you can use to get details about the		
	records being returned.  This productList has access to all of those methods:				
																								
	$.slatwall.productList().getRecordsCount()													
	$.slatwall.productList().getPageRecordsStart()												
	$.slatwall.productList().getPageRecordsEnd()												
	$.slatwall.productList().getPageRecordsShow()												
	$.slatwall.productList().getCurrentPage()													
	$.slatwall.productList().getTotalPages()													
																								
	You can find detailed information on SmartList and all of the additional API methods at:	
	http://docs.getslatwall.com/#developers-reference-smart-list								
																								
--->
<cfinclude template="_slatwall-header.cfm" />
<cfoutput>
	

<!--- Product Listing Example 1 --->
<div class="container">
	<div class="row">
		<div class="span12">
			<h2>Product Listing Example 1</h2>
		</div>
	</div>
	<div class="row">
		<div class="span3">
			<!--- Filter Brand --->
			<cfset brandFilterOptions = $.slatwall.getProductSmartList().getFilterOptions('brand.brandID', 'brand.brandName') />
			<h4>Filter By Brand</h4>
			<ul class="nav">
				<cfloop array="#brandFilterOptions#" index="brandOption">
					<li><a href="#$.slatwall.getProductSmartList().buildURL( 'f:brand.brandID=#brandOption["value"]#' )#">#brandOption["name"]#</a></li>
				</cfloop>
			</ul>
			
			<!--- Price Range Filter --->
			<h4>Price Range Filter</h4>
			<ul class="nav">
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=^20' )#">less than $20.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=20^50' )#">$20.00 - $50.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=50^100' )#">$50.00 - $100.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=100^250' )#">$100.00 - $250.00</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'r:calculatedSalePrice=250^' )#">over $250.00</a></li>
			</ul>
			
			<!--- Sorting --->
			<h4>Sorting</h4>
			<ul class="nav">
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedSalePrice|ASC' )#">Price Low To High</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedSalePrice|DESC' )#">Price High To Low</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedTitle|ASC' )#">Product Title A-Z</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=calculatedTitle|DESC' )#">Product Title Z-A</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=productName|ASC' )#">Product Name A-Z</a></li>
				<li><a href="#$.slatwall.getProductSmartList().buildURL( 'orderBy=productName|DESC' )#">Product Name Z-A</a></li>
			</ul>
		</div>
		<div class="span9">
			<cfif $.slatwall.productList().getRecordsCount()>
				<ul class="thumbnails">
					<cfloop array="#$.slatwall.getProductSmartList().getPageRecords()#" index="product">
						<li class="span3">
							<div class="thumbnail">
								<img src="#product.getResizedImagePath(size='m')#" alt="#product.getCalculatedTitle()#" />
								<h5>#product.getCalculatedTitle()#</h5>
	      						<p>#product.getDescription()#</p>
								<cfif product.getPrice() gt product.getCalculatedSalePrice()>
									<p><span style="text-decoration:line-through;">#product.getPrice()#</span> <span class="text-error">#product.getFormattedValue('calculatedSalePrice')#</span></p>
								<cfelse>
									<p>#product.getFormattedValue('calculatedSalePrice')#</p>	
								</cfif>
								<a href="#product.getListingProductURL()#">Details / Buy</a>
							</div>
						</li>
					</cfloop>
				</ul>
			<cfelse>
				<p>There are currently no products to display.</p>
			</cfif>
		</div>
	</div>
</div>


</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />