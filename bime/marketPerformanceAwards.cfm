<cfparam name="form.filterQtr" default="Q1" />
<cfparam name="form.filterYear" default="2018" />
<cfparam name="bDate" default= '2017-10-01' />
<cfparam name="eDate" default= '2017-12-31' />
<cfset request.filterUrl = '/?performance'/>
<cfswitch  expression="#form.filterQtr#">
	<cfcase value="Q1">
		<cfset bDate = '#form.filterYear#-01-01'/>
		<cfset eDate = '#form.filterYear#-03-31'/>
	</cfcase>
	<cfcase value="Q2">
		<cfset bDate = '#form.filterYear#-04-01'/>
		<cfset eDate = '#form.filterYear#-06-30'/>
	</cfcase>
	<cfcase value="Q3">
		<cfset bDate = '#form.filterYear#-07-01'/>
		<cfset eDate = '#form.filterYear#-09-30'/>
	</cfcase>
	<cfcase value="Q4">
		<cfset bDate = '#form.filterYear#-10-01'/>
		<cfset eDate = '#form.filterYear#-12-31'/>
	</cfcase>	
</cfswitch>
<cfset month1 = bDate />
<cfset month3 = dateadd('m', +2, bDate) />
<!---
	<cfset startMonth = month(bDate) />
	<cfset month1 = bDate />
	<cfset month2 = dateadd('m', +1, bDate) />
	<cfset month3 = dateadd('m', +2, bDate) />
	<cfset month1FirstDay = '#year(month1)#-#month(month1)#-01'/>
	<cfset month1LastDay = '#year(month1)#-#month(month1)#-#DaysInMonth(month1)#'/>
	<cfset month2FirstDay = '#year(month2)#-#month(month2)#-01'/>
	<cfset month2LastDay = '#year(month2)#-#month(month2)#-#DaysInMonth(month2)#'/>
	<cfset month3FirstDay = '#year(month3)#-#month(month3)#-01'/>
	<cfset month3LastDay = '#year(month3)#-#month(month3)#-#DaysInMonth(month3)#'/>
--->

		
<cfquery datasource="paintsquare" name="qTotalPerQuarter">
		--total dollars
	select sum(value) as total
	from (select sum(amount)/count(bidid) as value
  	FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
  group by bidid, paintpublishdate, amount) as tbl
</cfquery>
 <cfquery datasource="paintsquare" name="qTotalPaintPerQuarter">
 --total dollars paint
  select sum(amount) as total
  from pbt_market_total_dollars_unique
  where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59' and valuetypeid=2
</cfquery>
	
		
	
		

<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>

	<style>
		.bimeBoxText {min-height: 75px; min-width: 550px;float: left;font-size: 1.8EM;margin-top:20px;text-align:center;}
		.bimeBoxChart {min-height: 350px; float: left;text-align:center;}
		.pageTitle {background-color: #003163;color:white;font-size: 1.5EM;min-height: 40px;padding-left:15px;}
		section {width: 100%;}
		.container {border:2px solid black;padding-left:0;padding-right: 0;margin-left: 5px;}
	</style>
	
	<div class="container">
		<section>
			<header class="pageTitle">Market Performance Awards - <cfoutput>#dateformat(month1, 'mmm yyy')# - #dateformat(month3, 'mmm yyy')#</cfoutput></header>
		</section>
		<section>
			<cfinclude template="inc/filter.cfm" /> 
		</section>
		<section>
			<cfoutput>
				<div class="bimeBoxText"><strong>Total Dollars</strong> - #dollarformat(qTotalPerQuarter.total)#</div>
				<div class="bimeBoxText"><strong>Total Dollars : Painting</strong> - #dollarformat(qTotalPaintPerQuarter.total)#</div>
				<div class="bimeBoxChart col-xs-6"><div id="award_volume" style="width:550px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-6"><div id="award_contract" style="width:550px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-12"><div id="award_states" style="width:1100px;height:350px;"></div></div>	
			</cfoutput>
		</section>
		
	</div>
		 <cfoutput>
		 <!---#bDate# - #eDate#<br/>
		 #month1# / #month2# / #month3#<br />
		 #month1FirstDay# #month1LastDay#	 <br />	 
		 #month2FirstDay# #month2LastDay#	 <br />	
		 #month3FirstDay# #month3LastDay#	 <br />	--->
		
			 
		 <!---<h1>Award Volume by Month - #dollarformat(qTotalPerQuarterPerMonth.total[1])# #dollarformat(qTotalPerQuarterPerMonth.total[2])# #dollarformat(qTotalPerQuarterPerMonth.total[3])#</h1>
		 
		 <h1>Award Contract Avg by Month - #dollarformat(qAvgContractValuePerMonth.total[1]/qAvgContractValuePerMonth.bidcount[1])# #dollarformat(qAvgContractValuePerMonth.total[2]/qAvgContractValuePerMonth.bidcount[2])# #dollarformat(qAvgContractValuePerMonth.total[3]/qAvgContractValuePerMonth.bidcount[3])#</h1>
		 <cfdump var="#qAwardVolumnByState#" />
		 <div id="echart_pie" style="height:500px; width:600px"></div>
		 <div id="echart_bar" style="height:500px; width:800px"></div>--->
		 
		 <!---<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px src="https://technologypublishing.bime.io/dashboard/market-performance-total_v2?access_token=#session.auth.user_access_token###year=#session.auth.default_year#&quarter=#session.auth.default_qtr#"></iframe>--->
		 
		 </cfoutput>
    
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
				$.get('bime/process.cfm?main=mpa&sub=volumeByMonth&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
				$.get('bime/process.cfm?main=mpa&sub=valueByMonth&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
				$.get('bime/process.cfm?main=mpa&sub=volumeByState&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
				$.get('bime/process.cfm?result=states&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
