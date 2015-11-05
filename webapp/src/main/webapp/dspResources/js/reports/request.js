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
        
        
        var mySelections = [];
       	$('#entity1Ids option').each(function(i) {
            if (this.selected == true) {
                    mySelections.push(this.value);
            }
    	});
        
        /** ajax to change entitiy2List **/
        //$('#entity1Select').change(function() { 
        $('#entity1Ids').change(function() {
        	//we refresh the dropdown with entity2Ids
            $.ajax({
                type: 'POST',
                url: "/reports/returnEntity2List.do",
                data:{'entity1Ids': mySelections}, 
                success: function(data) {
                     //$("#entity2Div").html(data);
                	$("#entity2Div").html("hello");
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }); 
   
        
        
        
    });
});