/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    
	
    //initiate dataTables plugin
    var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                stateSave: true,
                "stateDuration": 60,
                "aoColumns": [
                    {"bSortable": false},
                    {"bSortable": false},
                    null, null, 
                    {"bSortable": false}
                ],
                "aaSorting": [[2, 'desc']],
                "oLanguage": {
                "sSearch": "Filter:"
                }
            });
            
    //New main folder button
    $(document).on('click', '#modifyFolder', function(event) {
       $.ajax({
            type: 'GET',
            url: '/documents/getFolderForm.do',
            data: {'editFolder': true, 'subfolder': false},
            success: function (data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                   bootbox.dialog({
                        message: data,
                        title: "New Folder Form",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {

                                }
                            },
                            success: {
                                label: "Update",
                                className: "btn-primary",
                                callback: function () {
                                    return folderFn();
                                }
                            },
                        }
                    }); 
                }
            }
        });
        
    });  
    
    /* Remove selected folder */
    $(document).on('click', '#deleteFolder', function () {

        var confirmed = confirm("Are you sure you want to remove this folder and all subfolders?");

        if (confirmed) {
            $.ajax({
                url: '/documents/deleteFolder.do',
                type: 'POST',
                success: function (data) {
                  window.location.href = data;
                },
                error: function (error) {

                }
            });
        }

    });
    
            
    //New main folder button
    $(document).on('click', '#newFolder', function(event) {
       $.ajax({
            type: 'GET',
            url: '/documents/getFolderForm.do',
            data: {'editFolder': false, 'subfolder': false},
            success: function (data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                   bootbox.dialog({
                        message: data,
                        title: "New Folder Form",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {

                                }
                            },
                            success: {
                                label: "Create",
                                className: "btn-primary",
                                callback: function () {
                                    return folderFn();
                                }
                            },
                        }
                    }); 
                }
            }
        });
        
    });
       
    //New subfolder button
    $(document).on('click', '#newSubfolder', function(event) {
       $.ajax({
            type: 'GET',
            url: '/documents/getFolderForm.do',
            data: {'editFolder': false, 'subfolder': true},
            success: function (data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        message: data,
                        title: "New Folder Form",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function () {

                                }
                            },
                            success: {
                                label: "Create",
                                className: "btn-primary",
                                callback: function () {
                                    return folderFn();
                                }
                            },
                        }
                    });  
                    
                }
            }
        });
        
    });
    
    
    $(document).on('submit', '#folderForm', function(event) {
        var errorFound = false;

        /** make sure there is a category **/
        if ($('#folderName').val().trim() == "") {
            $('#folderNameDiv').addClass("has-error");
            $('#folderNameMsg').addClass("has-error");
            $('#folderNameMsg').html('The folder name is required.');
            errorFound = true;
        }
        
        if(errorFound == true) {
            event.preventDefault();
            return false;
        }
    });
    
    function folderFn() {
        
        var noErrors = true;
        
        /** make sure there is a category **/
        if ($('#folderName').val().trim() == "") {
            $('#folderNameDiv').addClass("has-error");
            $('#folderNameMsg').addClass("has-error");
            $('#folderNameMsg').html('The folder name is required.');
            noErrors = false;
        }
        
        if ($("#isNotCountyFolder").is(':checked')) {
              $('#entityId').val(0);
        }
        
        var folderName = $('#folderName').val();
        var folderId = $('#folderId').val();
        var parentFolderId = $('#parentFolderId').val();
        
        var nameFound = checkFolderName(folderName, folderId, parentFolderId);
        
        if(nameFound == 1) {
            $('#folderNameDiv').addClass("has-error");
            $('#folderNameMsg').addClass("has-error");
            $('#folderNameMsg').html('This folder exists already.');
            noErrors = false;
        }
        
        if(noErrors == false) {
            return false;
        }
        else {
            $("#folderForm").submit();
        }
        
    }
    
    //Edit Document button
    $(document).on('click', '#newDocument', function(event) {
        $.ajax({
            type: 'GET',
            url: '/documents/getDocumentForm.do',
            data: {'documentId': 0},
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
                       allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx', 'ppt', 'csv', 'pptx', 'wma', 'zip', 'mp3', 'mp4', 'm4a'],
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
                            $('#docMsg').html("There were files attached that have an invalid file extension.<br />Valid File Extension:<br /> pdf, txt, doc, docx, gif, png, jpg, jpeg, xls, xlsx, csv, ppt, pptx, wma, zip, mp3, mp4, m4a");
                            event.preventDefault();
                        }
                        else if(info.error_count['size'] > 0) {
                            $('#docDiv').addClass("has-error");
                            $('#docMsg').addClass("has-error");
                            $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 4MB.");
                            event.preventDefault();
                        }
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
                       allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx', 'ppt', 'csv', 'pptx', 'wma', 'zip', 'mp3', 'mp4', 'm4a'],
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
                            $('#docMsg').html("There were files attached that have an invalid file extension.<br />Valid File Extension:<br /> pdf, txt, doc, docx, gif, png, jpg, jpeg, xls, xlsx, csv, ppt, pptx, wma, zip, mp3, mp4, m4a");
                            event.preventDefault();
                        }
                        else if(info.error_count['size'] > 0) {
                            $('#docDiv').addClass("has-error");
                            $('#docMsg').addClass("has-error");
                            $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 4MB.");
                            event.preventDefault();
                        }
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
                }
            }
        });
    });
    
    function documentFn(event) {
        
        $('span').removeClass("has-error");
        $('div').removeClass("has-error");
        $('#titleMsg').html("");
        $('#docMsg').html("");
        $('#webLinkMsg').html("");
        
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
    
    
    $(document).on("click", "a#documentNotificationManagerModel", function () {
        $('.popover').popover('destroy');
        $.ajax({
            url: '/documents/getDocumentNotificationModel.do',
            type: 'GET',
            success: function (data) {
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        title: "Document Notification Preferences",
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
                url: '/documents/saveNotificationPreferences.do',
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


function checkFolderName(folderName, folderId, parentFolderId) {
    
    var result = "";
     
    $.ajax({
        url: '/documents/checkFolderName.do',
        type: 'POST',
        async: false,
        data: {
            'folderName': folderName,
            'folderId': folderId,
            'parentFolderId': parentFolderId
        },
        success: function (data) {
            result = data;
        },
        error: function () {
            console.log(error);
        }
    });
    
    return result;
}

function isEmail(email) {
      var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      return regex.test(email);
}