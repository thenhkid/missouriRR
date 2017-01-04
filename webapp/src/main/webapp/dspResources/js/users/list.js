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
    
     //initiate dataTables plugin
    var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: true,
                stateSave: true,
                "stateDuration": 600,
                "aoColumns": [
                    null, null, null, null,
                    {"bSortable": false}
                ],
                "aaSorting": [[0, 'asc']],
                "oLanguage": {
                "sSearch": "Filter:"
                }
            });
            
    
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

        var errorFound = 0;

        $('div.form-group').removeClass("has-error");
        $('span.control-label').removeClass("has-error");
        $('span.control-label').html("");
        
        var newPassword = $('#password').val();
        var confirmPassword = $('#confirmPassword').val();

        if(newPassword.length < 5) {
            $('#passwordDiv').addClass("has-error");
            $('#passwordMsg').addClass("has-error");
            $('#passwordMsg').html('The new password must be between 5 and 15 characters.');
            errorFound = 1;
        }
        
        if(confirmPassword.length < 5) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be between 5 and 15 characters.');
            errorFound = 1;
        }
        
        if(newPassword != confirmPassword) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be equal to the new password.');
            errorFound = 1;
        } 
        
        if ($('#email').val().trim() == "") {
            $('#emailDiv').addClass("has-error");
            $('#emailMsg').html('The email address is a required field.');
            errorFound = 1;
        }
        
        if ($('#username').val().trim() == "") {
            $('#usernameDiv').addClass("has-error");
            $('#usernameMsg').html('The username is a required field.');
            errorFound = 1;
        }
        
        if($('#email').val().trim() != "") {
            var emailValidated = validateEmail($('#email').val().trim());

            if (emailValidated === false) {
                $('#emailDiv').addClass("has-error");
                $('#emailMsg').html('The email address entered is not a valid email address.');
                errorFound = 1;
            }
        }
        
        if(errorFound == 0) {

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

function validateEmail($email) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if (!emailReg.test($email)) {
        return false;
    }
    else {
        return true;
    }
}
