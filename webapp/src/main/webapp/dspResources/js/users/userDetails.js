/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



jQuery(function ($) {

    $("input:text,form").attr("autocomplete", "off");

    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }

    getAssociatedPrograms();

    $('#saveUser').click(function(event) {
       
       if (checkForm()) {
           //$("#userDetails").submit();
           $('form').preventDoubleSubmission();
       }  
       else {
           event.preventDefault();
       }   
    });

    //Modal to view associated program modules
    $(document).on('click', '.viewModules', function() {
       var programId = $(this).attr('rel');

       var i = getUrlParameter('i');
       var v = getUrlParameter('v');
       
        $('.popover').popover('destroy');
        $.ajax({
            url: 'getProgramModules.do',
            data: {'i':i, 'v': v},
            type: 'GET',
            success: function (data) {
                data = $(data);

                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        size: 'large',
                        title: "Associated Modules",
                        message: data
                    });
                }
            },
            error: function (error) {
                console.log(error);
            }
        });
    });

    //Function to submit the changes to an existing user program modules
    $(document).on('click', '#submitModuleButton', function(event) {

        var ProgramModules = [];

        $('.programModules').each(function() {
            if($(this).is(":checked")) {
                 ProgramModules.push($(this).val());
            }
        });
        var s = ProgramModules.join(',');

        $('#selProgramModules').val(s);

        var formData = $("#moduleForm").serialize();

        $.ajax({
            url: 'saveProgramUserModules.do',
            data: formData,
            type: "POST",
            async: false,
            success: function(data) {
                var url = $(data).find('#encryptedURL').val();
                window.location.href = "details"+url+"&msg=moduleAdded";
            }
        });
        event.preventDefault();
        return false;

    });

    //Function to display the selected hierarchy for the selected program and user
    $(document).on('click', '.viewEntities', function() {
        var programId = $(this).attr('rel');

        var i = getUrlParameter('i');
        var v = getUrlParameter('v');
        
        $('.popover').popover('destroy');
        $.ajax({
            url: 'getProgramEntities.do',
            data: {'i':i, 'v': v},
            type: 'GET',
            success: function (data) {
                data = $(data);

                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        title: "Associated Entities",
                        message: data
                    });
                }
            },
            error: function (error) {
                console.log(error);
            }
        });


    });

    //Function to submit the selected program to the user
    $(document).on('click', '#submitEntityButton', function(event) {
        
        $('div.form-group').removeClass("has-error");
        $('span.control-label').removeClass("has-error");
        $('span.control-label').html("");
        
        if($('#selectedEntityItems').val() == null) {
            $('.orgHierarchyDiv').addClass("has-error");
            $('#selectedEntity').addClass("has-error");
            $('#selectedEntity').html('At least one entity must be selected.');
        }
        else {
            var formData = $("#newProgramEntityForm").serialize();

            $.ajax({
                url: 'saveProgramUserEntity.do',
                data: formData,
                type: "POST",
                async: false,
                success: function(data) {
                    data = $(data);

                    if(data.find('.username').length > 0) {
                       top.location.href = '/login?expired';
                    }
                    else {
                        var url = data.find('#encryptedURL').val();
                        var completed = data.find('#completed').val();

                        if(completed === "1") {
                            window.location.href = "details"+url+"&msg=entityAdded";
                        }
                        else {
                            $('.popover').popover('destroy');
                            bootbox.hideAll();
                            bootbox.dialog({
                                title: "Associated Entities",
                                message: data
                            });
                        }
                    }
                }
            });
        }
 
        event.preventDefault();
        return false;

    });
    
    $(document).on('click','.programModules',function() {
       var moduleid = $(this).val();
       if($(this).is(':checked')) {
           $.each($('.permissions_'+moduleid+ '.use'), function() {
               $(this).prop('disabled', false);
           });
       }
       else {
           $.each($('.permissions_'+moduleid), function() {
               $(this).prop('checked', false);
               $(this).prop('disabled', true);
           });
       }
    });
    
    // jQuery plugin to prevent double submission of forms
    jQuery.fn.preventDoubleSubmission = function() {
      $(this).on('submit',function(e){
        var $form = $(this);

        if ($form.data('submitted') === true) {
          // Previously submitted - don't submit again
          e.preventDefault();
        } else {
          // Mark it so that the next submit can be ignored
          $form.data('submitted', true);
        }
      });

      // Keep chainability
      return this;
    };

});

function getAssociatedPrograms() {
   var i = getUrlParameter('i');
   var v = getUrlParameter('v');
    
   $.ajax({
        url: 'getAssociatedPrograms.do',
        data: {'i':i, 'v': v},
        type: "GET",
        success: function(data) {
            $('#associatedPrograms').html(data);
        }
    });
    
}

function getUrlParameter(sParam)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) 
        {
            return sParameterName[1];
        }
    }
}   


function checkForm()
{
    var errorFound = 0;

    $('div.form-group').removeClass("has-error");
    $('span.control-label').removeClass("has-error");
    $('span.control-label').html("");

    var newPassword = $('#password').val();
    var confirmPassword = $('#confirmPassword').val();
    
    if (newPassword.trim().length > 0 || confirmPassword.trim().length > 0) {
        if(newPassword.length < 5) {
            $('#passwordDiv').addClass("has-error");
            $('#passwordMsg').addClass("has-error");
            $('#passwordMsg').html('The new password must be between 5 and 15 characters.');
            return false;
        }
        if(confirmPassword.length < 5) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be between 5 and 15 characters.');
            return false;
        } 
        if(newPassword != confirmPassword) {
            $('#confirmPasswordDiv').addClass("has-error");
            $('#confirmPasswordMsg').addClass("has-error");
            $('#confirmPasswordMsg').html('The confirm password must be equal to the new password.');
            return false;
        } 
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
        return true;
    }
    else {
        return false;
    }
}   

function validateEmail($email) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if (!emailReg.test($email)) {
        return false;
    }
    else {
        return true;
    }
}