var search_delay = 0;
var svo_request_id = 0;

$(document).ready(function(){
	$.fn.serializeObject = function()
	{
	    var o = {};
	    var a = this.serializeArray();
	    $.each(a, function() {
	        if (o[this.name]) {
	            if (!o[this.name].push) {
	                o[this.name] = [o[this.name]];
					
	            }
	            o[this.name].push(this.value || '');
	        } else {
	            o[this.name] = this.value || '';
	        }
	    });
	    return o;
	};
	$('li.LogoSearch img').click(function(e){
		$('ul.MainMenu').show('fast');
		e.stopPropagation();
	});
	
	$("ul.MainMenu").click(function(e){
    	e.stopPropagation();
	});
	
	$("input.AdminSearch").val("");
	
	$("input.AdminSearch").keyup(function(){
		clearTimeout(search_delay);
		if($(this).val() != ''){
			search_delay = setTimeout("adminSearch()",200);
			$("div.svoutilitytoolbarsearch").css('display', 'block');
		}else{
			$("div.svoutilitytoolbarsearch").css('display', 'none');
		}
		
	});
});

$(document).click(function(e){
	$('ul.MainMenu').hide('fast');
});

function adminSearch(){
	var args = {
		'Keyword': $('input.AdminSearch').val()
	}
	getSVO('utility/toolbarsearch', args);
}
function getSVO(svo, args){
	svo_request_id = svo_request_id + 1;

	var instance = new ajaxManager();
	instance.setCallbackHandler(returnSVO);
	instance.getSVO(svo, args, svo_request_id);
}
function returnSVO(results){
	alert(results);
	var resultsArray = results.split("~");
	var selector = '.' + resultsArray[0];
	if (svo_request_id == resultsArray[1]) {
		$(selector).replaceWith(resultsArray[2]);
	}
}
function doSlatAction(action, rc){
	svo_request_id = svo_request_id + 1;
	$.ajax({
		type: "POST",
		url: "/plugins/Slat_" + slatsetting_pluginid + "/lib/ajax/ajaxManager.cfc",
		data: "method=doSlatAction&returnFormat=json&argumentCollection={%22action%22:%22" + action + "%22, %22rc%22:" + JSON.stringify(rc) + ", %22JSRequestID%22:" + svo_request_id + "}",
		dataType: "json",
		success: function(results){
			var resultsArray = results.split("~");
			var selector = '.' + resultsArray[0];
			if (svo_request_id == resultsArray[1]) {
				$(selector).replaceWith(resultsArray[2]);
			}
	}});
}

function getSlatDisplay(sah, Display, DisplaySettingsJSON){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateSlatDisplay);
	
	instance.getDisplay(sah, Display, DisplaySettingsJSON);
}
function updateSlatDisplay(results){
	var resultsArray = results.split("~");
	var selector = '.' + resultsArray[0];
	$(selector).replaceWith(resultsArray[1]);
}

function displaySlatPreloader(sah, message, premessage){
	var selector = '.' + sah;
	$(selector).html(premessage + '<div class="sdoLoading">' + message + '</div>');
}

function runSlatProcess(FormValuesJSON, sah, Display, DisplaySettingsJSON){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateSlatDisplay);
	instance.runProcess(FormValuesJSON, sah, Display, DisplaySettingsJSON);
}

function processSlatFormAjax(FormSelector, sah, Display, DisplaySettingsJSON){
	if(PowerValidate(FormSelector) == true){
		runSlatProcess($(FormSelector).serializeObject(),sah,Display,DisplaySettingsJSON);
	}
}

function activateSlatTabs(){
	$('ul.stNav > li').click(function() {
		if($(this).hasClass('current') == false){
			$($($(this).parent()).parent()).children($('div.stTab')).removeClass('on');
			$($(this).parent()).children().removeClass('current');
			var stid = $(this).attr('class');
			focusSlatTab(stid);
		}
	});
}

function focusSlatTab(stid){
	var tabselector = 'div.' + stid;
	var menuselector = 'li.' + stid;
	$(tabselector).addClass('on');
	$(menuselector).addClass('current');
}

