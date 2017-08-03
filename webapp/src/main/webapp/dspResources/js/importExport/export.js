/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    var date = new Date();

    $(document).on('click', '.exportSurveyResponses', function () {
        $.ajax({
            url: '/import-export/getExportModal.do',
            data: {'surveyId': $(this).attr('rel')},
            type: 'GET',
            success: function (data, date) {
                data = $(data);

                data.find(".exportStartDate").datepicker({
                    showOtherMonths: true,
                    selectOtherMonths: true
                });
                data.find(".exportEndDate").datepicker({
                    showOtherMonths: true,
                    selectOtherMonths: true
                });

                bootbox.dialog({
                    title: "Activity Log Export",
                    message: data
                });

            },
            error: function (error) {
                console.log(error);
            }
        });

    });
    
    $(document).on('click', '.exportSurveyQuestions', function () {
        $.ajax({
            url: '/import-export/getExportQuestionModal.do',
            data: {'surveyId': $(this).attr('rel')},
            type: 'GET',
            success: function (data, date) {
                data = $(data);

                bootbox.dialog({
                    title: "Activity Log Question Export",
                    message: data
                });

            },
            error: function (error) {
                console.log(error);
            }
        });

    });


    $(document).on("click", ".createSurveyExport", function () {

        $('div').removeClass("has-error");
        $('.help-block').html("");
        $('.help-block').hide();

        var noErrors = true;

        /*if ($('#exportName').val() === "") {
         $('#exportNameDiv').addClass('has-error');
         $('#errorMsg_exportName').html('The export file name is required');
         $('#errorMsg_exportName').show();
         noErrors = false;
         }*/

        if ($('.exportStartDate').val() === "") {
            $('#exportStartDateDiv').addClass('has-error');
            $('#errorMsg_exportStartDate').html('The start date range is required');
            $('#errorMsg_exportStartDate').show();
            noErrors = false;
        }

        if ($('.exportEndDate').val() === "") {
            $('#exportEndDateDiv').addClass('has-error');
            $('#errorMsg_exportEndDate').html('The end date range is required');
            $('#errorMsg_exportEndDate').show();
            noErrors = false;
        }

        if (noErrors == true) {
            
            $('.createSurveyExport').hide();
            $('#creatingExport').show();

            var formData = $("#exportForm").serialize();
            
            var intervalID = setInterval(function(){
                updateProgressBar();
            },1000);
            
            $('.exportProgress').show();
            $('.createSurveyExport').hide();

            $.ajax({
                url: '/import-export/saveActivityLogExport.do',
                type: 'POST',
                data: formData,
                success: function (data) {

                    data = $(data);
                    
                    //Check if the session has expired.
                    if(data.find('.username').length > 0) {
                       top.location.href = '/login?expired';
                    }
                    else {
                    
                        data.find(".alert").delay(2000).fadeOut(1000);

                        data.find(".exportStartDate").datepicker({
                            showOtherMonths: true,
                            selectOtherMonths: true
                        });
                        data.find(".exportEndDate").datepicker({
                            showOtherMonths: true,
                            selectOtherMonths: true
                        });

                        bootbox.hideAll();

                        clearInterval(intervalID);

                        bootbox.dialog({
                            title: "Activity Log Export",
                            message: data
                        });
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
		    clearInterval(intervalID);
		    console.log(jqXHR);
		    console.log(textStatus);
                    console.log(errorThrown);
                }
            });
        }

        return false;
    });


});

function updateProgressBar() {
    
    var uniqueId = $('#uniqueId').val();
    
     $.getJSON('/import-export/updateProgressBar.do', {
        uniqueId: uniqueId
    }, function(data) {
       $('.progress').attr('data-percent', data + '%');
       $('.progress-bar').css("width", data + '%');
    });
}