<!doctype html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<meta charset="UTF-8">
<title>Cryptocurrency </title>
</head>

<body>
<div class="ajaxBox">
<div class="currentvalue now"></div>
<div class="currentvalue row headerrow">
	<div class="col-sm-3">Type</div>
	<div class="col-sm-3">Current Per Coin Value</div>
	<div class="col-sm-3">Current Total Value</div>
	<div class="col-sm-3">=/-</div>
</div>
<div class="currentvalue row">
	<div class="col-sm-3">Bitcoin</div>
	<div class="col-sm-3 btc"></div>
	<div class="col-sm-3 btcnow"></div>
	<div class="col-sm-3 btcup"></div>
</div>
<div class="currentvalue row">
	<div class="col-sm-3">Ether</div>
	<div class="col-sm-3 eth"></div>
	<div class="col-sm-3 ethnow"></div>
	<div class="col-sm-3 ethup"></div>
</div>
<div class="currentvalue row">
	<div class="col-sm-3">Litecoin</div>	
	<div class="col-sm-3 ltc"></div>
	<div class="col-sm-3 ltcnow"></div>
	<div class="col-sm-3 ltcup"></div>
</div>
<div class="currentvalue row">
	<div class="col-sm-6">Earned</div>
	<div class="col-sm-3 earnedup"></div>	
	<div class="col-sm-3 totalup"></div>
</div>
</div>
<!---
<cfchart chartheight="500" chartwidth="500" format="png" title="Amount" show3d="yes" showlegend="yes">
	<cfchartseries itemcolumn="" serieslabel="current coins" type="bar">
		<cfchartdata item="Bitcoin" value=".221" />
		<cfchartdata item="Ethereum" value="12.027" />
		<cfchartdata item="Litecoin" value="1" />	
	</cfchartseries>
	<cfchartseries itemcolumn="" serieslabel="projected coins" type="bar">
		<cfchartdata item="Bitcoin" value="1" />
		<cfchartdata item="Ethereum" value="40" />
		<cfchartdata item="Litecoin" value="10" />	
	</cfchartseries>
</cfchart>
<cfchart chartheight="500" chartwidth="500" format="png" title="Value" labelmask="" labelformat="currency" show3d="yes" showlegend="yes" >
	<cfchartseries serieslabel="current value" type="bar" >
		<cfchartdata item="Bitcoin" value="507.66" />
		<cfchartdata item="Ethereum" value="2420.34" />
		<cfchartdata item="Litecoin" value="43.55" />	
	</cfchartseries>
	<cfchartseries itemcolumn="init value" serieslabel="init value" type="bar">
		<cfchartdata item="Bitcoin" value="436" />
		<cfchartdata item="Ethereum" value="2630" />
		<cfchartdata item="Litecoin" value="45" />	
	</cfchartseries>	
</cfchart>

<cfchart chartheight="500" chartwidth="500" format="png" title="Retirement" labelmask="" labelformat="currency" show3d="yes" showlegend="yes" >
	<cfchartseries serieslabel="current value" type="bar" >
		<cfchartdata item="TD" value="22000" />
		<cfchartdata item="HM Pension" value="6500" />
		<cfchartdata item="Voya" value="1600" />	
		<cfchartdata item="HM 401k" value="39000" />	
		<cfchartdata item="HM Pension" value="9000" />	
		<cfchartdata item="Crypto" value="2950" />
	</cfchartseries>
</cfchart>
<cfchart chartheight="500" chartwidth="500" format="png" title="Retirement" labelmask="" labelformat="currency" show3d="yes" showlegend="yes" >
	<cfchartseries serieslabel="goals" type="bar">			
		<cfchartdata item="Total Current" value="81105" />
		<cfchartdata item="Total Goal" value="150000" />		
	</cfchartseries>
</cfchart>

     --->
<script>
	
$(function() {
 // console.log( "ready!" );	
   init();
});

function init()	{
	setTimeout(getTime,1000);
	setTimeout(getBtc,1000);
	setTimeout(getEth,1000);
	setTimeout(getLtc,1000);
	setTimeout(getTot,2000);
}
	
function getTime(){
	var d = new Date();
	_now = d.toTimeString();
	$('.now').html("Updated : " + _now);
	setTimeout(function(){getTime()}, 60000);
}
	
function getBtc(){
	//console.log(Date.now);
	 $.get("https://api.coinbase.com/v2/prices/BTC-USD/spot", function(data, status){
		 var now$ = data.data.amount*0.221;
		 now$ = now$.toFixed(2);
		 var up$ = now$ - 275;
		 up$ = up$.toFixed(2);
       $('.btc').html(data.data.amount);
       $('.btcnow').html(now$);
       $('.btcup').html(up$);
		 
		 
    });   
	setTimeout(function(){getBtc()}, 60000);
}	
function getEth(){
	 $.get("https://api.coinbase.com/v2/prices/ETH-USD/spot", function(data, status){
		 var now$ = data.data.amount*12.027;
		 now$ = now$.toFixed(2);
		 var up$ = now$ - 2630;
		 up$ = up$.toFixed(2);
        $('.eth').html(data.data.amount);
        $('.ethnow').html(now$);
        $('.ethup').html(up$);
    });  
	setTimeout(function(){getEth()}, 60000);
}	
function getLtc(){
	$.get("https://api.coinbase.com/v2/prices/LTC-USD/spot", function(data, status){
		 var now$ = data.data.amount*1;
		 now$ = now$.toFixed(2);
		 var up$ = now$ - 43.55;
		 up$ = up$.toFixed(2);
        $('.ltc').html(data.data.amount);
        $('.ltcnow').html(now$);
        $('.ltcup').html(up$);
    });  
	setTimeout(function(){getLtc()}, 60000);
	
}		
function getTot(){
	tot$ = parseFloat($('.btcup').html()) + parseFloat($('.ltcup').html()) + parseFloat($('.ethup').html());
	$('.totalup').html('$'+tot$);
	totern$ = parseFloat($('.btcnow').html()) + parseFloat($('.ltcnow').html()) + parseFloat($('.ethnow').html());
	$('.earnedup').html('$'+totern$);
	setTimeout(function(){getTot()}, 60000);
}	
	
	
	
    
</script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" type="text/css" />
<style>
	.ajaxBox{background-color: antiquewhite;font-size: 1.2em;}
	.headerrow{font-size: 1.3em;font-weight: 500;}
</style>
</body>
</html>


<!--

live get every 6000 milliseconds
update the current spot price
update the charts value displays

-->