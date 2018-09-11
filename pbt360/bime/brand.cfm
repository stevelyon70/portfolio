<cfparam name="form.filterQtr" default="Q1" />
<cfparam name="form.filterYear" default="2018" />
<cfparam name="bDate" default= '2018-01-01' />
<cfparam name="eDate" default= '2018-03-31' />
<cfset request.filterUrl = '/?brand_dashboard'/>
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
<cfquery datasource="paintsquare" name="qIndProjects">
		--total project value dollars
	select count(distinct bidid) as total
	from pbt_market_brands_scorecard
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
</cfquery>
 <cfquery datasource="paintsquare" name="qIndProjectsPaint">
 select count(distinct bidid) as total
	from pbt_market_brands_scorecard
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59' and valuetypeid=2
</cfquery>
 <cfquery datasource="paintsquare" name="qtotalValue">
 select sum(distinct amount) as total
	from pbt_market_brands_scorecard
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
</cfquery>
	 

<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>

	<style>
		.bimeBoxText {min-height: 75px; min-width: 550px;float: left;font-size: 1.8EM;margin-top:20px;text-align:center;}
		.bimeBoxChart {min-height: 350px; float: left;text-align:center;}
		.pageTitle {background-color: #003163;color:white;font-size: 1.5EM;min-height: 40px;padding-left:15px;}
		section {width: 100%;}
		.container {border:2px solid black;padding-left:0;padding-right: 0;margin-left: 5px;}
		.chartbox{font-size:1EM;text-align:left;}
		td{padding:3px;padding-top:25px;}
		.tableHead{font-size:18px;padding-bottom: 20px;}
		
	</style>
	
	<div class="container">
		<section>
			<header class="pageTitle">Market Specification - Brand Profile - <cfoutput>#dateformat(month1, 'mmm yyy')# - #dateformat(month3, 'mmm yyy')#</cfoutput></header>
		</section>
		<section>
			<cfinclude template="inc/filter.cfm" /> 
		</section>
		<section>
			<cfoutput>	
				
				<div class="bimeBoxText col-xs-4"><strong>Number of Industrial Projects</strong> <div>#qIndProjects.total#</div></div>
				<div class="bimeBoxText col-xs-4"><strong>Number of Commercial Projects</strong> <div>#qIndProjectsPaint.total#</div></div>
				<div class="bimeBoxText col-xs-4"><strong>Total Project Value</strong> <div>#dollarformat(qtotalValue.total)#</div></div>
				<div class="bimeBoxText col-xs-4"></div>
				<div class="bimeBoxChart col-xs-6"><div id="projectsByStruc" style="width:650px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-6"><div id="projectsByState" style="width:650px;height:350px;"></div></div>	
			</cfoutput>
		</section>
		
	</div>
		 
    
    <script type="text/javascript">
		function init_projectsByStrucchart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#projectsByStruc').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('projectsByStruc'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Project by Structure'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					yAxis: {
						data: []
					},
					xAxis: [
					  {
						type : 'value',
						axisLabel : {
						 formatter: function(value){return [value];}
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
									formatter: function(values){
										var thisVal = values.value;							
										thisRtn = thisVal;							
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
				$.get('bime/process.cfm?main=brand&sub=prjStruct&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
						vlChart.hideLoading();
						_data = JSON.parse(data)
						console.log(_data);
						//alert(_data.foot);
						//alert(_data.items);
						vlChart.setOption({
						series: [{
								data: _data.items						
							}],
						yAxis: {
							//name: 'Month',
							data: _data.foot
						}
					});
				});
			};
		};

		function init_projectsByStatechart() {

			if( typeof (echarts) === 'undefined'){ return; }
			
			if ($('#projectsByState').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var cnChart = echarts.init(document.getElementById('projectsByState'));
				cnChart.showLoading();
				// specify chart configuration item and data
				cnChart.setOption({			
					title: {
						text: 'Projects By State'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					yAxis: {
						data: []
					},
					xAxis: [
					  {
						type : 'value',
						axisLabel : {
						 formatter: function(value){return [value];}
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
									var thisVal = values.value;							
									thisRtn = thisVal;							
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
				$.get('bime/process.cfm?main=brand&sub=prjbyState&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
					cnChart.hideLoading();
					_data = JSON.parse(data)
					//console.log(_data);
					cnChart.setOption({
						yAxis: {
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
			init_projectsByStrucchart();
			init_projectsByStatechart();
			
		});			
    </script>
