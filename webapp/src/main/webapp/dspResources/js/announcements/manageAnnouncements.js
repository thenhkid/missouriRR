/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {

    $("input:text,form").attr("autocomplete", "off");

    $(document).ready(function () {
       if ($('.alert').length > 0) {
            $('.alert').delay(2000).fadeOut(1000);
       }
       
        var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                stateSave: true,
                "stateDuration": 600,
                "aoColumns": [
                    {"bSortable": false},
                    null,null,null, 
                    {"bSortable": false}
                ],
                "aaSorting": [],
                "oLanguage": {
                "sSearch": "Filter:"
                }
            });
    });
    
    $(document).on('click', '.deleteAnnouncement', function() {
       
        return confirm("Are you sure you want to remove this announcement? This action cannot be undone.");
        
    });


     $(document).on('change', '.dspOrder', function(event) {
         var id = $(this).attr('rel');
         var dspVal = $(this).val();
         
         if($.isNumeric(dspVal) && (dspVal*1) > 0) {
            $.ajax({
                url: '/announcements/saveDspOrder.do',
                type: 'POST',
                data: {
                    'announcementId': id,
                    'dspVal': dspVal
                },
                success: function (data) {
                    $('#currDspOrder_' + id).html(dspVal);
                },
                error: function (error) {

                }
            }); 
         }
         else {
             $(this).val(function() {
                return this.defaultValue;
            });
         }
     });

     $(document).on('change', '.hpdspOrder', function(event) {
         var id = $(this).attr('rel');
         var dspVal = $(this).val();
         
         if($.isNumeric(dspVal) && (dspVal*1) > 0) {
            $.ajax({
                url: '/announcements/saveHPDspOrder.do',
                type: 'POST',
                data: {
                    'announcementId': id,
                    'dspVal': dspVal
                },
                success: function (data) {
                    $('#currDspOrder_' + id).html(dspVal);
                },
                error: function (error) {

                }
            }); 
         }
         else {
             $(this).val(function() {
                return this.defaultValue;
            });
         }
     });
    
});

