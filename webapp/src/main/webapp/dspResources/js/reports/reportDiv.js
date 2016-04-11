/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {

    	//after selecting a report, users have the choice to show entity1 or entity2
        $('#showEntity1RepButton').click(function (event) {
            event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            if (errors > 0) {  
            	return false;
            } else {
            	//reset entity1 
            	$('#entity1Ids').removeAttr("disabled");
            	$("#showEntity2RepButton").show();
            	$("#showEntity2Div1Button").show();            	
            	$("#changeEntity1Button").hide();
            	$("#entity1Div").show();
        		$("#changeRepButton").show();
        		$("#showEntity2RepButton").hide();
        		$("#showEntity1RepButton").hide();
        		$('#reportIds').prop('disabled', 'disabled');
        		
        		
            }           
        });
        /** end of showEntity1 button **/
        
        //after selecting a report, this shows user entity2
        $('#showEntity2RepButton').click(function (event) {
            event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            
            if (errors > 0) {  
            	return false;
            } else {
            	$('#entity2Ids').removeAttr("disabled");
            	$('#showEntity3Div2Button').show();           	
            	$("#entity2Div").show();
            	$("#entity1Div").hide();
        		$("#changeRepButton").show();
        		$("#showEntity2RepButton").hide();
        		$("#showEntity1RepButton").hide();
        		$('#reportIds').prop('disabled', 'disabled');
        		$('#entity1Ids').removeAttr("disabled");
        		
        		
            }
            //if report brings back different lay out, we adjust here
        });
        /** end of showEntity2 for reportDiv button **/

        
        /** changeRepButton is clicked **/
        $('#changeRepButton').click(function (event) {
            event.preventDefault();
            clearErrors (0);
            checkDates();
            //need to hide 
            $("#entity1Div").hide();
            $("#entity2Div").hide();
            $("#entity3Div").hide();
            $("#criteriaDiv").hide();
            $("#changeRepButton").hide();
            
            //release report button
            $("#reportIds").removeAttr("disabled");
            //show the buttons back
            var entity1ListSize = $('#entity1ListSize').val();
            $("#showEntity1RepButton").show();
                   
        });
        
        /** submit button for report 15 **/

        $('#submitRepButton').click(function (event) {
        	
        	//check our fields
        	event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            var reportTypeId = $('#reportTypeId').val();
            if (reportTypeId != 3) {
            	$('#errorMsg_reports').html("Please change report type");
            }
            
            if (errors > 0) {  
            	return false;
            } else {
            	
                var selectedreports = [];
                $('#reportIds :selected').each(function (i, selected) {
                    selectedreports[i] = $(selected).val();
                });

                selectedreports = selectedreports.join(", ");
                
                
                $("#startDateForm").val($('#startDate').val());
                $("#endDateForm").val($('#endDate').val());
                $("#reportIdsForm").val(selectedreports);
                $("#reportTypeIdForm").val($('#reportTypeId').val());
                
                
                $("#requestForm").submit();
               
            }
        	
        });
        
        	
    });
});
	
