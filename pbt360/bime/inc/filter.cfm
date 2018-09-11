<div class="col col-xs-12">
	<form action="<cfoutput>#request.filterUrl#</cfoutput>" method="POST">
<div class="col-sm-3">Quarter: 
	<input type="radio" name="filterQtr" value="Q1" <cfif form.filterQtr is 'Q1'>checked</cfif> />Q1
	<input type="radio" name="filterQtr" value="Q2" <cfif form.filterQtr is 'Q2'>checked</cfif> />Q2
	<input type="radio" name="filterQtr" value="Q3" <cfif form.filterQtr is 'Q3'>checked</cfif> />Q3
	<input type="radio" name="filterQtr" value="Q4" <cfif form.filterQtr is 'Q4'>checked</cfif> />Q4
</div>
<div class="col-sm-3">Year : 
	<input type="radio" name="filterYear" value="2015" <cfif form.filterYear is '2015'>checked</cfif> />2015
	<input type="radio" name="filterYear" value="2016" <cfif form.filterYear is '2016'>checked</cfif> />2016
	<input type="radio" name="filterYear" value="2017" <cfif form.filterYear is '2017'>checked</cfif> />2017
	<input type="radio" name="filterYear" value="2018" <cfif form.filterYear is '2018'>checked</cfif> />2018
</div>	
<div class="col-sm-2">
	<input type="submit" value="Apply Filter" />
</div>
</form>
</div>
<style>
	input[type="radio"]{margin-left:10px;margin-right:2px;}
</style>