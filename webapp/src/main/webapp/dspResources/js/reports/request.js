/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {

        $("input:text,form").attr("autocomplete", "off");
        var errorMsg = "You must select at least 1 ";
        
         $(function(){
         $('.date-picker').datepicker({
         autoclose: true,
         todayHighlight: true
         })
         //show datepicker when clicking on the icon
         .next().on(ace.click_event, function () {
         $(this).prev().focus();
         });
         });
         

        $('#reportTypeId').change(function (event) {
            event.preventDefault();
            var reportTypeId = $('#reportTypeId').val();
            $.ajax({
                type: 'POST',
                url: "/reports/availableReports.do",
                data: {'reportTypeId': reportTypeId},
                success: function (data) {
                    $("#selectReportDiv").html(data);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        });




        /** need to rewrite eventually to streamline fns, don't need so many and can use variables **/

        /** ajax to change entitiy2List **/
        $('#showEntity2').click(function (event) {
            event.preventDefault();
            /**a - we disable entity1
             * b - we get data and show entity2
             * c - we change button to say Change
             **/
            if ($('#entity1Ids').val() == null) {
                var message = errorMsg + $(this).attr("rel");
                $('#entity1Div').addClass('has-error');
                $('#errorMsg_entity1').html(message);
                return false;
            }


            $('#entity1Div').removeClass('has-error');
            $('#errorMsg_entity1').html("");
            $('#entity1Ids').prop('disabled', 'disabled');
            $('#entity2Div').show();
            $('#changeEntity1').show();
            $('#showEntity3').show();
            $('#showEntity2').hide();



            var selectednumbers = [];
            $('#entity1Ids :selected').each(function (i, selected) {
                selectednumbers[i] = $(selected).val();
            });

            selectednumbers = selectednumbers.join(", ");
            $.ajax({
                type: 'POST',
                url: "/reports/returnEntityList.do",
                data: {'entityIds': selectednumbers,
                    'tier': 1},
                success: function (data) {
                    $("#entity2SelectDiv").html(data);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        });



        $('#changeEntity1').click(function (event) {
            event.preventDefault();
            /**a - we disable entity1
             * b - we get data and show entity2
             * c - we change button to say Change
             **/

            $("#entity1Ids").removeAttr("disabled");
            $('#showEntity2').show();
            $('#entity2Div').hide();
            $('#changeEntity1').hide();
            $('#entity3Div').hide();
            $('#contentDiv').hide();
            $('#requestButton').hide();
            $('#changeEntity2').hide();
            $('#showEntity3').hide();
        });


        /** show schools / change districts **/
        /** ajax to change entitiy3List **/
        $('#showEntity3').click(function (event) {
            event.preventDefault();
            /**a - we disable entity1
             * b - we get data and show entity2
             * c - we change button to say Change
             **/
            if ($('#entity2Ids').val() == null) {
                var message = errorMsg + $(this).attr("rel");
                $('#entity2Div').addClass('has-error');
                $('#errorMsg_entity2').html(message);
                return false;
            }


            $('#entity2Div').removeClass('has-error');
            $('#errorMsg_entity2').html("");
            $('#entity2Ids').prop('disabled', 'disabled');
            $('#entity3Div').show();
            $('#changeEntity2').show();
            $('#showEntity3').hide();

            var selectednumbers = [];
            $('#entity2Ids :selected').each(function (i, selected) {
                selectednumbers[i] = $(selected).val();
            });

            selectednumbers = selectednumbers.join(", ");

            $.ajax({
                type: 'POST',
                url: "/reports/returnEntityList.do",
                data: {'entityIds': selectednumbers,
                    'tier': 2},
                success: function (data) {
                    $("#entity3SelectDiv").html(data);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        });



        $('#changeEntity2').click(function (event) {
            event.preventDefault();
            $("#entity2Ids").removeAttr("disabled");
            $('#showEntity3').show();
            $('#entity3Div').hide();
            $('#changeEntity2').hide();
            $('#entity3Div').hide();
            $('#contentDiv').hide();
            $('#requestButton').hide();
        });


        /** showCodes / changeEntity3  **/
        $('#showCodes').click(function (event) {
            event.preventDefault();
            /**a - we disable entity1
             * b - we get data and show entity2
             * c - we change button to say Change
             **/
            if ($('#entity3Ids').val() == null) {
                var message = errorMsg + $(this).attr("rel");
                $('#entity3Div').addClass('has-error');
                $('#errorMsg_entity3').html(message);
                return false;
            }


            $('#entity3Div').removeClass('has-error');
            $('#errorMsg_entity3').html("");
            $('#entity3Ids').prop('disabled', 'disabled');
            $('#contentDiv').show();
            $('#requestButton').show();
            $('#changeEntity3').show();
            $('#showCodes').hide();



            var selectednumbers = [];
            $('#entity3Ids :selected').each(function (i, selected) {
                selectednumbers[i] = $(selected).val();
            });

            selectednumbers = selectednumbers.join(", ");

            $.ajax({
                type: 'POST',
                url: "/reports/getCodeList.do",
                data: {'entityIds': selectednumbers
                            /** need to submit dates and report ids also **/
                },
                success: function (data) {
                    $("#codesSelectDiv").html(data);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        });



        $('#changeEntity3').click(function (event) {
            event.preventDefault();
            $("#entity3Ids").removeAttr("disabled");
            $('#showCodes').show();
            $('#contentDiv').hide();
            $('#requestButton').hide();
            $('#changeEntity3').hide();
        });


        /** here we submit the form **.
         */
        $('#submitButton').click(function (event) {
            $('#contentDiv').removeClass('has-error');
            $('#startDateDiv').removeClass('has-error');
            $('#endDateDiv').removeClass('has-error');
            $('#selectReportDiv').removeClass('has-error');
            $('#errorMsg_codes').html("");
            $('#errorMsg_reports').html("");
            $('#errorMsg_startDate').html("");
            $('#errorMsg_endDate').html("");
            
            //Check start date
            var DateValidated = validateDate($('#startDate').val());

            if (DateValidated === false) {
                $('#errorMsg_startDate').addClass("has-error");
                $('#errorMsg_startDate').html('The start date is not valid, format should be yyyy-mm-dd.');
                $('#errorMsg_startDate').show();
                return false;
            }
            
            //Check end date
            var DateValidated = validateDate($('#endDate').val());

            if (DateValidated === false) {
                $('#errorMsg_endDate').addClass("has-error");
                $('#errorMsg_endDate').html('This end date is not valid, format should be yyyy-mm-dd.');
                $('#errorMsg_endDate').show();
                return false;
            }


            if ($('#codeIds').val() == null) {
                $('#contentDiv').addClass('has-error');
                $('#errorMsg_codes').html("Please select at least one Content Area & Criteria");
                return false;
            }

            if ($('#reportIds').val() == null) {
                $('#reportIdDiv').addClass('has-error');
                $('#errorMsg_reports').html("Please select at least one report");
                return false;
            }


            var selectednumbers = [];
            $('#entity3Ids :selected').each(function (i, selected) {
                selectednumbers[i] = $(selected).val();
            });

            selectednumbers = selectednumbers.join(", ");

            var selectedreports = [];
            $('#reportIds :selected').each(function (i, selected) {
                selectedreports[i] = $(selected).val();
            });

            selectedreports = selectedreports.join(", ");

            var selectedcodes = [];
            $('#codeIds :selected').each(function (i, selected) {
                selectedcodes[i] = $(selected).val();
            });

            selectedcodes = selectedcodes.join(", ");


            $("#startDateForm").val($('#startDate').val());
            $("#endDateForm").val($('#endDate').val());
            $("#entity3IdsForm").val(selectednumbers);
            $("#codeIdsForm").val(selectedcodes);
            $("#reportIdsForm").val(selectedreports);

            $("#requestForm").submit();


        });

    });
});

function validateDate($date) {

    var currVal = $date;

    if (currVal == '')
        return false;

    //Declare Regex  
    var rxDatePattern = /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
    var dtArray = currVal.match(rxDatePattern); // is format OK?

    if (dtArray == null)
        return false;

    //Checks for yyyy-mm-dd format.
    dtMonth = dtArray[3];
    dtDay = dtArray[5];
    dtYear = dtArray[1];

    if (dtMonth < 1 || dtMonth > 12) {
        console.log("error 1");
        return false;
    }
    else if (dtDay < 1 || dtDay > 31) {
        console.log("error 2");
        return false;
    }
    else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31) {
        console.log("error 3");
        return false;
    }
    else if (dtMonth == 2)
    {
        var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
        if (dtDay > 29 || (dtDay == 29 && !isleap))
            return false;
    }
    return true;


    /*
     
     var DateReg = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/; // mm/dd/yyyy
     var DateReg2 = /\b\d{4}[\-]\d{1,2}[\-]\d{1,2}\b/; // yyyy-mm-dd
     if (!DateReg.test($date) && !DateReg2.test($date)) {
     return false;
     }
     else {
     return true;
     } */
}