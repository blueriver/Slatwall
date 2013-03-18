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
<cfparam name="rc.physical" type="any" />

<cfdump var="#rc.physical.getDiscrepancyQuery()#" />
<!---


Sku Code    |    Location Name    |    Discrepancy	
0981208			San Diego					-2		
0981208			New York					 2		
0981209			San Diego					 1		





TIME		| System Says | Counting | Picked for Shipping	
10:00am			1000										
10:10							100							
10:20			997								3			
10:30							300							
10:40			995								2			
10:50							595							 (Count finished)
10:55			889								6			
============================================================
11:00 RECONCILE												
				995				997							



<cfset rc.physicalCountItems = $.slatwall.getService("physicalService").listPhysicalCountItems() />

<cfoutput>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th style="white-space:normal; vertical-align: text-bottom;">Sku Code</th>
			<th style="white-space:normal; vertical-align: text-bottom;">Physical Qty</th>
			<th style="white-space:normal; vertical-align: text-bottom;">Qty #$.slatwall.rbKey('define.qiats.full')#</th>
		</tr>
		<tr class="sku">
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<cfif arrayLen(rc.locations) gt 1>
			<cfloop array="#rc.locations#" index="local.location">
				<tr class="stock">
					<td>#local.location.getLocationName()#</td>
					<td>#rc.sku.getQuantity('QOH', local.location.getLocationID())#</td>
					<td>#rc.sku.getQuantity('QIATS', local.location.getLocationID())#</td>
				</tr>
			</cfloop>
		</cfif>
	</table>	
</cfoutput>
--->