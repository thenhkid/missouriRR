/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    $("input:text,form").attr("autocomplete", "off");

    $(document).ready(function () {
       if ($('.alert').length > 0) {
            $('.alert').delay(2000).fadeOut(1000);
        }
    });


    $(document).on("click", "a#announcementNotificationManagerModel", function () {
        $('.popover').popover('destroy');
        $.ajax({
            url: '/announcements/getAnnouncementNotificationModel.do',
            type: 'GET',
            success: function (data) {
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        title: "Announcement Notification Preferences",
                        message: data
                    });
                }

            },
            error: function (error) {
                console.log(error);
            }
        });
    });
    
    $(document).on('click', '#saveNotificationPreferences', function () {

        var formData = $("#notificationPreferencesForm").serialize();
        var errorFound = false;

        if ($('#notificationEmail').val() == '') {
                $('#notificationEmailGroup').addClass("has-error");
                $('#notificationEmailMessage').addClass("has-error");
                $('#notificationEmailMessage').html('The notification email address is required.');
                errorFound = true;
        }
        
        if( !isEmail($('#notificationEmail').val())) {
            $('#notificationEmailGroup').addClass("has-error");
                $('#notificationEmailMessage').addClass("has-error");
                $('#notificationEmailMessage').html('Please enter a valid email address.');
                errorFound = true;
        }


        if (errorFound == false) {
            $('#notificationEmailGroup').removeClass("has-error");
            $('#notificationEmailMessage').removeClass("has-error");
            $('#notificationEmailMessage').html('');

            $.ajax({
                url: '/announcements/saveNotificationPreferences.do',
                type: 'POST',
                data: formData,
                success: function (data) {
                    $('.successAlert').show();
                    setTimeout(function () {
                        bootbox.hideAll();
                    }, 2000);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }

        return false;
    }); 
});

function isEmail(email) {
      var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      return regex.test(email);
}
