<!---
******************************
created : slyon 4/1/2017

******************************
--->
<cfparam default="folders" name="url.action" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<CFSET BASEDATE = #createodbcdate(now())#>

<cfinclude template="../template_inc/design/wrapper_top.cfm">
      <cftry>
        <cfinclude template="includes/email_pref_inc.cfm" />
        <cfcatch>
          <cfdump var="#cfcatch#" />
        </cfcatch>
      </cftry>
      <!---https://technologypublishing.bime.io/dashboard/main_dashboard##year=#application.default_year#&quarter=#application.default_qtr#---> 
      <!-- end: PAGE CONTENT--> 
    </div>
  </div>
  <!-- end: PAGE --> 
</div>
<cfinclude template="../template_inc/footer_inc.cfm">
<cfinclude template="../template_inc/feedback.cfm">	
<cfinclude template="../template_inc/script_inc.cfm">	
<script>
	jQuery(document).ready(function() {
		Main.init();
	});
</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">