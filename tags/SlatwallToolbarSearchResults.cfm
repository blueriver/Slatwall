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
<cfparam name="attributes.searchResults" type="struct" default="#structNew()#" />
<cfparam name="attributes.keywords" type="string" default="" />

<cfset local.fw = application.slatwall.pluginConfig.getApplication().getValue("fw") />

<cfsilent>
	<cfset local.hasProducts = false />
	<cfset local.hasProductTypes = false /> 
	<cfset local.hasBrands = false /> 
	<cfset local.hasOrders = false /> 
	<cfset local.hasAccounts = false /> 
	
	<cfif structKeyExists(attributes.searchResults, "products") && arrayLen(attributes.searchResults.products.getPageRecords())>
		<cfset local.hasProducts = true /> 
	</cfif>
	<cfif structKeyExists(attributes.searchResults, "productTypes") && arrayLen(attributes.searchResults.productTypes.getPageRecords())>
		<cfset local.hasProductTypes = true /> 
	</cfif>
	<cfif structKeyExists(attributes.searchResults, "brands") && arrayLen(attributes.searchResults.brands.getPageRecords())>
		<cfset local.hasBrands = true /> 
	</cfif>
	<cfif structKeyExists(attributes.searchResults, "orders") && arrayLen(attributes.searchResults.orders.getPageRecords())>
		<cfset local.hasOrders = true /> 
	</cfif>
	<cfif structKeyExists(attributes.searchResults, "accounts") && arrayLen(attributes.searchResults.accounts.getPageRecords())>
		<cfset local.hasAccounts = true /> 
	</cfif>
</cfsilent>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="searchResults">
			<cfif not local.hasProducts and not local.hasProductTypes and not local.hasBrands and not local.hasOrders and not local.hasAccounts>
				<div class="twoColumn">
					<ul>
						<li class="title">No results for keyword: #attributes.keywords#</li>
					</ul>
				</div>
			<cfelse>
				<cfif local.hasProducts>
					<div class="twoColumn">
						<ul>
							<li class="title">Products</li>
							<cfloop array="#attributes.searchResults.products.getPageRecords()#" index="product">
								<li><a href="#local.fw.buildURL(action='admin:product.detail', queryString='productID=#product.getProductID()#')#">#product.getBrand().getBrandName()# - #product.getProductName()#</a></li>
							</cfloop>
							<cfif arrayLen(attributes.searchResults.products.getPageRecords()) eq 14>
								<li><a href="#local.fw.buildURL(action='admin:product.list', queryString='keywords=#attributes.keywords#')#">... View All Products</a></li>
							</cfif>
						</ul>
					</div>
				</cfif>
				<cfif local.hasBrands or local.hasProductTypes>
					<div class="oneColumn">
						<cfif local.hasBrands>
							<ul>
								<li class="title">Brands</li>
								<cfloop array="#attributes.searchResults.brands.getPageRecords()#" index="brand">
									<li><a href="#local.fw.buildURL(action='admin:brand.detail', queryString='brandID=#brand.getBrandID()#')#">#brand.getBrandName()#</a></li>
								</cfloop>
								<cfif arrayLen(attributes.searchResults.brands.getPageRecords()) eq 7>
									<li><a href="#local.fw.buildURL(action='admin:brand.list', queryString='keywords=#attributes.keywords#')#">... View All Brands</a></li>
								</cfif>
							</ul>
						</cfif>
						<cfif local.hasProductTypes>
							<ul>
								<li class="title">Product Types</li>
								<cfloop array="#attributes.searchResults.productTypes.getPageRecords()#" index="productType">
									<li><a href="#local.fw.buildURL(action='admin:product.detailproducttype', queryString='productTypeID=#productType.getProductTypeID()#')#">#productType.getProductTypeName()#</a></li>
								</cfloop>
								<cfif arrayLen(attributes.searchResults.productTypes.getPageRecords()) eq 7>
									<li><a href="#local.fw.buildURL(action='admin:product.listproducttypes', queryString='keywords=#attributes.keywords#')#">... View All Product Types</a></li>
								</cfif>
							</ul>
						</cfif>
					</div>
				</cfif>
				<cfif local.hasOrders or local.hasAccounts>
					<div class="oneColumn">
						<cfif local.hasOrders>
							<ul>
								<li class="title">Orders</li>
								<cfloop array="#attributes.searchResults.orders.getPageRecords()#" index="order">
									<li><a href="#local.fw.buildURL(action='admin:order.detail', queryString='orderID=#order.getOrderID()#')#">#order.getOrderNumber()# - #order.getAccount().getFullName()#</a></li>
								</cfloop>
								<cfif arrayLen(attributes.searchResults.orders.getPageRecords()) eq 7>
									<li><a href="#local.fw.buildURL(action='admin:order.list', queryString='keywords=#attributes.keywords#')#">... View All Orders</a></li>
								</cfif>
							</ul>
						</cfif>
						<cfif local.hasAccounts>
							<ul>
								<li class="title">Accounts</li>
								<cfloop array="#attributes.searchResults.accounts.getPageRecords()#" index="account">
									<li><a href="#local.fw.buildURL(action='admin:account.detail', queryString='accountID=#account.getAccountID()#')#">#account.getFullName()#</a></li>
								</cfloop>
								<cfif arrayLen(attributes.searchResults.accounts.getPageRecords()) eq 7>
									<li><a href="#local.fw.buildURL(action='admin:account.list', queryString='keywords=#attributes.keywords#')#">... View All Accounts</a></li>
								</cfif>
							</ul>
						</cfif>
					</div>
				</cfif>
			</cfif>
		</div>
	</cfoutput>
</cfif>