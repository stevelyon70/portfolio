<cfset the_dsn = "paintsquare">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>		

<div id="echart_pie" style="height:500px; width:600px"></div>
<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>
<!--- Custom Theme Scripts 
<cfinclude template="echarts.cfm">--->
<script>
	
	function init_echarts() {

		if( typeof (echarts) === 'undefined'){ return; }
		console.log('init_echarts');


		var theme = {
		  color: [
			  '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
			  '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
		  ]
		};


		//echart Pie		  
		if ($('#echart_pie').length ){  

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

		  /*var dataStyle = {
			normal: {
			  label: {
				show: false
			  },
			  labelLine: {
				show: false
			  }
			}
		  };*/

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
			$.get('process.cfm').done(function (data) {
				echartPie.hideLoading();
				_data = JSON.parse(data)
				console.log(_data);
				//alert(_data.leg);
				//alert(_data.items);
				// fill in data
				echartPie.setOption({
					legend: {
						data: _data.leg
					},
					series: [{
						data: _data.items
						/*data:[
						{value: 1, name: "company-link"},
						{value: 1, name: "company-logo-link"},
						{value: 1, name: "download-file"},
						{value: 9, name: "download-url"},
						{value: 17, name: "image-gallery"},
						{value: 8, name: "recent-content"},
						{value: 1, name: "social-media-Facebook"},
						{value: 8, name: "video-gallery"}	
						]*/
					}]
				});
			});				
			
			
				/*$.ajax({
					url: "process.cfm?r=" + Math.random(),
					type: 'GET',
					dataType: "json",
					success: function(result) {
						// ... Process the result ...
						echartPie.hideLoading();//alert(result.legend);
						// fill in data
						echartPie.setOption({
							legend: {
								data: [result.legend]
							},
							series: [{
								data: data.items
								data:[
								{value: 1, name: "company-link"},
								{value: 1, name: "company-logo-link"},
								{value: 1, name: "download-file"},
								{value: 9, name: "download-url"},
								{value: 17, name: "image-gallery"},
								{value: 8, name: "recent-content"},
								{value: 1, name: "social-media-Facebook"},
								{value: 8, name: "video-gallery"}	
								]
							}]
						});						

					},
					error: function (request, status, error) {
					alert("ERROR" +request.responseText);
					}
					error: function() {				
						alert('There has been an error, please alert us immediately.\nPlease provide details of what you were working on when you\nreceived this error.');						
					}
				});	*/		
			
			
			

		};	
	};		
	
	
	$(document).ready(function() {

		init_echarts();	

	});	
</script>
<cfabort>

<cfquery name="results" datasource="#the_dsn#">
SELECT SUM(amount) as amount,  count(amount) as count, 'Jul 2017' as month
FROM pbt_market_kpi_total_dollars_tagged 
WHERE (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-07-01') AND (paintpublishdate < '2017-08-01')

UNION
 
SELECT SUM(amount) as amount,  count(amount) as count, 'Aug 2017' as month
FROM pbt_market_kpi_total_dollars_tagged
WHERE (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-08-01') AND (paintpublishdate < '2017-09-01')

UNION

SELECT SUM(amount) as amount,  count(amount) as count, 'Sep 2017' as month
FROM pbt_market_kpi_total_dollars_tagged
WHERE (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-09-01') AND (paintpublishdate < '2017-10-01')
</cfquery> 

<table>
<cfloop list="bar,line,pyramid,area,horizontalbar,cone,curve,cylinder,step,scatter,pie" index="c">
<tr>
<td>
<cfchart format="html" title="Total Cost" show3d="false">
	<cfchartseries type="#c#">
		<cfoutput query="results">
		
		<cfchartdata item="#month#" value="#amount#">
		</cfoutput>
		<!---<cfchartdata item="2014" value="#RandRange(300000,900000)#">
		<cfchartdata item="2015" value="#RandRange(300000,900000)#">--->
	</cfchartseries>
</cfchart>
</td>
<td>
<cfchart format="html" title="Total Projects" show3d="false">
	<cfchartseries type="#c#">
		<cfoutput query="results">
		<cfchartdata item="#month#" value="#count#">
		</cfoutput>
		<!---<cfchartdata item="2014" value="#RandRange(300000,900000)#">
		<cfchartdata item="2015" value="#RandRange(300000,900000)#">--->
	</cfchartseries>
</cfchart>
</td>
</tr>
</cfloop>
</table>

<!---<cfhtmltopdf margintop=".5" marginbottom=".5" 
 marginleft=".5" marginright=".5">
 <cfhtmltopdfitem type="header">Paint BidTracker Lead Details</cfhtmltopdfitem>
 <cfoutput>#session.leadDetail#</cfoutput>
<cfhtmltopdfitem type="pagebreak" />
<cfoutput>#session.leadDetail#</cfoutput>
 <cfhtmltopdfitem type="footer">Page: _PAGENUMBER of _LASTPAGENUMBER</cfhtmltopdfitem>
</cfhtmltopdf>--->