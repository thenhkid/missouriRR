/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
    	/**
    	 * showEntity3Div2Button
    	 * changeEntity2Button
    	 * **/
    	
    	//users click this button after selecting tier 1, we query tier 2 belongs to those tier 1s
        $('#showEntity3Div2Button').click(function (event) {
        	event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            errors = errors + checkEntity1();
            errors = errors + checkEntity2();
            
            if (errors > 0) {  
            	return false;
            } else {
            	
            	var selectedReportIds = [];
	            $('#reportIds :selected').each(function (i, selected) {
	            	selectedReportIds[i] = $(selected).val();
	            });
	            selectedReportIds = selectedReportIds.join(", ");
            	
            	var selectedEntity2s = [];
	            $('#entity2Ids :selected').each(function (i, selected) {
	            	selectedEntity2s[i] = $(selected).val();
	            });
	            selectedEntity2s = selectedEntity2s.join(", ");
	            $.ajax({
	                type: 'POST',
	                url: "/reports/returnEntityList.do",
	                data: {'entityIds': selectedEntity2s,
	                		'tier':2,
	                		'reportIds': selectedReportIds,
	                	},
	                success: function (data) {
	                	data = $(data);
	                	if($(data).find('entity3DivId')) {
	                		
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
	                		$("#entity3Div").html(data);
	                		$("#entity3Div").show();
	                		$("#showCriteriaDiv3Button").show();
	                		
	                     }
	                },
	                error: function (error) {
	                    console.log(error);
	                }
	            
	            });
            }  
          
        });
        /** end of showEntity3Div2Button from entity1Div page **/
        /** this button let user reselect tier 1 **/
        $('#changeEntity2Button').click(function (event) {
        	$("#entity3Div").hide();
        	$("#criteriaDiv").hide();
        	
        	//change the button
        	$("#changeEntity2Button").hide();
        	$("#showEntity3Div2Button").show();
        	$("#entity2Ids").removeAttr("disabled"); 	
        });
        
        
        
        
    	
    	
    });
});
	
