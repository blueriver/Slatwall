<!--- Setup Setting Details --->
<cfsilent>
	<!--- contentRestrictAccessFlagDetails --->
	<cfset local.contentRestrictAccessFlagDetails = $.slatwall.getContent().getSettingDetails('contentRestrictAccessFlag') />
	<cfset local.contentRestrictAccessFlagDetails.parentValue = $.slatwall.getSettingDetails('contentRestrictAccessFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRestrictAccessFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRestrictAccessFlag') />	
	</cfif>
	<cfset local.contentRestrictAccessFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRestrictAccessFlagDetails.parentValue, "yesno") />
	
	<!--- contentRequirePurchaseFlagDetails --->
	<cfset local.contentRequirePurchaseFlagDetails = $.slatwall.getContent().getSettingDetails('contentRequirePurchaseFlag') />
	<cfset local.contentRequirePurchaseFlagDetails.parentValue = $.slatwall.getSettingDetails('contentRequirePurchaseFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRequirePurchaseFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRequirePurchaseFlag') />	
	</cfif>
	<cfset local.contentRequirePurchaseFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRequirePurchaseFlagDetails.parentValue, "yesno") />
	
	<!--- contentRequireSubscriptionFlagDetails --->
	<cfset local.contentRequireSubscriptionFlagDetails = $.slatwall.getContent().getSettingDetails('contentRequireSubscriptionFlag') />
	<cfset local.contentRequireSubscriptionFlagDetails.parentValue = $.slatwall.getSettingDetails('contentRequireSubscriptionFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRequireSubscriptionFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRequireSubscriptionFlag') />	
	</cfif>
	<cfset local.contentRequireSubscriptionFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRequireSubscriptionFlagDetails.parentValue, "yesno") />
</cfsilent>

<span id="extendset-container-tabslatwalltop" class="extendset-container"></span>
<cfoutput>
	<div class="fieldset">
		<!--- Content Template Type --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('entity.content.contentTemplateType_hint')#">#$.slatwall.rbKey('entity.content.contentTemplateType')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<select name="slatwall.content.contentTemplateType.typeID">
					<cfloop array="#$.slatwall.getContent().getContentTemplateTypeOptions()#" index="typeOption">
						<option value="#typeOption['value']#" <cfif (isNull($.slatwall.getContent().getContentTemplateType()) and typeOption['value'] eq "") or (not isNull($.slatwall.getContent().getContentTemplateType()) and typeOption['value'] eq $.slatwall.getContent().getContentTemplateType().getTypeID())>selected="true"</cfif>>#typeOption['name']#</option>
					</cfloop>
				</select>
			</div>
		</div>
		<!--- Product Listing Page Flag --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('entity.content.productListingPageFlag_hint')#">#$.slatwall.rbKey('entity.content.productListingPageFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<div class="controls">
					<label class="radio inline span3"><input type="radio" name="slatwall.content.productListingPageFlag" value="1" <cfif !isNull($.slatwall.getContent().getProductListingPageFlag()) and $.slatwall.getContent().getProductListingPageFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>	
					<label class="radio inline span2"><input type="radio" name="slatwall.content.productListingPageFlag" value="0" <cfif isNull($.slatwall.getContent().getProductListingPageFlag()) or !$.slatwall.getContent().getProductListingPageFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				</div>
			</div>
		</div>
		<!--- Setting: Restrict Access --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRestrictAccessFlag_hint')#">#$.slatwall.rbKey('setting.contentRestrictAccessFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<div class="controls">
					<cfset inheritedAttribute = "hide" />
					<cfif local.contentRestrictAccessFlagDetails.parentValue>
						<cfset inheritedAttribute = "show" />	
					</cfif>
					<label class="radio inline span3"><input type="radio" name="slatwall.content.contentRestrictAccessFlag" data-checked-#inheritedAttribute#="contentRequirePurchaseFlagDetails" value="" <cfif local.contentRestrictAccessFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherited')# ( #local.contentRestrictAccessFlagDetails.settingValueFormatted# )</label>
					<label class="radio inline span2"><input type="radio" name="slatwall.content.contentRestrictAccessFlag" data-checked-hide="contentRequirePurchaseFlagDetails" value="1" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
					<label class="radio inline span2"><input type="radio" name="slatwall.content.contentRestrictAccessFlag" data-checked-show="contentRequirePurchaseFlagDetails" value="0" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and !local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				</div>
			</div>
		</div>
		<!--- Setting: Require Purchase Flag --->
		<div class="control-group" id="contentRequirePurchaseFlagDetails">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRestrictAccessFlag_hint')#">#$.slatwall.rbKey('setting.contentRestrictAccessFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<div class="controls">
					<label class="radio inline span3"><input type="radio" name="slatwall.content.contentRequirePurchaseFlag" value="" <cfif local.contentRestrictAccessFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherited')# ( #local.contentRestrictAccessFlagDetails.settingValueFormatted# )</label>
					<label class="radio inline span2"><input type="radio" name="slatwall.content.contentRequirePurchaseFlag" value="1" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
					<label class="radio inline span2"><input type="radio" name="slatwall.content.contentRequirePurchaseFlag" value="0" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and !local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
