/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {

    var calendar;
    var eventContainer;

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
                $('#calendarDiv').removeClass("col-sm-8");
                $('#calendarDiv').addClass("col-sm-10");
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
                        url: '/calendar/searchEvents.do',
                        data: {
                            'searchTerm': searchTerm
                        },
                        type: "GET",
                        success: function (data) {
                            $('#calendarDiv').removeClass("col-sm-10");
                            $('#calendarDiv').addClass("col-sm-8");
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
            $('#calendarDiv').removeClass("col-sm-8");
            $('#calendarDiv').addClass("col-sm-10");
            $('#searchResults').html("");
            $('#searchResults').hide();
            $('#searchSpinner').hide();
            $('#clearSearch').hide();
            $('#nav-search-input').val("");
        });

        $(document).on('click', '.loadeventfound', function () {
            var start = $(this).attr('start');
            var end = $(this).attr('end');

            calendar.fullCalendar('gotoDate', $.fullCalendar.moment(start));

        });

    });

    /* initialize the external events
     -----------------------------------------------------------------*/

    $('#external-events div.external-event').each(function () {

        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        // it doesn't need to have a start or end
        var eventObject = {
            title: $.trim($(this).text()) // use the element's text as the event title
        };

        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject);

        // make the event draggable using jQuery UI
        $(this).draggable({
            zIndex: 999,
            revert: true, // will cause the event to go back to its
            revertDuration: 0  //  original position after the drag
        });

    });

    $(document).on("click", ".eventSave", function () {

        var formData = $("#eventForm").serializefiles();
        
        var errorFound = false;
        
        if ($('#eventStartTime').val() === "") {
            $('#eventTimeDiv').addClass('has-error');
            $('#eventStartTimeMessage').addClass('has-error');
            $('#eventStartTimeMessage').html('The event start time is required.');
            $('#eventStartTimeMessage').show();
            errorFound = true;
        }
        
        if ($('#eventEndTime').val() === "") {
            $('#eventTimeDiv').addClass('has-error');
            $('#eventEndTimeMessage').addClass('has-error');
            $('#eventEndTimeMessage').html('The event end time is required.');
            $('#eventEndTimeMessage').show();
            errorFound = true;
        }
        
        if (errorFound == false) {
            $('#eventTimeDiv').removeClass('has-error');
            $('#eventStartTimeMessage').removeClass('has-error');
            $('#eventStartTimeMessage').html('');
            
            $.ajax({
                url: '/calendar/saveEvent.do',
                type: 'POST',
                contentType: false,
                processData: false,
                data: formData,
                success: function (data) {
                    //bootbox.hideAll();
                    $('.popover').popover('destroy');
                    calendar.fullCalendar('refetchEvents');
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }
        
        return false;
    });

    /* initialize the calendar
     -----------------------------------------------------------------*/

    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();

    var typeArray = [];
    $.each($("input[name='eventTypeIdFilter']:checked"), function () {
        typeArray.push($(this).val());
    });

    var events = {
        url: '/calendar/getEventsJSON.do',
        type: 'GET',
        data: {
            eventTypeId: typeArray.toString()
        }
    };

    calendar = $('#calendar').fullCalendar({
        //isRTL: true,
        buttonHtml: {
            prev: '<i class="ace-icon fa fa-chevron-left"></i>',
            next: '<i class="ace-icon fa fa-chevron-right"></i>'
        },
        header: {
            left: 'title',
            center: '',
            //right: 'month,agendaWeek,agendaDay'
            right: 'prev,next today'
        },
        events: events,
        timezone: 'local',
        editable: true,
        droppable: true, // this allows things to be dropped onto the calendar !!!
        drop: function (date, allDay) { // this function is called when something is dropped

            // retrieve the dropped element's stored Event Object
            var originalEventObject = $(this).data('eventObject');
            var $extraEventClass = $(this).attr('data-class');


            // we need to copy it, so that multiple events don't have a reference to the same object
            var copiedEventObject = $.extend({}, originalEventObject);

            // assign it the date that was reported
            copiedEventObject.start = date;
            copiedEventObject.allDay = allDay;
            if ($extraEventClass)
                copiedEventObject['className'] = [$extraEventClass];

            // render the event on the calendar
            // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
            $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

            // is the "remove after drop" checkbox checked?
            if ($('#drop-remove').is(':checked')) {
                // if so, remove the element from the "Draggable Events" list
                $(this).remove();
            }

        }
        ,
        selectable: true,
        selectHelper: true,
        select: function (start, end, allDay) {

        }
        ,
        dayClick: function (date, jsEvent, view) {

            /* Check to see if the user has create permission */
            if ($('.calRow').attr('createPermission') == "true") {

                $('.popover').popover('destroy');
                var tempThis = $(this);

                $.ajax({
                    url: '/calendar/getNewEventForm.do',
                    type: 'GET',
                    success: function (data) {

                        data = $(data);

                        data.find('#simple-colorpicker-1').ace_colorpicker()
                                .on('change', function () {
                                    queryEventType(this.value);
                                });

                        /* File input */
                        data.find('#id-input-file-2').ace_file_input({
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

                        data.find('.timeFrom').timepicker({'scrollDefault': 'now'});
                        
                        data.find('.timeFrom').val($('.timeFrom option:first').val());
                        
                        data.find('.timeFrom').on('changeTime', function () {

                            var date = new Date();
                            date.setHours(0);
                            date.setMinutes(0);
                            date.setSeconds(0);

                            var timePicked = $(this).val().indexOf(':');
                            timePicked = $(this).val().substring(0, timePicked);

                            if ($(this).val().indexOf('am') > 0 && parseInt(timePicked) == 12) {
                                timePicked = parseInt(timePicked) - 12;
                            }
                            else if ($(this).val().indexOf('pm') > 0 && parseInt(timePicked) < 12) {
                                timePicked = parseInt(timePicked) + 12;
                            }
                            date.setHours(parseInt(timePicked) + 1);

                            var minutesPicked = $(this).val().indexOf(':');
                            minutesPicked = $(this).val().substring(minutesPicked + 1, minutesPicked + 3);
                            date.setMinutes(minutesPicked);

                            $('.timeTo').timepicker('setTime', date);

                        });

                        data.find(".timeTo").timepicker({'scrollDefault': 'now'});
                        data.find(".eventStartDate").datepicker({
                            showOtherMonths: true,
                            selectOtherMonths: true
                        });

                        data.find(".eventStartDate").datepicker("setDate", date.format('MM/DD/YYYY'));
                        data.find(".eventEndDate").datepicker("setDate", date.format('MM/DD/YYYY'));

                        data.find(".eventEndDate").datepicker({
                            showOtherMonths: true,
                            selectOtherMonths: true
                        });

                        $(tempThis).popover({
                            trigger: 'focus',
                            content: data,
                            placement: 'auto right',
                            html: true,
                            title: 'Create Event  <button type="button" id="closePopover" class="close pull-right">&times;</button>',
                            container: 'body',
                            callback: function () {

                            }
                        });
                        $(tempThis).popover('toggle');

                        $(document).on("change", ".eventStartDate", function () {
                            $(".eventEndDate").val($(this).val());
                            $(".eventEndDate").datepicker("setDate", $(this).val());
                        });


                    },
                    error: function (error) {
                        console.log(error);
                    }
                });
            }

        }
        ,
        eventClick: function (calEvent, jsEvent, view) {
            $('.popover').popover('destroy');

            var eventId = calEvent._id;

            var tempThis = $(this);

            eventContainer = tempThis;

            $.ajax({
                url: '/calendar/getEventDetails.do',
                type: 'GET',
                data: {
                    'eventId': eventId
                },
                success: function (data) {

                    data = $(data);

                    data.find('#simple-colorpicker-1').ace_colorpicker('pick', $('#simple-colorpicker-1').attr('rel'))
                            .on('change', function () {
                                queryEventType(this.value);
                            });

                    /* File input */
                    data.find('#id-input-file-2').ace_file_input({
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

                    data.find('.timeFrom').timepicker({'scrollDefault': 'now'});
                    data.find('.timeFrom').on('changeTime', function () {

                        var date = new Date();
                        date.setHours(0);
                        date.setMinutes(0);
                        date.setSeconds(0);

                        var timePicked = $(this).val().indexOf(':');
                        timePicked = $(this).val().substring(0, timePicked);

                        if ($(this).val().indexOf('am') > 0 && parseInt(timePicked) == 12) {
                            timePicked = parseInt(timePicked) - 12;
                        }
                        else if ($(this).val().indexOf('pm') > 0 && parseInt(timePicked) < 12) {
                            timePicked = parseInt(timePicked) + 12;
                        }
                        date.setHours(parseInt(timePicked) + 1);

                        var minutesPicked = $(this).val().indexOf(':');
                        minutesPicked = $(this).val().substring(minutesPicked + 1, minutesPicked + 3);
                        date.setMinutes(minutesPicked);

                        $('.timeTo').timepicker('setTime', date);

                    });
                    data.find('.timeTo').timepicker({'scrollDefault': 'now'});
                    data.find(".eventStartDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });
                    data.find(".eventEndDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });

                    $(tempThis).popover({
                        trigger: 'focus',
                        content: data,
                        placement: 'auto right',
                        html: true,
                        title: 'Event Details <button type="button" id="closePopover" class="close pull-right">&times;</button>',
                        container: 'body'
                    });

                    $(tempThis).popover('toggle');


                },
                error: function (error) {
                    console.log(error);
                }
            });
        }
    });


    function queryEventType(eventColor) {
        $.ajax({
            url: '/calendar/getEventTypeId.do',
            type: 'GET',
            data: {
                'eventColor': eventColor
            },
            success: function (data) {
                $('#hiddenEventTypeId').val(data);
            },
            error: function (error) {
                console.log(error);
            }
        });
    }

    $(document).on('click', 'div.fc-bg table tbody tr td', function (e) {
        $('.popover').popover('destroy');
    });


    $(document).on("click", "a#eventTypeManagerModel", function () {
        $('.popover').popover('destroy');
        $.ajax({
            url: '/calendar/getEventTypes.do',
            type: 'GET',
            success: function (data) {
                data = $(data);

                data.find('#eventTypeColorField').colorpicker().on('changeColor', function (event) {
                    $('#eventTypeColorFieldInput').val(event.color.toHex());
                    $('#eventTypeColorField').attr('data-color', event.color.toHex());
                    $('#eventTypeColorFieldAddon').css("background-color", event.color.toHex());
                    $('#eventTypeColorField').colorpicker('hide');
                });

                bootbox.dialog({
                    title: "Event Types",
                    message: data
                });

            },
            error: function (error) {
                console.log(error);
            }
        });
    });
    
    $(document).on("click", "a#eventNotificationManagerModel", function () {
        $('.popover').popover('destroy');
        $.ajax({
            url: '/calendar/getEventNotificationModel.do',
            type: 'GET',
            success: function (data) {
                data = $(data);

                bootbox.dialog({
                    title: "Event Notification Preferences",
                    message: data
                });

            },
            error: function (error) {
                console.log(error);
            }
        });
    });

    function checkAvailableColors(eventId) {
        var result = "";
        $.ajax({
            url: '/calendar/isColorAvailable.do',
            type: 'GET',
            async: false,
            data: {
                'hexColor': $('#eventTypeColorFieldInput').val(),
                'eventId': eventId
            },
            success: function (data) {
                result = data;
            },
            error: function (error) {
                console.log(error);
            }
        });
        return result;
    }

    $(document).on("click", "#addNewEventTypeButton", function () {
        $('#newEventTypeForm').show();
    });
    
    $(document).on("click", ".editEventTypeButton", function () {
        var eventTypeId = $(this).attr("rel");
        $('#newEventTypeForm').show();

        $('#eventTypeHeading').html("Edit Event Type");

        $('.eventTypeColor').simplecolorpicker().on('change', function () {
            $('.eventTypeColorField').val($('.eventTypeColor').val());
        });

        $.ajax({
            url: '/calendar/getEventType.do',
            type: 'GET',
            data: {
                'eventTypeId': eventTypeId
            },
            success: function (data) {
                $('#eventTypeId').val(data[0]);
                $('.eventTypeColorField').val(data[3]);
                $('#eventTypeColorFieldInput').val(data[3]);
                $('#eventTypeColorField').attr('data-color', data[3]);
                $('#eventTypeColorFieldAddon').css("background-color", data[3]);
                $('#eventType').val(data[2]);
                $('#adminOnly').attr("checked", data[4]);
            },
            error: function (error) {
                console.log(error);
            }
        });

        return false;
    });

    $(document).on("click", "#newEventSaveButton", function () {
        
        $('div').removeClass("has-error");
        $('.help-block').html("");
        $('.help-block').hide();

        var noErrors = true;

        var isAvailable = checkAvailableColors($('#eventTypeId').val());

        if (isAvailable === 0) {
            $('#eventColorDiv').addClass('has-error');
            $('#errorMsg_eventCategoryColor').html('The selected color is already in use.');
            $('#errorMsg_eventCategoryColor').show();
            noErrors = false;
        }

        if ($('#eventType').val() === "") {
            $('#eventCategoryDiv').addClass('has-error');
            $('#errorMsg_eventCategory').html('The event category is required');
            $('#errorMsg_eventCategory').show();
            noErrors = false;
        }

        if (noErrors == true) {
            var eventTypeId = $('#eventTypeId').val();
            var eventTypeColor = $('#eventTypeColorFieldInput').val();
            var eventType = $('#eventType').val();
            if ($('#adminOnly').is(":checked")) {
                var adminOnly = "true";
            }
            else {
                var adminOnly = "false";
            }
            
            $.ajax({
                url: '/calendar/saveEventType.do',
                type: 'POST',
                data: {
                    'eventTypeId': eventTypeId,
                    'eventTypeColor': eventTypeColor,
                    'eventType': eventType,
                    'adminOnly': adminOnly
                },
                success: function (data) {
                    $('#newEventTypeForm').hide();
                    $('#eventTypeId').val(0);
                    $('#eventTypeColorFieldInput').val("");
                    $('#eventType').val("");
                    $('#adminOnly').attr("checked", false);
                    calendar.fullCalendar('refetchEvents');
                    refreshEventTypesColumn();
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }

        return false;
    });

    $(document).on("click", ".showCategory", function () {
        var clickedCategory = $(this).attr('rel');

        /* Uncheck */
        if ($(this).find("i.fa-check").length > 0) {
            $(this).find("i").removeClass('fa-check');
        }
        else {
            $(this).find("i").addClass('fa-check');
        }

        var typeArray = [];

        $('.showCategory').each(function () {
            if ($(this).find("i.fa-check").length > 0) {
                typeArray.push($(this).attr('rel'));
            }
        });

        var events = {
            url: '/calendar/getEventsJSON.do',
            type: 'GET',
            data: {
                eventTypeId: typeArray.toString()
            }
        };
        calendar.fullCalendar('removeEventSource', events);
        calendar.fullCalendar('addEventSource', events);


        return false;
    });

    

    $(document).on("click", "#categoriesToShow", function () {
        $('.popover').popover('destroy');
        var tempThis = $(this);
        $.ajax({
            url: '/calendar/getEventCategories.do',
            type: 'GET',
            success: function (data) {
                $(tempThis).popover({
                    trigger: 'focus',
                    content: data,
                    placement: 'auto bottom',
                    html: true,
                    title: 'Event Categories',
                    container: 'body',
                    callback: function () {

                    }
                });
                $(tempThis).popover('toggle');
            },
            error: function (error) {
                console.log(error);
            }
        });
    });

    $(document).on("click", "#closePopover", function () {
        $('.popover').popover('destroy');
    });

    $(document).on("click", ".deleteEvent", function () {
        var eventId = $(this).attr('rel');
        $('.popover').popover('destroy');
        bootbox.confirm({
            size: 'small',
            message: "Are you sure you want to delete this event?",
            callback: function (result) {
                if (result == true) {
                    $.ajax({
                        url: '/calendar/deleteEvent.do',
                        type: 'POST',
                        data: {
                            'eventId': eventId
                        },
                        success: function (data) {
                            calendar.fullCalendar('removeEvents', function (ev) {
                                return (ev._id == eventId);
                            });
                        },
                        error: function (error) {
                            console.log(error);
                        }
                    });
                }
            }
        });
        return false;
    });


    $.fn.serializefiles = function () {
        var obj = $(this);
        /* ADD FILE TO PARAM AJAX */
        var formData = new FormData();
        $.each($(obj).find("input[type='file']"), function (i, tag) {
            $.each($(tag)[0].files, function (i, file) {
                formData.append(tag.name, file);
            });
        });
        var params = $(obj).serializeArray();
        $.each(params, function (i, val) {
            formData.append(val.name, val.value);
        });
        return formData;
    };

    /* Remove existing document */
    $(document).on('click', '.removeAttachment', function () {

        var confirmed = confirm("Are you sure you want to remove this document?");

        if (confirmed) {
            var docId = $(this).attr('rel');
            $.ajax({
                url: '/calendar/deleteEventDocument.do',
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

    $(document).on('click', '#saveNotificationPreferences', function () {
        
        var formData = $("#notificationPreferencesForm").serialize();
        var errorFound = false;
        
        if ($('#alwaysCreateAlert1').is(":checked")) {
            if ($('#notificationEmail').val() == ''){
                $('#notificationEmailGroup').addClass("has-error");
                $('#notificationEmailMessage').addClass("has-error");
                $('#notificationEmailMessage').html('The notification email address is required.');
                errorFound = true;
            }
        }
        
        if (errorFound == false) {
            $('#notificationEmailGroup').removeClass("has-error");
            $('#notificationEmailMessage').removeClass("has-error");
            $('#notificationEmailMessage').html('');

            $.ajax({
                url: '/calendar/saveNotificationPreferences.do',
                type: 'POST',
                data: formData,
                success: function (data) {
                    $('.successAlert').show();
                    setTimeout(function(){
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
    
    $(document).on('click', '#alwaysCreateAlert', function () {
        if ($('#alwaysCreateAlert').is(":checked")) {
            $('#notificationFrequencyDiv').show();
        }
        else {
            $('#notificationFrequencyDiv').hide();
        }
    });
    
    $(document).on('click', '#newEventNotifications1', function () {
        if($('#newEventNotifications1').is(':checked') == true){
            $('.notificationsOptions').hide();
        }
        else{
            $('.notificationsOptions').show();
        }
    });
    
    $(document).on('click', '#alwaysCreateAlert1', function () {
        $('#alertFrequency').toggle();
    });

});

function refreshEventTypesColumn(){
    $.ajax({
        url: '/calendar/getEventTypesColumn.do',
        type: 'GET',
        success: function (data) {
            $('#eventTypesColumn').html(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}