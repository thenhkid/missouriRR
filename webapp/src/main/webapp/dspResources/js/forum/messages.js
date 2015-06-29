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
    
    $('#newPost').on('click', function () {
        var topicId = $(this).attr('rel');

        showPostForm(topicId, 0, 0);
    });

    $(document).on("click", ".editPost", function () {

        var topicId = $('.topicMessageContainer').attr('rel');
        var postId = $(this).attr('rel');

        showPostForm(topicId, postId, 0);

    });

    $(document).on("click", ".reply", function () {

        var topicId = $('.topicMessageContainer').attr('rel');
        var parentMessageId = $(this).attr('rel');

        showPostForm(topicId, 0, parentMessageId);

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
    
    function showPostForm(topicId, postId, parentMessageId) {
        $.ajax({
            type: 'GET',
            url: '/forum/getPostForm.do',
            data: {'topicId': topicId, 'postId': postId, 'parentMessageId': parentMessageId},
            success: function (data, event) {
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
                                var topicId = messageFn(event);

                                if (topicId == 0) {
                                    return false;
                                }
                                else {
                                    $('#messagesDiv').html("");
                                    loadTopicMessages(topicId);
                                }

                            }
                        },
                    }
                });
            }
        });
    }
    
    

    function messageFn(event) {

        var formData = $("#postForm").serialize();

        var topicId = 0;
        var errorFound = false;

        /** make sure there is a category **/
        if ($('#message').val().trim() == "") {
            $('#messageDiv').addClass("has-error");
            $('#messageMsg').addClass("has-error");
            $('#messageMsg').html('The message is required.');
            errorFound = true;
        }

        if (errorFound == false) {

            $.ajax({
                url: '/forum/savePostForm.do',
                type: 'POST',
                async: false,
                data: formData,
                success: function (data) {
                    topicId = data;
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }

        return topicId;

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