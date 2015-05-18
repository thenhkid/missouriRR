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
                "aoColumns": [
                    null,null,null,
                    {"bSortable": false},
                    {"bSortable": false},
                    {"bSortable": false}
                ],
                "aaSorting": []
            });


    //TableTools settings
    TableTools.classes.container = "btn-group btn-overlap";
    TableTools.classes.print = {
        "body": "DTTT_Print",
        "info": "tableTools-alert gritter-item-wrapper gritter-info gritter-center white",
        "message": "tableTools-print-navbar"
    }

    //initiate TableTools extension
    var tableTools_obj = new $.fn.dataTable.TableTools(oTable1, {
        "sSwfPath": "../dspResources/js/dataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf", //in Ace demo dist will be replaced by correct assets path

        "sRowSelector": "td:not(:last-child)",
        "sRowSelect": "multi",
        "fnRowSelected": function (row) {
            //check checkbox when row is selected
            try {
                $(row).find('input[type=checkbox]').get(0).checked = true
            }
            catch (e) {
            }
        },
        "fnRowDeselected": function (row) {
            //uncheck checkbox
            try {
                $(row).find('input[type=checkbox]').get(0).checked = false
            }
            catch (e) {
            }
        },
        "sSelectedClass": "success",
        "aButtons": [
            {
                "sExtends": "copy",
                "sToolTip": "Copy to clipboard",
                "sButtonClass": "btn btn-white btn-primary btn-bold",
                "sButtonText": "<i class='fa fa-copy bigger-110 pink'></i>",
                "fnComplete": function () {
                    this.fnInfo('<h3 class="no-margin-top smaller">Table copied</h3>\
									<p>Copied ' + (oTable1.fnSettings().fnRecordsTotal()) + ' row(s) to the clipboard.</p>',
                            1500
                            );
                }
            },
            {
                "sExtends": "csv",
                "sToolTip": "Export to CSV",
                "sButtonClass": "btn btn-white btn-primary  btn-bold",
                "sButtonText": "<i class='fa fa-file-excel-o bigger-110 green'></i>"
            },
            {
                "sExtends": "pdf",
                "sToolTip": "Export to PDF",
                "sButtonClass": "btn btn-white btn-primary  btn-bold",
                "sButtonText": "<i class='fa fa-file-pdf-o bigger-110 red'></i>"
            },
            {
                "sExtends": "print",
                "sToolTip": "Print view",
                "sButtonClass": "btn btn-white btn-primary  btn-bold",
                "sButtonText": "<i class='fa fa-print bigger-110 grey'></i>",
                "sMessage": "<div class='navbar navbar-default'><div class='navbar-header pull-left'><a class='navbar-brand' href='#'><small><i class='fa fa-leaf'></i>&nbsp;MO Healthy Schools Monitoring System</small></a></div></div>",
                "sInfo": "<h3 class='no-margin-top'>Print view</h3>\
									  <p>Please use your browser's print function to\
									  print this table.\
									  <br />Press <b>escape</b> when finished.</p>",
            }
        ]
    });
    //we put a container before our table and append TableTools element to it
    $(tableTools_obj.fnContainer()).appendTo($('.tableTools-container'));

    //also add tooltips to table tools buttons
    //addding tooltips directly to "A" buttons results in buttons disappearing (weired! don't know why!)
    //so we add tooltips to the "DIV" child after it becomes inserted
    //flash objects inside table tools buttons are inserted with some delay (100ms) (for some reason)
    setTimeout(function () {
        $(tableTools_obj.fnContainer()).find('a.DTTT_button').each(function () {
            var div = $(this).find('> div');
            if (div.length > 0)
                div.tooltip({container: 'body'});
            else
                $(this).tooltip({container: 'body'});
        });
    }, 200);



    //ColVis extension
    var colvis = new $.fn.dataTable.ColVis(oTable1, {
        "buttonText": "<i class='fa fa-search'></i>",
        "aiExclude": [5],
        "bShowAll": true,
        //"bRestore": true,
        "sAlign": "right",
        "fnLabel": function (i, title, th) {
            return $(th).text();//remove icons, etc
        }

    });

    //style it
    $(colvis.button()).addClass('btn-group').find('button').addClass('btn btn-white btn-info btn-bold')

    //and append it to our table tools btn-group, also add tooltip
    $(colvis.button())
            .prependTo('.tableTools-container .btn-group')
            .attr('title', 'Show/hide columns').tooltip({container: 'body'});

    //and make the list, buttons and checkboxed Ace-like
    $(colvis.dom.collection)
            .addClass('dropdown-menu dropdown-light dropdown-caret dropdown-caret-right')
            .find('li').wrapInner('<a href="javascript:void(0)" />') //'A' tag is required for better styling
            .find('input[type=checkbox]').addClass('ace').next().addClass('lbl padding-8');



    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }
    

    $(document).on('click', '#createNewEntry', function () {
        var surveyId = $(this).attr('rel');

        $.ajax({
            url: '/districts/getDistrictList.do',
            data: {'surveyId': surveyId},
            type: "GET",
            success: function (data) {
                $('#districtSelectModal').html(data);
            }
        });

    });

    /* Submit the district selection */
    $(document).on('click', '#submitDistrictSelect', function () {

        var districts = [];

        $('.entitySelect').each(function () {
            if ($(this).is(":checked")) {
                districts.push($(this).val());
            }
        });
        var s = districts.join(',');

        $('#selDistricts').val(s);

        $('#districtSelectForm').submit();

    });


    /* Function to check if engagments are required */
    $(document).on('change', '.startSurvey', function () {

        var selSurvey = $(this).val();
        var i = $('.main').attr('rel');
        var v = $('.main').attr('rel2');

        if (selSurvey > 0) {
            var engagementRequired = $(this).attr('rel');
            var allowEngagement = $(this).attr('rel2');
            var duplicatesAllowed = $(this).attr('rel3');

            /* If engagments are required go get the engagements for this patient */
            if (engagementRequired == true) {
                /*$.ajax({
                 url: 'surveys/getAvailableEngagements.do',
                 data: {'i':i,'v':v},
                 type: "GET",
                 success: function(data) {
                 
                 }
                 });*/
            }

            else {
                $('.startSurveyBtn').show();
            }
        }
        else {
            $('.startSurveyBtn').hide();
        }

    });


    /* Function to start the survey */
    $(document).on('click', '.startSurveyBtn', function () {

        var selSurvey = $('.startSurvey').val();

        var i = $('.main').attr('rel');
        var v = $('.main').attr('rel2');

        if (selSurvey > 0) {
            window.location.href = "/clients/surveys/takeSurvey?i=" + i + "&c=0&s=" + selSurvey + "&v=" + v;
        }

    });
});