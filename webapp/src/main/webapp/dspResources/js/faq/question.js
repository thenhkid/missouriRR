
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
});