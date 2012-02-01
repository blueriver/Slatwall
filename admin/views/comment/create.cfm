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
<div class="svoadmincommentcreate">
	<form name="addComment" method="post" action="#buildURL(action="admin:comment.create")#" />
		
		<cfif structKeyExists(rc, "brand") and isObject(rc.brand)>
			<input type="hidden" name="brands" value="#rc.brand.getBrandID()#" />
			<input type="hidden" name="returnURL" value="#buildURL(action='admin:brand.detail', queryString="brandID=#rc.brand.getBrandID()#")#" />
		</cfif>
		
		<cfif structKeyExists(rc, "product") and isObject(rc.product)>
			<input type="hidden" name="products" value="#rc.product.getProductID()#" />
			<input type="hidden" name="returnURL" value="#buildURL(action='admin:product.detail', queryString="productID=#rc.product.getProductID()#")#" />
		</cfif>
		
		<cfif structKeyExists(rc, "order") and isObject(rc.order)>
			<input type="hidden" name="orders" value="#rc.order.getOrderID()#" />
			<input type="hidden" name="returnURL" value="#buildURL(action='admin:order.detail', queryString="orderID=#rc.order.getOrderID()#")#" />
		</cfif>
		
		<dl class="oneColumn">
			<dt>New Comment</dt>
			<dd><cf_SlatwallFormField fieldType="textarea" fieldName="comment"> </dd>
		</dl>
		<button type="submit">Add Comment</button>
	</form>
</div>
</cfoutput>
