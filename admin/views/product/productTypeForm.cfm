<cfparam name="rc.parentTypeID" default="" />
<cfparam name="rc.productTypes" type="query" />
<cfset local.pt = rc.ProductTypes />

<cfoutput>
<form name="ProductTypeForm" id="ProductTypeForm" action="?action=admin:product.processProductTypeForm" method="post">
<input type="hidden" id="productTypeID" name="productTypeID" value="#rc.productType.getProductTypeID()#" />
    <dl class="oneColumn">
        <dt class="first">
            <label for="productType">#rc.rbFactory.getKey("product.producttype.producttypename")#</label>
		</dt>
		<dd>
		  <input type="text" id="productType" name="productType" value="#rc.productType.getProductType()#" />
		</dd>
		<dt>
            <label for="parentProductType">#rc.rbFactory.getKey("product.producttype.parentproducttype")#</label>
        </dt>
		<dd>
		<select name="parentProductType_productTypeID" id="parentProductType_productTypeID">
            <option value=""<cfif rc.parentProductTypeID EQ 0> selected</cfif>>None</option>
        <cfloop query="local.pt">
		    <cfif not listFind(local.pt.path,rc.productType.getProductType())><!--- type can't be it's own parent --->
            <cfset ThisDepth = local.pt.TreeDepth />
            <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
            <option value="#local.pt.productTypeID#"<cfif rc.parentProductTypeID eq local.pt.productTypeID or rc.parentTypeID EQ local.pt.productTypeID> selected="selected"</cfif>>
                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##local.pt.productType#
            </option>
			</cfif>
        </cfloop>
        </select>
		
		</dd>
	</dl>
<input type="submit" value="Save" />
</form>
</cfoutput>