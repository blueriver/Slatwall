var current= 1;
var $newOption;
$(document).ready(function() {
	$("#addOption").click(function() {
		current++;
		$newOption= $("#optionTemplate").clone(true);
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
			$currentElem.attr("id","optionDescription"+current);
		});
		$newOption.children("dl").children("dt").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("id",$currentElem.attr("id")+current);
		});
		$newOption.children("dl").children("dd").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("id",$currentElem.attr("id")+current);
		});
		
		$("#buttons").before($newOption);
		$newOption.removeClass("hideElement");
		$newOption.removeAttr("id");

	});
	$('textarea#optionDescription').ckeditor({ toolbar:'Default',
							  height:'150',
						      customConfig : 'config.js.cfm' },
							  htmlEditorOnComplete);	 
});