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
        
        getProviderItems();
        getProviderServices();
        
        $('#saveDetails').click(function(event) {
            var errorsFound = 0;
            $('#action').val('save');
            
            errorsFound = checkFormFields();

            if (errorsFound == 0) {
               $("#providerDetails").submit();
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
               $("#providerDetails").submit();
            }
            else {
                $('.alert-danger').show();
                $('.alert-danger').delay(2000).fadeOut(1000);
            }

        });
        
        //Open the new association modal
        $('#associateNewHierarchy').click(function() {
           
            $.ajax({
                url: '/hierarchy/getProviderAssocItems',
                type: "GET",
                data: {'providerId': $(this).attr('rel')},
                success: function(data) {
                    $("#newAssocModal").html(data);
                }
            });
        });
        
        //Button to submit the hierarchy item changes
        $(document).on('click','#submitItemAssoc', function(event) {
           
            var providerId = $('#associateNewHierarchy').attr('rel');
           
            $.ajax({
                url: '/hierarchy/saveProviderAssocItem',
                data: {'providerId': providerId, 'items': "'" + $('#selItems').val()  + "'"},
                type: "POST",
                async: false,
                success: function(data) {
                    
                    getProviderItems();
                    $("#newAssocModal").modal('hide');

                    $('.assocSuccess').html('<strong>Success!</strong> The selected item has been associated to the provider!');
                    $('.assocSuccess').show();
                    $('.alert').delay(2000).fadeOut(1000);
                }
            });
            event.preventDefault();
            return false;
        });
        
        
        //Button to remove the selected hierarchy Item
        $(document).on('click', '.deleteAssoc', function() {
            var itemId = $(this).attr('rel');
            
            var confirmClick = confirm("Are you sure you want to remove this association?");
            
            if(confirmClick) {
                $.ajax({
                    url: '/hierarchy/removeProviderAssocItem',
                    data: {'itemId': itemId},
                    type: "POST",
                    async: false,
                    success: function(data) {

                        getProviderItems();

                        $('.assocSuccess').html('<strong>Success!</strong> The selected item has been removed!');
                        $('.assocSuccess').show();
                        $('.alert').delay(2000).fadeOut(1000);
                    }
                });
            }
            
        });
        
        //Open the new association modal
        $('#associateNewService').click(function() {
            
            var providerId = $(this).attr('rel');
           
            $.ajax({
                url: '/hierarchy/getAvailableServices',
                type: "GET",
                data: {'providerId': providerId},
                success: function(data) {
                    $("#newAssocModal").html(data);
                }
            });
        });
        
        //Button to submit the provider services
        $(document).on('click','#submitServiceAssoc', function(event) {
            
            if($('#selItems').val() == null) {
                $('#serviceDiv').addClass("has-error");
                $('#serviceMsg').addClass("has-error");
                $('#serviceMsg').html('A service must be selected!');
            }
            else {
                var formData = $("#assocItemForm").serialize();
            
                $.ajax({
                    url: '/hierarchy/saveProviderServices',
                    data: formData,
                    type: "POST",
                    async: false,
                    success: function(data) {

                        getProviderServices();
                        $("#newAssocModal").modal('hide');

                        $('.assocSuccess').html('<strong>Success!</strong> The selected service has been associated to the provider!');
                        $('.assocSuccess').show();
                        $('.alert').delay(2000).fadeOut(1000);
                    }
                });
            }
           
            event.preventDefault();
            return false;
        });
        
        //Button to remove the selected service
        $(document).on('click', '.deleteService', function() {
            var serviceId = $(this).attr('rel');
            
            var providerId = $('#associateNewHierarchy').attr('rel');
            
            var confirmClick = confirm("Are you sure you want to remove this service?");
            
            if(confirmClick) {
                $.ajax({
                    url: '/hierarchy/removeProviderService',
                    data: {'serviceId': serviceId, 'providerId': providerId},
                    type: "POST",
                    async: false,
                    success: function(data) {

                        getProviderServices();

                        $('.assocSuccess').html('<strong>Success!</strong> The selected service has been removed!');
                        $('.assocSuccess').show();
                        $('.alert').delay(2000).fadeOut(1000);
                    }
                });
            }
            
        });
        
    });
});


function getProviderItems() {
    
    var providerId = $('#associateNewHierarchy').attr('rel');
    
    $.ajax({
        url: '/hierarchy/getExistingProviderAssocItems',
        data: {'providerId': providerId},
        type: "GET",
        async: false,
        success: function(data) {
            $("#providerAssocTable").html(data);
        }
    });
    
}

function getProviderServices() {
    
    var providerId = $('#associateNewHierarchy').attr('rel');
    
    $.ajax({
        url: '/hierarchy/getExistingProviderServices',
        data: {'providerId': providerId},
        type: "GET",
        async: false,
        success: function(data) {
            $("#providerServices").html(data);
        }
    });
}

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