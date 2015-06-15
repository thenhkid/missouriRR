
jQuery(function ($) {
    $("input:text,form").attr("autocomplete", "off");
        
    $('#categoryIdDropDown').change(function() {        	
        alert($(this).val()); 
        //we refresh the dropdown with max pos for the category
        
        
    }); 
});