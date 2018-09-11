<cfquery name="sup" datasource="#the_dsn#">
	SELECT x.supplier_id, a.company_name
	FROM ss_account_company_xref x
	JOIN ss_account a ON a.account_id = x.account_id
	WHERE company_id = 2080   <!---#session.companyid#--->
</cfquery> 
<cfquery name="click_act" datasource="#the_dsn#">
	SELECT COUNT(Id) as count, section 
	FROM ss_click_tracker
	WHERE supplier_id = #sup.supplier_id#
	GROUP BY section
</cfquery>     


<script>
	/* ECHRTS */
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
        
				text: '<cfoutput>#sup.company_name#</cfoutput>',
        
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
				data: [<cfoutput query="click_act">'#section#'<cfif currentrow neq click_act.recordcount>,</cfif></cfoutput>]/*'Direct Access', 'E-mail Marketing', 'Union Ad', 'Video Ads', 'Search Engine'*/
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
				},
				restore: {
				  show: false,
				  title: "Restore"
				},
				saveAsImage: {
				  show: false,
				  title: "Save Image"
				}
			  }
			},
			calculable: true,
			series: [{
			  name: 'Click Totals',
			  type: 'pie',
			  radius: '50%',
			  center: ['50%', '50%'],
			  data: [
			  <cfoutput query="click_act">
				  {
					value: #count#,
					name: '#section#'
				  }
				  <cfif currentrow neq click_act.recordcount>,</cfif></cfoutput>	  
			  ],
            		itemStyle: {
                
				emphasis: {
                    
					shadowBlur: 10,
                    
					shadowOffsetX: 0,
                    
					shadowColor: 'rgba(0, 0, 0, 0.5)'
                
				}
            
			}
			}]
		  });

		  var dataStyle = {
			normal: {
			  label: {
				show: false
			  },
			  labelLine: {
				show: false
			  }
			}
		  };

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

		};			



		};	
	
	
	$(document).ready(function() {
		init_echarts();				
	});	
</script>	