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
	<table class="stripe">
		<tr>
			<th>Image Preview</th>
			<th>Image Type</th>
			<th>Image Name</th>
			<th class="varWidth">Image Description</th>
			<th class="administration">&nbsp;</th>
		</tr>
	</table>
	<cfloop array="#rc.product.getImages()#" index="local.image" >
		<tr>
			<td>#local.image.getImage()#</td>
			<td>#local.image.getImageType().getType()#</td>
			<td>#local.image.getImageName()#</td>
			<td class="varWidth">#local.image.getImageDescription()#</td>
			<td class="administration">
				<ul class="one">
					<cf_SlatwallActionCaller action="admin:product.deleteImage" querystring="imageID=#local.image.getImageID()#" class="delete" type="list">
				</ul>
			</td>
		</tr>
	</cfloop>
	<cfif rc.edit>
		<hr />
		<form name="uploadImage">
			<h4>Upload Image</h4>
			<cfset rc.blankImage = entityNew("SlatwallImage") />
			<cf_SlatwallPropertyDisplay object="#rc.blankImage#" property="imageName" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.blankImage#" property="imageDescription" edit="#rc.edit#">
			<cf_SlatwallPropertyDisplay object="#rc.blankImage#" property="imageType" edit="#rc.edit#">
			
			<input type="file" id="productImageFile" name="productImageFile" accept="image/gif, image/jpeg, image/jpg, image/png">
		</form>
	</cfif>	
</cfoutput>