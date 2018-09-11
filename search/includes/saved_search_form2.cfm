<div id="saved-form" class="js-frmfld" title="Save this Search">
Please enter a name for this search.
</div>
<div>
<cfif isdefined("qt")>
<CFSET qt = #replace(qt,"%22","""","ALL")#>
</cfif>
<cfoutput>
	<cfif isdefined("sort") and isdefined("desc")>
			<cfset sortdesc= "">
			<cfset sortdesc = sortdesc & "&sort=#sort#&desc=#desc#">
	<cfelse>
		<cfset sortdesc="">
	</cfif>
	<cfif isdefined("showall") and showall is not "no">
			<cfset sortdesc = sortdesc & "&showall=#showall#">
	</cfif>
<form name="saveSearchParams" id="saveSrch" action="" method="post">
	<cfif isdefined("qt")><input type="hidden" name="qt" value="#qt#"></cfif>
	<cfif isdefined("amount")><input type="Hidden" name="amount" value="#amount#"><cfelse><input type="Hidden" name="amount" value=""></cfif>
	<cfif isdefined("state")><input type="Hidden" name="state" value="#state#"><cfelse><input type="Hidden" name="state" value="66"></cfif>
	<cfif isdefined("postfrom")><input type="Hidden" name="postfrom" value="#postfrom#"><cfelse></cfif>
	<cfif isdefined("postto")><input type="Hidden" name="postto" value="#postto#"><cfelse></cfif>
	<cfif isdefined("subfrom")><input type="Hidden" name="subfrom" value="#subfrom#"><cfelse></cfif>
	<cfif isdefined("subto")><input type="Hidden" name="subto" value="#subto#"><cfelse></cfif>
	<cfif isdefined("project_stage")><input type="Hidden" name="project_stage" value="#project_stage#"><cfelse></cfif>
	<cfif isdefined("all_scopes")><input type="Hidden" name="all_scopes" value="#all_scopes#"><cfelse></cfif>
	<cfif isdefined("bidID")><input type="hidden" name="bidID" value="#bidID#"><cfelse></cfif>
	<cfif isdefined("showall")><input type="hidden" name="showall" value="#showall#"><cfelse></cfif>
	<cfif isdefined("industrial")><input type="Hidden" name="industrial" value="#industrial#"><cfelse></cfif>
	<cfif isdefined("paintingprojects")><input type="Hidden" name="paintingprojects" value="#paintingprojects#"><cfelse></cfif>
	<cfif isdefined("qualifications")><input type="Hidden" name="qualifications" value="#qualifications#"><cfelse></cfif>
	<cfif isdefined("supply")><input type="Hidden" name="supply" value="#supply#"></cfif>
	<cfif isdefined("structures")><input type="hidden" name="structures" value="#structures#"><cfelse></cfif>
	<cfif isdefined("scopes")><input type="hidden" name="scopes" value="#scopes#"></cfif>
	<cfif isdefined("sorting")><input type="hidden" name="sorting" value="#sorting#"></cfif>
	<cfif isdefined("all_services")><input type="Hidden" name="all_services" value="#all_services#"><cfelse></cfif>
	<cfif isdefined("services")><input type="Hidden" name="services" value="#services#"><cfelse></cfif>
	<cfif isdefined("commercial")><input type="Hidden" name="commercial" value="#commercial#"><cfelse></cfif>
	<cfif isdefined("generalcontracts")><input type="Hidden" name="generalcontracts" value="#generalcontracts#"><cfelse></cfif>
	<cfif isdefined("verifiedprojects")><input type="Hidden" name="verifiedprojects" value="#verifiedprojects#"><cfelse></cfif>
	<cfif isdefined("contractorname")><input type="Hidden" name="contractorname" value="#contractorname#"><cfelse></cfif>
	<cfif isdefined("filter")><input type="Hidden" name="filter" value="#filter#"><cfelse></cfif>
	<cfif isdefined("allprojects")><input type="Hidden" name="allprojects" value="#allprojects#"><cfelse></cfif>
	<cfif isdefined("planholders")><input type="Hidden" name="planholders" value="#planholders#"><cfelse></cfif>
	<input type="hidden" name="action" value="#paction#">
	<cfif isdefined("userid")><input type="hidden" name="userid" value="#userid#"></cfif>
	<input type="Hidden" name="sAction" value="SaveSearch">	
	
	<input type="text" name="label" id="label" value="" class="js-frmfld">
	<input type="submit" name="submit" value="Save Search" id="submitfrm" class="btn btn-blue js-frmfld">
	<span class="hidden">PROCESSING... <img src="../assets/images/spinner.svg" id="spin"> </span>
	<span class="hidden message"></span>
</form>
</cfoutput>
</div>
<script>
	$(function () {
		$("#saveSrch").submit(function(e){
			e.preventDefault();
			if(!$("#label").val()){
				alert('Please enter a search name');
			}
			else{
				$('.message').addClass('hidden');
				$('#spin').addClass('hidden');	
				$('#submitfrm').removeClass('btn-blue').toggleClass('btn-warning').prop('disabled', true).text('Processing');
				$.ajax({
					url: "includes/saved_search_process.cfm?val=" + Math.random(),
					type: 'POST',
					dataType: "json",
					data: $("#saveSrch").serialize(),
					success: function(result) {
						// ... Process the result ...
						if (result.valid)
						{	
							$('.js-frmfld').addClass('hidden');
							$('.message').removeClass('hidden').html(result.message);								
						}
						else
						{		
							$('#submitfrm').addClass('btn-blue').toggleClass('btn-warning').prop('disabled', false).text('Save Search');
							$('.message').removeClass('hidden').html(result.message);
							$('#spin').addClass('hidden');
						}
					},

					error: function() {
						$('#spin').addClass('hidden');
						$('#submitfrm').addClass('btn-blue').toggleClass('btn-warning').prop('disabled', false).text('Submit');						
						alert('There has been an error, please alert us immediately.\nPlease provide details of what you were working on when you\nreceived this error.');

					}					
					/*error: function (request, status, error) {
						alert(request.responseText);
					}*/

				});	
			}
		});
	});			 
</script>
