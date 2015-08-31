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
        allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx'],
        before_remove: function () {
            return true;
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
        
        var submitURL = "/surveys/saveDocumentForm.do";
        $("#surveyDocForm").attr("action", submitURL);
        $("#surveyDocForm").submit();
    });

});