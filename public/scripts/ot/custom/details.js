$('document').ready(function() {
    
    $('#orderMessage').hide();
    
    $('#attributeList').sortable({
        cursor: 'ns-resize'
    });
    
    $('#saveButton').click(function() {
        $.post(
            $('#baseUrl').val() + '/ot/custom/save-attribute-order/', {
                objectId: $('#objectId').val(),
                'attributeIds[]': $('#attributeList').sortable('toArray')
            },
            function (data) {
                $('#orderMessage').text(data.msg);
                if (data.rc == 1) {
                    $('#orderMessage').removeClass('ui-state-error').addClass('ui-state-highlight');
                } else {
                    $('#orderMessage').removeClass('ui-state-highlight').addClass('ui-state-error');
                }
                
                $('#orderMessage').fadeIn();
                
                setTimeout(function() { $('#orderMessage').fadeOut(); }, 2500); 
            },
            "json"
        ).error(function(data){
        	error = JSON.parse(data.responseText);
        	alert(error.toSource())
        	$('#orderMessage').text(error.message).addClass('ui-state-error').fadeIn();
        });
    });
});