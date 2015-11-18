/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    $("input:text,form").attr("autocomplete", "off");

    $(document).ready(function () {

        var topicId = $('.topicMessageContainer').attr('rel');
        if (topicId > 0) {
            loadTopicMessages(topicId);
        }

    });
    
    $('#newPost').on('click', function (event) {
        var topicId = $(this).attr('rel');

        showPostForm(topicId, 0, 0, event);
    });

    $(document).on("click", ".editPost", function (event) {

        var topicId = $('.topicMessageContainer').attr('rel');
        var postId = $(this).attr('rel');

        showPostForm(topicId, postId, 0, event);

    });

    $(document).on("click", ".reply", function (event) {

        var topicId = $('.topicMessageContainer').attr('rel');
        var parentMessageId = $(this).attr('rel');

        showPostForm(topicId, 0, parentMessageId, event);

    });

    $(document).on("click", ".deletePost", function () {

        var topicId = $('.topicMessageContainer').attr('rel');
        var postId = $(this).attr('rel');

        var confirmed = confirm("Are you sure you want to remove this post?");

        if (confirmed) {
            $.ajax({
                type: 'POST',
                url: '/forum/removePost.do',
                data: {'postId': postId},
                success: function (data) {
                    $('#messagesDiv').html("");
                    loadTopicMessages(topicId);
                }
            });
        }

    });
    
    /* Remove existing document */
    $(document).on('click', '.deleteDocument', function () {

        var confirmed = confirm("Are you sure you want to remove this document?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            $.ajax({
                url: '/forum/deleteDocument.do',
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
    
    
    function showPostForm(topicId, postId, parentMessageId, event) {
        $.ajax({
            type: 'GET',
            url: '/forum/getPostForm.do',
            data: {'topicId': topicId, 'postId': postId, 'parentMessageId': parentMessageId},
            success: function (data) {
                
                data = $(data);
                    
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
                    title: "New Post",
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
                                return messageFn(event);
                            }
                        },
                    }
                });
            }
        });
    }
    
    

    function messageFn(event) {

        var errorFound = false;

        /** make sure there is a category **/
        if ($('#message').val().trim() == "") {
            $('#messageDiv').addClass("has-error");
            $('#messageMsg').addClass("has-error");
            $('#messageMsg').html('The message is required.');
            errorFound = true;
        }
        
        if(errorFound == true) {
            event.preventDefault();
            return false;
        }
        
        var submitURL = "/forum/savePostForm.do";
        $("#postForm").attr("action", submitURL);
        $("#postForm").submit();

    }

    function loadTopicMessages(topicId) {
        $('#loadingDiv').show();
        $.ajax({
            url: '/forum/getTopicMessages.do',
            type: 'GET',
            data: {'topicId': topicId},
            success: function (data) {
                $('#messagesDiv').html(data);
                $('#loadingDiv').hide();
            },
            error: function (error) {
                console.log(error);
            }
        });
    }

});