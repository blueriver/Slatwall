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
	<cfif arrayLen(rc.product.getImages())>
	<table class="stripe">
		<tr>
			<th>#$.slatwall.rbKey("admin.product.alternateImages.preview")#</th>
			<th>#$.slatwall.rbKey("entity.image.imageType")#</th>
			<th>#$.slatwall.rbKey("entity.image.imageName")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.image.imageDescription")#</th>
			<th class="administration">&nbsp;</th>
		</tr>
	<cfloop array="#rc.product.getImages()#" index="local.image" >
		<cfif len(local.image.getImageID())>
		<tr>
			<td>#local.image.getImage(height="120", width="120")#</td>
			<td>#local.image.getImageType().getType()#</td>
			<td>#local.image.getImageName()#</td>
			<td class="varWidth">#local.image.getImageDescription()#</td>
			<td class="administration">
				<ul class="one">
					<cf_SlatwallActionCaller action="admin:product.deleteImage" querystring="imageID=#local.image.getImageID()#&productID=#rc.product.getProductID()#" confirmRequired="true" class="delete" type="list">
				</ul>
			</td>
		</tr>
		</cfif>
	</cfloop>
	</table>
	<cfelse>
		<em>#$.slatwall.rbKey("admin.product.alternateImages.noAlternateImagesExist")#</em>
	</cfif>
	<cfif rc.edit>
		<!---<cf_SlatwallActionCaller action="admin:product.uploadAlternateImage" queryString="productID=#rc.product.getProductID()#" type="link" class="button">--->
		<h4>#$.slatwall.rbKey("admin.product.alternateImages.uploadimage")#</h4>
		<input type="file" id="productImageFile" class="imageFile" name="productImageFile" accept="image/gif, image/jpeg, image/jpg, image/png">
		<cf_SlatwallPropertyDisplay object="#rc.image#" propertyObject="Type" fieldName="image.imageType" property="imageType" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageName" fieldName="image.imageName" edit="true">
		<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageDescription" fieldName="image.imageDescription" editType="textarea" edit="true">
		
<!---	<div id="actionButtons" class="clearfix">
			<input type="submit" class="button uploadImage" id="adminproductuploadProductImage" title="Upload Image" value="#rc.$.Slatwall.rbKey('admin.product.uploadAlternateImage')#" disabled="true" />
		</div>--->
	</cfif>	
</cfoutput>