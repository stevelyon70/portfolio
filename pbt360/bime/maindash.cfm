<cfparam name="form.filterQtr" default="Q1" />
<cfparam name="form.filterYear" default="2018" />
<cfparam name="bDate" default= '2018-01-01' />
<cfparam name="eDate" default= '2018-03-31' />
<cfset request.filterUrl = '/?defaultdashboard'/>
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
<cfquery datasource="paintsquare" name="qIndBidsPerQtr">
	select count(distinct bidid) as total
	from pbt_market_kpi_total_projects_tagged
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)
</cfquery>
<cfquery datasource="paintsquare" name="qIndPaintBidsPerQtr">
	select count(distinct bidid) as total
	from pbt_market_kpi_total_projects_tagged
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)
	 and valuetypeid=2
</cfquery>
<cfquery datasource="paintsquare" name="qCommBidsPerQtr">
	select count(distinct bidid) as total
	from pbt_market_kpi_total_projects_tagged
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in (14,21,22,92,72,70,15,68,25,18,26,31,69,71,26)
</cfquery>
<cfquery datasource="paintsquare" name="qCommPaintBidsPerQtr">
	select count(distinct bidid) as total
	from pbt_market_kpi_total_projects_tagged
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in (14,21,22,92,72,70,15,68,25,18,26,31,69,71,26)
	 and valuetypeid=2
</cfquery>	 
<cfquery datasource="paintsquare" name="qTop5Structures">
	select top 5 bidid, projectname,state, value_type, amount
	from pbt_market_total_dollars_unique a
	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and valuetypeid=2
	order by a.amount desc
</cfquery>	

	
		
<cfquery datasource="paintsquare" name="qTotalDollars">
	select sum(amount) as total
	from pbt_market_kpi_total_dollars
	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
</cfquery>	
<cfquery datasource="paintsquare" name="qTotalDollarsPaint">
	select sum(amount) as total
	from pbt_market_kpi_total_dollars
	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and valuetypeid=2
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
			<header class="pageTitle">Dashboard- <cfoutput>#dateformat(month1, 'mmm yyy')# - #dateformat(month3, 'mmm yyy')#</cfoutput></header>
		</section>
		<section>
			<cfinclude template="inc/filter.cfm" /> 
		</section>
		<section>
			<cfoutput>
				<div class="bimeBoxText"><strong>Industrial Bids</strong> <div>#qIndBidsPerQtr.total#</div></div>
				<div class="bimeBoxText"><strong>Industrial Bids : Painting</strong><div>#qIndPaintBidsPerQtr.total#</div></div>
				<div class="bimeBoxText"><strong>Commercial Bids</strong> <div>#qCommBidsPerQtr.total#</div></div>				
				<div class="bimeBoxText"><strong>Commercial Bids : Painting</strong> <div>#qCommPaintBidsPerQtr.total#</div></div>
				
				
				<div class="bimeBoxText"><strong>Total Dollars</strong> <div>#dollarformat(qTotalDollars.total)#</div></div>				
				<div class="bimeBoxText"><strong>Total Dollars : Painting</strong> <div>#dollarformat(qTotalDollarsPaint.total)#</div></div>
			</cfoutput>
				<div class="bimeBoxChart col-xs-6"><div id="top5Struct" style="width:650px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-6"><div id="top5ContracAwards" style="width:650px;height:350px;">
					<table class="chartbox">
						<tbody>
							<tr>
								<th colspan="5" class="tableHead">
									Top 5 Contract Awards
								</th>
							</tr>
							<tr>
								<th>Bidid</th>
								<th>Project Name</th>
								<th>State</th>
								<th>Type of Contract</th>
								<th>Award Amount</th>
							</tr>
							<cfoutput query="qTop5Structures">
							<tr>
								<td>#bidid#</td>
								<td>#left(projectname,25)#</td>
								<td>#state#</td>
								<td>#value_type#</td>
								<td>#dollarformat(amount)#</td>
							</tr>
							</cfoutput>
					</tbody>
					</table>	
				</div></div>
				<div class="bimeBoxChart col-xs-6"><div id="top5ContractorsAwarded" style="width:550px;height:350px;"></div></div><!---	--->
			
		</section>		
	</div>
		 
    
    <script type="text/javascript">
		function init_top5StructTagschart() {

			if( typeof (echarts) === 'undefined'){ return; }
			//console.log('init_echarts-volume');	

			if ($('#top5Struct').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('top5Struct'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Top 5 Structure Tags by Total Spending'
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
				$.get('bime/process.cfm?main=maindash&sub=top5StructTags&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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

		function init_top5ContracAwardschart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#top5ContracAwards').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var cnChart = echarts.init(document.getElementById('top5ContracAwards'));
				cnChart.showLoading();
				// specify chart configuration item and data
				cnChart.setOption({			
					title: {
						text: 'Top 5 Contract Awards'
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
				$.get('bime/process.cfm?main=maindash&sub=top5CA&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
		
		function init_top5ContractorsAwardedchart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#top5ContractorsAwarded').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var stChart = echarts.init(document.getElementById('top5ContractorsAwarded'));
				stChart.showLoading();
				// specify chart configuration item and data
				stChart.setOption({			
					title: {
						text: 'Top 5 Contractors by Volumn Awarded'
					},
					tooltip: {},
					//color: ['#5bbfea'],
					//legend: {data:['Month']},
					yAxis: {
						interval: '0',
						boundaryGap: 'true',
						data: []
					},
					xAxis: [
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
				$.get('bime/process.cfm?main=maindash&sub=top5Contractors&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
					stChart.hideLoading();
					_data = JSON.parse(data)
					//console.log(_data);
					stChart.setOption({
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
			init_top5StructTagschart();
			//init_top5ContracAwardschart();
			init_top5ContractorsAwardedchart();
		});			
    </script>
