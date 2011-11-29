/**
 * 
 * @depends /admin/core.js
 */

$(document).ready(function(){
	
	$("a.paymentDetails").click(function(){
		$(this).parent().hide();
		$(this).parent().siblings().show()
		var id = $(this).attr("id").substring(5);
		$('#orderDetail_' + id).toggle();
		return false;
	});
	
	$("a.customizations").click(function(){
		$(this).parent().hide();
		$(this).parent().siblings().show()
		$(this).parents('ul').next('div').toggle();
		return false;
	});
	
    $(".adminorderrefundOrderPayment").colorbox({
		onComplete: function() {
            $('input.refundAmount').focus();         
        }
	});
});