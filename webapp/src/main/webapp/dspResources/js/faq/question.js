
jQuery(function ($) {
    $("input:text,form").attr("autocomplete", "off");
        
    $('#categoryId').change(function() {        	
        var categoryId = $(this).val();
        var questionId =  $(this).attr('rel');
        //we refresh the dropdown with max pos for the category
        $.ajax({
            type: 'POST',
            url: "/faq/chagneDisplayPosList.do",
            data:{'categoryId': categoryId, 'questionId':questionId}, 
            success: function(data) {
                 $("#displayPosDiv").html(data);
            }
        });
    }); 

        $('.deleteDocument').click(function() { 
        // need to confirm
        var documentId = $(this).attr('rel');
        bootbox.confirm({
            size: 'small',
            message: "Are you sure you want to delete this event?",
            callback: function (result) {
                if (result == true) {
                    $.ajax({
                        type: 'POST',
                        url: "/faq/deleteDocument.do",
                        data:{'documentId': documentId}, 
                        success: function (data) {
                            $("#documentListDiv").html(data);
                        },
                        error: function (error) {
                            console.log(error);
                        }
                    });
                }
            }
        });   
    }); 
    
    
});