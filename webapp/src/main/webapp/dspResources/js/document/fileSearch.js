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
    
    $(document).ready(function () {
        
         var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                "aoColumns": [
                    {"bSortable": false},
                    {"bSortable": false},
                    {"bSortable": false}, null, 
                    {"bSortable": false}
                ],
                "aaSorting": [[3, 'desc']],
                "oLanguage": {
                "sSearch": "Filter:"
                }
            });
        
        
        if((document.referrer.indexOf("documents") > 0 || document.referrer.indexOf("login")) && ($('#savedSearchString').val() !== "" || $('#savedstartSearchDate').val() !== "")) {
          
          $('#documentSearchValue').val($('#savedSearchString').val());
          
          if($('#savedadminOnly') == 1) {
             $(':input:radio:eq(0)').attr('checked', 'checked'); 
          }
          else {
            $(':input:radio:eq(1)').attr('checked', 'checked'); 
          }
          $('#startSearchDate').val($('#savedstartSearchDate').val());
          $('#endSearchDate').val($('#savedendSearchDate').val());
          
          searchDocuments();
          
        } 
        else {
          $('#savedstartSearchDate').val("");
          $('#savedendSearchDate').val("");
          $('#savedadminOnly').val(0);
          
        }
      
        
        $("input:text,form").attr("autocomplete", "off");
    
        $('.input-daterange').datepicker({autoclose:true});
        
        /* Search for documents */
        $(document).on('click', '#documentSearchButton', function () {
            searchDocuments();
        });
        
        $(document).on('click', '.multipleFileDownload', function() {
            var docId = $(this).attr('docid');

            $.ajax({
                type: 'GET',
                url: '/documents/getDocumentFiles.do',
                data: {'documentId': docId},
                success: function (data) {

                    data = $(data);

                    //Check if the session has expired.
                    if(data.find('.username').length > 0) {
                       top.location.href = '/login?expired';
                    }
                    else {

                        bootbox.dialog({
                            message: data,
                            title: "Uploaded Files",
                            buttons: {
                                cancel: {
                                    label: "Close",
                                    className: "btn-default",
                                    callback: function () {

                                    }
                                }
                            }
                        }); 
                    }
               }
            });
        });
        
        //Edit Document button
        $(document).on('click', '.editDocument', function(event) {
            $.ajax({
                type: 'GET',
                url: '/documents/getDocumentForm.do',
                data: {'documentId': $(this).attr('rel')},
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
                           btn_choose: 'click to upload the document',
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

                        data.find('#folderId').on('change', function () {
                            isSelFolderAdmin();
                        });

                        bootbox.dialog({
                            message: data,
                            title: "Document Form",
                            buttons: {
                                cancel: {
                                    label: "Cancel",
                                    className: "btn-default",
                                    callback: function () {

                                    }
                                },
                                success: {
                                    label: "Save",
                                    className: "btn-primary",
                                    callback: function () {
                                        return documentFn(event);
                                    }
                                },
                            }
                        });

                        isSelFolderAdmin();
                    }
                }
            });
        });
        
        /* Remove existing document */
        $(document).on('click', '.removeFile', function () {

            var confirmed = confirm("Are you sure you want to remove this document file?");

            if (confirmed) {
                var docId = $(this).attr('rel');
                $.ajax({
                    url: '/documents/deleteDocumentFile.do',
                    type: 'POST',
                    data: {
                        'fileId': docId
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
    
    /* Remove existing document */
    $(document).on('click', '.deleteDocument', function () {

        var confirmed = confirm("Are you sure you want to remove this document?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            
            var table = $('#dynamic-table').DataTable();
            
            table.row($(this).parents('tr')).remove().draw();
            
            
            $.ajax({
                url: '/documents/deleteDocument.do',
                type: 'POST',
                data: {
                    'documentId': docId
                },
                success: function (data) {
                    //location.reload();
                },
                error: function (error) {

                }
            });
        }

    });
    
    $(document).on('click', '#clearSearchFields', function() {
       $('#savedSearchString').val("");
       $('#savedadminOnly').val("0");
       $('#savedstartSearchDate').val("");
       $('#savedendSearchDate').val("");
       
       $('#startSearchDate').val("");
       $('#endSearchDate').val("");
       $('#documentSearchValue').val("");
   });
    
    
});

function searchDocuments() {
    var searchValue = $('#documentSearchValue').val();
    var startSearchDate = $('#startSearchDate').val();
    var endSearchDate = $('#endSearchDate').val();
    var adminOnly = $("input[type='radio'][name='adminOnly']:checked").val();

    $('#reqSearchTerm').hide();
    $('#searchingDocuments').show();

    if (searchValue === "" && startSearchDate === "" && endSearchDate === "") {
        //$('#searchingDocuments').hide();
        //$('#reqSearchTerm').show();
        $('#searchingText').html("Returning all Documents");
    }
    else {
        $('#searchingText').html("Searching");
    }
    //else {
        $.ajax({
            url: 'documents/searchDocuments',
            data: {'searchString': searchValue, 'adminOnly': adminOnly, 'startSearchDate': startSearchDate, 'endSearchDate': endSearchDate},
            type: "GET",
            success: function (data) {
                $('#searchingDocuments').hide();
                $('#reqSearchTerm').hide();
                $("#documentSearchResults").html(data);

                //initiate dataTables plugin
                $('#documentSearchResults').find('#dynamic-table')
                 .dataTable({
                     bAutoWidth: false,
                     "aoColumns": [
                        {"bSortable": false},
                        {"bSortable": false},
                        {"bSortable": false}, 
                        null, 
                        {"bSortable": false}
                     ],
                     "aaSorting": [[3,"desc"]],
                    "oLanguage": {
                    "sSearch": "Filter:"
                    }
                 });
            }
        });
    //}
}

function documentFn(event) {
        
    $('span').removeClass("has-error");
    $('div').removeClass("has-error");
    $('#titleMsg').html("");f
    $('#docMsg').html("");
    $('#webLinkMsg').html("");
    $('#fromSearch').val(1);

    var documentId = $('#documentId').val();

    var errorFound = false;

    /** make sure there is a document title **/
    if ($('#title').val().trim() == "") {
        $('#titleDiv').addClass("has-error");
        $('#titleMsg').addClass("has-error");
        $('#titleMsg').html('The document title is required.');
        errorFound = true;
    }

    /** make sure there is a document description **/
    if ($('#docDesc').val().trim() == "") {
        $('#docDescDiv').addClass("has-error");
        $('#docDescMsg').addClass("has-error");
        $('#docDescMsg').html('The document description is required.');
        errorFound = true;
    }

    /** Make sure either a document is uploaded or an external link is provided **/
    if($('.uploadedDocuments').length == 0 && $('#webLink').val().trim() === "" && $('#id-input-file-2').val().trim() === "" && $('#uploadedFile').val() === "") {
        $('#docDiv').addClass("has-error");
        $('#webLinkDiv').addClass("has-error");
        $('#docMsg').addClass("has-error");
        $('#docMsg').html('Either a document must be uploaded or an external link must be entered.');
        errorFound = true;
    }

    if($('#webLink').val().trim() != "") {
        var val = $('#webLink').val().trim();
        if (val && !val.match(/^http([s]?):\/\/.*/)) {
          $('#webLink').val('http://' + val);
        }

        if(/^(http|https|ftp):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i.test($("#webLink").val())){

        } else {
            $('#webLinkDiv').addClass("has-error");
            $('#webLinkMsg').addClass("has-error");
            $('#webLinkMsg').html('The external web link must be a valid url.');
        }

    }

    if(errorFound == true) {
        event.preventDefault();
        return false;
    }
    else {
        $('#uploading').show();
    }
    
     var box = bootbox.dialog({
        message: "<i class='fa fa-upload bigger-210 white'></i><span class='bigger-210 white' style='padding-left:10px;'>Uploading...</span>",
        closeButton: false,
        size: "small"
     });

    box.find('.modal-content').css({'background-color': '#CBCBCB'}); 

    setTimeout( function () { 
      var submitURL = "/documents/saveDocuemntForm.do";
        $("#documentForm").attr("action", submitURL);
        $("#documentForm").submit();
     }, 300);

}

function isSelFolderAdmin() {
    var folderId = $('#folderId').val();
    
    $.ajax({
        url: '/documents/checkAdminFolder.do',
        type: 'GET',
        async: false,
        data: {
            'folderId': folderId
        },
        success: function (data) {
            if(data == 1) {
                $('#adminOnly').hide();
            }
            else {
                $('#adminOnly').show();
            }
        },
        error: function () {
            console.log(error);
        }
    });
}

