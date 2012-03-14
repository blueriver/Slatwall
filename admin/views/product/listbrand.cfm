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
<cfparam name="rc.brandSmartList" type="any" />

<cfoutput>
	
<cf_SlatwallActionBar type="listing" object="#rc.brandSmartList#" rc="#rc#" />

<cfif rc.brandSmartList.getRecordsCount()>
	<table id="ProductBrands" class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>
					<div class="dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">#rc.$.Slatwall.rbKey("entity.brand.brandName")# <span class="caret"></span> </a>
						<ul class="dropdown-menu">
							<li><a href="">Sort Ascending</a></li>
							<li><a href="">Sort Decending</a></li>
							<li class="divider"></li>
						</ul>
					</div>
				</th>
				<th>
					<div class="dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown">#rc.$.Slatwall.rbKey("entity.brand.brandWebsite")# <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="">Sort Ascending</a></li>
							<li><a href="">Sort Decending</a></li>
							<li class="divider"></li>
						</ul>
					</div>
				</th>
				<th>
					&nbsp;
				</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#rc.brandSmartList.getPageRecords()#" index="Local.Brand">
				<tr>
					<td class="primary"><cf_SlatwallActionCaller action="admin:product.detailbrand" querystring="brandID=#local.brand.getBrandID()#" text="#local.Brand.getBrandName()#"></td>
					<td><a href="#Local.Brand.getBrandWebsite()#" target="_blank">#local.Brand.getBrandWebsite()#</a></td>
					<td class="administration">
						<cf_SlatwallActionCaller action="admin:product.editbrand" querystring="brandID=#local.brand.getBrandID()#" class="btn btn-mini" icon="edit" iconOnly="true">            
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	<cf_SlatwallSmartListPager smartList="#rc.brandSmartList#" />
<cfelse>
	<em>#rc.$.Slatwall.rbKey("admin.brand.nobrandsdefined")#</em>
</cfif>


</cfoutput>
