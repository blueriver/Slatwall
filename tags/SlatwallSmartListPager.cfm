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
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.smartList" type="any" />
	
	<cfsilent>
		<cfset local.showPreviousDots = false />
		<cfset local.showNextDots = false />
		<cfset local.pageStart = 1 />
		<cfset local.pageCount = 2 />
		
		<!--- If there are less than 5 pages, then we just show everything --->
		<cfif attributes.smartList.getTotalPages() lte 5>
			<cfset local.pageCount = attributes.smartList.getTotalPages() />
		<cfelse>
			<cfif attributes.smartList.getTotalPages() - 1 gt attributes.smartList.getCurrentPage()>
				<cfset local.showNextDots = true />
			</cfif>
			<cfif attributes.smartList.getCurrentPage() gt 2>
				<cfset local.showPreviousDots = true />
				<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
					<cfset local.pageStart = attributes.smartList.getCurrentPage() - 1 />
				<cfelse>
					<cfset local.pageStart = attributes.smartList.getTotalPages() - 2 />
				</cfif>
			</cfif>
		</cfif>
		
		<cfset local.pageEnd = local.pageStart + local.pageCount />
	</cfsilent>
	
	<cfoutput>
		<div class="pagination" data-tableid="#attributes.smartList.getSavedStateID()#">
			<cfif attributes.smartList.getTotalPages() gt 1>
				<ul>
					<cfif attributes.smartList.getCurrentPage() gt 1>
						<li><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() - 1#')#" class="listing-pager" data-page="#attributes.smartList.getCurrentPage() - 1#">Prev</a></li>
					</cfif>
					<cfif local.showPreviousDots>
						<li><a href="#attributes.smartList.buildURL('P:Current=1')#" class="listing-pager" data-page="1">1</a></li>
						<li class="disabled"><a href="##">...</a></li>
					</cfif>
					<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
						<li <cfif attributes.smartList.getCurrentPage() eq i>class="active"</cfif>><a href="#attributes.smartList.buildURL('P:Current=#i#')#" class="listing-pager" data-page="#i#">#i#</a></li>
					</cfloop>
					<cfif local.showNextDots>
						<li class="disabled"><a href="##">...</a></li>
						<li><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getTotalPages()#')#" class="listing-pager" data-page="#attributes.smartList.getTotalPages()#">#attributes.smartList.getTotalPages()#</a></li>
					</cfif>
					<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
						<li><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() + 1#')#" class="listing-pager" data-page="#attributes.smartList.getCurrentPage() + 1#">Next</a></li>
					</cfif>
				</ul>
			</cfif>
		</div>
	</cfoutput>
</cfif>