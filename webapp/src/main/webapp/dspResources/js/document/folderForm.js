
jQuery(function ($) {
    $('.countyRadio').change(function() {        	
        showCountyDropDown ();
    }); 
 
});


function showCountyDropDown () {
    if ($("#isCountyFolder").is(':checked')) {
        $("#entityDropDown").show();
    } else {
        $("#entityDropDown").hide();
        $('#entityId').val(0);
    }
}
   