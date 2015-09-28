/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {


    $(document).ready(function () {
        
        $('.Date').each(function () {
            var dateVal = $(this).val();
            console.log(dateVal);
            dateVal = dateVal.split("/");
            
            if(dateVal[2].length == 2) {
                dateVal[2] = "20" + dateVal[2];
                
                $(this).val(dateVal.join('/'));
            }
            
        });

        /* $('.multiselect').multiselect({
         maxHeight: 300,
         buttonWidth: '500px',
         enableFiltering: true,
         buttonClass: 'btn btn-white btn-primary',
         enableClickableOptGroups: true,
         disableIfEmpty: true,
         nonSelectedText: 'Select Schools...',
         numberDisplayed: 5,
         templates: {
         button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"></button>',
         ul: '<ul class="multiselect-container dropdown-menu"></ul>',
         filter: '',
         filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
         li: '<li><a href="javascript:void(0);" ><label></label></a></li>',
         divider: '<li class="multiselect-item divider"></li>',
         liGroup: '<li class="multiselect-item group"><label class="multiselect-group" style="padding-left:5px; font-weight:bold;"></label></li>'
         },
         onChange: function (option, checked, select) {
         
         if (checked == true) {
         $.ajax({
         url: 'getEntityCodeSets',
         data: {'entityId': option.val(), 'surveyId': 0},
         type: "GET",
         success: function (data) {
         $('#contentAndCriteriaDiv').html(data);
         }
         });
         }
         else {
         $.ajax({
         url: 'removeCodeSets',
         data: {'entityId': option.val()},
         type: "GET",
         success: function (data) {
         $('#contentAndCriteriaDiv').html(data);
         }
         });
         }
         }
         });*/

        if (!ace.vars['touch']) {
            $('.chosen-select').chosen({allow_single_deselect: true});
            //resize the chosen on window resize

            $(window)
                    .off('resize.chosen')
                    .on('resize.chosen', function () {
                        $('.chosen-select').each(function () {
                            var $this = $(this);
                            $this.next().css({'width': $this.parent().width()});
                        })
                    }).trigger('resize.chosen');
            //resize chosen on sidebar collapse/expand
            $(document).on('settings.ace.chosen', function (e, event_name, event_val) {
                if (event_name != 'sidebar_collapsed')
                    return;
                $('.chosen-select').each(function () {
                    var $this = $(this);
                    $this.next().css({'width': $this.parent().width()});
                })
            });

        }

        $("input:text,form").attr("autocomplete", "off");

        $('.input-daterange').datepicker({autoclose: true});
        $('.date-picker').datepicker({
            autoclose: true,
            todayHighlight: true
        })
        //show datepicker when clicking on the icon
           .next().on(ace.click_event, function () {
           $(this).prev().focus();
        });

        var surveyId = $('#submittedSurveyId').val();

        var selectedSchools = $('#schoolSelect').val();

        var disabled = $('#disabled').val();

        if (selectedSchools != null) {
            var schools = [];
            $.each(selectedSchools, function (i, entityId) {
                schools.push(entityId);
            });
            var schoolList = schools.join(',');

            $.ajax({
                url: 'getEntityCodeSets',
                data: {'entityId': schoolList, 'surveyId': surveyId, 'disabled': disabled},
                type: "GET",
                success: function (data) {
                    $('#contentAndCriteriaDiv').html(data);
                }
            });
        }
    });


    /* If editing or viewing need to get the content area */

    /* Get the content area and criteria for the clicked school */
    $('#schoolSelect').on('change', function (evt, params) {

        if (params.selected > 0) {
            $.ajax({
                url: 'getEntityCodeSets',
                data: {'entityId': params.selected, 'surveyId': 0, 'disabled': $('#disabled').val()},
                type: "GET",
                success: function (data) {
                    $('#contentAndCriteriaDiv').html(data);
                }
            });
        }
        else if (params.deselected > 0) {
            $.ajax({
                url: 'removeCodeSets',
                data: {'entityId': params.deselected, 'disabled': $('#disabled').val()},
                type: "GET",
                success: function (data) {
                    $('#contentAndCriteriaDiv').html(data);
                }
            });
        }

    });


    /* Save the code set when selected */
    $(document).on('click', '.contentSel', function () {
        var entityId = $(this).attr('rel');
        var codeId = $(this).val();

        if ($(this).is(':checked')) {
            $.ajax({
                url: 'saveSelCodeSet',
                data: {'entityId': entityId, 'codeId': codeId},
                type: "POST",
                success: function (data) {
                }
            });
        }
        else {
            $.ajax({
                url: 'removeSelCodeSet',
                data: {'entityId': entityId, 'codeId': codeId},
                type: "POST",
                success: function (data) {
                }
            });
        }


    })

    /* Handle multiple answer questions */
    $(document).on('change', '.multiAns', function () {

        var qId = 0;
        var enterVals = false;
        var answerValues = [];
        $('.multiAns').each(function () {
            var nextqId = $(this).attr('rel');

            if (qId != nextqId) {
                if (qId != 0) {
                    enterVals = true
                }
                qId = nextqId;
            }
            answerValues.push($(this).val());

            if (enterVals == true) {
                var s = answerValues.join('^^^^^');
                $('#multiAns_' + qId).val(s);
                enterVals = false;
                answerValues = [];
            }

        });

        if (enterVals == false) {
            var s = answerValues.join('^^^^^');
            $('#multiAns_' + qId).val(s);
        }

    });

    /* Function to control clicking a page number on the left pane */
    $(document).on('click', '.goToPage', function () {
        var clickedpageNum = $(this).attr('rel');
        var curPageNum = $(this).attr('rel2');

        if ((clickedpageNum * 1) < (curPageNum * 1)) {
            $('#action').val("prev");
            $('#goToPage').val((clickedpageNum * 1));
            $('#lastQNumAnswered').val($('.qNumber:first').attr('rel'));
            $("#survey").submit();
        }
        else if ((clickedpageNum * 1) > (curPageNum * 1)) {
            $('#action').val("next");
            $('#goToPage').val((clickedpageNum * 1));
            $('#lastQNumAnswered').val($('.qNumber:first').attr('rel'));
            $("#survey").submit();
        }

    });


    /* Function to process the NEXT button */
    $(document).on('click', '.nextPage', function (event) {
        var errorsFound = 0;

        errorsFound = checkSurveyFields();

        if (errorsFound == 0) {
            $('#action').val("next");
            $('#lastQNumAnswered').val($('.qNumber:last').attr('rel'));

            /* Remove any disabled options */
            $('input, select').attr('disabled', false);
            $('input, radio').attr('disabled', false);
            $('input, checkbox').attr('disabled', false);

            $("#survey").submit();
        }

        event.preventDefault();
        return false;

    });

    /* Function to process the PREVIOUS button */
    $(document).on('click', '.prevPage', function () {

        $('#action').val("prev");
        $('#lastQNumAnswered').val($('.qNumber:first').attr('rel'));

        /* Remove any disabled options */
        $('input, select').attr('disabled', false);
        $('input, radio').attr('disabled', false);
        $('input, checkbox').attr('disabled', false);

        $("#survey").submit();
    });

    /* Function to process the COMPLETE button */
    $(document).on('click', '.completeSurvey', function (event) {
        var errorsFound = 0;

        errorsFound = checkSurveyFields();

        if (errorsFound == 0) {
            $('#action').val("done");
            $('#lastQNumAnswered').val(1);
            $("#survey").submit();
        }

        event.preventDefault();
        return false;

    });

    /* Function to process the SAVE button */
    $(document).on('click', '.saveSurvey', function () {

        $('#action').val("save");
        $('#lastQNumAnswered').val(1);
        $("#survey").submit();
    });

});

