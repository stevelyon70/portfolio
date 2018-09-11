$(function() {
	$("#feedback-tab").click(function() {
		$("#feedback-form").toggle("slide");
	});

	$("#feedback-form form").on('submit', function(event) {
		var $form = $(this);
		$.ajax({
			type: $form.attr('method'),
			url: $form.attr('action'),
			data: $form.serialize(),
			success: function() {
				$(".send").hide(); $("#message").html('Thank you for your feedback'); setTimeout(function(){$("#feedback-form").toggle("slide"); $("#message").html(''); $(".send").show(); }, 3000);		}
		});
		event.preventDefault();
	});
});