<script type="text/javascript">
	$(document).ready(function(e){
		
		updateSlatwallShowHide();
		
		$('selectshowhide').on('change', function(e) {
			updateSlatwallShowHide();
		});
	});
	function updateSlatwallShowHide() {
		$.each($('input[data-checked-show]:checked'), function(index, value) {
			console.log($(this));
			console.log("SHOW:" + $(this).data('data-checked-show') );
			//$('#' $(this).data('checked-show') ).removeClass('hide');	
		});
		$.each($('input[data-checked-hide]:checked'), function(index, value) {
			console.log($(this));
			//console.log("HIDE:" + $(this).data('data-checked-hide') );
			//$('#' $(this).data('checked-hide') ).addClass('hide');	
		});
	}
</script>
<span id="extendset-container-slatwall" class="extendset-container"></span>
<span id="extendset-container-tabslatwallbottom" class="extendset-container"></span>



<!---
<cfset request.slatwallScope.getService("settingService").clearAllSettingsQuery() />
<cfset slatwallContent = request.slatwallScope.getService("contentService").getContentByCmsContentID($.content("contentID"), true) />

<cfset slatwallProductSmartList = request.slatwallScope.getService("productService").getSmartList(entityName="SlatwallProduct") />
<cfset slatwallProductSmartList.addLikeFilter(propertyIdentifier="productType_productTypeIDPath", value="%444df313ec53a08c32d8ae434af5819a%") />
<cfset slatwallProducts = slatwallProductSmartList.getRecords() />

<cfset restrictedContentTemplates = request.slatwallScope.getService("contentService").listContentFilterByTemplateFlag(1) />

