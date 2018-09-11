
	<cfquery datasource="#application.dataSource#" name="articlesall">
	select a.*, b.category
	from standards a
	left outer join standardcat b on b.catID = a.catID
	where a.active = 'y' <cfif #addwords# is not "" or #searchtext# is not "">and</cfif>
		<cfif #addwords# is not "" and #searchtext# is not ""> (</cfif> <cfif #appear# is "standard_title" and searchtext is not "">
			a.standard_title like '%#searchtext#%'
		</cfif>
		<cfif #appear# is "summary" and searchtext is not "">
			a.description1 like '%#searchtext#%' or description2 like '%#searchtext#%' or description3 like '%#searchtext#%' or 
			a.description4 like '%#searchtext#%' or description5 like '%#searchtext#%' or description6 like '%#searchtext#%'
		</cfif>
		<cfif #addwords# is not ""><cfif #searchtext# is not "">#operator#</cfif> a.sspc_number like '%#addwords#%' </cfif>
		<cfif #addwords# is not "" and #searchtext# is not "">)</cfif>
		<cfif isdefined("appear2") and appear2 is not "" and appear2 is not 0>and a.catid = #appear2#</cfif>
		<cfif sort is "1">order by a.sspc_number asc</cfif>
		<cfif sort is "2">order by a.catid desc</cfif>
		<cfif sort is "3">order by a.standard_title asc</cfif>
	</cfquery>


	<table border="0" cellpadding="5" cellspacing="0" width="100%">
		<tr>
			<td width="100%" align="left" valign="top" colspan="3">
				<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="left" valign="top">
								<h3>Paint and Coatings Industry Standards</h3>
								<hr>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="5" cellspacing="0" width="100%">
		<tr>
			<td align="right" valign="top">
				<cfoutput><a href="#rootpath#?action=standards&fuseaction=search">New Search</a> | <a href="#rootpath#?action=standards">Back to all Standards</a></cfoutput>
			</td>
		</tr>
	</table>
	
	<cfif articlesall.recordcount neq 0>	
		<div id="progress_bar" class="progress progress-striped active loadBanner">
			<div class="progress-bar"  role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
				 Processing
			</div>
		</div>	   

		<table class="grid table table-striped hidden" id="results_table">
			<thead class="thead-default">
				<tr class="grid grid_head">
				  <th class="grid grid_head searchGridHead">Organization </th>
				  <th class="grid grid_head searchGridHead">Number </th>
				  <th class="grid grid_head searchGridHead">Standard Title + Description </th>
				</tr>
			</thead>
			<tfoot class="thead-default">
				<tr class="grid grid_head">
				  <th class="grid grid_head searchGridHeadB">Organization </th>
				  <th class="grid grid_head searchGridHeadB">Number </th>
				  <th class="grid grid_head searchGridHeadB">Standard Title + Description </th>
				</tr>
			</tfoot>	   

			<cfloop query="articlesall">
				<cfoutput>
					<tr>
						<td><b>#category#</b></td>
						<td>#sspc_number#</td> 
						<td>
							<a href="#rootpath#?action=standards&fuseaction=view&id=#standardid#">#standard_title#</a>
							<br>
							#ltrim(description1)#
						</td> 
					</tr>
				</cfoutput>
			</cfloop> 
		</table>

     <cfelse>  
					  
		<p align="left" style="margin-top: 18; ">
			<b>Sorry, but your search returned no results.</b><br>
		</p>	       

		<p align="left" style="margin-top: 18; ">
			<b>Search Tips:</b>
			<ul type="square">
				<li>Avoid punctuation and special characters.</li>
				<li>Try to be as general as you can when selecting keywords, or only type in the first part of the word or phrase you're searching for.</li>
				<li>If you searched for 'Appearing In: Title' only, try searching on 'Appearing In: Description' instead.</li>
				<li>If you searched on a Standard Number, try entering only the first few digits.</li>
			</ul>
		</p>	
		 
	</cfif>		  
			  
			  
<script>
	
$(function () {
	
	$('#results_table').dataTable( {
		"paging": true,
		"columnDefs": [	
        	{ "targets": [-1], "orderable": false}		
    	],		
		"initComplete": function( settings, json ) {
			$( ".loadBanner" ).addClass( "hidden" );
			$( "#results_table" ).removeClass( "hidden" );
  		}		
	} );
	
});
</script>