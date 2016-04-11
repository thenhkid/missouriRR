/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
    	/**Buttons on this page
    	 * showEntity2Div1Button
    	 * changeEntity1Button
    	 * **/
    	
    	//users click this button after selecting tier 1, we query tier 2 belongs to those tier 1s
        $('#showEntity2Div1Button').click(function (event) {
            event.preventDefault();
            clearErrors (0);
            var errors = checkDates();
            errors = errors + checkReports();
            errors = errors + checkEntity1();
            
            if (errors > 0) {  
            	return false;
            } else {
            	
            	var selectedEntity1s = [];
	            $('#entity1Ids :selected').each(function (i, selected) {
	            	selectedEntity1s[i] = $(selected).val();
	            });
	            selectedEntity1s = selectedEntity1s.join(", ");
	            $.ajax({
	                type: 'POST',
	                url: "/reports/returnEntityList.do",
	                data: {'entityIds': selectedEntity1s,
	                		'tier':1
	                	},
	                success: function (data) {
	                	data = $(data);
	                	if($(data).find('entity2DivId')) {
	                		$("#changeEntity1Button").hide();
	                		$("#changeRepButton").show();
	                		$("#entity1Div").show();
	                		$("#entity2Div").html(data);
	                		$("#entity2Div").show();
	                		$("#showEntity1RepButton").hide();
	                		$("#showEntity2Div1Button").hide();
	                		$("#showEntity2RepButton").hide();
	                		$("#showEntity3Div2Button").show();
	                		$("#changeEntity1Button").show();
	                		$('#reportIds').prop('disabled', 'disabled');
	                		$('#entity1Ids').prop('disabled', 'disabled');
	                     }
	                },
	                error: function (error) {
	                    console.log(error);
	                }
	            
	            });
            }  
          
        });
        /** end of showEntity2Div1Button from entity1Div page **/
        
        
        /** this button let user reselect tier 1 **/
        $('#changeEntity1Button').click(function (event) {
        	$("#entity2Div").hide();
        	$("#entity3Div").hide();
        	$("#criteriaDiv").hide();
        	//change the button
        	$("#changeEntity1Button").hide();
        	$("#showEntity2Div1Button").show();
        	$("#entity1Ids").removeAttr("disabled"); 	
        });
        
    	
    	
    });
});
	
