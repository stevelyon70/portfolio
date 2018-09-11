
<tr>
  <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;"><cfform name="myform" >
      <cfinput type="hidden" name="userID" value="#userID#">
      <table class="grid table table-striped">
       <thead class="thead-default">
        <tr class="grid grid_head">
          <th  class="grid grid_head col-xs-1">            
             <cfif search_results.recordcount GT 0>
             <input type="checkbox" class="selAllTrash" />
              <a href="javaScript:ColdFusion.MessageBox.show('trash_confirm')">
              	 <img src="//app.paintbidtracker.com/images/icons/Trash.png" >              	
              </a><script>
					
						$(".selAllTrash").on('click',function(){
								if(this.checked){
									$('.trashbox').each(function(){
										this.checked = true;
									})
								}else{
									$('.trashbox').each(function(){
										this.checked = false;
									})
								}
							});
				</script>
              <cfelse>
              <img src="//app.paintbidtracker.com/images/icons/Trash.png" >
            </cfif>
          </th>
          <th class="grid grid_head col-xs-2">Project Name </th>
          <th class="grid grid_head col-xs-1">Stage </th>
          <th class="grid grid_head col-xs-1">Agency </th>
          <th class="grid grid_head col-xs-1">City </th>
          <th class="grid grid_head col-xs-1">State </th>
          <th class="grid grid_head col-xs-1">Phone</th>
          <th class="grid grid_head col-xs-1">Tags </th>
          <th class="grid grid_head col-xs-1">Submittal Date </th>
          <th class="grid grid_head col-xs-1">Est. Value / Project Size </th>
          <th class="grid grid_head col-xs-1">
             <cfif search_results.recordcount GT 0>
             <input type="checkbox" class="selAllSave" />
              <a href="javaScript:ColdFusion.Window.show('folderSave')"  ><img src="//app.paintbidtracker.com/images/icons/SaveFolder.png"></a>
              <script>
					
						$(".selAllSave").on('click',function(){
								if(this.checked){
									$('.savebox').each(function(){
										this.checked = true;
									})
								}else{
									$('.savebox').each(function(){
										this.checked = false;
									})
								}
							});
				</script>
             <cfelse>
              <img src="//app.paintbidtracker.com/images/icons/SaveFolder.png">
            </cfif>
		  </th>
        </tr>
        </thead>
        <cfloop query="search_results" >
          <cfif valuetype is 1>
            <cfset valueT = "Total Contract">
            <cfelseif valuetype is 2>
            <cfset valueT = "Painting Only">
            <cfelse>
            <cfset valueT = "">
          </cfif>
          <cfoutput>
            <cfif stageID EQ 5 or stageID EQ 6>
              <cfstoredproc procedure="get_low" datasource="#application.dataSource#" >
                <cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#bidid#">
                <cfprocresult name="getlow" resultset="1">
                <cfprocresult name="getlow2" resultset="2">
              </cfstoredproc>
            </cfif>
            <tr class="grid projectBid">
              <td class="grid col-xs-1">  
               <i class="clip-clipboard"></i>            
                <cfinput name="trash" type="checkbox" value="#bidID#" class="trashbox">
              </td>
              <td class="grid col-xs-2">
                 <cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
                  <span style="color: red; font-weight:bold" >New Today!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateID is 10) >
                  <span style="color: red; font-weight:bold" >Updated!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 2 >
                  <span style="color: red; font-weight:bold" >Submittal Change!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 3 >
                  <span style="color: red; font-weight:bold" >Cancelled!</span><br>                 
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 5 >
                  <span style="color: red; font-weight:bold" >Award!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 6 >
                  <span style="color: red; font-weight:bold" >Postponed!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 7 >
                  <span style="color: red; font-weight:bold" >Low Bidders!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 8 >
                  <span style="color: red; font-weight:bold" >Rejected!</span><br>
                 <cfelseif updateid is not "" and viewed is not bidid and updateid is 9 >
                  <span style="color: red; font-weight:bold" >Rebid!</span><br>
                 <cfelseif isdefined("planholders") and planholders NEQ "" >
                  <span style="color: red; font-weight:bold" >Planholders!</span><br>
                </cfif>
					 BidID - <div id="bid">#bidid#</div> &nbsp; <i class="clip-search qv" data-bidid="#bidid#"></i><br>
				<cfif len(projectnum)>Project ## - #projectnum#<br /></cfif>
                <cfif viewed is not "" >
                  <a href="../leads/?bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:purple; text-decoration:none; font-weight:bold;">
                <cfelse>
                  <a href="../leads/?bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
                </cfif>
					<div>#trim(projectname)#</div> </a>
              </td>
              <td class="grid col-xs-1">#stage#</td>
              <td class="grid col-xs-1"><cfif isdefined("supplierID") and supplierID is not "">
                  <a href="#request.rootpath#agency/?agency&supplierID=#search_results.supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;"><!---a href="?action=53&userid=#userid#&supplierID=#supplierID#" style="color:##2d53ac; text-decoration:none; font-weight:bold;"--->#owner#</a>
                  <cfelse>
                  #owner# 
                </cfif></td>
              <td class="grid col-xs-1"><cfif city NEQ "">
                  #trim(city)#
                  <cfelseif county NEQ "">
                  #trim(county)#
                </cfif></td>
              <td class="grid col-xs-1">#state#</td>
              <td class="grid col-xs-1">#phonenumber#</td>
              <td class="grid col-xs-1">#tags#</td>
              <td class="grid col-xs-1">#dateformat(submittaldate, "mm/dd/yyyy")#</td>
              <td class="grid col-xs-1">
                 <cfif stageID NEQ 5 and stageID NEQ 6>
                  <cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
                    <cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                  <cfelseif minimumvalue is not "" and minimumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">
                    #bidvalue#
                  <cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                  <cfelse>
                    <cfset bidvalue = projectsize>
                    #bidvalue#
                  </cfif>
                 <cfelseif (stageID EQ 5 or stageID EQ 6) and getlow.recordcount EQ 0 and getlow2.recordcount EQ 0>
                  <cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
                    <cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                  <cfelseif minimumvalue is not "" and minimumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">
                    #bidvalue#
                  <cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                  <cfelse>
                    <cfset bidvalue = projectsize>
                    #bidvalue#
                  </cfif>
                <cfelseif (stageID EQ 5 or stageID EQ 6) and getlow.recordcount GT 0>
                  <cfloop query="getlow">
                    <cfif supplierID NEQ "">
                      <!---a href="?action=90&supplierid=#supplierid#"---> 
                      <a href="#request.rootpath#/contractor/?contractor&supplierID=#supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;"> <font face="Arial" size="1" color="blue">#companyname#</font> </a>
                      <cfelse>
                      <font face="Arial" size="1" >#companyname#</font>
                    </cfif>
                    <br>
                    <font size=1>#dollarformat(amount)#</font><br>
                    <br>
                  </cfloop>
                  <cfelseif (stageID EQ 5 or stageID EQ 6) and getlow2.recordcount GT 0>
                  <cfloop query="getlow2">
                    <font face="Arial" size="1" >#companyname#</font> <br>
                    <font size=1>#dollarformat(amount)#</font><br>
                    <br>
                  </cfloop>
                  <cfelse>
                  <cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
                    <cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                    <cfelseif minimumvalue is not "" and minimumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">
                    #bidvalue#
                    <cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
                    <cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">
                    #bidvalue#
                    <cfelse>
                    <cfset bidvalue = #projectsize#>
                    #bidvalue#
                  </cfif>
                </cfif></td>
              <td class="grid col-xs-1"><cfif not listcontains(valuelist(pull_saved_projects.bidID),bidID)>
                  <cfinput name="check1"  type="checkbox" value="#bidID#"  class="savebox">
                  <cfelse>
                  <cfinput name="check1"  type="checkbox" value="#bidID#" disabled class="savebox">
                </cfif></td>
            </tr>
          </cfoutput>
        </cfloop>
      </table>
    </cfform></td>
