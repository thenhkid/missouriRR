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
        
        /* File input */
        $('#id-input-file-2').ace_file_input({
           style: 'well',
           btn_choose: 'click to upload the document',
           btn_change: null,
           no_icon: 'ace-icon fa fa-cloud-upload',
           droppable: false,
           thumbnail: 'small',
           allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx', 'ppt', 'csv', 'pptx', 'wma', 'zip'],
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
                $('#docMsg').html("There were files attached that have an invalid file extension.<br />Valid File Extension:<br /> pdf, txt, doc, docx, gif, png, jpg, jpeg, xls, xlsx, csv, ppt, pptx, wma, zip");
                event.preventDefault();
            }
        });
        
        $('.multiselect').multiselect({
            enableFiltering: false,
            includeSelectAllOption: true,
            buttonClass: 'btn btn-white btn-primary',
            enableClickableOptGroups: false,
            enableCaseInsensitiveFiltering: false,
            disableIfEmpty: true,
            nonSelectedText: 'Select your ' + $('#topLevelName').html(),
            numberDisplayed: 10,
            templates: {
                button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"></button>',
                ul: '<ul class="multiselect-container dropdown-menu" style="max-height:250px; overflow-y:auto"></ul>',
                filter: '<li class="multiselect-item filter"><div class="input-group"><span class="input-group-addon"><i class="fa fa-search"></i></span><input class="form-control multiselect-search" type="text"></div></li>',
                filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
                li: '<li><a href="javascript:void(0);"><label></label></a></li>',
                divider: '<li class="multiselect-item divider"></li>',
                liGroup: '<li class="multiselect-item group"><label class="multiselect-group" style="padding-left:5px; font-weight:bold;"></label></li>'
            }
        });
        
        $(".activateDate").datepicker({
            showOtherMonths: true,
            selectOtherMonths: true
            
        });
        $(".retirementDate").datepicker({
            showOtherMonths: true,
            selectOtherMonths: true
        });

    });
    
    $('.exitAnnouncementForm').click(function(event) {
        event.preventDefault();
        window.location.href = '/announcements/manage';
    });
    
    $(document).on('click', '.whichEntity', function () {

        if ($(this).val() == 1) {
            $('#entityIds').val("");
            $('#entitySelectList').hide();
        }
        else {
            $('#entitySelectList').show();
        }

    });
    
    /* Remove existing document */
    $(document).on('click', '.deleteDocument', function () {

        var confirmed = confirm("Are you sure you want to remove this file?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            $.ajax({
                url: '/announcements/deleteDocument.do',
                type: 'POST',
                data: {
                    'documentId': docId
                },
                success: function (data) {
                    $('#docDiv_' + docId).remove();
                    
                    /* See if there are any other documents */
                    if($(".existingDocs").length == 0) {
                        $('#noDocs').show();
                    }
                },
                error: function (error) {

                }
            });
        }

    });
    
    $('#saveAnnouncement').click(function(event) {
        
        $('#action').val("Save");
       
       if (checkForm()) {
            //$("#userDetails").submit();
            $('form').preventDoubleSubmission();
        }  
        else {
            event.preventDefault();
        }
    });
    
    $('#saveReturnAnnouncement').click(function(event) {
        
       $('#action').val("SaveReturn");
       
       if (checkForm()) {
            //$("#userDetails").submit();
            $('form').preventDoubleSubmission();
        }  
        else {
            event.preventDefault();
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

function checkForm() {
    
    var errorFound = 0;

    $('div.form-group').removeClass("has-error");
    $('span.control-label').removeClass("has-error");
    $('span.control-label').html("");

    if ($('#announcement').val().trim() == "") {
        $('#announcementDiv').addClass("has-error");
        $('#announcementMsg').html('The announcement is a required field.');
        errorFound = 1;
    }

    if(errorFound == 0) {
        return true;
    }
    else {
        return false;
    }
}   


