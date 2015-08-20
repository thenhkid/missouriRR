/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    $('#user-profile-3')
            .find('input[type=file]').ace_file_input({
                style: 'well',
                btn_choose: 'Change Profile Photo',
                btn_change: null,
                no_icon: 'ace-icon fa fa-picture-o',
                thumbnail: 'large',
                droppable: true,
                allowExt: ['jpg', 'jpeg', 'png', 'gif'],
                allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
            })
            .end().find('button[type=reset]').on(ace.click_event, function () {
        $('#user-profile-3 input[type=file]').ace_file_input('reset_input');
    });
    
    
    if($('#avatar').attr('src') != "/profilePhotos/") {
        $('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);
    }
    
    
    $('#user-profile-3').find('.remove').on('click',function() {
        $.ajax({
            type: 'POST',
            url: '/profile/removePhoto.do',
            success: function(data, event) {
               
            }
        });
    });

   // $('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);

    $(document).on('click', '.btn-info', function() {
        
         var errorFound = false;

        if ($('#email').val().trim() == "") {
            $('#emailDiv').addClass("has-error");
            errorFound = true;
        }
        
        if ($('#firstName').val().trim() == "" || $('#lastName').val().trim() == "") {
            $('#nameDiv').addClass("has-error");
            errorFound = true;
        }
        
        if($('#newPassword').val().trim() != "" && ($('#newPassword').val().trim() != $('#newPassword2').val().trim())) {
            $('#edit-password').addClass("has-error");
            $('#newPasswordMsg').addClass("has-error");
            $('#newPasswordMsg').html("Your two passwords did not match.");
            errorFound = true;
        }
        
        if(errorFound == false) {
            var submitURL = "/profile/saveProfileForm.do";
            $("#profileForm").attr("action", submitURL);
            $("#profileForm").submit();
        }
    });
});


