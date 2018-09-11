
<cfquery name="pull_cat" datasource="#application.dataSource#">
select distinct a.catid,a.category
from standardcat a
inner join standards b on b.catid = a.catid
where b.active = 'y'
order by a.catid
</cfquery>
<cfoutput>
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
			  <td align="right" valign="top">

			</tr>
		  </table>
		</div>
	  </td>
	</tr>
	</table>

 <br> You can search on specific words or phrases in the title or description of the standard, by standard number, or by organization.
 									 	
<br>
<br>
	<cfform action="index.cfm?action=standards&fuseaction=results" method="POST" enablecab="Yes" name="month">	  
					  
			 <table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" >

										<tr>
											<td width="300" align="left" valign="top">
													<strong>
														Enter Search Words
													</strong> 
												<br>
												<input type="text" name="searchtext" size="40" value="">
											</td>
											<td width="260" align="left" valign="top">
													<strong>
														Appearing In
													</strong>
												<br>
												<select name="appear" size=1 class="smtext">
													<!---option value="body">Full Article</option--->
													<option value="standard_title" selected>Title</option>
													<option value="summary" >Description</option>
													
												</select>
											</td>
										</tr>
										<tr>
											<td width="560" colspan="2" valign="top" align="left">					

													<input type="radio" name="operator" value="AND" checked>And 
													<input type="radio" name="operator" value="OR">Or 
													
												<br><br>
											</td>
										</tr>
										<tr>
											<td width="300" align="left" valign="top">
													<strong>Enter Standard Number</strong>
												<br>
												<input type="text" name="addwords" size="40" value="">
											</td>
											<td width="260" align="left" valign="top">
													<strong>Search by Organization</strong>
												<br>
												<select name="appear2" size=1 class="smtext">
													<!---option value="text">Full Article</option--->
													<option value="0" selected>All Standards </option>
													<cfloop query="pull_cat">
													<option value="#catid#">#category#</option>
													</cfloop>
													

												</select>
											</td>
										</tr>
												
										<tr> 
													<td width="200">
															<strong>Sort By:</strong>
														<br>

					<select name="sort">
					<option value="1" >Number</option>
					<option value="2">Organization</option>
					<option value="3" selected>Title</option>
					
					</select>
														</font>
													</td>
													 </tr>
								
												
		<!---<tr> 
		<td width="200">
		<font face="arial,helvetica,sans-serif" class="smtext" size="-1">
		<strong>Display Results:</strong>
		</font>
		<br>
		<font face="arial, Arial, Helvetica" size="2">Display
		<select name="RowsperPage">
		<option value="10" selected>10</option>
		<option value="20" >20</option>
		<option value="30" >30</option>
		<option value="50">50</option>
		<option value="100" >100</option>
		</select>&nbsp;results per page</font>
		</font>
		</td>


		<td width="150">



		</td>
		</tr> --->
	</table>	 
	<div align="left"><br>
<input type="submit" class="btn btn-primary" name="submit" value="Submit"><br><br></div>				  
					
					  
					  </cfform>					  
			  
</cfoutput>
		<p align="left" style="margin-top: 28; ">
			<b>Search Tips:</b>
			<ul type="square">
				<li>Avoid punctuation and special characters.</li>
				<li>Try to be as general as you can when selecting keywords, or only type in the first part of the word or phrase you're searching for.</li>
				<li>If you searched for 'Appearing In: Title' only, try searching on 'Appearing In: Description' instead.</li>
				<li>If you searched on a Standard Number, try entering only the first few digits.</li>
			</ul>
		</p>	