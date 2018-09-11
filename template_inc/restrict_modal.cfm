<!---
*********************************
Restricted Modal
Created by RM 3/2018
*********************************
--->

<!--- Restricted Modal --->
<div class="modal fade" id="restrictModal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" data-toggle="modal"> <!---data-backdrop="static" data-keyboard="false"--->
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
        <div class="modal-header" align="center">
         <img name="PBT" src="../assets/images/PBT_Logo_WebHeader_Home_DoubleSize.png" border="0" alt="" width="100%"/>
        </div>     
      <div class="modal-body">
		<div class="modalText">Your current subscription does not include access to Bids &amp; Results. If you would like to add access to Bids &amp; Results, please contact your sales representative or email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a>.</div>
		<!---<div class="top-gap"><button type="button" class="btn btn-danger btn-block" id="sub"><b>SUBSCRIBE</b></button></div>	--->
		<cfif isDefined("extra_message")><br><cfoutput>#extra_message#</cfoutput></cfif>    	
      </div>
 	  <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	  </div>      
    </div>
  </div>
</div> 

<script>
    $(document).ready(function(){												
       //Button clicks
        $('#sub').on('click',function(e){
            window.location.href='';
        });	
	});
</script>