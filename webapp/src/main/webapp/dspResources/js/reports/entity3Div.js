/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
    	/**
    	 * changeEntity3Button
    	 * showCriteriaDiv3Button
    	 * requestReportDiv3Button
    	 * **/
    	
    	//users click this button after selecting tier 1, we query tier 2 belongs to those tier 1s
        $('#showCriteriaDiv3Button').click(function (event) {
            event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            errors = errors + checkEntity1();
            errors = errors + checkEntity2();
            errors = errors + checkEntity3();
            
            if (errors > 0) {  
            	return false;
            } else {
            	//need reportId
            	var selectedEntity3s = [];
	            $('#entity3Ids :selected').each(function (i, selected) {
	            	selectedEntity3s[i] = $(selected).val();
	            });
	            selectedEntity3s = selectedEntity3s.join(", ");
	            
	            var selectedReportIds = [];
	            $('#reportIds :selected').each(function (i, selected) {
	            	selectedReportIds[i] = $(selected).val();
	            });
	            selectedReportIds = selectedReportIds.join(", ");
	            
	            var startDate = $('#startDate').val();
	            var endDate = $('#endDate').val();
	            
	            $.ajax({
	                type: 'POST',
	                url: "/reports/getCodeList.do",
	                data: {'entity3Ids': selectedEntity3s,
	                	   'reportIds': selectedReportIds,
	                	   'startDate': startDate,
	                	   'endDate': endDate 
	                	},
	                success: function (data) {
	                	data = $(data);
		                if($(data).find('criteriaDivId')) {	
	                		//report div
	                		$("#changeRepButton").show();
	                		$("#showEntity1RepButton").hide();
	                		$("#showEntity2RepButton").hide();
	                		$('#reportIds').prop('disabled', 'disabled');
	                		
	                		//div 1
	                		$("#entity1Div").show();
	                		$('#entity1Ids').prop('disabled', 'disabled');
	                		$("#changeEntity1Button").show();
	                		$("#showEntity2Div1Button").hide();
	                		
	                		//div 2
	                		$("#entity2Div").show();
	                		$('#entity2Ids').prop('disabled', 'disabled');
	                		$("#changeEntity2Button").show();
	                		$("#showEntity3Div2Button").hide();
	                		
	                		//div 3
	                		$("#entity3Div").show();
	                		$('#entity3Ids').prop('disabled', 'disabled');
	                		$("#changeEntity3Button").show();
	                		$("#showEntity3Div2Button").hide();
	                		$("#requestReportDiv3Button").hide();
	                		
	                		//show criteria
	                		$("#criteriaDiv").show();
	                		$("#criteriaDiv").html(data);
	                		$("#showCriteriaDiv3Button").hide();
	                		
	                     }
	                },
	                error: function (error) {
	                    console.log(error);
	                }
	            
	            });
            }  
          
        });
        /** end of showEntity3Div2Button from entity1Div page **/
        
        /** this button only shows up if there is a criteria, currently only report 36 **/
        $('#changeEntity3Button').click(function (event) {
        	$("#criteriaDiv").hide();
        	
        	//change the button
        	$("#changeEntity3Button").hide();
        	$("#showEntity3Div2Button").hide();
        	$("#entity3Ids").removeAttr("disabled");
        	$("#showCriteriaDiv3Button").show();
        });
        
        //submit form here
        $('#requestReportDiv3Button').click(function (event) {
        	
        	$("#criteriaDiv").hide();
        	//check our fields
        	event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            errors = errors + checkEntity1();
            errors = errors + checkEntity2();
            errors = errors + checkEntity3();
            
            if (errors > 0) {  
            	return false;
            } else {
            	//need
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

               
                $("#startDateForm").val($('#startDate').val());
                $("#endDateForm").val($('#endDate').val());
                $("#entity3IdsForm").val(selectednumbers);
                $("#reportIdsForm").val(selectedreports);
                $("#reportTypeIdForm").val($('#reportTypeId').val());
                
                
                var reportIdSelected = $('#reportIds').val();
                
                $("#requestForm").submit();
               
            }
        	
        });

    
    });
});
	
