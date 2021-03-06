/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

require(['./main'], function () {
    require(['jquery'], function($) {

        //Fade out the updated/created message after being displayed.
        if ($('.alert').length > 0) {
            $('.alert').delay(2000).fadeOut(1000);
        }
       
        loadDistricts($('td.active.entity').children('a').attr('rel'), $('td.active.entity').children('a').text());
        
        $("input:text,form").attr("autocomplete", "off");
        
         $(document).on('click', '.loadDistricts', function() {
             $('.entity').removeClass("active");
             $(this).parent().addClass("active");
             loadDistricts($(this).attr('rel'), $(this).attr('title'));
         });
        
    });
});

function loadDistricts(countyId, countyName) {
    $('#countyName').html(countyName);
    $.ajax({
        url: 'districts/getDistrictList',
        data: {'countyId':countyId},
        type: "GET",
        success: function(data) {
            $('#districtList').html(data);
        }
   });
}