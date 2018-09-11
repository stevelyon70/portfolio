<cfparam name="url.bDate" default= '2017-01-01' />
<cfparam name="url.eDate" default= '2017-12-31' />
<!doctype html>
<html>
<head>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>		


<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
<!---<img src="image_1193393.gif">--->


	<div id="award_volume" style="width: 550px;height:350px;"></div>
	<div id="award_contract" style="width: 550px;height:350px;"></div>
	<div id="award_states" style="width: 75%;height:350px;"></div>
	<!---<div id="echart_pie" style="height:500px; width:600px"></div>--->
<!---<cfoutput>
<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px src="https://technologypublishing.bime.io/dashboard/market-performance-total_v2?access_token=#session.auth.user_access_token###year=#session.auth.default_year#&quarter=#session.auth.default_qtr#"></iframe>		
</cfoutput>--->
<!---
xAxis: {data: [<cfoutput query="qTotalPerQuarterPerMonth">'#qTotalPerQuarterPerMonth.mthname#'<cfif currentrow neq qTotalPerQuarterPerMonth.recordcount>,</cfif></cfoutput>]},
data: [<cfoutput query="qTotalPerQuarterPerMonth">#qTotalPerQuarterPerMonth.total#<cfif currentrow neq qTotalPerQuarterPerMonth.recordcount>,</cfif></cfoutput>]
--->	 
</body>
    
    <script type="text/javascript">
		function init_volumechart() {

			if( typeof (echarts) === 'undefined'){ return; }
			console.log('init_echarts-volume');	

			if ($('#award_volume').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('award_volume'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Award Volume by Month'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					xAxis: {
						data: []
					},
					yAxis: [
					  {
						type : 'value',
						axisLabel : {
						 formatter: function(value){return ['$' + (value/1000000) + 'M'];}
						  }
					  }
					],
					series: [
						{
							name: 'Volume In Dollars',
							type: 'bar',
							//barWidth: '100',
							cursor: 'arrow',
							data: [],
							label: {
								normal: {
									show: 'true',
									position: 'top',
									color: '#000',
									fontWeight: 'bold',
									formatter: function(value){
										var thisVal = (value.value/1000000).toFixed(0);							
										thisRtn = '$' + thisVal + 'M';							
										return thisRtn;
									}
								},

							},
							itemStyle: {
								normal: {
									color: new echarts.graphic.LinearGradient(
										0, 0, 0, 1,
										[
											{offset: 0, color: '#83bff6'},
											{offset: 0.5, color: '#188df0'},
											{offset: 1, color: '#188df0'}
										]
									)
								}
							}

						}
					]

				});			
				// Asynchronous data loading 
				$.get('process.cfm?result=volume&bDate=<cfoutput>#url.bDate#</cfoutput>').done(function (data) {
						vlChart.hideLoading();
						_data = JSON.parse(data)
						console.log(_data);
						//alert(_data.foot);
						//alert(_data.items);
						vlChart.setOption({
						series: [{
								data: _data.items						
							}],
						xAxis: {
							//name: 'Month',
							data: _data.foot
						}
					});
				});
			};
		};

		function init_contractchart() {

			if( typeof (echarts) === 'undefined'){ return; }
			console.log('init_echarts-contract');	

			if ($('#award_contract').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var cnChart = echarts.init(document.getElementById('award_contract'));
				cnChart.showLoading();
				// specify chart configuration item and data
				cnChart.setOption({			
					title: {
						text: 'Average Contract Volume by Month'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					xAxis: {
						data: []
					},
					yAxis: [
					  {
						type : 'value',
						axisLabel : {
						 formatter: function(value){return ['$' + (value/1000000) + 'M'];}
						  }
					  }
					],
					series: [
						{
						name: 'Volume In Dollars',
						type: 'bar',
						data: [],
						//barWidth: '100',
						cursor: 'arrow',
						label: {
							normal: {
								show: 'true',
								position: 'top',
								color: '#000',
								fontWeight: 'bold',
								formatter: function(values){
									var thisVal = (values.value/1000000).toFixed(0);							
									thisRtn = '$' + thisVal + 'M';							
									return thisRtn;
								}
							},

						},
						itemStyle: {
							normal: {
								color: new echarts.graphic.LinearGradient(
									0, 0, 0, 1,
									[
										{offset: 0, color: '#9bffc4'},
										{offset: 0.5, color: '#3dff8d'},
										{offset: 1, color: '#3dff8d'}
									]
								)
							}
						}												
					}]
					

				});			
				// Asynchronous data loading 
				$.get('process.cfm?result=contract&bDate=<cfoutput>#url.bDate#</cfoutput>').done(function (data) {
					cnChart.hideLoading();
					_data = JSON.parse(data)
					//console.log(_data);
					cnChart.setOption({
						xAxis: {
							data: _data.foot
						},						
						series: [{
							data: _data.items						
						}]
					});
				});
			};
		};		
		
		function init_stateschart() {

			if( typeof (echarts) === 'undefined'){ return; }
			console.log('init_echarts-states');	

			if ($('#award_states').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var stChart = echarts.init(document.getElementById('award_states'));
				stChart.showLoading();
				// specify chart configuration item and data
				stChart.setOption({			
					title: {
						text: 'Award Volume by State'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					xAxis: {
						interval: '0',
						boundaryGap: 'true',
						data: []
					},
					yAxis: [
					  {
						type : 'value',
						axisLabel : {
						 formatter: function(value){return ['$' + (value/1000000) + 'M'];}
						  }
					  }
					],
					series: [
						{
						name: 'Volume In Dollars',
						type: 'bar',
						data: [],
						//barWidth: '100',
						//cursor: 'arrow',
						label: {
							normal: {
								show: 'true',
								position: 'top',
								color: '#000',
								fontWeight: 'bold',
								formatter: function(values){
									var thisVal = (values.value/1000000).toFixed(0);							
									thisRtn = '$' + thisVal + 'M';							
									return thisRtn;
								}
							},

						},
						itemStyle: {
							normal: {
								color: new echarts.graphic.LinearGradient(
									0, 0, 0, 1,
									[
										{offset: 0, color: '#fc8080'},
										{offset: 0.5, color: '#f94040'},
										{offset: 1, color: '#f94040'}
									]
								)
							}
						}												
					}]
					

				});			
				// Asynchronous data loading 
				$.get('process.cfm?result=states&bDate=<cfoutput>#url.bDate#&eDate=#url.eDate#</cfoutput>').done(function (data) {
					stChart.hideLoading();
					_data = JSON.parse(data)
					//console.log(_data);
					stChart.setOption({
						xAxis: {
							data: _data.foot
						},						
						series: [{
							data: _data.items						
						}]
					});
				});
			};
		};		
		
		function init_piechart() {		
			//echart Pie		  
			if ($('#echart_pie').length ){  
			var theme = {
			  color: [
				  '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
				  '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
			  ]
			};
			  var echartPie = echarts.init(document.getElementById('echart_pie'),theme);

			  echartPie.setOption({
				title: {
					text: '',
					left: 'center',
					top: 15,
					textStyle: {
						color: '#ccc'
					}
				},
				tooltip: {
				  trigger: 'item',
				  formatter: "{a} <br/>{b} : {c}" //({d}%)
				},
				legend: {
				  x: 'center',
				  y: 'bottom',
				  data: []
				},
				toolbox: {
				  show: true,
				  feature: {
					magicType: {
					  show: true,
					  type: ['pie', 'funnel'],
					  option: {
						funnel: {
						  x: '25%',
						  width: '50%',
						  funnelAlign: 'left',
						  max: 1548
						}
					  }
					}
				  }
				},
				calculable: true,
				series: [{
				  name: 'Click Totals',
				  type: 'pie',
				  radius: '50%',
				  center: ['50%', '50%'],
				  data: [],
				  itemStyle: {				  
					emphasis: {
						shadowBlur: 10,
						shadowOffsetX: 0,
						shadowColor: 'rgba(0, 0, 0, 0.5)'
					}
				  }
				}]
			  });


			  var placeHolderStyle = {
				normal: {
				  color: 'rgba(0,0,0,0)',
				  label: {
					show: false
				  },
				  labelLine: {
					show: false
				  }
				},
				emphasis: {
				  color: 'rgba(0,0,0,0)'
				}
			  };



			echartPie.showLoading();

				// Asynchronous data loading 
				$.get('process.cfm?result=states&bDate=<cfoutput>#url.bDate#&eDate=#url.eDate#</cfoutput>').done(function (data) {
					echartPie.hideLoading();
					_data = JSON.parse(data)
					console.log(_data);
					//alert(_data.leg);
					//alert(_data.items);
					// fill in data
					echartPie.setOption({
						legend: {
							data: _data.foot
						},
						series: [{
							data: _data.items						
						}]
					});
				});				

			};		
		};
		$(document).ready(function() {
			init_volumechart();	
			init_contractchart();	
			init_stateschart();
			//init_piechart();
		});			
    </script>

</html>