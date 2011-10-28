jQuery(document).ready(function() {
	
	// Create the chart	
	window.chart = new Highcharts.StockChart({
	    chart: {
	        renderTo: 'container'
	    },
	    credits : {
			enabled: false
		},
	    rangeSelector: {
	        selected: 0,
			inputEnabled: false
	    },
	    
	    title: {
	        text: 'Order Report'
	    },
	    
	    xAxis: {
	        maxZoom: 14 * 24 * 3600000 // fourteen days
	    },
	    yAxis: [{
	        title: {
	            text: '  '
	        }
	    },{
	        title: {
	            text: ''
	        },
			offset: 25
	    }
		
		],
	    series: [
			{name: 'Carts Created',data: reportCartCreated, yAxis: 1},
			{name: 'Carts Created Subtotal', data: reportCartCreatedSubtotal, type: 'area'},
			{name: 'Orders Placed', data: reportOrderPlaced, yAxis: 1},
			{name: 'Orders Placed Subtotal', data: reportOrderPlacedSubtotal, type: 'area'},
			{name: 'Orders Closed',data: reportOrderClosed, yAxis: 1},
			{name: 'Orders Closed Subtotal', data: reportOrderClosedSubtotal, type: 'area'}
		]
	});
	
	/*
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
	*/
});