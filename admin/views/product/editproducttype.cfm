<cfparam name="rc.productType" type="any" />
<cfparam name="rc.productTypeTree" type="query" />
<cfparam name="rc.parentProductTypeID" type="string" default="" />

<cfset local.tree = rc.productTypeTree />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.listproducttypes" type="list">
</ul>
<form name="ProductTypeForm" id="ProductTypeForm" action="?action=admin:product.saveproducttype" method="post">
<input type="hidden" id="productTypeID" name="productTypeID" value="#rc.productType.getProductTypeID()#" />
    <dl class="oneColumn">
    	<cf_PropertyDisplay object="#rc.productType#" property="productType" edit="true" first="true">
		<dt>
			<label for="parentProductType_productTypeID">Parent Product Type</label>
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
<a href="javascript: history.go(-1)" class="button">#rc.$.Slatwall.rbKey("admin.nav.back")#</a>
<cfif !rc.productType.isNew() and !rc.productType.getIsAssigned() and !arrayLen(rc.productType.getSubProductTypes())>
<cf_ActionCaller action="admin:product.deleteproducttype" querystring="producttypeid=#rc.producttype.getproducttypeID()#" class="button" type="link" confirmrequired="true">
</cfif>
<cf_ActionCaller action="admin:product.saveproducttype" confirmrequired="true" type="submit">
</form>
Products: #arraylen(rc.productType.getProducts())#
</cfoutput>