(function ($) {
 "use strict";


 /*-----------------------------------------------*/
 /* Get data from json*/
 /*----------------------------------------------*/

  var jsonData = $.ajax({
    url: 'WeatherPollution/weatherData',
    dataType: 'json',
  }).done(function (results) {
    // Split timestamp and data into separate arrays
    var labels = [], data=[], dataWind=[], dataHumid=[];
    results.forEach(function(i) {
      labels.push(i.Station);
      data.push(i.Temperature);
      dataWind.push(i.WindSpeed);
      dataHumid.push(i.Humidity);
    });

    // Create the chart.js data structure using 'labels' and 'data'
    var tempData = {
      labels : labels,
      datasets : [{data : data
      }]
    };

	 /*----------------------------------------*/
	/*  1.  Basic Line Chart
	/*----------------------------------------*/
	var ctx = document.getElementById("basiclinechart");
	var basiclinechart = new Chart(ctx, {
		type: 'line',
		data: {
			labels: tempData.labels,
			datasets: [{
				label: "Temperature",
				fill: false,
        backgroundColor: '#5D3F6A',
				borderColor: '#5D3F6A',
				data: data
            }, {
        label: "Wind Speed",
				fill: false,
        backgroundColor: '#fb9678',
				borderColor: '#fb9678',
				data: dataWind

		}, {
        label: "Humidity",
				fill: false,
        backgroundColor: '#3f6a48',
				borderColor: '#3f6a48',
				data: dataHumid

		}]
		},
		options: {
			responsive: true,
			title:{
				display:true,
				text:'Basic Line Chart'
			},
			tooltips: {
				mode: 'index',
				intersect: false,
			},
			hover: {
				mode: 'nearest',
				intersect: true
			},
			scales: {
				xAxes: [{
					display: true,
					scaleLabel: {
						display: true,
						labelString: 'Station'
					}
				}],
				yAxes: [{
					display: true,
					scaleLabel: {
						display: true,
						labelString: 'Value'
					}
				}]
			}
		}
	});
	});
	/*----------------------------------------*/
	/*  2.  Line Chart Interpolation
	/*----------------------------------------*/
	/*
	var ctx = document.getElementById("linechartinterpolation");
	var linechartinterpolation = new Chart(ctx, {
		type: 'line',
		data: {
			labels: ["0", "1", "2"],
			datasets: [{
				label: "Cubic interpolation",
				fill: false,
                backgroundColor: '#5D3F6A',
				borderColor: '#5D3F6A',
				data: [0, 15, 17, 200, 0, 12, -200, 5, 200, 8, 200, 12, 200],
				cubicInterpolationMode: 'monotone'
            }, {
                label: "Cubic interpolation",
				fill: false,
                backgroundColor: '#fb9678',
				borderColor: '#fb9678',
				data: [-100, 200, 12, -200, 12, 200, 8, -200, 9, 200, -200, -12, -200]

		}]
		},
		options: {
			responsive: true,
			title:{
				display:true,
				text:'Line Chart interpolation'
			},
			tooltips: {
				mode: 'index'
			},
			scales: {
				xAxes: [{
					display: true,
					scaleLabel: {
						display: true
					}
				}],
				yAxes: [{
					display: true,
					scaleLabel: {
						display: true,
						labelString: 'Value'
					},
					ticks: {
						suggestedMin: -10,
						suggestedMax: 200,
					}
				}]
			}
		}
	});
	*/

	/*----------------------------------------*/
	/*  3.  Line Chart styles
	/*----------------------------------------*/
 var jsonData = $.ajax({
    url: 'WeatherPollution/weatherPrediction',
    dataType: 'json',
  }).done(function (results) {
    // Split timestamp and data into separate arrays
    var labels = [], data=[], dataWind=[];
    results.forEach(function(i) {
      labels.push(i.time);
      data.push(i.Temperature);
      dataWind.push(i.WindSpeed);
    });

    // Create the chart.js data structure using 'labels' and 'data'
    var tempData = {
      labels : labels,
      datasets : [{data : data
      }]
    };

	var ctx = document.getElementById("linechartstyles");
	var linechartstyles = new Chart(ctx, {
		type: 'line',
		data: {
			labels: tempData.labels,
			datasets: [{
				label: "Temprature",
				fill: false,
                backgroundColor: '#01c0c8',
				borderColor: '#01c0c8',
				data: data
            }, {
                label: "Wind Speed",
				fill: false,
                backgroundColor: '#fb9678',
				borderColor: '#fb9678',
				borderDash: [5, 5],
				data: dataWind

		}]
		},
		options: {
			responsive: true,
			title:{
				display:true,
				text:'Line Chart Style'
			},
			tooltips: {
				mode: 'index',
				intersect: false,
			},
			hover: {
				mode: 'nearest',
				intersect: true
			},
			scales: {
				xAxes: [{
					display: true,
					scaleLabel: {
						display: true,
						labelString: 'Month'
					}
				}],
				yAxes: [{
					display: true,
					scaleLabel: {
						display: true,
						labelString: 'Value'
					}
				}]
			}
		}
	});

	});
	/*----------------------------------------*/
	/*  4.  Line Chart point circle
	/*----------------------------------------*/
	/*
	var ctx = document.getElementById("linechartpointcircle");
	var linechartpointcircle = new Chart(ctx, {
		type: 'line',
		data: {
			labels: ["May", "June", "July"],
			datasets: [{
				label: "My First dataset",
				backgroundColor: '#5D3F6A',
				borderColor: '#5D3F6A',
				data: [0, 10, 20, 30, 40, 50, 60],
				fill: false,
				pointRadius: 4,
				pointHoverRadius: 10,
				showLine: false
			}]
		},
		options: {
			responsive: true,
			title:{
				display:true,
				text:'Line Chart Point Circle'
			},
			legend: {
				display: false
			},
			elements: {
				point: {
					pointStyle: 'circle',
				}
			}
		}
	});
	*/
	
		
})(jQuery); 