/**
 *
 *	@depends /tools/jquery/jquery-1.7.1.js
 *	@depends /tools/jquery-ui/jquery-ui-1.8.16.custom.min.js
 *	@depends /tools/jquery-validate/jquery.validate.min.js
 *  @depends /tools/colorbox/jquery.colorbox.js
 *  @depends /tools/imgpreview/imgpreview-min.js
 *  @depends /tools/timepicker/jquery-ui-timepicker-addon.js
 *  @depends /tools/multiselect/ui.multiselect.js
 *
*/


jQuery(document).ready(function(){
	
	jQuery('.multiselect').multiselect();
	jQuery('.datetimepicker').datetimepicker();
	jQuery('.datepicker').datepicker();
	jQuery('.accordion').accordion();
	jQuery('.tabs').tabs();
	
	jQuery('.wysiwyg').ckeditor();
	
	stripe('stripe');
	
});


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

/* Function used to open up a modal dialog with text/html content, where called provides a function that returns boolean, who's return value closes the dialog */
function actionDialog($dialogDiv, okHandler){
    //jQuery("#alertDialogMessage").html(message);
	
	//$dialogDiv.attr("title", title);
    $dialogDiv.dialog({
        resizable: false,
        modal: true,
        buttons: {
            'Ok': function() {
				if(okHandler())
	                jQuery(this).dialog('close');      
			},
            'Cancel': function() {
                jQuery(this).dialog('close');
            }
        }
    });

    return false;   
}


function toggleDisplay(link, expand, close){
	var target = jQuery(link).parent().next().children('div');
	target.toggle();
	if(jQuery(link).html() == '[' + expand + ']') {
		jQuery(link).html('[' + close + ']');
	} else {
		jQuery(link).html('[' + expand + ']');
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
   jQuery('div.' + theclass + ' dl').each(
		function(index) {
			if(index % 2){
				jQuery(this).addClass('alt');	
			} else {
				jQuery(this).removeClass('alt');
			}
		}
	);
}

// This actually came from Mura admin.js.
function confirmDialog(message,action){
	confirmedAction=action;
	
	jQuery("#alertDialogMessage").html(message);
	jQuery("#alertDialog").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'YES': function() {
					jQuery(this).dialog('close');
					if(typeof(confirmedAction)=='function'){
						confirmedAction();
					} else {
						location.href=confirmedAction;
					}
					
					},
				'NO': function() {
					jQuery(this).dialog('close');
				}
			}
		});

	return false;	
}
