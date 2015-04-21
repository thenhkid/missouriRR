/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



require(['./main'], function () {
    require(['jquery'], function($) {

        //Fade out the updated/created message after being displayed.
        if ($('.alert').length > 0) {
            $('.alert').delay(2000).fadeOut(1000);
        }
        
        $("input:text,form").attr("autocomplete", "off");
        
        $('#saveDetails').click(function(event) {
            var errorsFound = 0;
            $('#action').val('save');
            
            errorsFound = checkFormFields();

            if (errorsFound == 0) {
               $("#engagmentdetails").submit();
            }
            else {
                $('.alert-danger').show();
                $('.alert-danger').delay(2000).fadeOut(1000);
            }
        });

        $('#saveCloseDetails').click(function(event) {
            var errorsFound = 0;
            $('#action').val('close');
            
             errorsFound = checkFormFields();

            if (errorsFound == 0) {
               $("#engagmentdetails").submit();
            }
            else {
                $('.alert-danger').show();
                $('.alert-danger').delay(2000).fadeOut(1000);
            }

        });
        
        //Show the modification field modal
        $('.modified').click(function(event) {
            
            var fieldId = $(this).attr('rel');
            var engagementId = $(this).attr('rel2');
            
            $.ajax({
                url: 'getFieldModifications',
                type: "GET",
                data: {'fieldId': fieldId, 'engagementId': engagementId},
                success: function(data) {
                    $("#modifiedModal").html(data);
                }
            });
            
        });
        
        
        //Modify the visity type field
        $(document).on('change', '.visitType', function() {
           var fieldId = $(this).attr('rel');
           
           $('#'+fieldId).val($(this).val());
        });
        
    });
 });
 
 function checkFormFields() {
    var errorFound = 0;

    $('div').removeClass("has-error");
    $('span.has-error').html("");

    //Look at all required fields.
    $('.required').each(function() {
        var fieldId = $(this).attr('id');

        if ($(this).val() === '') {
            $('#fieldDiv_' + fieldId).addClass("has-error");
            $('#errorMsg_' + fieldId).addClass("has-error");
            $('#errorMsg_' + fieldId).html('This is a required field.');
            errorFound = 1;
        }
    });

    //Look at all Email validation types
    $('.Email').each(function() {
        var fieldId = $(this).attr('id');
        var emailVal = $(this).val();

        if (emailVal != '') {
            var emailValidated = validateEmail(emailVal);

            if (emailValidated === false) {
                $('#fieldDiv_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).html('This is not a valid email address.');
                errorFound = 1;
            }
        }
    });

    //Look at all Phone Number validation types
    $('.Phone-Number').each(function() {
        var fieldId = $(this).attr('id');
        var phoneVal = $(this).val();

        if (phoneVal != '') {
            var phoneValidated = validatePhone(phoneVal);

            if (phoneValidated === false) {
                $('#fieldDiv_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).html('This is not a valid phone number.');
                errorFound = 1;
            }
        }
    });

    //Look at all numeric validation types
    $('.Numeric').each(function() {
        var fieldId = $(this).attr('id');
        var fieldVal = $(this).val();

        if (fieldVal != '') {
            var fieldValidated = validateNumericValue(fieldVal);

            if (fieldValidated === false) {
                $('#fieldDiv_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).html('The value must be numeric.');
                errorFound = 1;
            }
        }
    });

    //Look at all URL validation types
    $('.URL').each(function() {
        var fieldId = $(this).attr('id');
        var URLVal = $(this).val();

        if (URLVal != '') {
            var URLValidated = validateURL(URLVal);

            if (URLValidated === false) {
                $('#fieldDiv_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).html('This is not a valid URL.');
                errorFound = 1;
            }
        }
    });

    //Look at all Date validation types
    $('.Date').each(function() {
        var fieldId = $(this).attr('id');
        var dateVal = $(this).val();

        if (dateVal != '') {
            var DateValidated = validateDate(dateVal);

            if (DateValidated === false) {
                $('#fieldDiv_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).addClass("has-error");
                $('#errorMsg_' + fieldId).html('This is not a valid Date, format should be mm/dd/yyyy.');
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
    
    if($fieldVal.indexOf("/") != -1) {
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
    //var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
    var rxDatePattern = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/;
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

}