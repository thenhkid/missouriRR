/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {

    /* File input */
    $('.pageQuestionsPanel').find('#id-input-file-2').ace_file_input({
        style: 'well',
        btn_choose: 'click to upload files',
        btn_change: null,
        no_icon: 'ace-icon fa fa-cloud-upload',
        droppable: false,
        thumbnail: 'small',
        maxSize: 4000000,
        allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx', 'ppt', 'csv', 'pptx', 'wma', 'zip', 'mp3', 'mp4'],
        before_remove: function () {
            return true;
        },
        before_change: function() {
            $('span').removeClass("has-error");
            $('div').removeClass("has-error");
            $('#docMsg').html("");
            return true;
        }
     }).on('file.error.ace', function(event, info) {
         if(info.error_count['ext'] > 0) {
            $('#docDiv').addClass("has-error");
            $('#docMsg').addClass("has-error");
            $('#docMsg').html("There were files attached that have an invalid file extension.<br />Valid File Extension:<br /> pdf, txt, doc, docx, gif, png, jpg, jpeg, xls, xlsx, csv, ppt, pptx, wma, zip, mp3, mp4");
            event.preventDefault();
        }
        else if(info.error_count['size'] > 0) {
            $('#docDiv').addClass("has-error");
            $('#docMsg').addClass("has-error");
            $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 4MB.");
            event.preventDefault();
        }
     });
    
    $(document).on('change', '#id-input-file-2', function() {
        $('span').removeClass("has-error");
        $('div').removeClass("has-error");
        $('#titleMsg').html("");
        $('#docMsg').html("");
        $('#webLinkMsg').html("");

        var errorFound = false;
        
        /** Make sure either a document is uploaded or an external link is provided **/
        if($('#id-input-file-2').val().trim() == "") {
            $('#docDiv').addClass("has-error");
            $('#webLinkDiv').addClass("has-error");
            $('#docMsg').addClass("has-error");
            $('#docMsg').html('At least one file must be uploaded.');
            errorFound = true;
        }
        
        if(errorFound == true) {
            event.preventDefault();
            return false;
        }
        else {
            $('#uploading').show();
            $('#surveyBtns').hide();
        }
        
        var submitURL = "/surveys/saveDocumentForm.do";
        $("#surveyDocForm").attr("action", submitURL);
        $("#surveyDocForm").submit();
    });
    
    /* Remove existing document */
    $(document).on('click', '.deleteDocument', function () {

        var confirmed = confirm("Are you sure you want to remove this file?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            $.ajax({
                url: '/surveys/deleteDocument.do',
                type: 'POST',
                data: {
                    'documentId': docId
                },
                success: function (data) {
                    $('#docDiv_' + docId).remove();
                },
                error: function (error) {

                }
            });
        }

    });

});