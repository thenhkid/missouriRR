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
        
        //Show the modification field modal
        $('.newSurvey').click(function() {
            
            $.ajax({
                url: 'surveys/getAvailableSurveys.do',
                type: "GET",
                success: function(data) {
                    $("#surveyModal").html(data);
                }
            });
            
        });
        
        /* Function to check if engagments are required */
        $(document).on('change', '.startSurvey', function() {
           
            var selSurvey = $(this).val();
            var i = $('.main').attr('rel');
            var v = $('.main').attr('rel2');
            
            if(selSurvey > 0) {
                var engagementRequired = $(this).attr('rel');
                var allowEngagement = $(this).attr('rel2');
                var duplicatesAllowed = $(this).attr('rel3');
                
                /* If engagments are required go get the engagements for this patient */
                if(engagementRequired == true) {
                    /*$.ajax({
                        url: 'surveys/getAvailableEngagements.do',
                        data: {'i':i,'v':v},
                        type: "GET",
                        success: function(data) {
                           
                        }
                    });*/
                }
                
                else {
                   $('.startSurveyBtn').show();
                }
            }
            else {
                $('.startSurveyBtn').hide();
            }
            
        });
        
        
        /* Function to start the survey */
        $(document).on('click', '.startSurveyBtn', function() {
           
           var selSurvey = $('.startSurvey').val();
           
           var i = $('.main').attr('rel');
           var v = $('.main').attr('rel2');
           
           if(selSurvey > 0) {
               window.location.href= "/clients/surveys/takeSurvey?i="+i+"&c=0&s="+selSurvey+"&v="+v;
           }
            
        });
        
    });
});