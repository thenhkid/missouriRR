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
       
        loadActivityLog($('td.active.survey').children('a').attr('rel'), $('td.active.survey').children('a').text());
        
        $("input:text,form").attr("autocomplete", "off");
        
         $(document).on('click', '.loadActivityLog', function() {
             $('.entity').removeClass("active");
             $(this).parent().addClass("active");
             loadActivityLog($(this).attr('rel'), $(this).attr('text'));
         });
         
         $(document).on('click', '#createNewEntry', function() {
            var surveyId = $('td.active.survey').children('a').attr('rel'); 
         });
        
    });
});

function loadActivityLog(surveyId, surveyName) {
    $('#surveyName').html(surveyName);
    $.ajax({
        url: 'getDistrictActivityLog',
        data: {'surveyId':surveyId},
        type: "GET",
        success: function(data) {
            $('#activityLogList').html(data);
        }
   });
}