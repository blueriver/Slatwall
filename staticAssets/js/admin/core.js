/*
 *
 *
 *	@depends /tools/jquery/jquery-1.7.1.js
 *	@depends /tools/jquery-ui/js/jquery-ui-1.8.16.custom.min.js
 *
*/

jQuery(document).ready(function(){
	
	//setDatePickers(".datepicker",dtLocale);
	//setTabs(".tabs",activeTab);
	//setAccordions(".accordion",activePanel);
	//loadWysiwygs();
	//jQuery('.multiselect').multiselect();
	jQuery('.hasDatepicker').datepicker();
	stripe('stripe');
	

});

function loadWysiwygs() {
	jQuery('textarea.wysiwyg').each(function(i) {
		setRTE(jQuery(this));
	});
}

function setRTE(txtarea) {
	if( txtarea.hasClass("Basic") ) {
		var wysiwygType = "Basic";
	} else {
		var wysiwygType = "Default";
	}
	var loadEditorCount = 0;
		txtarea.ckeditor({ 
			toolbar:wysiwygType,
			height:'150',
			customConfig : 'config.js.cfm'
		}, htmlEditorOnComplete);
}


function btnConfirmDialog(message,btn){
    
    jQuery("#alertDialogMessage").html(message);
    jQuery("#alertDialog").dialog({
            resizable: false,
            modal: true,
            buttons: {
                'YES': function() {
                    jQuery(this).dialog('close');
                    btn.form.submit();        
                    },
                'NO': function() {
                    jQuery(this).dialog('close');
                }
            }
        });

    return false;   
}


function toggleDisplay(link,expand,close){
	var $target = $(link).parent().next().children('div');
	$target.toggle();
	if($(link).html() == '[' + expand + ']') {
		$(link).html('[' + close + ']');
	} else {
		$(link).html('[' + expand + ']');
	}  
}

function stripe(theclass) {
  jQuery('table.' + theclass + ' tr').each(
		function(index) {
			if(index % 2){
				jQuery(this).addClass('alt');	
			} else {
				jQuery(this).removeClass('alt');
			}
		}
	);
   jQuery('div.mura-grid.' + theclass + ' dl').each(
		function(index) {
			if(index % 2){
				jQuery(this).addClass('alt');	
			} else {
				jQuery(this).removeClass('alt');
			}
		}
	);
}
