<cfparam name="rc.edit" default="false" >
<cfparam name="rc.productType" type="any" />
<cfparam name="rc.parentProductTypeID" type="string" default="" />

<!--- set up options for setting select boxes --->
<cfset local.Options = [{id="1",name=rc.$.Slatwall.rbKey('sitemanager.yes')},{id="0",name=rc.$.Slatwall.rbKey('sitemanager.no')}] />
<cfset local.defaultOption = {id="",name=rc.$.Slatwall.rbKey('setting.inherit')} />


<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.listproducttypes" type="list">
	<cfif !rc.edit><cf_ActionCaller action="admin:product.editproducttype" querystring="productTypeID=#rc.productType.getProductTypeID()#" type="list"></cfif>
</ul>

<cfif rc.edit>
<form name="ProductTypeForm" id="ProductTypeForm" action="#buildURL(action='admin:product.saveproducttype')#" method="post">
<input type="hidden" id="productTypeID" name="productTypeID" value="#rc.productType.getProductTypeID()#" />
</cfif>
    <dl class="twoColumn">
    	<cf_PropertyDisplay object="#rc.productType#" property="productTypeName" edit="#rc.edit#" first="true">
		<cfif rc.edit>
		<cfset local.tree = rc.productTypeTree />
		<dt>
			<label for="parentProductType_productTypeID">Parent Product Type</label>
		</dt>
		<dd>
		<select name="parentProductType" id="parentProductType_productTypeID">
            <option value=""<cfif isNull(rc.productType.getParentProductType())> selected</cfif>>None</option>
        <cfloop query="local.tree">
		    <cfif not listFind(local.tree.path,rc.productType.getProductTypeName())><!--- can't be child of itself or any of its children --->
            <cfset ThisDepth = local.tree.TreeDepth />
            <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
            <option value="#local.tree.productTypeID#"<cfif (!isNull(rc.productType.getParentProductType()) and rc.productType.getParentProductType().getProductTypeID() eq local.tree.productTypeID) or rc.parentProductTypeID eq local.tree.productTypeID> selected="selected"</cfif>>
                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##local.tree.productTypeName#
            </option>
			</cfif>
        </cfloop>
        </select>	
		</dd>
		<cfelse>
			<cf_PropertyDisplay object="#rc.productType#" property="parentProductType" propertyObject="productType" nullValue="#rc.$.Slatwall.rbKey('admin.none')#" edit="false">
		</cfif>
	</dl>
	<table class="stripe" id="productTypeSettings">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey('admin.product.producttypesettings')#</th>
			<th></th>
		</tr>
		<cf_PropertyDisplay object="#rc.productType#" property="trackInventory" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="showOnWeb" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="showOnWebWholesale" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="callToOrder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="allowShipping" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="allowPreorder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="allowBackorder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="allowDropShip" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		<cf_PropertyDisplay object="#rc.productType#" property="manufactureDiscontinued" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
	</table>
<cfif rc.edit>
	<div id="actionButtons" class="clearfix">
		<a href="javascript: history.go(-1)" class="button">#rc.$.Slatwall.rbKey("sitemanager.cancel")#</a>
		<cfif !rc.productType.isNew() and !rc.productType.hasProducts() and !rc.productType.hasSubProductTypes()>
		<cf_ActionCaller action="admin:product.deleteproducttype" querystring="producttypeid=#rc.producttype.getproducttypeID()#" class="button" type="link" confirmrequired="true">
		</cfif>
		<cf_ActionCaller action="admin:product.saveproducttype" confirmrequired="true" type="submit">
	</div>
</form>
</cfif>
</cfoutput>