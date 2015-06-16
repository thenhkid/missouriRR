
jQuery(function ($) {
    $("input:text,form").attr("autocomplete", "off");
        
    $('#categoryId').change(function() {        	
        var categoryId = $(this).val();
        //we refresh the dropdown with max pos for the category
        $.ajax({
            type: 'POST',
            url: "/faq/chagneDisplayPosList.do",
            data:{'categoryId': categoryId}, 
            success: function(data) {
                 $("#displayPosDiv").html(data);
            }
        });
    }); 

        $('.deleteDocument').click(function() {        	
        var documentId = $(this).attr('rel');
        alert(documentId);
        //we refresh the dropdown with max pos for the category
        $.ajax({
            type: 'POST',
            url: "/faq/deleteDocument.do",
            data:{'documentId': documentId}, 
            success: function(data) {
                 $("#documentListDiv").html(data);
            }
        });
    }); 
    
    
});