<cfset contentRestrictAccessFlag = slatwallContent.getSettingDetails('contentRestrictAccessFlag') />
<cfset contentRequirePurchaseFlag = slatwallContent.getSettingDetails('contentRequirePurchaseFlag') />
<cfset contentRequireSubscriptionFlag = slatwallContent.getSettingDetails('contentRequireSubscriptionFlag') />
<cfoutput>
	<dl class="oneColumn">
		<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.templateFlag_hint")#" fieldName="slatwallData.templateFlag" fieldType="yesno" value="#slatwallContent.getTemplateFlag()#" edit="true">
		<cf_SlatwallSetting settingName="contentProductListingFlag" settingObject="#slatwallContent#" />
		<div class="productListingFlagRelated">
			<cf_SlatwallSetting settingName="contentIncludeChildContentProductsFlag" settingObject="#slatwallContent#" />
			<cf_SlatwallSetting settingName="contentDefaultProductsPerPage" settingObject="#slatwallContent#" />
			<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.disableProductAssignmentFlag_hint")#" fieldName="slatwallData.disableProductAssignmentFlag" fieldType="yesno" value="#slatwallContent.getDisableProductAssignmentFlag()#" edit="true">
		</div>
		<cf_SlatwallSetting settingName="contentRestrictedContentDisplayTemplate" settingObject="#slatwallContent#" />
		<cf_SlatwallSetting settingName="contentRestrictAccessFlag" settingObject="#slatwallContent#" />
		<div class="restrictAccessFlagRelated">
			<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.allowPurchaseFlag_hint")#" fieldName="slatwallData.allowPurchaseFlag" fieldType="yesno" value="#slatwallContent.getAllowPurchaseFlag()#" edit="true">
			<div class="requirePurchaseFlag">
				<cf_SlatwallSetting settingName="contentRequirePurchaseFlag" settingObject="#slatwallContent#" />
			</div>
			<div class="requireSubscriptionFlag">
				<cf_SlatwallSetting settingName="contentRequireSubscriptionFlag" settingObject="#slatwallContent#" />
			</div>
					
			<div class="allowPurchaseFlagRelated" id="allowPurchaseFlagRelated">
				<!--- show all the skus for this content --->
				<cfif arrayLen(slatwallContent.getSkus())>
					<dt>
						<label>This Content is currently assigned to these skus:</label>
					</dt>
					<dd>
						<table>
							<tr>
								<th>Product</th>
								<th>Sku Code</th>
								<th>Price</th>
								<th></th>
							</tr>
							<cfloop array="#slatwallContent.getSkus()#" index="local.sku">
								<tr>
									<td><a href="/plugins/slatwall/?slatAction=product.edit&productID=#sku.getProduct().getProductID()#">#sku.getProduct().getProductName()#</a></td>
									<td>#sku.getSkuCode()#</td>
									<td>#sku.getPrice()#</td>
									<td><a href="" class="delete" /></td>
								</tr>					
							</cfloop>
						</table>
					</dd>
					<input type="hidden" name="slatwallData.addSku" value="0" />
					<dt>Add Another Sku <a href="##" id="addSkuRelatedLink" onclick="toggleDisplay('addSkuRelated','Expand','Close');return setupAddSku();return false;">[Expand]</a></dt>
				<cfelse>
					<input type="hidden" name="slatwallData.addSku" value="1" />
				</cfif>
				
				<!--- add new sku --->
				<div class="addSkuRelated" id="addSkuRelated">
					<dt>
						<label for="slatwallData.product.productID">Sell Access through an existing or new Product </label>
					</dt>
					<dd>
						<div>
							Product: 
							<div>
								<select name="slatwallData.product.productID">
									<option value="">New Product</option>
									<cfloop array="#slatwallProducts#" index="local.product">
										<option value="#product.getProductID()#">#product.getProductName()#</option>
									</cfloop>
								</select>
							</div>
						</div>
						</br>
						<div>
							Sku:
							<div>
								<select name="slatwallData.product.sku.skuID">
									<option value="">New Sku</option>
								</select>
							</div>	
						</div>
					</dd>
					<div class="skuRelated">
						<dt>
							<label for="slatwallData.product.price">Price</label>
						</dt>
						<dd>
							<input name="slatwallData.product.price" value="" />
						</dd>
					</div>
				</div>
			</div>
		</div>
	</dl>
</cfoutput>

<cfoutput>
<script type="text/javascript">
var $ = jQuery;
function setupTemplateFlagDisplay() {
	if ($('input[name="slatwallData.templateFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.templateFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.templateFlag"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.setting.contentProductListingFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').filter('[value=0]').prop('checked', true).change();
	}
}

function setupProductListingFlagDisplay() {
	if($('input[name="slatwallData.setting.contentProductListingFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.setting.contentProductListingFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.setting.contentProductListingFlag"]').val();
	}
	// check inherited value
	if(selectedValue == '') {
		var selectedValue = $('input[name="contentProductListingFlagInherited"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.templateFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.productListingFlagRelated').show();
	} else {
		$('input[name="slatwallData.setting.contentIncludeChildContentProductsFlag"]').filter('[value=""]').prop('checked', true).change();
		$('input[name="slatwallData.disableProductAssignmentFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentDefaultProductsPerPage"]').val('');
		$('.productListingFlagRelated').hide();
	}
}

