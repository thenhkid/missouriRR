/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function($) {
    
    $('.passwordMsgContainer').hide();
        
    $('.resetPassword').click(function() {
        
        $('#newPasswordMsg').val("");

        var newPassword = $('#newPassword').val();
        var confirmPassword = $('#confirmPassword').val();

        if(newPassword.length < 5) {
            $('.passwordMsgContainer').show();
            $('#newPasswordMsg').html('The new password must be between 5 and 15 characters.');
        }
        else if(confirmPassword.length < 5) {
            $('.passwordMsgContainer').show();
            $('#newPasswordMsg').html('The confirm password must be between 5 and 15 characters.');
        }
        else if(newPassword != confirmPassword) {
            $('.passwordMsgContainer').show();
            $('#newPasswordMsg').html('The confirm password must match the new password.');
        }
        else {

            $('#resetPassword').submit();

        }

    });
        
});