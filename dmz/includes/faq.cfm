<div class="page-header">
  <h3>Paint BidTracker Information <small>FAQ's</small></h3>
</div>
<div align="left">
	<!---Begin Heading--->
	<!---<table border="0" cellpadding="5" cellspacing="0" width="100%" bgcolor="ffffff">
		<tr>
			<td width="100%" align="left" valign="top" colspan="3">
				<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="left" valign="bottom">
								<h1><span style="font-size:16px">Paint BidTracker Information</span></h1>
							</td>
							<td align="right" width="33%">				
							</td>
						</tr>
					</table>
				</div>
				<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td width="100%">
								<hr class="PBT" noshade
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>--->
	<!---End Heading--->
	<!---Begin Main Area--->
	<!---Get FAQ--->
<cfquery name="faq" datasource="#application.dataSource#">
	select faqID, question, answer
	from gateway_faq
	where active=1
	and gatewayID = <cfqueryparam value="#gatewayID#" cfsqltype="cf_sql_integer">
	order by sort, question
</cfquery>
<cfoutput>
<div class="section container">
	<div class="row">
		<div class="col-sm-12 h5">
			Here are some answers to frequently asked questions regarding Paint BidTracker:
		</div>		
	</div>	
	<div class="row">
		<div class="col-sm-12">			
		</div>		
	</div>
	<div class="row">
		<div class="col-sm-12 h4">
			<cfloop query="faq">
				<i class="clip-question"></i> <a href="##faq#faqID#">#question#</a><br />
			</cfloop>
		</div>		
	</div>		
	<div class="row">
		<div class="col-sm-12">
			<cfloop query="faq">
				<p class="bg-info"><i class="clip-question"></i> <a name="faq#faqID#"></a>#question# </p>
				<p class="h6">#answer# <!--[<a href="##top"><i class="clip-chevron-up text-muted"></i>back to top</a>]--></p>
				<hr size="1" color="C0C0C0" noshade>
			</cfloop>
		</div>		
	</div>	
</div>
</cfoutput>
	<!---End Main Area--->
</div>

					
					