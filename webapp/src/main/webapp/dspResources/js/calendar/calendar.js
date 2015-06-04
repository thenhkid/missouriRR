/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {

    var calendar;
    var eventContainer;

    $(document).ready(function () {

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

        var eventTypeId = $('#hiddenEventTypeId').val();
        var eventName = $('.popover-content div form div.form-group .eventName').val();
        var eventLocation = $('.popover-content div form div.form-group .eventLocation').val();
        var eventStartDate = $('.popover-content div form div.form-group .eventStartDate').val();
        var eventEndDate = $('.popover-content div form div.form-group .eventEndDate').val();
        var eventStartTime = $('.popover-content div form div.form-group .timeFrom').val();
        var eventEndTime = $('.popover-content div form div.form-group .timeTo').val();
        var eventNotes = $('.popover-content div form div.form-group .eventNotes').val();
        var eventId = 0;

        $.ajax({
            url: '/calendar/saveEvent.do',
            type: 'POST',
            data: {
                'eventId': eventId,
                'eventTypeId': eventTypeId,
                'eventName': eventName,
                'eventLocation': eventLocation,
                'eventStartDate': eventStartDate,
                'eventEndDate': eventEndDate,
                'eventStartTime': eventStartTime,
                'eventEndTime': eventEndTime,
                'eventNotes': eventNotes
            },
            success: function (data) {
                //bootbox.hideAll();
                $('.popover').popover('destroy');
                calendar.fullCalendar('refetchEvents');
            },
            error: function (error) {
                console.log(error);
            }
        });

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
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
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
            var tempThis = $(this);

            $.ajax({
                url: '/calendar/getNewEventForm.do',
                type: 'GET',
                success: function (data) {
                    $('.popover').popover('destroy');

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
                    
                    //$('#simple-colorpicker-1').ace_colorpicker('pick', 2);//select 2nd color

                    $('#simple-colorpicker-1').ace_colorpicker()
                    .on('change', function () {
                        queryEventType(this.value);
                    });

                    $('.timeFrom').timepicker({'scrollDefault': 'now'});
                    $('.timeFrom').val($('.timeFrom option:first').val());
                    $('.timeFrom').on('changeTime', function () {

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

                    $('.timeTo').timepicker({'scrollDefault': 'now'});
                    $(".eventStartDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });

                    $(".eventStartDate").datepicker("setDate", date.format('MM/DD/YYYY'));
                    $(".eventEndDate").datepicker("setDate", date.format('MM/DD/YYYY'));

                    $(document).on("change", ".eventStartDate", function () {
                        $(".eventEndDate").val($(this).val());
                        $(".eventEndDate").datepicker("setDate", $(this).val());
                    });

                    $(".eventEndDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }
        ,
        eventClick: function (calEvent, jsEvent, view) {
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

                    $('.popover').popover('destroy');

                    $(tempThis).popover({
                        trigger: 'focus',
                        content: data,
                        placement: 'auto right',
                        html: true,
                        title: 'Event Details <button type="button" id="closePopover" class="close pull-right">&times;</button>',
                        container: 'body'
                    });
                    
                    $(tempThis).popover('toggle');
                    
                    $('#simple-colorpicker-1').ace_colorpicker('pick', $('#simple-colorpicker-1').attr('rel'))
                    .on('change', function () {
                        queryEventType(this.value);
                    });
                    

                    $('.timeFrom').timepicker({'scrollDefault': 'now'});
                    $('.timeFrom').on('changeTime', function () {

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
                    $('.timeTo').timepicker({'scrollDefault': 'now'});
                    $(".eventStartDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });
                    $(".eventEndDate").datepicker({
                        showOtherMonths: true,
                        selectOtherMonths: true
                    });
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

    var loadEventTypesDatatableObject;

    function loadEventTypeDatatable() {
        $('#eventTypesTable').dataTable().fnDestroy();

        loadEventTypesDatatableObject = $('#eventTypesTable').dataTable({
            "processing": true,
            "bServerSide": false,
            "sAjaxSource": "/calendar/getEventTypesDatatable.do",
            "sScrollY": "160px",
            "bPaginate": false,
            "bScrollCollapse": true,
            "bAutoWidth": true,
            "bFilter": false,
            "aaSorting": [[0, "desc"]],
            "sDom": '<"top">rt<"bottom"lp><"clear">',
            "fnDrawCallback": function (oSettings) {
                //$('#dataTableCount').html(this.fnGetData().length);
            },
            "aoColumns": [
                {"bSortable": false, "sClass": "center", "sWidth": "10px"},
                {"bSortable": true, "sClass": "left"},
                {"bSortable": true, "sClass": "center"},
                {"bSortable": false, "sClass": "center"}
            ]
        });
    }

    $(document).on("show.bs.modal", "#eventTypeManagerModel", function () {
        loadEventTypeDatatable();
    });

    $(document).on("shown.bs.modal", "#eventTypeManagerModel", function () {
        loadEventTypesDatatableObject.fnAdjustColumnSizing();
    });

    $(document).on("hide.bs.modal", "#eventTypeManagerModel", function () {
        //alert('load modal table with js now');
        $('#newEventTypeForm').hide();
    });

    $(document).on("click", "a#eventTypeManagerModel", function () {
        $('.popover').popover('destroy');
        $.ajax({
            url: '/calendar/getNewEventTypeForm.do',
            type: 'GET',
            success: function (data) {
                var modal = $(data).appendTo('body');
                modal.modal('show');
            },
            error: function (error) {
                console.log(error);
            }
        });
    });

    $(document).on("click", "#addNewEventTypeButton", function () {
        $('#eventTypeHeading').html("New Event Type");
        var eventTypeId = $('#eventTypeId').val(0);
        var eventTypeColor = $('#eventTypeColor').val("");
        var eventType = $('#eventType').val("");
        var adminOnly = $('#adminOnly').attr("checked", false);
        $('#newEventTypeForm').show();
        $('.eventTypeColor').simplecolorpicker('selectColor', $('.eventTypeColor option:first').val()).on('change', function () {
            $('.eventTypeColorField').val($('.eventTypeColor').val());
        });

        $('.eventTypeColorField').val($('.eventTypeColor').val());
    });

    $(document).on("click", "#newEventSaveButton", function () {
        var eventTypeId = $('#eventTypeId').val();
        var eventTypeColor = $('#eventTypeColorField').val();
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
                var eventTypeId = $('#eventTypeId').val(0);
                var eventTypeColor = $('#eventTypeColor').val("");
                var eventType = $('#eventType').val("");
                var adminOnly = $('#adminOnly').attr("checked", false);
                loadEventTypeDatatable();
                calendar.fullCalendar('refetchEvents');
            },
            error: function (error) {
                console.log(error);
            }
        });

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
                var eventTypeId = $('#eventTypeId').val(data[0]);
                var eventTypeColor = $('.eventTypeColorField').val(data[3]);
                $('.eventTypeColor').simplecolorpicker('selectColor', data[3]);
                var eventType = $('#eventType').val(data[2]);
                var adminOnly = $('#adminOnly').attr("checked", data[4]);
            },
            error: function (error) {
                console.log(error);
            }
        });

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

    
});