function checkSurveyFields() {
    var errorFound = 0;
    var missingQuestions = "";

    $('div').removeClass("has-error");
    $('.help-block').html("");
    $('.help-block').hide();

    //Make sure at least one school is selcted
    if ($('#schoolSelect').val() == "" || $('#schoolSelect').val() == null) {
        $('#errorMsg_schools').html("At least one school must be selected.");
        $('#errorMsg_schools').show();
        missingQuestions+="- Involved School(s) / ECC,";
        errorFound = 1;
    }
    
    //Make sure at least one school is selcted
    if ($('.contentSel').is(':checked') == false) {
        $('#errorMsg_content').html("At least one content area & criteria must be selected.");
        $('#errorMsg_content').show();
        missingQuestions+="- Content Area & Criteria,";
        errorFound = 1;
    }

    //Look at all required fields.
    $('.required').each(function () {
        var qId = $(this).attr('rel');
        var qName = $(this).attr('rel2');
        var qType = $(this).attr('rel3');
        var qNum = $(this).attr('qnum');
        var requiredMsg = $('#requiredMsg' + qId).val();
        if (requiredMsg === '') {
            requiredMsg = "This is a required question.";
        }

        //Text Box || Select box
        if (qType == 3 || qType == 5 || qType == 2 || qType == 6) {

            if ($(this).val() === '') {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html(requiredMsg);
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
        // Multiple Choice
        else if (qType == 1) {
            if ($('input[name="' + qName + '"]:checked').length == 0) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html(requiredMsg);
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
        

    });

    //Look at all Email validation types
    $('.Email').each(function () {
        var qId = $(this).attr('rel');
        var emailVal = $(this).val();
        var qNum = $(this).attr('qnum');

        if (emailVal != '') {
            var emailValidated = validateEmail(emailVal);

            if (emailValidated === false) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid email address.');
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
        
    });

    //Look at all Phone Number validation types
    $('.Phone-Number').each(function () {
        var qId = $(this).attr('rel');
        var phoneVal = $(this).val();
        var qNum = $(this).attr('qnum');

        if (phoneVal != '') {
            var phoneValidated = validatePhone(phoneVal);

            if (phoneValidated === false) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid phone number.');
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
    });

    //Look at all numeric validation types
    $('.Numeric').each(function () {
        var qId = $(this).attr('rel');
        var fieldVal = $(this).val();
        var qNum = $(this).attr('qnum');

        if (fieldVal != '') {
            var fieldValidated = validateNumericValue(fieldVal);

            if (fieldValidated === false) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('The value must be numeric.');
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
    });

    //Look at all URL validation types
    $('.URL').each(function () {
        var qId = $(this).attr('rel');
        var URLVal = $(this).val();
        var qNum = $(this).attr('qnum');

        if (URLVal != '') {
            var URLValidated = validateURL(URLVal);

            if (URLValidated === false) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid URL.');
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
    });

    //Look at all Date validation types
    $('.Date').each(function () {
        var qId = $(this).attr('rel');
        var dateVal = $(this).val();
        var qNum = $(this).attr('qnum');

        if (dateVal != '') {
            var DateValidated = validateDate(dateVal);

            if (DateValidated === false) {
                $('#questionOuterDiv_' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid Date, format should be mm/dd/yyyy.');
                $('#errorMsg_' + qId).show();
                if(missingQuestions.indexOf("- Question " + qNum) == -1) {
                    missingQuestions+="- Question "+qNum+",";
                }
                errorFound = 1;
            }
        }
    });

    if (errorFound === 1) {
        $.gritter.add({
            title: 'Missing / Invalid Value!',
            text: 'The following question(s) were not answered or have an invalid value.<br />  '+missingQuestions.replace(/,/g,"<br />"),
            class_name: 'gritter-error gritter-light'
        });
    }

    return errorFound;
}

function validateEmail($email) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if (!emailReg.test($email)) {
        return false;
    }
    else {
        return true;
    }
}

function validatePhone($phone) {
    var phoneRegExp = /1?\s*\W?\s*([2-9][0-8][0-9])\s*\W?\s*([2-9][0-9]{2})\s*\W?\s*([0-9]{4})(\se?x?t?(\d*))?/;
    //var phoneRegExp = /^[0-9-+]+$/;
    if (!phoneRegExp.test($phone)) {
        return false;
    }
    else {
        return true;
    }
}

function validateNumericValue($fieldVal) {

    if ($fieldVal.indexOf("/") != -1) {
        return false;
    }
    else {

        var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
        if (!numericReg.test($fieldVal)) {
            return false;
        }
        else {
            return true;
        }
    }
}

function validateURL($URL) {
    var URLReg = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
    if (!URLReg.test($URL)) {
        return false;
    }
    else {
        return true;
    }
}

function validateDate($date) {

    var currVal = $date;

    if (currVal == '')
        return false;

    //Declare Regex  
    var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
    var dtArray = currVal.match(rxDatePattern); // is format OK?

    if (dtArray == null)
        return false;

    //Checks for mm/dd/yyyy format.
    dtMonth = dtArray[1];
    dtDay = dtArray[3];
    dtYear = dtArray[5];

    if (dtMonth < 1 || dtMonth > 12)
        return false;
    else if (dtDay < 1 || dtDay > 31)
        return false;
    else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31)
        return false;
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
