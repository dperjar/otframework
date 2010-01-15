$('document').ready(function() {
		
	$('#type').change(function(e) {

		if ($(this).val() == 'multiselect' || $(this).val() == 'multicheckbox' || $(this).val() == 'radio' || $(this).val() == 'select') {
	        $('#opt').css('display', 'block');
	    } else {
	        $('#opt').css('display', 'none');
	    }           
	});
	
	$('#addRowButton').click(function() {
		var newRow = $('#optionRow').clone();
		newRow.find('input').each(function() {
			$(this).val('');
		});
		$('#options tbody').append(newRow);
	});
	
	$('#removeRowButton').click(function() {
		
	    if ($('#options tbody').children().length < 2) {
	        alert('No new rows left to remove');
	    } else {
	        $('#options tbody tr:last').remove();
	    }
	});
});