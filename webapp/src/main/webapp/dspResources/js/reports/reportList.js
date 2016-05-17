/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
        $("input:text,form").attr("autocomplete", "off");


        var oTable1 = $('#dynamic-table').dataTable({
             bAutoWidth: false,
              "pageLength": 25,
             "aoColumns": [
                null, null, null, null,null, null, null, {"bSortable": false}
             ],
             "aaSorting": [],
                    "oLanguage": {
                    "sSearch": "Filter:"
                    }
         });

        
        
        $('.deleteReport').click(function() { 
            // need to confirm
            var reportRequestId = $(this).attr('rel');
            var reli = $(this).attr('reli');
            var relv = $(this).attr('relv');
            
            bootbox.confirm({
                size: 'small',
                message: "Are you sure you want to delete this report?",
                callback: function (result) {
                    if (result == true) {
                        $.ajax({
                            type: 'POST',
                            url: "/reports/deleteReportRequest.do",
                            data:{
	                            'reli': reli, 
	                            'relv': relv},
	                            success: function (data) {
	                                $('#reportRow_'+reportRequestId).remove();
	                            },
	                            error: function (error) {
	                                console.log(error);
	                            }
                        });
                    }
                }
            });   
        }); 
        
        
        
        
    });
});