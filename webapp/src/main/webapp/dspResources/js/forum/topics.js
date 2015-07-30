/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    $("input:text,form").attr("autocomplete", "off");

    var typewatch = (function () {
        var timer = 0;
        return function (callback, ms) {
            clearTimeout(timer);
            timer = setTimeout(callback, ms);
        };
    })();

    $(document).ready(function () {

        $(document).on("keyup", "#nav-search-input", function () {

            if ($(this).val() == "") {
                $('#topicsDiv').removeClass("col-sm-10");
                $('#topicsDiv').addClass("col-sm-12");
                $('#searchResults').html("");
                $('#searchResults').hide();
                $('#searchSpinner').hide();
                $('#clearSearch').hide();
            }
            else {

                var searchTerm = $(this).val();

                typewatch(function () {
                    $('#clearSearch').hide();
                    $('#searchSpinner').show();

                    $.ajax({
                        url: '/forum/searchMessages.do',
                        data: {
                            'searchTerm': searchTerm
                        },
                        type: "GET",
                        success: function (data) {
                            $('#topicsDiv').removeClass("col-sm-12");
                            $('#topicsDiv').addClass("col-sm-10");
                            $('#searchResults').html(data);
                            $('#searchResults').show();
                            $('#searchSpinner').hide();
                            $('#clearSearch').show();
                        }
                    });

                }, 1000);
            }
        });

        $(document).on('click', '#clearSearch', function () {
            $('#topicsDiv').removeClass("col-sm-10");
            $('#topicsDiv').addClass("col-sm-12");
            $('#searchResults').html("");
            $('#searchResults').hide();
            $('#searchSpinner').hide();
            $('#clearSearch').hide();
            $('#nav-search-input').val("");
        });

    });


    $('#newTopic').on('click', function () {
        showTopicForm(0);
    });

    $('.editTopic').on('click', function () {
        showTopicForm($(this).attr('rel'));
    });

    $(document).on("click", ".deleteTopic", function () {

        var topicId = $(this).attr('rel');

        var confirmed = confirm("Are you sure you want to remove this topic and all associated posts?");

        if (confirmed) {
            $.ajax({
                type: 'POST',
                url: '/forum/removeForumTopic.do',
                data: {'topicId': topicId},
                success: function (data) {
                    window.location.reload();
                }
            });
        }

    });

    function showTopicForm(topicId) {

        $.ajax({
            type: 'GET',
            url: '/forum/getTopicForm.do',
            data: {'topicId': topicId},
            success: function (data, event) {

                data = $(data);

                data.find('.multiselect').multiselect({
                    enableFiltering: false,
                    includeSelectAllOption: true,
                    buttonClass: 'btn btn-white btn-primary',
                    enableClickableOptGroups: false,
                    enableCaseInsensitiveFiltering: false,
                    disableIfEmpty: true,
                    nonSelectedText: 'Select your Counties',
                    numberDisplayed: 10,
                    templates: {
                        button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"></button>',
                        ul: '<ul class="multiselect-container dropdown-menu"></ul>',
                        filter: '<li class="multiselect-item filter"><div class="input-group"><span class="input-group-addon"><i class="fa fa-search"></i></span><input class="form-control multiselect-search" type="text"></div></li>',
                        filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
                        li: '<li><a href="javascript:void(0);"><label></label></a></li>',
                        divider: '<li class="multiselect-item divider"></li>',
                        liGroup: '<li class="multiselect-item group"><label class="multiselect-group" style="padding-left:5px; font-weight:bold;"></label></li>'
                    }
                });

                bootbox.dialog({
                    message: data,
                    title: "New Topic",
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
                                var topicId = topicFn(event);

                                if (topicId == 0) {
                                    return false;
                                }
                                else {
                                    //Reload the topics
                                    window.location.reload();
                                }

                            }
                        },
                    }
                });
            }
        });
    }

    function topicFn(event) {
        $('div').removeClass("has-error");
        $('span').removeClass("has-error");
        $('#titleMsg').html("");
        $('#messageMsg').html("");
        $('#entityMsg').html("");
        var formData = $("#topicForm").serialize();

        var topicId = 0;
        var errorFound = false;

        /** make sure there is a topic title and initial message **/
        if ($('#title').val().trim() == "") {
            $('#titleDiv').addClass("has-error");
            $('#titleMsg').addClass("has-error");
            $('#titleMsg').html('The topic title is required.');
            errorFound = true;
        }
        if ($('#topicId').val() == 0) {
            if ($('#message').val().trim() == "") {
                $('#messageDiv').addClass("has-error");
                $('#messageMsg').addClass("has-error");
                $('#messageMsg').html('The initial message is required.');
                errorFound = true;
            }
        }

        //Make sure at least one school is selcted
        if ($('.whichEntity:checked').val() == 2 && ($('#entityIds').val() == "" || $('#entityIds').val() == null)) {
            $('#entityDiv').addClass("has-error");
            $('#entityMsg').addClass("has-error");
            $('#entitySelectList').addClass("has-error");
            $('#entityMsg').html("At least one county must be selected.");
            errorFound = true;
        }

        if (errorFound == false) {

            $.ajax({
                url: '/forum/saveTopicForm.do',
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

    $(document).on('click', '.whichEntity', function () {

        if ($(this).val() == 1) {
            $('#entityIds').val("");
            $('#entitySelectList').hide();
        }
        else {
            $('#entitySelectList').show();
        }

    });

});