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
        
        $("input:text,form").attr("autocomplete", "off");
        
        $('.matchClient').click(function() {
            var simClientId = $(this).attr('rel');
            var newClientId = $(this).attr('rel2');
            
            var chosenAction = $('.useType'+simClientId+':checked').val();
            
            if(chosenAction > 0) {
                $.ajax({
                    url: 'matchClient',
                    type: "POST",
                    data: {'chosenAction': chosenAction, 'newClientId': newClientId, 'simClientId': simClientId},
                    success: function(data) {
                        
                        //If data == 1 then we used the selected similar client 
                        if(data == 1) {
                            window.location.href="/MCI?msg=match";
                        }
                        //If data == 2 then we used the new client data to replace the selected similar
                        else {
                            window.location.href="/MCI?msg=merged";
                        }

                    }
                });
            }
            else {
                alert("Please choose which client data you would like to use.");
            }
            
        });
        
        
        $('#enrollClient').click(function() {
            var newClientId = $(this).attr('rel');
           
            $.ajax({
                url: 'enroll',
                type: "POST",
                data: {'newClientId': newClientId},
                success: function(data) {

                }
            });
            
            
        });
        
        
    });
});
