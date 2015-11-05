/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
        $("input:text,form").attr("autocomplete", "off");

        $(function(){
        	$('.date-picker').datepicker({
                autoclose: true,
                todayHighlight: true
            })
            //show datepicker when clicking on the icon
               .next().on(ace.click_event, function () {
               $(this).prev().focus();
            });
        });
        
        
        
        
        /** ajax to change entitiy2List **/
        $('#showEntity2').click(function(event) {
        	event.preventDefault();
        	/**a - we disable entity1
        	 * b - we get data and show entity2
        	 * c - we change button to say Change
        	**/
           
        	$('#entity1Ids').prop('disabled', 'disabled');
        	$('#entity2Div').show();
        	$('#changeEntity1').show();
        	$('#showEntity2').hide();
        	 
        	 var selectednumbers = [];
             $('#entity1Ids :selected').each(function(i, selected) {
                 selectednumbers[i] = $(selected).val();
             });
        	 
             selectednumbers = selectednumbers.join(", ");
        	 
             $.ajax({
                type: 'POST',
                url: "/reports/returnEntityList.do",
                data:{'entityIds':selectednumbers,
                	'tier':1},
                success: function(data) {
                     $("#entity2Div").html(data);
                },
                error: function (error) {
                    console.log(error);
                }
            });  
        });
        
        $('#showEntity2').click(function(event) {
        	event.preventDefault();
        	/**a - we disable entity1
        	 * b - we get data and show entity2
        	 * c - we change button to say Change
        	**/
           
        	$('#entity1Ids').prop('disabled', 'disabled');
        	$('#entity2Div').show();
        	$('#changeEntity1').show();
        	$('#showEntity2').hide();
        	
            	$.ajax({
                type: 'POST',
                url: "/reports/returnEntity2List.do",
                data:{'entity1Ids': mySelections}, 
                success: function(data) {
                     $("#entity2Div").html(data);
                	//$("#entity2Div").html("hello");
                },
                error: function (error) {
                    console.log(error);
                }
            });
           
        }); 
        
        $('#changeEntity1').click(function(event) {
        	event.preventDefault();
        	/**a - we disable entity1
        	 * b - we get data and show entity2
        	 * c - we change button to say Change
        	**/
           
        	$("#entity1Ids").removeAttr("disabled");
        	$('#entity2Div').hide();
        	$('#changeEntity1').hide();
        	$('#showEntity2').show();
        	/**
            	$.ajax({
                type: 'POST',
                url: "/reports/returnEntity2List.do",
                data:{'entity1Ids': mySelections}, 
                success: function(data) {
                     $("#entity2Div").html(data);
                	//$("#entity2Div").html("hello");
                },
                error: function (error) {
                    console.log(error);
                }
            });
            **/
        });
        
        
        
    });
});