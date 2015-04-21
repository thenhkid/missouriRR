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
        
        searchClients('');

        $("input:text,form").attr("autocomplete", "off");
        
        //Search button
        $(document).on('click', '#submitButton', function() {
            var fieldList = $('#fieldList').val();
            
            var fieldSearchList = "";
            $.each(fieldList.split(':'), function() {
                if(this != '') {
                   fieldSearchList+=this+":"+$('#'+this).val()+"|"; 
                }
            });
            
            searchClients(fieldSearchList);
            
        })
        
        //Clear search fields
        $(document).on('click', '#clearButton', function() {
           $('#clear').val('yes');
           $('#searchForm').submit();
       });
       
       //Engagement entry
       $(document).on('click', '#newPatientViaEngagement', function() {
          
          var clientNumber = "";
          
          //Loop through the search fields to find a patient Id field
          $('.form-control').each(function() {
            if($(this).attr('rel') == 'sourcePatientId') {
                clientNumber = $(this).val();
            }
          });
          
          // if not found or patient id field is empty ask for one
          if(clientNumber == "" || !$.isNumeric(clientNumber)) {
              
              $.ajax({
                url: 'clients/newClientNumberForm',
                data: {'msg': ""},
                type: "GET",
                success: function(data) {
                    $("#newClientNumber").modal('show');
                    $("#newClientNumber").html(data);
                }
            });
          }
          
          //Else make sure the patient doesn't already exist
          else {
             $.ajax({
                url: 'clients/checkForExistingClient',
                data: {'clientNumber':clientNumber},
                type: "POST",
                success: function(data) {
                    if(data == 1) {
                        var msg = "The client number " + clientNumber + " already exists.";
                        
                        $.ajax({
                            url: 'clients/newClientNumberForm',
                            data: {'msg': msg},
                            type: "GET",
                            success: function(data) {
                                $("#newClientNumber").modal('show');
                                $("#newClientNumber").html(data);
                            }
                        });
                    }
                    else {
                        showEngagementForm(clientNumber);
                    }
                }
            });
          }
           
       });
       
       //Enter the new client number
       $(document).on('click', '#saveNewClientNumber', function() {
            
            var clientNumber = $('#clientNumber').val();
            
            // if not found or patient id field is empty ask for one
          if(clientNumber == "" || !$.isNumeric(clientNumber)) {
              var msg = "Please enter a valid numeric client number.";
              $.ajax({
                url: 'clients/newClientNumberForm',
                 data: {'msg': msg},
                type: "GET",
                success: function(data) {
                    $("#newClientNumber").modal('show');
                    $("#newClientNumber").html(data);
                }
            });
          }
          else {
            
            $.ajax({
                url: 'clients/checkForExistingClient',
                data: {'clientNumber':clientNumber},
                type: "POST",
                success: function(data) {
                    if(data == 1) {
                        var msg = "The client number " + clientNumber + " already exists.";
                        
                        $.ajax({
                            url: 'clients/newClientNumberForm',
                            data: {'msg': msg},
                            type: "GET",
                            success: function(data) {
                                $("#newClientNumber").modal('show');
                                $("#newClientNumber").html(data);
                            }
                        });
                    }
                    else {
                        showEngagementForm(clientNumber);
                    }
                }
            });
        }
            
       });
        
    });
});

function showEngagementForm(clientNumber) {
   
    $.ajax({
        url: 'clients/createClientByEngagement',
        data: {'clientNumber': clientNumber},
        type: "POST",
        success: function(data) {
            window.location.href = "clients/engagements/details?"+data;
        }
    });
   
}

function searchClients(searchString) {
    
    if(searchString == '') {
        var fieldList = $('#fieldList').val();
        
        searchString = "";
        if(fieldList) {
            $.each(fieldList.split(':'), function() {
                if(this != '') {
                   searchString+=this+":"+$('#'+this).val()+"|"; 
                }
            });
        }
    }
    
    $.ajax({
        url: 'clients/getClientList',
        data: {'searchString':searchString},
        type: "GET",
        success: function(data) {
            $('#clientList').html(data);
        }
   }); 
}