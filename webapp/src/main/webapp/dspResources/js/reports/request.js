/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {

    	var startDate = new Date('09/02/2013');
    	var toEndDate = new Date();
    	
        $("input:text,form").attr("autocomplete", "off");
        var errorMsg = "You must select at least 1 ";
        
         $(function(){
         $('.date-picker').datepicker({
        	 //format: 'yyyy-mm-dd',
        	 format: 'mm/dd/yyyy',
	         autoclose: true,
	         todayHighlight: true,
	         endDate:toEndDate,
	         startDate:startDate
         })
         //show datepicker when clicking on the icon
         .next().on(ace.click_event, function () {
         $(this).prev().focus();
         });
         });
         
         
       //we need to keep checking date picker
         $('.date-picker').change(function (event) {
        	 clearErrors (0);
         }); 
         
        //changing a report type
        $('#reportTypeId').change(function (event) {
        	clearErrors (0);
            event.preventDefault();
            var reportTypeId = $('#reportTypeId').val();
            var entity1ListSize = $('#entity1ListSize').val();
            
            
            $.ajax({
                type: 'POST',
                url: "/reports/availableReports.do",
                data: {'reportTypeId': reportTypeId,
                	'entity1ListSize': entity1ListSize
                },
                
                success: function (data) {
                    $("#reportDiv").html(data);
            		$("#entity1Div").hide();
                    $("#entity2Div").hide();
                    $("#entity3Div").hide();
                    $("#criteriaDiv").hide(); 
                    if (reportTypeId == 3) {
                    	$('#submitRepButton').show();
                    	$('#showEntity1RepButton').hide();
                    } else {
                    	 $('#showEntity1RepButton').show();
                    	 $('#submitRepButton').hide();
                    }
                },
                error: function (error) {
                    console.log(error);
                }
            });
        });
        
        //end of ajax calls
    });
});

/** this function needs to clear by reportId as some reports have different criteria **/

function clearErrors (reportId) {
	
	$('#startDateDiv').removeClass('has-error');
	$('#errorMsg_startDate').html("");
	
	$('#endDateDiv').removeClass('has-error');
	$('#errorMsg_endDate').html("");
	
	$('#reportIdDiv').removeClass('has-error');
	$('#errorMsg_reports').html("");
	
	$('#entity1Div').removeClass('has-error');
    $('#errorMsg_entity1').html("");
	 
	$('#entity2Div').removeClass('has-error');
	$('#errorMsg_entity2').html("");
	
	$('#entity3Div').removeClass('has-error');
	$('#errorMsg_entity3').html("");
	
	$('#criteriaDiv').removeClass('has-error');
	$('#errorMsg_criteria').html("");
	
	//depending on report selected we clear errors too
	
}

function checkReports() {
	if ($('#reportIds').val() == null) {
	        $('#reportIdDiv').addClass('has-error');
	        $('#errorMsg_reports').html("Please select at least one report");
	        return 1;
	} else  {
		return 0;
	}
}

function checkEntity1 () {
	if ($('#entity1Ids').val() == null) {
        $('#entity1Div').addClass('has-error');
        $('#errorMsg_entity1').html("Please select at least one value.");
        return 1;
	} else  {
		return 0;
	}	
}

function checkEntity2 () {
	if ($('#entity2Ids').val() == null) {
        $('#entity2Div').addClass('has-error');
        $('#errorMsg_entity2').html("Please select at least one value.");
        return 1;
	} else  {
		return 0;
	}
}

function checkEntity3 () {
	if ($('#entity3Ids').val() == null) {
        $('#entity3Div').addClass('has-error');
        $('#errorMsg_entity3').html("Please select at least one value.");
        return 1;
	} else  {
		return 0;
	}
}

function checkCriteria () {
	if ($('#criteriaValues').val() == null) {
        $('#criteriaDiv').addClass('has-error');
        $('#errorMsg_criteria').html("Please select at least one value.");
        return 1;
	} else  {
		return 0;
	}
}



function checkDates() {
	var errors = 0;
	
	var DateValidated = validateDate($('#startDate').val());

	if (DateValidated === false) {
        $('#errorMsg_startDate').addClass("has-error");
        $('#errorMsg_startDate').html('The start date is not valid, format should be mm/dd/yyyy.');
        $('#errorMsg_startDate').show();
        errors++;
    }
    
    //Check end date
    var DateValidated = validateDate($('#endDate').val());

    if (DateValidated === false) {
        $('#errorMsg_endDate').addClass("has-error");
        $('#errorMsg_endDate').html('This end date is not valid, format should be mm/dd/yyyy.');
        $('#errorMsg_endDate').show();
        errors++;
    }
    
    return errors;
	
	
}


function validateDateOld($date) {

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

}