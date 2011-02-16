<cfparam name="rc.productTypeTree" type="query" />
<cfparam name="rc.parentProductTypeID" default="" />
<cfset local.tree = rc.productTypeTree />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.listproducttypes" type="list">
</ul>
<form name="ProductTypeForm" id="ProductTypeForm" action="?action=admin:product.processProductTypeForm" method="post">
<input type="hidden" id="productTypeID" name="productTypeID" value="#rc.productType.getProductTypeID()#" />
    <dl class="oneColumn">
        <dt class="first">
            <label for="productType">#rc.$w.rbKey("entity.producttype.producttype")#</label>
		</dt>
		<dd>
		  <input type="text" id="productType" name="productType" value="#rc.productType.getProductType()#" />
		</dd>
		<dt>
            <label for="parentProductType">#rc.$w.rbKey("entity.producttype.parentproducttype")#</label>
        </dt>
		<dd>
		<select name="parentProductType_productTypeID" id="parentProductType_productTypeID">
            <option value=""<cfif isNull(rc.productType.getParentProductType())> selected</cfif>>None</option>
        <cfloop query="local.tree">
		    <cfif not listFind(local.tree.path,rc.productType.getProductTypeID())><!--- can't be child of itself or any of its children --->
            <cfset ThisDepth = local.tree.TreeDepth />
            <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
            <option value="#local.tree.productTypeID#"<cfif (!isNull(rc.productType.getParentProductType()) and rc.productType.getParentProductType().getProductTypeID() eq local.tree.productTypeID) or rc.parentProductTypeID eq local.tree.productTypeID> selected="selected"</cfif>>
                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##local.tree.productType#
            </option>
			</cfif>
        </cfloop>
        </select>
		
		</dd>
	</dl>
<input type="submit" value="Save" />
</form>
</cfoutput>