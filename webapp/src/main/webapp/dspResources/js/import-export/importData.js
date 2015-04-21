/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



require(['./main'], function () {
    require(['jquery'], function($) {
        
        //This function will launch the new file upload overlay with a blank screen
        $(document).on('click', '.uploadImportFile', function() {
            
            var importTypeId = $(this).attr('rel');
            
            $.ajax({
                url: '/import-export/fileUploadForm',
                data: {'importTypeId': importTypeId},
                type: "GET",
                success: function(data) {
                    $("#uploadFile").html(data);
                }
            });
        });
        
        //Function to submit file upload from the modal window.
        $(document).on('click', '#submitFileImport', function(event) {
            var errorFound = 0;

            //Remove any error message classes
            $('#uploadedFileDiv').removeClass("has-error");
            $('#uploadedFileMsg').removeClass("has-error");
            $('#uploadedFileMsg').html('');

            //Make sure a file is uploaded
            if ($('#uploadedFile').val() == '') {
                $('#uploadedFileDiv').addClass("has-error");
                $('#uploadedFileMsg').addClass("has-error");
                $('#uploadedFileMsg').html('The file is a required field.');
                errorFound = 1;
            }
            //Make sure the file is a valid format
            //(.csv)
            if ($('#uploadedFile').val() != '' && $('#uploadedFile').val().indexOf('.csv') == -1) {
                $('#uploadedFileDiv').addClass("has-error");
                $('#uploadedFileMsg').addClass("has-error");
                $('#uploadedFileMsg').html('The uploaded file must be a CSV file.');
                errorFound = 1;

            }

            if (errorFound == 1) {
                event.preventDefault();
                return false;
            }

            $('#fileUploadForm').submit();

        });

        
    });
 });
 