function removeCartPayment(PaymentID){
	FormValuesJSON = {
		"slatProcess": "RemoveCartPaymentMethod",
		"RemoveCartPaymentID": PaymentID
	}
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateSlatDisplay);
	instance.runProcess(FormValuesJSON,'sdoBillingPaymentForm', 'BillingPaymentForm');
}

// OLD FUNCTIONS BELOW
function updateHiddenValue(selector, value){
	$(selector).val(value);
}

function submitSlatForm(selector){
	$(selector).submit();
}

function getSearchResults(keyword){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateSearchResults);
	instance.getProductSearchResults($("#Keyword").val());
}

function updateSearchResults(result) {
	$("#search_results").html(result);
	$("#search_clear_icon").attr("src", "/default/includes/themes/nytro/images/header_search_clear_icon.gif");
}

function updateOrderSummary(result) {
	$("#CartOrderSummary").html(result);
}

function getShippingRates() {
	$("#ShippingRates").html('<div class="LoadingRates">Loading Rates</div><input type="hidden" name="ShippingPostalCode" required="true" value="" message="Please Enter a Valid Postal Code to get Shipping Rates." />');
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateShippingMethods);
	instance.getShippingRates(1, $('select[name=ShippingCountry] :selected').val(), $('input[name=ShippingLocality]').val(), $('select[name=ShippingState] :selected').val(), $('input[name=ShippingCity]').val(), $('input[name=ShippingPostalCode]').val(), $('input[name=ShippingStreetAddress]').val());
}

function updateShippingMethods(result) {
	$("#ShippingRates").html(result);
}

function updateCartShippingMethod(AddressID, Carrier, Method, Cost, DeliveryTime) {
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateOrderSummary);
	instance.updateCartShippingMethod(AddressID, Carrier, Method, Cost, DeliveryTime);
}

function getNewContentOptions(){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateNewContentOptions);
	instance.getNewContentOptions($('input[name=ContentKeyword]').val(), $('input[name=ProductID]').val());
}

function updateNewContentOptions(results){
	$("#NewContentOptions").html(results);
	stripe('stripe');
}

function addProductToContent(contentid, productid){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateExistingContentAssociation);
	instance.addProductToContent(contentid, productid);
}
function removeProductFromContent(contentid, productid){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateExistingContentAssociation);
	instance.removeProductFromContent(contentid, productid);
}
function updateExistingContentAssociation(results){
	$("#ExistingContentAssociation").html(results);
	stripe('stripe');
}

function getMessageLogDetail(messagelogid, column){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateMessageLogDetail);
	instance.getMessageLogDetial(messagelogid, column);
}
function updateMessageLogDetail(results){
	$("#MessageLogDetail").html(results);
}

function AddToCartOptionsChanged() {
	var shipDate = $('#AddToCartOptions :selected').attr('shipDate');
	var imageID = $('#AddToCartOptions :selected').attr('imageID');
	if (shipDate != '') {
		$('#EstimatedShippingDate').html('This Item is Estimated to ship: ' + shipDate);
		$('input[name=AddToCartExpectedShipDate]').val(shipDate);
	} else {
		$('#EstimatedShippingDate').html('');
		$('input[name=AddToCartExpectedShipDate]').val('');
	}
	var largeImage = 'http://www.nytro.com/prodimages/' + imageID + '-l.jpg';
	var mediumImage = 'http://www.nytro.com/prodimages/' + imageID + '-m.jpg';
	
	$('input[name=AddToCartExpectedShipDate]').val(shipDate);
	
	$('#zoomer').attr('href', largeImage);
	$('#FullZoom').attr('href', largeImage);
	$('#MainImage').attr('src', mediumImage);
	
	MagicZoom.refresh(); 
}


