<cfoutput>
<script type="text/javascript">
var current= 1;

jQuery(document).ready(function() {
	jQuery("##addSKU").click(function() {
		current++;
		$newSKU= jQuery( "##tableTemplate tbody>tr:last" ).clone(true);
		
		/*$newSKU.children("ol").children("li").children("label").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("for","shirt["+current+"]."+$currentElem.attr("for"));
		});
		$newSKU.children("ol").children("li").children("input").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("name","shirt["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id","shirt["+current+"]."+$currentElem.attr("id"));
		});
		$newSKU.children("ol").children("li").children("select").each(function(i) {
			var $currentElem= $(this);
			$currentElem.attr("name","shirt["+current+"]."+$currentElem.attr("name"));
			$currentElem.attr("id","shirt["+current+"]."+$currentElem.attr("id"));
		});*/
		
		
		jQuery('##skuTable > tbody:last').append($newSKU);
	});
});
	
</script>


<style type="text/css">
.hideElement {display:none;}
</style>
</cfoutput>