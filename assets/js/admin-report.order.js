jQuery(function() {
	// Create the chart	
	window.chart = new Highcharts.StockChart({
	    chart: {
	        renderTo: 'container'
	    },
	    
	    rangeSelector: {
	        selected: 1
	    },
	    
	    title: {
	        text: 'Total Revenue By Date Closed'
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
			{name: 'Orders Closed', data: reportRevenueClosed}
		]
	});
});