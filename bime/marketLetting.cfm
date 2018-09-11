<cfparam name="form.filterQtr" default="Q1" />
<cfparam name="form.filterYear" default="2018" />
<cfparam name="bDate" default= '2018-01-01' />
<cfparam name="eDate" default= '2018-03-31' />
<cfset request.filterUrl = '/?market_letting'/>
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
<cfquery datasource="paintsquare" name="qIndTotalPerQuarter">
	select count(*) as total
	FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
	 where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	 and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)							 
</cfquery>
 <cfquery datasource="paintsquare" name="qIndPaintTotalPaintPerQuarter">
	 --all ind paint
	select count(*) as total
	FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)
	 and valuetypeid=2
</cfquery>
	 <cfset gcInd = qIndTotalPerQuarter.total - qIndPaintTotalPaintPerQuarter.total />
<cfquery datasource="paintsquare" name="qCommTotalPerQuarter">
	select count(*) as total
	FROM [paintsquare].[dbo].[pbt_market_kpi_total_projects_tagged]
	 where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	 and tagid in (14,21,22,92,72,70,15,68,25,18,26,31,69,71,26)															 
</cfquery>
 <cfquery datasource="paintsquare" name="qCommPaintTotalPaintPerQuarter">
	 --all ind paint
	select count(*) as total
	FROM [paintsquare].[dbo].[pbt_market_kpi_total_projects_tagged]
	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
	and tagid in  (14,21,22,92,72,70,15,68,25,18,26,31,69,71,26)	
	 and valuetypeid=2
</cfquery>
	 
	 <cfset gcCom = qCommTotalPerQuarter.total - qCommPaintTotalPaintPerQuarter.total />
	<!--- <cfquery datasource="paintsquare" name="qIndTotalPerQuarter">
		select count(*) as total, #DateFormat(month1, "m")# as mth, '#DateFormat(month1, "mmm")# #DateFormat(month1, "yyyy")#' as mthname
		FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
		 where '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
		 and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)	
																	 
		union
																	 
		select count(*) as total, #DateFormat(month2, "m")# as mth, '#DateFormat(month2, "mmm")# #DateFormat(month2, "yyyy")#' as mthname
		FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
		 where '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
		 and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)
		 
		union
		 
		select count(*) as total, #DateFormat(month3, "m")# as mth, '#DateFormat(month3, "mmm")# #DateFormat(month3, "yyyy")#' as mthname
		FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
		 where '#month3FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
		 and tagid in (14,8,21,17,675,20,79,16,11,13,70,19,18,24,10,23,652,9,12,74,73,20,75,76,77,78)
	</cfquery>
	<cfquery datasource="paintsquare" name="qTotalPerQuarterPerMonth" result="r1">
		--total dollars per month
		select sum(mth1.value) as total, #DateFormat(month1, "m")# as mth, '#DateFormat(month1, "mmm")# #DateFormat(month1, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		union 

		select sum(mth1.value) as total, #DateFormat(month2, "m")# as mth, '#DateFormat(month2, "mmm")# #DateFormat(month2, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		union

		select sum(mth1.value) as total, #DateFormat(month3, "m")# as mth, '#DateFormat(month3, "mmm")# #DateFormat(month3, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month3FirstDay# 00:00:00' and paintpublishdate <= '#month3LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		order by mth
	</cfquery>
		
	<cfquery datasource="paintsquare" name="qAvgContractValuePerMonth" result="r2">
		select sum(mth1.value) as total, #DateFormat(month1, "m")# as mth, '#DateFormat(month1, "mmm")# #DateFormat(month1, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' ) as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		union 

		select sum(mth1.value) as total, #DateFormat(month2, "m")# as mth, '#DateFormat(month2, "mmm")# #DateFormat(month2, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' ) as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		union

		select sum(mth1.value) as total, #DateFormat(month3, "m")# as mth, '#DateFormat(month3, "mmm")# #DateFormat(month3, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' ) as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month3FirstDay# 00:00:00' and paintpublishdate <= '#month3LastDay# 23:59:59' 
		group by bidid, paintpublishdate, amount) as mth1

		order by mth
	</cfquery>
		
<cfquery datasource="paintsquare" name="qAwardVolumnByState">
	select sum(value) as total, state
	from (select sum(amount)/count(bidid) as value, state
  	FROM [paintsquare].[dbo].[pbt_market_kpi_total_dollars_tagged]
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
    group by bidid, paintpublishdate, amount,state) as tbl
    Group By state
    order by state																				 