function rateProductOver(productid,rate){
	var star1id = '.' + productid + '_Star1';
	var star2id = '.' + productid + '_Star2';
	var star3id = '.' + productid + '_Star3';
	var star4id = '.' + productid + '_Star4';
	var star5id = '.' + productid + '_Star5';
	if (rate == 1) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('blank'));
		$(star3id).attr('src', $(star3id).attr('blank'));
		$(star4id).attr('src', $(star4id).attr('blank'));
		$(star5id).attr('src', $(star5id).attr('blank'));
	}else if (rate == 2) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('blank'));
		$(star4id).attr('src', $(star4id).attr('blank'));
		$(star5id).attr('src', $(star5id).attr('blank'));
	}else if (rate == 3) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star4id).attr('src', $(star4id).attr('blank'));
		$(star5id).attr('src', $(star5id).attr('blank'));
	}else if (rate == 4) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star4id).attr('src', $(star4id).attr('user'));
		$(star5id).attr('src', $(star5id).attr('blank'));
	}else if (rate == 5) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star4id).attr('src', $(star4id).attr('user'));
		$(star5id).attr('src', $(star5id).attr('user'));
	}
}

function rateProductOut(productid){
	var star1id = '.' + productid + '_Star1';
	var star2id = '.' + productid + '_Star2';
	var star3id = '.' + productid + '_Star3';
	var star4id = '.' + productid + '_Star4';
	var star5id = '.' + productid + '_Star5';
	$(star1id).attr('src', $(star1id).attr('rating'));
	$(star2id).attr('src', $(star2id).attr('rating'));
	$(star3id).attr('src', $(star3id).attr('rating'));
	$(star4id).attr('src', $(star4id).attr('rating'));
	$(star5id).attr('src', $(star5id).attr('rating'));
}


function rateProduct(productid, rate, userid){
	if (userid == '') {
		var qrlHeight = $('#QuickRatingLogin').css('height');
		var qrlHeight = qrlHeight.replace("px","");
		var qrlWidth = $('#QuickRatingLogin').css('width');
		var qrlWidth = qrlWidth.replace("px","");
		var newtop = mouseY - qrlHeight;
		var newleft = mouseX - (qrlWidth/2);
		$('#QuickRatingLogin').css('top', newtop);
		$('#QuickRatingLogin').css('left', newleft);
		$('#QuickRatingLogin').addClass('on');
	}
	else {	
		var instance = new ajaxManager();
		instance.setCallbackHandler(rateProductUpdate);
		instance.getProductRating(productid, rate, userid, 'default');
	}
}

function rateProductUpdate(results){
	var resultarray = results.split("~");
	var star1id = '.' + resultarray[0] + '_Star1';
	var star2id = '.' + resultarray[0]  + '_Star2';
	var star3id = '.' + resultarray[0]  + '_Star3';
	var star4id = '.' + resultarray[0]  + '_Star4';
	var star5id = '.' + resultarray[0]  + '_Star5';
	if (resultarray[1] == 1) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star1id).attr('rating', $(star1id).attr('user'));
	}else if (resultarray[1] == 2) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star1id).attr('rating', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star2id).attr('rating', $(star2id).attr('user'));
	}else if (resultarray[1] == 3) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star1id).attr('rating', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star2id).attr('rating', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star3id).attr('rating', $(star3id).attr('user'));
	}else if (resultarray[1] == 4) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star1id).attr('rating', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star2id).attr('rating', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star3id).attr('rating', $(star3id).attr('user'));
		$(star4id).attr('src', $(star4id).attr('user'));
		$(star4id).attr('rating', $(star4id).attr('user'));
	}else if (resultarray[1] == 5) {
		$(star1id).attr('src', $(star1id).attr('user'));
		$(star1id).attr('rating', $(star1id).attr('user'));
		$(star2id).attr('src', $(star2id).attr('user'));
		$(star2id).attr('rating', $(star2id).attr('user'));
		$(star3id).attr('src', $(star3id).attr('user'));
		$(star3id).attr('rating', $(star3id).attr('user'));
		$(star4id).attr('src', $(star4id).attr('user'));
		$(star4id).attr('rating', $(star4id).attr('user'));
		$(star5id).attr('src', $(star5id).attr('user'));
		$(star5id).attr('rating', $(star5id).attr('user'));
	}
}

function checkCardBalance(){
	var instance = new ajaxManager();
	instance.setCallbackHandler(updateCardBalance);
	instance.getGiftCardBalance($('#GiftCardNumber').val());
}
function updateCardBalance(results){
	$('#GiftCardResults').html(results);
}