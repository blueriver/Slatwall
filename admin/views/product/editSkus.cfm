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
<cfoutput>
<table>
	<tr>
		<th>Company SKU</th>
		<th>Original Price</th>
		<th>List Price</th>
		<th>QOH</th>
		<th>QOO</th>
		<th>QC</th>
		<th>QIA</th>
		<th>QEA</th>
		<th>Image Path</th>
		<th></th>
	</tr>
	<cfset local.arrayIndex = 1 />
	<cfloop array="#local.skus#" index="local.thisItem">
	<tr>			
		<td><input type="text" name="SKU#local.arrayIndex#_SKUID" id="SKU#local.arrayIndex#_SKUID" value="#local.thisItem.getSkuID()#" /></td>
		<td><input type="text" name="SKU#local.arrayIndex#_originalPrice" id="SKU#local.arrayIndex#_originalPrice" value="#local.thisItem.getOriginalPrice()#" /></td>
		<td><input type="text" name="SKU#local.arrayIndex#_listPrice" id="SKU#local.arrayIndex#_listPrice" value="#local.thisItem.getListPrice()#" /></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<cfset local.arrayIndex++ />
	</cfloop>
</table>
</cfoutput>
