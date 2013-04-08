<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="rc.product" type="any" />

<cfoutput>
	<h4>#$.slatwall.rbKey('admin.entity.producttabs.images.defaultImages')#</h4>
	<ul class="thumbnails">
		<cfloop array="#rc.product.getDefaultProductImageFiles()#" index="imageFile">
			<li class="span3">
				<div class="thumbnail">
					<div class="small em image-caption">#imageFile#</div>
					<!---
					<a href="?slatAction=admin:entity.detailImage&imageID=#image.getImageID()#">
						#image.getImage(width=210, height=210)#
					</a>
					<hr />
					<div class="small em image-caption">#image.getImagePath()#</div>
					<cf_HibachiActionCaller action="admin:entity.detailImage" querystring="imageID=#image.getImageID()#&objectName=#attributes.object.getClassName()#" class="btn" iconOnly="true" icon="eye-open" />
					<cf_HibachiActionCaller action="admin:entity.editImage" querystring="imageID=#image.getImageID()#&objectName=#attributes.object.getClassName()#" class="btn" iconOnly="true" icon="pencil" />
					<cf_HibachiActionCaller action="admin:entity.deleteImage" querystring="imageID=#image.getImageID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" class="btn" iconOnly="true" icon="trash" confirm="true" />
					--->				
				</div>
				</li>
		</cfloop>
	</ul>
	<!---
	<cf_HibachiPropertyList divclass="span6">
		<cfif rc.edit>
			<div class="image pull-right">
				<img src="#rc.sku.getResizedImagePath(width="150", height="150")#" border="0" width="150px" height="150px" /><br />
				<cfif rc.sku.getImageExistsFlag()>
					<cf_HibachiFieldDisplay fieldType="yesno" title="Delete Current Image" fieldname="deleteImage" edit="true" />
				</cfif>
				<!---<cf_HibachiFieldDisplay fieldType="file" title="Upload New Image" fieldname="imageFileUpload" edit="true" />--->
				<cf_SlatwallAdminImagesDisplay object="#rc.sku#" />	
				<cf_HibachiFieldDisplay fieldType="radiogroup" title="Image Name" fieldname="imageExclusive" edit="true" valueOptions="#[{name=" Default Naming Convention<br />", value=0},{name=" Make Image Unique to Sku", value=1}]#" />
			</div>
		<cfelse>
			<div class="image pull-right">
				<img src="#rc.sku.getResizedImagePath(width="150", height="150")#" border="0" width="150px" height="150px" /><br />
			</div>
		</cfif>
	</cf_HibachiPropertyList>
	--->
	<hr />
	<h4>#$.slatwall.rbKey('admin.entity.producttabs.images.alternateImages')#</h4>
	<cf_SlatwallAdminImagesDisplay object="#rc.product#" />
	<!---
	<cfset local.images = rc.product.getProductImages() />
	
	<cf_HibachiListingDisplay smartList="#rc.product.getProductImagesSmartList()#"
							   recordDetailAction="admin:main.detailImage"
							   recordDetailModal="true"
							   recordEditAction="admin:main.editImage"
							   recordEditQueryString="productID=#rc.product.getProductID()#&redirectAction=admin:entity.detailproduct"
							   recordEditModal="true"
							   recordDeleteAction="admin:main.deleteImage"
							   recorddeletequerystring="redirectAction=product.editproduct&productID=#rc.product.getProductID()###tabalternateimages">
				
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="imageName" />
		<cf_HibachiListingColumn propertyIdentifier="imageDescription" />
		<cf_HibachiListingColumn propertyIdentifier="imageType.type" />
	</cf_HibachiListingDisplay>
	
	<cf_HibachiActionCaller action="admin:main.createimage" class="btn" icon="plus" queryString="productID=#rc.product.getProductID()#&directory=product&redirectAction=admin:entity.detailproduct" modal=true />
	--->
</cfoutput>
