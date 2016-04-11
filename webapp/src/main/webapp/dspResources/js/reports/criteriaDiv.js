/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        //criteriaDivSubmitButton
    	//submit form here
        $('#criteriaDivSubmitButton').click(function (event) {
        	
        	//check our fields
        	event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            errors = errors + checkEntity1();
            errors = errors + checkEntity2();
            errors = errors + checkEntity3();
            errors = errors + checkEntity3();
            errors = errors + checkCriteria ();
            
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
                
                var selectedCriterias = [];
                $('#criteriaValues :selected').each(function (i, selected) {
                	selectedCriterias[i] = $(selected).val().trim();
                });

                selectedCriterias = selectedCriterias.join(",");
                
                
                $("#startDateForm").val($('#startDate').val());
                $("#endDateForm").val($('#endDate').val());
                $("#entity3IdsForm").val(selectednumbers);
                $("#reportIdsForm").val(selectedreports);
                $("#reportTypeIdForm").val($('#reportTypeId').val());
                $("#codeIdsForm").val(selectedCriterias);
                
                
                $("#requestForm").submit();
               
            }
        	
        });
    	
    	
    	
    });
});
	
