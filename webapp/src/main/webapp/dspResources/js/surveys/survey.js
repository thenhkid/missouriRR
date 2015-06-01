/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

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
    
    /* Handle multiple answer questions */
    $(document).on('change', '.multiAns', function() {
        
          var qId = 0;
          var enterVals = false;
          var answerValues = [];
          $('.multiAns').each(function() {
             var nextqId = $(this).attr('rel');
             
             if(qId != nextqId) {
                 if(qId != 0) {enterVals = true}
                 qId = nextqId;
             }
             answerValues.push($(this).val());
             
              if(enterVals == true) {
                var s = answerValues.join('^^^^^'); 
                $('#multiAns_'+qId).val(s);
                enterVals = false;
                answerValues = [];
              } 
             
          });    
          
          if(enterVals == false) {
            var s = answerValues.join('^^^^^'); 
            $('#multiAns_'+qId).val(s);
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
        
        /* Make sure at lease one school is checked */
        $('#entityList').val("");
        var schools = [];
        $('.selectedSchools').each(function () {
            if ($(this).is(":checked")) {
                schools.push($(this).val());
            }
        });
        var s = schools.join(',');

        $('#entityList').val(s);
        
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
        
        /* Make sure at lease one school is checked */
        $('#entityList').val("");
        var schools = [];
        $('.selectedSchools').each(function () {
            if ($(this).is(":checked")) {
                schools.push($(this).val());
            }
        });
        var s = schools.join(',');

        $('#entityList').val(s)
        
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

        /* Make sure at lease one school is checked */
        $('#entityList').val("");
        var schools = [];
        $('.selectedSchools').each(function () {
            if ($(this).is(":checked")) {
                schools.push($(this).val());
            }
        });
        var s = schools.join(',');

        $('#entityList').val(s);

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

        /* Make sure at lease one school is checked */
        $('#entityList').val("");
        var schools = [];
        $('.selectedSchools').each(function () {
            if ($(this).is(":checked")) {
                schools.push($(this).val());
            }
        });
        var s = schools.join(',');

        $('#entityList').val(s);

        $('#action').val("save");
        $('#lastQNumAnswered').val(1);
        $("#survey").submit();
    });

});

function checkSurveyFields() {
    var errorFound = 0;

    $('div').removeClass("has-error");
    $('.alert-danger').html("");
    $('.alert-danger').hide();

    //Make sure at least one school is selcted
    if ($('#entityList').val() == "") {
        $('#errorMsg_schools').html("At least one school must be selected.");
        $('#errorMsg_schools').show();
    }

    //Look at all required fields.
    $('.required').each(function () {
        var qId = $(this).attr('rel');
        var qName = $(this).attr('rel2');
        var qType = $(this).attr('rel3');
        var requiredMsg = $('#requiredMsg' + qId).val();
        if (requiredMsg === '') {
            requiredMsg = "This is a required question.";
        }

        //Text Box || Select box
        if (qType == 3 || qType == 2 | qType == 6) {

            if ($(this).val() === '') {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html(requiredMsg);
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
        // Multiple Choice
        else if (qType == 1) {
            if ($('input[name="' + qName + '"]:checked').length == 0) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html(requiredMsg);
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }

    });

    //Look at all Email validation types
    $('.Email').each(function () {
        var qId = $(this).attr('rel');
        var emailVal = $(this).val();

        if (emailVal != '') {
            var emailValidated = validateEmail(emailVal);

            if (emailValidated === false) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid email address.');
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
    });

    //Look at all Phone Number validation types
    $('.Phone-Number').each(function () {
        var qId = $(this).attr('rel');
        var phoneVal = $(this).val();

        if (phoneVal != '') {
            var phoneValidated = validatePhone(phoneVal);

            if (phoneValidated === false) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid phone number.');
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
    });

    //Look at all numeric validation types
    $('.Numeric').each(function () {
        var qId = $(this).attr('rel');
        var fieldVal = $(this).val();

        if (fieldVal != '') {
            var fieldValidated = validateNumericValue(fieldVal);

            if (fieldValidated === false) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('The value must be numeric.');
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
    });

    //Look at all URL validation types
    $('.URL').each(function () {
        var qId = $(this).attr('rel');
        var URLVal = $(this).val();

        if (URLVal != '') {
            var URLValidated = validateURL(URLVal);

            if (URLValidated === false) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid URL.');
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
    });

    //Look at all Date validation types
    $('.Date').each(function () {
        var qId = $(this).attr('rel');
        var dateVal = $(this).val();

        if (dateVal != '') {
            var DateValidated = validateDate(dateVal);

            if (DateValidated === false) {
                $('#qNum' + qId).addClass("has-error");
                $('#errorMsg_' + qId).html('This is not a valid Date, format should be mm/dd/yyyy.');
                $('#errorMsg_' + qId).show();
                errorFound = 1;
            }
        }
    });

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
