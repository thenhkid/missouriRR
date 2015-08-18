/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    
    $("input:text,form").attr("autocomplete", "off");
    
    //initiate dataTables plugin
    var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                "aoColumns": [
                    {"bSortable": false},
                    {"bSortable": false},
                    null, null, 
                    {"bSortable": false}
                ],
                "aaSorting": []
            });
            
    //New main folder button
    $(document).on('click', '#newFolder', function(event) {
       $.ajax({
            type: 'GET',
            url: '/documents/getFolderForm.do',
            data: {'subfolder': false},
            success: function (data) {
                
                data = $(data);
                
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
                                return folderFn(event);
                            }
                        },
                    }
                });
            }
        });
        
    });
            
    //New subfolder button
    $(document).on('click', '#newSubfolder', function(event) {
       $.ajax({
            type: 'GET',
            url: '/documents/getFolderForm.do',
            data: {'subfolder': true},
            success: function (data) {
                
                data = $(data);
                
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
                                return folderFn(event);
                            }
                        },
                    }
                });
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
    
    function folderFn(event) {

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
        
        $("#folderForm").submit();
    }
    
    //Edit Document button
    $(document).on('click', '#newDocument', function(event) {
        $.ajax({
            type: 'GET',
            url: '/documents/getDocumentForm.do',
            data: {'documentId': 0},
            success: function (data) {
                
                data = $(data);
                    
                /* File input */
                data.find('#id-input-file-2').ace_file_input({
                   style: 'well',
                   btn_choose: 'click to upload the document',
                   btn_change: null,
                   no_icon: 'ace-icon fa fa-cloud-upload',
                   droppable: false,
                   thumbnail: 'small',
                   allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx'],
                   before_remove: function () {
                       return true;
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
                    
                /* File input */
                data.find('#id-input-file-2').ace_file_input({
                   style: 'well',
                   btn_choose: 'click to upload the document',
                   btn_change: null,
                   no_icon: 'ace-icon fa fa-cloud-upload',
                   droppable: false,
                   thumbnail: 'small',
                   allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx'],
                   before_remove: function () {
                       return true;
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
        });
    });
    
    function documentFn(event) {

        var errorFound = false;

        /** make sure there is a category **/
        if ($('#title').val().trim() == "") {
            $('#titleDiv').addClass("has-error");
            $('#titleMsg').addClass("has-error");
            $('#titleMsg').html('The document title is required.');
            errorFound = true;
        }
        
        if(errorFound == true) {
            event.preventDefault();
            return false;
        }
        
        var submitURL = "/documents/saveDocuemntForm.do";
        $("#documentForm").attr("action", submitURL);
        $("#documentForm").submit();

    }
    
    /* Remove existing document */
    $(document).on('click', '.deleteDocument', function () {

        var confirmed = confirm("Are you sure you want to remove this document?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            $.ajax({
                url: '/documents/deleteDocument.do',
                type: 'POST',
                data: {
                    'documentId': docId
                },
                success: function (data) {
                    location.reload();
                },
                error: function (error) {

                }
            });
        }

    });

});