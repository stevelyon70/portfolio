var FormElements = function () {
    //function to initiate jquery.inputlimiter
    var runInputLimiter = function () {
        $('.limited').inputlimiter({
            remText: 'You only have %n character%s remaining...',
            remFullText: 'Stop typing! You\'re not allowed any more characters!',
            limitText: 'You\'re allowed to input %n character%s into this field.'
        });
    };
    //function to initiate query.autosize    
    var runAutosize = function () {
        $("textarea.autosize").autosize();
    };
    //function to initiate Select2
    var runSelect2 = function () {
        $(".search-select").select2({
            placeholder: "Select State",
            allowClear: true
        });
		$(".search-select-structure").select2({
            placeholder: "Select Structure Type",
            allowClear: true
        });
		$(".search-select-comp").select2({
            placeholder: "Select Company Type",
            allowClear: true
        });
		$(".search-select-contract").select2({
            placeholder: "Select Contract Type",
            allowClear: true
        });
		$(".search-select-specified").select2({
            placeholder: "Select Brand Specification",
            allowClear: true
        });
    };
	
    //function to initiate jquery.maskedinput
    var runMaskInput = function () {
        $.mask.definitions['~'] = '[+-]';
        $('.input-mask-date').mask('99/99/9999');
        $('.input-mask-phone').mask('(999) 999-9999');
        $('.input-mask-eyescript').mask('~9.99 ~9.99 999');
        $(".input-mask-product").mask("a*-999-a999", {
            placeholder: " ",
            completed: function () {
                alert("You typed the following: " + this.val());
            }
        });
    };
    var runMaskMoney = function () {
        $(".currency").maskMoney();
    };
    //function to initiate bootstrap-datepicker
    var runDatePicker = function () {
        $('.date-picker').datepicker({
            autoclose: true
        });
    };
    //function to initiate bootstrap-timepicker
    var runTimePicker = function () {
        $('.time-picker').timepicker();
    };
    //function to initiate daterangepicker
    var runDateRangePicker = function () {
        $('.date-range').daterangepicker();
        $('.date-time-range').daterangepicker({
            timePicker: true,
            timePickerIncrement: 15,
            format: 'MM/DD/YYYY h:mm A'
        });
		
		$('#reportrange').daterangepicker(
    		{
		      ranges: {
		         'Today': [moment(), moment()],
		         'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
		         'Last 7 Days': [moment().subtract('days', 6), moment()],
		         'Last 30 Days': [moment().subtract('days', 29), moment()],
		         'This Month': [moment().startOf('month'), moment().endOf('month')],
				 'This Year': [moment().startOf('year'), moment().endOf('year')],
		         'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')],
				 'Last Year': [moment().subtract('year', 1).startOf('year'), moment().subtract('year', 1).endOf('year')]
		      },
		      startDate: moment().subtract('days', 29),
		      endDate: moment()
		    },
		    function(start, end) {
		        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
				//getTable(start.format("YYYY-MM-DD"), end.format("YYYY-MM-DD"), selected_goal);
				alert('A date range was chosen: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
                document.searchForm.submit();
		    }
		);

    };
    //function to initiate bootstrap-colorpicker
    var runColorPicker = function () {
        $('.color-picker').colorpicker({
            format: 'hex'
        });
        $('.color-picker-rgba').colorpicker({
            format: 'rgba'
        });
        $('.colorpicker-component').colorpicker();
    };
    //function to initiate bootstrap-colorpalette
    var runColorPalette = function () {
        $('.color-palette').colorPalette()
            .on('selectColor', function (e) {
                $('#selected-color1').val(e.color);
            });
    };
    //function to initiate jquery.tagsinput
    var runTagsInput = function () {
        $('#tags_1').tagsInput({
            width: 'auto'
        });
    };
    //function to initiate summernote
    var runSummerNote = function () {
        $('.summernote').summernote({
            height: 300,
            tabsize: 2
        });
    };
    //function to initiate ckeditor
    var runCKEditor = function () {
        CKEDITOR.disableAutoInline = true;
        $('textarea.ckeditor').ckeditor();
    };
	

    return {
        //main function to initiate template pages
        init: function () {
            runInputLimiter();
            runAutosize();
            runSelect2();
            runMaskInput();
            runMaskMoney();
            runDatePicker();
            runTimePicker();
            runDateRangePicker();
            runColorPicker();
            runColorPalette();
            runTagsInput();
            runSummerNote();
            runCKEditor();
		
			
        }
    };
}();