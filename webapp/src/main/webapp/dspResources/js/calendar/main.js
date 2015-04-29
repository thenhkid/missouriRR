require.config({
    urlArgs: "bust=" + (new Date()).getTime(),
    paths: {
        'jquery': '../vendor/jquery-1.10.1.min',
        'bootstrap': '../vendor/bootstrap',
        'responsive-tables': '../vendor/responsive-tables',
        'mediaModal': '../mediaModal',
        'overlay': '../overlay',
        'sprintf': '../vendor/sprintf',
        'moment': '../vendor/moment',
        'calendar': '../calendar/calendar',
        'underscore': '../calendar/underscore-min',
        'simplecolorpicker': '../calendar/jquery.simplecolorpicker'
    },
    shim: {
        'bootstrap': ['jquery'],
        'responsive-tables': ['jquery'],
        'calendar': ['jquery', 'underscore'],
        'simplecolorpicker': ['jquery','bootstrap']
    }
});

define(['jquery', 'moment', 'bootstrap', 'responsive-tables', 'mediaModal', 'overlay', 'calendar', 'simplecolorpicker'], function($, moment) {

    $.ajaxSetup({
        cache: false
    });

    $(document).ready(function() {
        var options = {
            events_source: '/dspResources/js/calendar/events.json',
            view: 'month',
            tmpl_path: '/dspResources/tmpls/',
            tmpl_cache: false,
            day: '2013-03-24',
            onAfterEventsLoad: function(events) {
                if (!events) {
                    return;
                }
                var list = $('#eventlist');
                list.html('');

                $.each(events, function(key, val) {
                    $(document.createElement('li'))
                            .html('<a href="' + val.url + '">' + val.title + '</a>')
                            .appendTo(list);
                });
            },
            onAfterViewLoad: function(view) {
                $('.page-header h3').text(this.getTitle());
                $('.btn-group button').removeClass('active');
                $('button[data-calendar-view="' + view + '"]').addClass('active');
            },
            classes: {
                months: {
                    general: 'label'
                }
            }
        };

        var calendar = $('#calendar').calendar(options);

        $('.btn-group button[data-calendar-nav]').each(function() {
            var $this = $(this);
            $this.click(function() {
                calendar.navigate($this.data('calendar-nav'));
            });
        });

        $('.btn-group button[data-calendar-view]').each(function() {
            var $this = $(this);
            $this.click(function() {
                calendar.view($this.data('calendar-view'));
            });
        });

        $('#first_day').change(function() {
            var value = $(this).val();
            value = value.length ? parseInt(value) : null;
            calendar.setOptions({first_day: value});
            calendar.view();
        });

        $('#events-in-modal').change(function() {
            var val = $(this).is(':checked') ? $(this).val() : null;
            calendar.setOptions({modal: val});
        });

        $('#events-modal .modal-header, #events-modal .modal-footer').click(function(e) {
            //e.preventDefault();
            //e.stopPropagation();
        });

        $.event.special.rightclick = {
            bindType: "contextmenu",
            delegateType: "contextmenu"
        };

        $(document).on("rightclick", ".cal-month-day", function() {
            var dateClicked = $(this).children('span').attr('data-cal-date');
            $('.cal-month-day').popover('destroy');
            $(this).popover({
                trigger: 'focus',
                content: $('#createEventForm').html(),
                placement: 'auto right',
                html: true,
                title: 'Create Event',
                container: 'body'
            });
            $(this).popover('toggle');
            $('.eventDate').val(dateClicked);
            return false;
        });
        
        $(document).on("click", ".cal-month-day", function() {
            $('.cal-month-day').popover('destroy');
        });
        
        $('select[name="colorpicker-picker-longlist"]').simplecolorpicker();
        
        $('#eventTypeManagerModel').on('show.bs.modal', function (e) {
            //alert('load modal table with js now');
        });
        
        $(document).on("click", "#addNewEventTypeButton", function() {
            $('#newEventTypeForm').show();
        });
        
        //eventTypesTable
        
    });

});