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
	<cfset local.images = rc.product.getImages() />
	<cfif arrayLen(local.images)>
	<table id="alternateImages" class="listing-grid stripe">
		<tr>
			<th>#$.slatwall.rbKey("admin.product.alternateImages.preview")#</th>
			<th>#$.slatwall.rbKey("entity.image.imageType")#</th>
			<th>#$.slatwall.rbKey("entity.image.imageName")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.image.imageDescription")#</th>
			<th class="administration">&nbsp;</th>
		</tr>
	<cfloop from="1" to="#arrayLen(local.images)#" index="local.i" >
		<cfset local.thisImage = local.images[local.i] />
		<cfif len(local.thisImage.getImageID()) && !len(local.thisImage.getErrorBean().getError("AlternateImage"))>
		<tr>
			<cfif rc.edit><input type="hidden" class="imageid" name="images[#local.i#].imageID" value="#local.thisImage.getImageID()#" /></cfif>
			<td><a href="#local.thisImage.getImagePath()#" class="lightbox<cfif !rc.edit> preview</cfif>"><cfif rc.edit>#local.thisImage.getImage(height="120", width="120")#<cfelse>#$.Slatwall.rbKey("admin.product.previewalternateimage")#</cfif></a></td>
			<td><cf_SlatwallPropertyDisplay id="imageType#local.i#" object="#local.thisImage#" property="imageType" propertyObject="Type" fieldName="images[#local.i#].imageType" displayType="plain" edit="#rc.edit#"></td>
			<td><cf_SlatwallPropertyDisplay id="imageName#local.i#" object="#local.thisImage#" property="imageName" fieldName="images[#local.i#].imageName" displayType="plain" edit="#rc.edit#"></td>
			<td class="varWidth"><cf_SlatwallPropertyDisplay id="imageDescription#local.i#" object="#local.thisImage#" property="imageDescription" fieldName="images[#local.i#].imageDescription" displayType="plain" fieldType="wysiwyg" edit="#rc.edit#"></td>
			<td class="administration">
				<ul class="one">
					<cf_SlatwallActionCaller action="admin:product.deleteImage" querystring="imageID=#local.thisImage.getImageID()#&productID=#rc.product.getProductID()#" confirmRequired="true" class="delete" type="list">
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
		<cfloop from="1" to="#arrayLen(local.images)#" index="local.i">
			<cfset local.thisImage = local.images[local.i] />
			<cfif local.thisImage.isNew() || len(local.thisImage.getErrorBean().getError("AlternateImage"))>
				<dl class="alternateImageUpload">
					<dt class="spdimagefile"> Upload Image </dt>
					<dd class="spdimagefile">
						<input type="hidden" name="images[#local.i#].imageID" value="" />
						<input type="file" class="imageFile" name="images[#local.i#].productImageFile" accept="image/gif, image/jpeg, image/jpg, image/png">
					</dd>
					<cf_SlatwallPropertyDisplay object="#local.thisImage#" propertyObject="Type" fieldName="images[#local.i#].imageType" property="imageType" edit="true" allowNullOption="false">
					<cf_SlatwallPropertyDisplay object="#local.thisImage#" property="imageName" fieldName="images[#local.i#].imageName" edit="true">
					<cf_SlatwallPropertyDisplay id="imageDescription#local.i#" object="#local.thisImage#" property="imageDescription" fieldName="images[#local.i#].imageDescription" fieldType="wysiwyg" edit="true" toggle="hide">
				</dl>				
			</cfif>
		</cfloop>
		<div class="buttons">
			<a class="button" id="addImage">#rc.$.Slatwall.rbKey("admin.product.edit.addImage")#</a>
		</div>
		
		<dl id="imageUploadTemplate" class="hideElement">
			<dt class="spdimagefile"> Upload Image </dt>
			<dd class="spdimagefile">
				<input type="hidden" name="imageID" value="" />
				<input type="file" class="imageFile" name="productImageFile" accept="image/gif, image/jpeg, image/jpg, image/png">
			</dd>
			<cf_SlatwallPropertyDisplay object="#rc.image#" propertyObject="Type" fieldName="imageType" property="imageType" edit="true" allowNullOption="false">
			<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageName" fieldName="imageName" edit="true">
			<cf_SlatwallPropertyDisplay id="imageDescription" object="#rc.image#" property="imageDescription" fieldName="imageDescription" fieldType="textarea" edit="true" toggle="hide">
		</dl>
	</cfif>	
</cfoutput>