</cfquery>
--->
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
			<header class="pageTitle">Market Specification - Brand Profile - <cfoutput>#dateformat(month1, 'mmm yyy')# - #dateformat(month3, 'mmm yyy')#</cfoutput></header>
		</section>
		<section>
			<cfinclude template="inc/filter.cfm" /> 
		</section>
		<section>
			<cfoutput>
				<div class="bimeBoxText"><strong>Industrial Bids</strong> <div>#qIndTotalPerQuarter.total#</div></div>
				<div class="bimeBoxText"><strong>Industrial Bids : Painting</strong> <div>#qIndPaintTotalPaintPerQuarter.total#</div></div>
				<div class="bimeBoxText"><strong>Commercial Bids</strong> <div>#qCommTotalPerQuarter.total#</div></div>
				<div class="bimeBoxText"><strong>Commercial Bids : Painting</strong> <div>#qCommPaintTotalPaintPerQuarter.total#</div></div>
				<!--
				<div class="bimeBoxText">Ind Paint: #qIndPaintTotalPaintPerQuarter.total# GC : #gcInd#</div>
				<div class="bimeBoxText">Comm Paint: #qCommPaintTotalPaintPerQuarter.total# GC : #gcCom#</div>
				-->
				<!---div class="bimeBoxChart col-xs-4"><div id="pieChart" style="width:550px;height:350px;"></div></div--->
				
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="mlIndBids" style="width:550px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="mlIndBidsGC" style="width:550px;height:350px;"></div></div>	
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="mlIndBidsPaint" style="width:550px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="commBids" style="width:550px;height:350px;"></div></div>
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="commBidsGC" style="width:550px;height:350px;"></div></div>	
				<div class="bimeBoxChart col-xs-12 col-sm-6"><div id="commBidsPaint" style="width:550px;height:350px;"></div></div>
			</cfoutput>
		</section>
		
	</div>
    <script type="text/javascript">
		function init_mlIndBidschart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#mlIndBids').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('mlIndBids'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Industrial Bids'
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
						 formatter: function(value){return [(value) ];}
						  }
					  }
					],
					series: [
						{
							name: 'Number of Bids',
							type: 'pie',
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
										var thisVal = (value.value).toFixed(0);							
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
											{offset: 0.5, color: '#3dff8d'},
											{offset: 1, color: '#188df0'}
										]
									)
								}
							}

						}
					]

				});			
				// Asynchronous data loading 
				$.get('bime/process.cfm?main=mktLet&sub=indBids&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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

			if ($('#mlIndBidsGC').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var cnChart = echarts.init(document.getElementById('mlIndBidsGC'));
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
				$.get('bime/process.cfm?main=mktLet&sub=valueByMonth&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
		
		function init_commBidschart() {

			if( typeof (echarts) === 'undefined'){ return; }
			

			if ($('#commBids').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var stChart = echarts.init(document.getElementById('commBids'));
				stChart.showLoading();
				// specify chart configuration item and data
				stChart.setOption({			
					title: {
						text: 'Commercial Bids'
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
						 formatter: function(value){return [value];}
						  }
					  }
					],
					series: [
						{
						name: 'Number of Bids',
						type: 'pie',
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
									var thisVal = (values.value).toFixed(0);							
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
				$.get('bime/process.cfm?main=mktLet&sub=commBids&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
		function init_commBidsGCchart() {

			if( typeof (echarts) === 'undefined'){ return; }
			

			if ($('#commBidsGC').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var stChart = echarts.init(document.getElementById('commBidsGC'));
				stChart.showLoading();
				// specify chart configuration item and data
				stChart.setOption({			
					title: {
						text: 'Commercial Bids'
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
						 formatter: function(value){return [value];}
						  }
					  }
					],
					series: [
						{
						name: 'Number of Bids',
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
									var thisVal = (values.value).toFixed(0);							
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
				$.get('bime/process.cfm?main=mktLet&sub=commBidsGC&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
		function init_commBidsPaintchart() {

			if( typeof (echarts) === 'undefined'){ return; }
			

			if ($('#commBidsPaint').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var stChart = echarts.init(document.getElementById('commBidsPaint'));
				stChart.showLoading();
				// specify chart configuration item and data
				stChart.setOption({			
					title: {
						text: 'Commercial Bids'
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
						 formatter: function(value){return [value];}
						  }
					  }
					],
					series: [
						{
						name: 'Number of Bids',
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
									var thisVal = (values.value).toFixed(0);							
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
				$.get('bime/process.cfm?main=mktLet&sub=commBidsPaint&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
			if ($('#pieChart').length ){  
			var theme = {
			  color: [
				  '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
				  '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
			  ]
			};
			  var echartPie = echarts.init(document.getElementById('pieChart'),theme);

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
				$.get('bime/process.cfm?main=mktLet&sub=pie&bDate=<cfoutput>#bDate#&eDate=#eDate#</cfoutput>').done(function (data) {
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
		
		function init_mlIndBidsGCchart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#mlIndBidsGC').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('mlIndBidsGC'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Industrial Bids'
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
						 formatter: function(value){return [(value) ];}
						  }
					  }
					],
					series: [
						{
							name: 'Number of Bids',
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
										var thisVal = (value.value).toFixed(0);							
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
											{offset: 0.5, color: '#3dff8d'},
											{offset: 1, color: '#188df0'}
										]
									)
								}
							}

						}
					]

				});			
				// Asynchronous data loading 
				$.get('bime/process.cfm?main=mktLet&sub=indBidsGC&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
		
		function init_mlIndBidsPaintchart() {

			if( typeof (echarts) === 'undefined'){ return; }

			if ($('#mlIndBidsPaint').length ){ 
				
				// based on prepared DOM, initialize echarts instance
				var vlChart = echarts.init(document.getElementById('mlIndBidsPaint'));
				vlChart.showLoading();
				// specify chart configuration item and data
				vlChart.setOption({			
					title: {
						text: 'Industrial Bids'
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
						 formatter: function(value){return [(value) ];}
						  }
					  }
					],
					series: [
						{
							name: 'Number of Bids',
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
										var thisVal = (value.value).toFixed(0);							
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
											{offset: 0.5, color: '#3dff8d'},
											{offset: 1, color: '#188df0'}
										]
									)
								}
							}

						}
					]

				});			
				// Asynchronous data loading 
				$.get('bime/process.cfm?main=mktLet&sub=indBidsPaint&bDate=<cfoutput>#bDate#</cfoutput>').done(function (data) {
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
		
		$(document).ready(function() {
			init_mlIndBidschart();	
			init_mlIndBidsGCchart();
			init_mlIndBidsPaintchart();	
			
			init_commBidschart();
			init_commBidsGCchart();
			init_commBidsPaintchart();
		});			
    </script>
