/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    /* Populate the district drop down */
    $.ajax({
        url: '/districts/getDistrictList.do',
        data: {'surveyId': $('#surveyId').val()},
        type: "GET",
        success: function (data) {
            $('#districtList').html(data);

            $('.multiselect').multiselect({
                enableFiltering: true,
                buttonClass: 'btn btn-white btn-primary',
                enableClickableOptGroups: true,
                enableCaseInsensitiveFiltering: true,
                disableIfEmpty: true,
                nonSelectedText: 'Select your Districts / CBO',
                numberDisplayed: 0,
                templates: {
                    button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown" style="width:200px;"></button>',
                    ul: '<ul class="multiselect-container dropdown-menu" style="max-height:350px; overflow:auto"></ul>',
                    filter: '<li class="multiselect-item filter"><div class="input-group"><span class="input-group-addon"><i class="fa fa-search"></i></span><input class="form-control multiselect-search" type="text"></div></li>',
                    filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
                    li: '<li><a href="javascript:void(0);"><label></label></a></li>',
                    divider: '<li class="multiselect-item divider"></li>',
                    liGroup: '<li class="multiselect-item group"><label class="multiselect-group" style="padding-left:5px; font-weight:bold;"></label></li>'
                }
            });
        }
    });

    $(document).on('click', '.surveyDocuments', function (event) {
        $.ajax({
            url: '/surveys/getSurveyDocuments.do',
            data:{'surveyId':$(this).attr('rel')},
            type: 'GET',
            success: function (data) {

                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    /* File input */
                    data.find('#id-input-file-2').ace_file_input({
                        style: 'well',
                        btn_choose: 'click to upload files',
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

                    bootbox.dialog({
                        message: data,
                        title: "Upload Survey Files",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {

                                }
                            },
                            success: {
                                label: "Upload",
                                className: "btn-primary",
                                callback: function () {
                                    return documentFn(event);
                                }
                            },
                        }
                    });
                }
            }
        });

    });

    /* Submit the district selection */
    $(document).on('click', '#createNewEntry', function () {

        if ($('.multiselect').val() != null) {
            $('#districtSelectForm').submit();
        }
        else {
            $.gritter.add({
                title: 'Missing District!',
                text: 'Please select at least one district to start a survey.',
                class_name: 'gritter-error gritter-light'
            });
        }

    });


    //initiate dataTables plugin
    var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                "aoColumns": [
                    null, null, null, null, null,
                    {"bSortable": false},
                    {"bSortable": false}
                ],
                "aaSorting": []
            });



    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }

    //Delete Survey
    $(document).on('click', '.deleteSurvey', function () {

        var confirmed = confirm("Are you sure you want to remove this activity log?");

        if (confirmed) {
            
            var table = $('#dynamic-table').DataTable();
            
            table.row($(this).parents('tr')).remove().draw();
            
            $.ajax({
                type: 'POST',
                url: '/surveys/removeEntry.do',
                data: {'i': $(this).attr('rel')},
                success: function (data) {
                    //location.reload();
                    
                }
            });
        }
    });

    function documentFn(event) {
        
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

    }
    
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