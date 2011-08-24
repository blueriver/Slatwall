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
	<div class="svoadminsettingdetaildbtools">
		<ul id="navTask">
			
		</ul>
		<h2>Delete All Orders</h2>
		<form action="#buildURL(action='admin:setting.deleteallorders')#" method="post">
			<p>This will delete Orders, Carts and all other related data like Payments & Deliveries<br />Only Click this button if you are 100% sure that you want to remove all orders.</p>
			<br />
			<br />
			Confirm Delete: <input type="checkbox" name="confirmDelete" value="1" />
			<cf_SlatwallActionCaller action="admin:setting.deleteallorders" type="submit" class="button" confirmRequired="true">
		</form>
		<hr />
		<h2>Delete All Products (and Orders)</h2>
		<form action="#buildURL(action='admin:setting.deleteallproducts')#" method="post">
			<p>Only Click this button if you are 100% sure that you want to remove all products. <br />This will delete, Orders, Carts, Products, Stock, Skus, Attribute Values, ect.</p>
			<ul>
				<li>Delete Brands: <input type="checkbox" name="deleteBrands" value="1" /></li>
				<li>Delete Product Types: <input type="checkbox" name="deleteProductTypes" value="1" /></li>
				<li>Delete Product Options: <input type="checkbox" name="deleteOptions" value="1" /></li>
			</ul>
			<br />
			<br />
			Confirm Delete: <input type="checkbox" name="confirmDelete" value="1" />
			<cf_SlatwallActionCaller action="admin:setting.deleteallproducts" type="submit" class="button" confirmRequired="true">
		</form>
		<hr /><applet></applet>
	</div>
</cfoutput>