function setupRestrictAccessFlagDisplay() {
	if ($('input[name="slatwallData.setting.contentRestrictAccessFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.setting.contentRestrictAccessFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.setting.contentRestrictAccessFlag"]').val();
	}
	// check inherited value
	if(selectedValue == '') {
		var selectedValue = $('input[name="contentRestrictAccessFlagInherited"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.templateFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentProductListingFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.restrictAccessFlagRelated').show();
		setupAllowPurchaseFlagDisplay();
	} else {
		$('input[name="slatwallData.allowPurchaseFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.restrictAccessFlagRelated').hide();
	}
}

function setupAllowPurchaseFlagDisplay() {
	var selectedValue = $('input[name="slatwallData.allowPurchaseFlag"]:checked').val();
	if(selectedValue == 1){
		$('.allowPurchaseFlagRelated').show();
	} else {
		$('.allowPurchaseFlagRelated').hide();
	}
	if($('input[name="slatwallData.addSku"]').val() == 1) {
		$('.addSkuRelated').show();
	} else {
		$('.addSkuRelated').hide();
	}
	setupRequirePurchaseFlagDisplay();
}

function setupRequirePurchaseFlagDisplay() {
	var selectedValue = $('input[name="slatwallData.allowPurchaseFlag"]:checked').val();
	if(selectedValue == undefined || selectedValue == "0"){
		$('.requirePurchaseFlag').hide();
	} else {
		$('.requirePurchaseFlag').show();
	}
}

function setupAddSku() {
	if ($('.addSkuRelated').is(':visible')) {
		$('input[name="slatwallData.addSku"]').val(1);
	} else {
		$('input[name="slatwallData.addSku"]').val(0);
	}
}
	
$(document).ready(function(){
	
	$('input[name="slatwallData.templateFlag"]').change(function(){
		setupTemplateFlagDisplay();
	});
	
	$('input[name="slatwallData.setting.contentProductListingFlag"]').change(function(){
		setupProductListingFlagDisplay();
	});
	
	$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').change(function(){
		setupRestrictAccessFlagDisplay();
	});
	
	$('input[name="slatwallData.addSku"]').change(function(){
		$('.allowPurchaseFlagRelated').show();
	});
	
	$('input[name="slatwallData.allowPurchaseFlag"]').change(function(){
		setupAllowPurchaseFlagDisplay();
	});
	
	$('select[name="slatwallData.product.sku.skuID"]').change(function() {
		if($(this).val() != ""){
			$('.skuRelated').hide();
		} else {
			$('.skuRelated').show();
		}
	});
	
	$('select[name="slatwallData.product.productID"]').change(function() {
		
		var postData = {};
		postData['slatAction'] = 'admin:ajax.updateListingDisplay';
		postData['entityName'] = 'Sku';
		postData['F:product.productID'] = $('select[name="slatwallData.product.productID"]').val();
		postData['P:Show'] = 'all';
		postData['propertyIdentifiers'] = 'skuID,skuCode,price';
		

		$.ajax({
			type: 'get',
			url: '#request.slatwallScope.getBaseURL()#',
			data: postData,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
			success: function(r) {
				$('select[name="slatwallData.product.sku.skuID"]').html('');
				$('select[name="slatwallData.product.sku.skuID"]').append('<option value="">New Sku</option>');
				if(r["pageRecords"].length > 0){
					$.each(r["pageRecords"],function(index,value){
						var option = '<option value="'+value['skuID']+'">'+value['price']+' - '+value['skuCode']+'</option>';
						$('select[name="slatwallData.product.sku.skuID"]').append(option);
					});
				}
			}, error: function(r) {
				alert("Error Loading Skus");
			}
		});
		
	});
	
	setupTemplateFlagDisplay();
	setupProductListingFlagDisplay();
	setupRestrictAccessFlagDisplay();
	setupAllowPurchaseFlagDisplay();
});
</script>
</cfoutput>
--->