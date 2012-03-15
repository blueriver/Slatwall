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
<cfparam name="attributes.smartList" type="any" />
<cfparam name="attributes.rc" type="any" />
<cfparam name="attributes.recordEditAction" type="string" default="" />

<cfif thisTag.executionMode eq "end">
	<cfoutput>
		<cfif attributes.smartList.getRecordsCount()>
			<table class="table table-striped table-bordered">
				<thead>
					<tr>
						<cfloop array="#thistag.columns#" index="column">
							<th>
								<div class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">#column.propertyIdentifier# <span class="caret"></span> </a>
									<ul class="dropdown-menu">
										<li><a href="#attributes.smartList.buildURL('orderBy=#column.propertyIdentifier#|ASC')#"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
										<li><a href="#attributes.smartList.buildURL('orderBy=#column.propertyIdentifier#|DESC')#"><i class="icon-arrow-up"></i> Sort Decending</a></li>
										<li class="divider"></li>
									</ul>
								</div>
							</th>
						</cfloop>
						<cfif attributes.recordEditAction neq "">
							<th>&nbsp;</th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#attributes.smartList.getPageRecords()#" index="record">
						<tr>
							<cfloop array="#thistag.columns#" index="column">
								<td class="#column.tdclass#">#record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
							</cfloop>
							<cfif attributes.recordEditAction neq "">
								<td>
									<cf_SlatwallActionCaller action="#attributes.recordEditAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#" class="btn btn-mini" icon="edit" iconOnly="true" />
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cf_SlatwallSmartListPager smartList="#attributes.smartList#" />
		<cfelse>
			<em>#rc.$.Slatwall.rbKey("admin.brand.listbrand.norecords")#</em>
		</cfif>
	</cfoutput>
</cfif>