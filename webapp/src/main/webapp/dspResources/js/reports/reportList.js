/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
        $("input:text,form").attr("autocomplete", "off");
        
        
        $('.deleteReport').click(function() { 
            // need to confirm
            var reportRequestId = $(this).attr('rel');
            bootbox.confirm({
                size: 'small',
                message: "Are you sure you want to delete this report?",
                callback: function (result) {
                    if (result == true) {
                        $.ajax({
                            type: 'POST',
                            url: "/reports/deleteReportRequest.do",
                            data:{'reportRequestId': reportRequestId}, 
                            success: function (data) {
                                $('#reportRow_'+reportRequestId).remove();
                                //$("#documentListDiv").html(data);
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