var TableData = function () {
    //function to initiate DataTable
    //DataTable is a highly flexible tool, based upon the foundations of progressive enhancement, 
    //which will add advanced interaction controls to any HTML table
    //For more information, please visit https://datatables.net/
    var runDataTable = function () {
        var oTable = $('#award_table').dataTable({
            "aoColumnDefs": [{
                "aTargets": [0]
            }],
            "oLanguage": {
                "sLengthMenu": "Show _MENU_ Rows",
                "sSearch": "",
				"sEmptyTable": "No awards were found.",
                "oPaginate": {
                    "sPrevious": "",
                    "sNext": ""
                }
            },
			"aoColumns": [
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "date" },
						{ "sType": "string" }
					],
            "aaSorting": [
                [4, 'desc']
            ],
            "aLengthMenu": [
                [5, 10, 15, 20, -1],
                [5, 10, 15, 20, "All"] // change per page values here
            ],
            // set the initial value
            "iDisplayLength": 5,
        });
        $('#award_table_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
        // modify table search input
        $('#award_table_wrapper .dataTables_length select').addClass("m-wrap small");
        // modify table per page dropdown
        $('#award_table_wrapper .dataTables_length select').select2();
       
       
       
    };
    
 var runAgencyTable = function(){
     var oTable = $('#agencyT').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
			"aoColumns": [
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "numeric" },
						{ "sType": "numeric" }
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No agencies were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[3, 'desc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 5,
		});
		$('#agencyT_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#agencyT_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#agencyT_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#agencyT_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    	
    };  
 
    var runBrandTable = function () {
        var oTable = $('#brandT').dataTable({
            "aoColumnDefs": [{
                "aTargets": [0]
            }],
            "oLanguage": {
                "sLengthMenu": "Show _MENU_ Rows",
                "sSearch": "",
				"sEmptyTable": "No brand specifications were found.",
                "oPaginate": {
                    "sPrevious": "",
                    "sNext": ""
                }
            },
			"aoColumns": [
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" }
					],
            "aaSorting": [
                [2, 'desc']
            ],
            "aLengthMenu": [
                [5, 10, 15, 20, -1],
                [5, 10, 15, 20, "All"] // change per page values here
            ],
            // set the initial value
            "iDisplayLength": 5,
        });
        $('#brandT_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
        // modify table search input
        $('#brandT_wrapper .dataTables_length select').addClass("m-wrap small");
        // modify table per page dropdown
        $('#brandT_wrapper .dataTables_length select').select2();
       
       
       
    };
	
  var runBRTable = function(){
     var oTable = $('#bidResults').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
			
			"aoColumns": [
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "date"},
						{ "sType": "numeric"}
						
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No bid results were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[4, 'desc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 5,
		});
		$('#bidResults_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#bidResults_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#bidResults_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#bidResults_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    };  
	
	  var runContactTable = function(){
      var oTable = $('#contactT').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
			
			"aoColumns": [
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "string"},
						{ "sType": "string"}
						
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No contacts were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[3, 'desc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 5,
		});
		$('#contactT_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#contactT_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#contactT_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#contactT_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    };
	
	var runCSearchTable = function(){
     var oTable = $('#search_resultsTable').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No results were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[0, 'asc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 10,
		});
		$('#search_resultsTable_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#search_resultsTable_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#search_resultsTable_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#search_resultsTable_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    };  
 

	
		var runCLBSearchTable = function(){
     		var oTable = $('#search_resultsLBTable').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2017",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable').dataTable().fnDestroy();
   	runCLBSearchTable(); // Run your update function
});

var runCLBSearchTable_2016 = function(){
     		var oTable = $('#search_resultsLBTable_2016').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2016",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_2016_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_2016_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_2016_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable_2016').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable_2016').dataTable().fnDestroy();
   	runCLBSearchTable_2016(); // Run your update function
});

	
var runCLBSearchTable_2015 = function(){
     		var oTable = $('#search_resultsLBTable_2015').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2015",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_2015_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_2015_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_2015_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable_2015').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable_2015').dataTable().fnDestroy();
   	runCLBSearchTable_2015(); // Run your update function
});

	var runCLBSearchTable_2014 = function(){
     		var oTable = $('#search_resultsLBTable_2014').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2014",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_2014_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_2014_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_2014_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable_2014').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable_2014').dataTable().fnDestroy();
   	runCLBSearchTable_2014(); // Run your update function
});
	  
		var runCLBSearchTable_2013 = function(){
     		var oTable = $('#search_resultsLBTable_2013').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2013",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_2013_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_2013_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_2013_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable_2013').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable_2013').dataTable().fnDestroy();
   	runCLBSearchTable_2013(); // Run your update function
});
	  
	 	var runCLBSearchTable_2012 = function(){
     		var oTable = $('#search_resultsLBTable_2012').dataTable({	
		 		"aoColumns": [
							
							{ "sType": "numeric", "orderable": false},
							{ "bVisible": false },
							{ "sType": "string"},
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" },
							{ "sType": "numeric" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[8, 'desc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contractor_leaderboard_results&year_field=2012",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
							$('td:eq(1)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 aoData.push({"name":"quarter_field", "value":$("[name='quarter_field']:checked").val() });
									 aoData.push({"name":"cstate_field", "value":$("[name='cstate_field']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#search_resultsLBTable_2012_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#search_resultsLBTable_2012_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#search_resultsLBTable_2012_wrapper .dataTables_length select').select2();
			    $('#search_resultsLBTable_2012').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#responsive').modal('hide');
	
	$('#search_resultsLBTable_2012').dataTable().fnDestroy();
   	runCLBSearchTable_2012(); // Run your update function
});
 
var runAgencySearchTable = function(){
     var oTable = $('#search_AgencyresultsTable').dataTable({
			
			"aoColumns": [
						{ "sType": "string"},
						{ "sType": "string" }
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No results were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[0, 'asc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 10,
		});
		$('#search_AgencyresultsTable_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#search_AgencyresultsTable_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#search_AgencyresultsTable_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#search_AgencyresultsTable_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    };   
	
	/*
	var runContractorSearchTable = function(){
     var oTable = $('#contractor_table').dataTable({	
	 "aoColumns": [
						{ "bVisible": false },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" }
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},	
		"aaSorting" : [[1, 'asc']],	
        "processing": true,
        "serverSide": true,
        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contacts_server3",
		
		"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
					//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
					$('td:eq(0)', nRow).html('<a href="?contractor&supplierID='+aaData[0]+'">'+aaData[1]+'</a>');  return nRow;},
    	} );
		$('#contractor_table_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#contractor_table_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#contractor_table_wrapper .dataTables_length select').select2();
	    $('#contractor_table').dataTable().fnFilterOnReturn();
		//$('#contractor_table').dataTable().columnFilter();
		
	  };  
 	*/
	
		//Agency serverside processing main search page
		var runContractorSearchTable = function(){
     		var oTable = $('#contractor_table').dataTable({	
		 		"aoColumns": [
							
							{ "bVisible": false },
							{ "bVisible": false },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" },
							{ "sType": "string" }
						],
				"oLanguage" : {
					"sLengthMenu" : "Show _MENU_ Rows",
					"sSearch" : "",
					"sEmptyTable": "No results were found.",
					"oPaginate" : {
						"sPrevious" : "",
						"sNext" : ""
					},
					"sProcessing":"<div class=\"progress progress-striped active progress-sm\"><div class=\"progress-bar progress-bar-success\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\"><span class=\"sr-only\"> 40% Complete (success)</span></div></div>"
				},	
				"aaSorting" : [[2, 'asc']],
		        "processing": true,
		        "serverSide": true,
		        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contacts_server4",
				"fnPreDrawCallback":function(){
		            $("#resultsGrid").hide();
		            $("#progress_bar").show();
		           // alert("Pre Draw");
		        },
				 "fnDrawCallback":function(){
		            $("#resultsGrid").show();
		           $("#progress_bar").hide();
		            //alert("Draw");
		        },
				"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
							//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
					
							$('td:eq(0)', nRow).html('<a href="?contractor&supplierID='+aaData[1]+'">'+aaData[2]+'</a>');  return nRow;
							},
						
				 "fnServerData":function (sSource, aoData, fnCallback) {
		                            //aoData.push({"name":"year_field", "value":$("[name='year_field']:checked").val() });
									 //aoData.push({"name":"agency_name", "value":$("[name='agency_name']:checked").val() });
									 aoData.push({"name":"contractor_name", "value":$("[name='contractor_name']").val() });
									 aoData.push({"name":"geo_type", "value":$("[name='geo_type']").val() });
									 aoData.push({"name":"state_field", "value":$("[name='state_field']").val() });
									 aoData.push({"name":"structure_field", "value":$("[name='structure_field']").val() });
									 //if ($("[name='company_type_field']").val().length != 0) {
									if ( $("[name='company_type_field']").val()) {
									  aoData.push({"name":"company_type_field", "value":$("[name='company_type_field']").val() });	
									 }
									 else {
									 aoData.push({"name":"company_type_field", "value":"1" });
									 };
		                             $.getJSON( sSource, aoData, function(json) {
		                                     fnCallback(json)
		                             });
		                       },
				 "fnInitComplete": function(oSettings, json) {
		         		//$("#total").html('$'+json.fSum);
						 $('#filterInfo').attr('data-content',json.filterData);
		    		}                   			
		    	} );
				$('#contractor_table_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
				// modify table search input
				$('#contractor_table_wrapper .dataTables_length select').addClass("m-wrap small");
				// modify table per page dropdown
				$('#contractor_table_wrapper .dataTables_length select').select2();
			    $('#contractor_table').dataTable().fnFilterOnReturn();
				//$('#contractor_table').dataTable().columnFilter();

};  
	
 	$('#submit').on( 'click', function () {
	$('#resultsGrid').modal('hide');
	
	$('#contractor_table').dataTable().fnDestroy();
   	runContractorSearchTable(); // Run your update function
});
 
 var runContractorSearchTable_rev = function(){
     var oTable = $('#contractor_table_rev').dataTable({	
	 "aoColumns": [
						{ "bVisible": false },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" },
						{ "sType": "string" }
					],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"sEmptyTable": "No results were found.",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},	
		"aaSorting" : [[1, 'asc']],	
        "processing": true,
        "serverSide": true,
        "sAjaxSource": "../cfc/contractor_profile.cfc?method=pull_contacts_server",
		"fnRowCallback": function( nRow, aaData, iDisplayIndex ) {  
					//$('td:eq(0)', nRow).html('<input type="checkbox" class="chk_ctr" name="delete[]" 					value="'+aData[0]+'">');  
					$('td:eq(0)', nRow).html('<a href="?contractor&supplierID='+aaData[0]+'">'+aaData[1]+'</a>');  return nRow;},
    	} );
		$('#contractor_table_rev_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#contractor_table_rev_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#contractor_table_rev_wrapper.dataTables_length select').select2();
	    $('#contractor_table_rev').dataTable().fnFilterOnReturn();
	  };  
    var runEditableTable = function(){
    	
    	var newRow = false;
		var actualEditingRow = null;

		function restoreRow(oTable, nRow) {
			var aData = oTable.fnGetData(nRow);
			var jqTds = $('>td', nRow);

			for (var i = 0, iLen = jqTds.length; i < iLen; i++) {
				oTable.fnUpdate(aData[i], nRow, i, false);
			}

			oTable.fnDraw();
		}

		function editRow(oTable, nRow) {
			var aData = oTable.fnGetData(nRow);
			var jqTds = $('>td', nRow);
			jqTds[0].innerHTML = '<input type="text" class="form-control" value="' + aData[0] + '">';
			jqTds[1].innerHTML = '<input type="text" class="form-control" value="' + aData[1] + '">';
			jqTds[2].innerHTML = '<input type="text" class="form-control" value="' + aData[2] + '">';

			jqTds[3].innerHTML = '<a class="save-row" href="">Save</a>';
			jqTds[4].innerHTML = '<a class="cancel-row" href="">Cancel</a>';

		}

		function saveRow(oTable, nRow) {
			var jqInputs = $('input', nRow);
			oTable.fnUpdate(jqInputs[0].value, nRow, 0, false);
			oTable.fnUpdate(jqInputs[1].value, nRow, 1, false);
			oTable.fnUpdate(jqInputs[2].value, nRow, 2, false);
			oTable.fnUpdate('<a class="edit-row" href="">Edit</a>', nRow, 3, false);
			oTable.fnUpdate('<a class="delete-row" href="">Delete</a>', nRow, 4, false);
			oTable.fnDraw();
			newRow = false;
			actualEditingRow = null;
		}

		$('body').on('click', '.add-row', function(e) {
			e.preventDefault();
			if (newRow == false) {
				if (actualEditingRow) {
					restoreRow(oTable, actualEditingRow);
				}
				newRow = true;
				var aiNew = oTable.fnAddData(['', '', '', '', '']);
				var nRow = oTable.fnGetNodes(aiNew[0]);
				editRow(oTable, nRow);
				actualEditingRow = nRow;
			}
		});
		$('#sample_2').on('click', '.cancel-row', function(e) {

			e.preventDefault();
			if (newRow) {
				newRow = false;
				actualEditingRow = null;
				var nRow = $(this).parents('tr')[0];
				oTable.fnDeleteRow(nRow);

			} else {
				restoreRow(oTable, actualEditingRow);
				actualEditingRow = null;
			}
		});
		$('#sample_2').on('click', '.delete-row', function(e) {
			e.preventDefault();
			if (newRow && actualEditingRow) {
				oTable.fnDeleteRow(actualEditingRow);
				newRow = false;

			}
			var nRow = $(this).parents('tr')[0];
			bootbox.confirm("Are you sure to delete this row?", function(result) {
				if (result) {
					$.blockUI({
					message : '<i class="fa fa-spinner fa-spin"></i> Do some ajax to sync with backend...'
					});
					$.mockjax({
						url : '/tabledata/delete/webservice',
						dataType : 'json',
						responseTime : 1000,
						responseText : {
							say : 'ok'
						}
					});
					$.ajax({
						url : '/tabledata/delete/webservice',
						dataType : 'json',
						success : function(json) {
							$.unblockUI();
							if (json.say == "ok") {
							oTable.fnDeleteRow(nRow);
							}
						}
					});				
					
				}
			});
			

			
		});
		$('#sample_2').on('click', '.save-row', function(e) {
			e.preventDefault();

			var nRow = $(this).parents('tr')[0];
			$.blockUI({
					message : '<i class="fa fa-spinner fa-spin"></i> Do some ajax to sync with backend...'
					});
					$.mockjax({
						url : '/tabledata/add/webservice',
						dataType : 'json',
						responseTime : 1000,
						responseText : {
							say : 'ok'
						}
					});
					$.ajax({
						url : '/tabledata/add/webservice',
						dataType : 'json',
						success : function(json) {
							$.unblockUI();
							if (json.say == "ok") {
								saveRow(oTable, nRow);
							}
						}
					});	
		});
		$('#sample_2').on('click', '.edit-row', function(e) {
			e.preventDefault();
			if (actualEditingRow) {
				if (newRow) {
					oTable.fnDeleteRow(actualEditingRow);
					newRow = false;
				} else {
					restoreRow(oTable, actualEditingRow);

				}
			}
			var nRow = $(this).parents('tr')[0];
			editRow(oTable, nRow);
			actualEditingRow = nRow;

		});
		var oTable = $('#sample_2').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
			"oLanguage" : {
				"sLengthMenu" : "Show _MENU_ Rows",
				"sSearch" : "",
				"oPaginate" : {
					"sPrevious" : "",
					"sNext" : ""
				}
			},
			"aaSorting" : [[1, 'asc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 10,
		});
		$('#sample_2_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#sample_2_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#sample_2_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#sample_2_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
    	
    	
    	
    	
    	
    	
    };
   /* 
    var runMarketing_learnSend  = function(){
    	$( "#unlockmod" ).dialog({
						autoOpen: false,
						height: 600,
						width: 450,
						modal: true,
						position: 'center',
						buttons: {
							 "Send Report": function(){
							 	$("#upgradeform").submit()
								$( this ).dialog( "close" );
							 },
							 
							Cancel: function() {
							$( this ).dialog( "close" );
							}
						}
						
						});
	 };
	*/
	
    return {
        //main function to initiate template pages
        init: function () {
            runDataTable();
			runAgencyTable();
			runBRTable();
            runEditableTable();
			runCSearchTable();
			runCLBSearchTable();
			runAgencySearchTable();
			runBrandTable();
			runContractorSearchTable();
			runContractorSearchTable_rev();
			runCLBSearchTable_2016();
			runCLBSearchTable_2015();
			runCLBSearchTable_2014();
			runCLBSearchTable_2013();
			runCLBSearchTable_2012();
			//runMarketing_learnSend();
        }
    };
}();