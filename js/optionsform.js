$(document).ready(function() {
	$("#addOption").click(function() {
		var current= $('.optionFieldSet').length;
		current++;
		var $newOption= $("#optionTemplate").clone(true);
		$newOption.children("legend").html("Add Option "+current);
		$newOption.children("dl").children("dt").children("label").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("for",$currentElem.attr("for")+current);
		});
		$newOption.children("dl").children("dd").children("input").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("name","options["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id",$currentElem.attr("id")+current);
		});
		$newOption.children("dl").children("dd").children("textarea").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("name","options["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id",$currentElem.attr("id")+current);
			$currentElem.addClass("richtext");
		});
		$newOption.children("dl").children("dd").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("id",$currentElem.attr("id")+current);
		});
		
		$("#remOption").attr('disabled','');
		$("#buttons").before($newOption);
		$newOption.removeClass("hideElement").addClass("optionFieldSet").attr("id","Option"+current);
		$('textarea.richtext').ckeditor({ toolbar:'Default',
						  height:'150',
					      customConfig : 'config.js.cfm' },
						  htmlEditorOnComplete);	

	});
	
	$('#remOption').click(function() {
		var num	= $('.optionFieldSet').length;
		$('#Option' + num).remove();		// remove the last element
	
		// enable the "add" button
		$('#addOption').attr('disabled','');
	
		// if only one element remains, disable the "remove" button
		if (num-1 == 1)
			$('#remOption').attr('disabled','disabled');
	});

	$('textarea.richtext').ckeditor({ toolbar:'Default',
							  height:'150',
						      customConfig : 'config.js.cfm' },
							  htmlEditorOnComplete);	 
});