/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }
    
    //Show the modification field modal
    $('.newUser').click(function (event) {
        $('.popover').popover('destroy');
        $.ajax({
            url: 'users/user.create',
            type: 'GET',
            success: function (data) {
                data = $(data);

                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        title: "New User",
                        message: data
                    });
                }
            },
            error: function (error) {
                console.log(error);
            }
        });
    });
    
    //Function to submit the changes to an existing administrator or 
    //submit the new user fields from the modal window.
    $(document).on('click', '#saveNewUser', function(event) {

      $('div.form-group').removeClass("has-error");
        $('span.control-label').removeClass("has-error");
        $('span.control-label').html("");

        var newPassword = $('#password').val();
        var confirmPassword = $('#confirmPassword').val();

        if(newPassword.length < 5) {
            $('#passwordDiv').addClass("has-error");
            $('#passwordMsg').addClass("has-error");
            $('#passwordMsg').html('The new password must be between 5 and 15 characters.');
        }
        else if(confirmPassword.length < 5) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be between 5 and 15 characters.');
        }
        else if(newPassword != confirmPassword) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be equal to the new password.');
        } else {

            var formData = $("#newuserform").serialize();

            $.ajax({
                url: 'users/user.create',
                data: formData,
                type: "POST",
                async: false,
                success: function(data) {

                    if (data.indexOf('?i=') != -1) {
                        var url = $(data).find('#encryptedURL').val();
                        window.location.href = "users/details"+url;
                    }
                    else {
                        $('.popover').popover('destroy');
                        bootbox.hideAll();
                        bootbox.dialog({
                            title: "New User",
                            message: data
                        });
                    }
                }
            });
            event.preventDefault();
            return false;
        }

    });
    
    
});

