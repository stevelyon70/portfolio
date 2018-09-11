<!---Footer Info
Main Landing Page
*************************
Created by AF 11/2009
*************************
--->
<cfquery name="getprivacy" datasource="#application.dataSource#" maxrows="1">
	select privacy_text, updatedon
	from privacy_update
	where gateway_id = 2
	order by updateID desc
</cfquery>      
<cfset privacy_text_1 = #REReplace("#getprivacy.privacy_text#","<h1>","<h2>","ALL")#>
<cfset privacy_text_final = #REReplace("#privacy_text_1#","</h1>","</h2>","ALL")#>

<cfoutput>
<div align="left">
	<!---Begin Heading--->
	<table border="0" cellpadding="5" cellspacing="0" width="100%" bgcolor="ffffff">
		<tr>
			<td width="100%" align="left" valign="top" colspan="3">
				<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="left" valign="bottom">
								<h1><span style="font-size:16px">Paint BidTracker Information</span></h1>
							</td>
							<!---<td align="right" width="33%">
								--- AddThis Button BEGIN ---
						<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a> <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
						<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
						--- AddThis Button END ---
							</td>--->
						</tr>
					</table>
				</div>
				<!---<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td width="100%">
								<hr class="PBT" noshade>
							</td>
						</tr>
					</table>
				</div>--->
			</td>
		</tr>
	</table>
	<!---End Heading--->
	<!---Begin Main Area--->
	<table border="0" cellpadding="5" cellspacing="0" width="100%">
		<tr>
			<td valign="top">
		       <table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td width="100%" valign="bottom"><p class="header1"> 
										<b>Privacy Policy</b></a>
									</td>
								</tr>
							</table>
						<hr class="PBTsmall" noshade>
						</td>
					</tr>
					<tr>
						<td width="100%">
							<p style="margin-top: 0;">
							#dateformat(getprivacy.updatedon, "mmmm d, yyyy")#
							</p><br>
							<p style="margin-top: 0;">
							#privacy_text_final#
							</p>
						</td>
					</tr>
					<tr>
						<td width="100%">
							<hr size="1" color="C0C0C0" noshade>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;<br>
							&nbsp;
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<!---End Main Form--->
</div>
</cfoutput>