</tr>
<li class="cbLI">
<div class="clipboard">
		<h3>Project Clipboard</h3>
		<div style="background:#fff">
		<table id="clipboardcontent" fitColumns="true" style="height:auto;">
			<thead>
				<tr>
					<th field="name" width=140>Name</th>
					<th field="bid" width=60 align="right">Project ID</th>
				</tr>
			</thead>
		</table>
		</div>
	</div>
</li>
<!--- Quick View Modal --->
<div class="modal fade" tabindex="-1" role="dialog" id="quickview">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h5 class="modal-title" id="detailLabel"></h5>
			</div>							  
			<div class="modal-body"></div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>	
<style>
	.activeClip{border:2px dashed #C39F30;}
</style>
<script>
$(function () {
	// Quick View hover
    	$(".qv").hover(function() {
        	$(this).css('cursor','pointer').attr('title', 'Click for project preview');
    	}, function() {
        	$(this).css('cursor','auto');
    	});

	// Quick View handler
	$(".qv").click(function(){
	  var bidID = $(this).attr('data-bidid');
	  var full = "<a href='../leads/?bidid=" + bidID + "'>View full details</a>"
	  $(".modal-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
  	  $(".modal-title").html("QUICK VIEW - BidID: " + bidID);
	
	  $(".modal-footer").html(full);		
	  $("#quickview").modal("show");
	  $(".modal-body").load('../leads/includes/quickview.cfm?bidid=' + bidID);
	});	
	var $cb = $('.cbLI').detach();
	$cb.insertAfter($('.socialLinks'));
});		 
</script>