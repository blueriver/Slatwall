jQuery(function() {
	// Create the chart	
	window.chart = new Highcharts.StockChart({
	    chart: {
	        renderTo: 'container'
	    },
	    
	    rangeSelector: {
	        selected: 2
	    },
	    
	    title: {
	        text: 'Order Report'
	    },
	    
	    xAxis: {
	        maxZoom: 14 * 24 * 3600000 // fourteen days
	    },
	    yAxis: {
	        title: {
	            text: 'Exchange rate'
	        }
	    },
		
	    series: [
			{name: 'Orders Closed', data: reportOrderClosed},
			{name: 'Orders Placed', data: reportOrderPlaced},
			{name: 'Carts Created', data: reportCartCreated}
		]
	});
	
	jQuery.ajax({
		type: 'post',
		url: '/plugins/Slatwall/api/index.cfm/reportService/getOrderReport/',
		data: {startDate: '9/1/2011', endDate: '11/1/2011'},
		dataType: "json",
		context: document.body,
		success: function(r) {
			console.log(r);
		}
	});
});