/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {
   
        var myTable = $('#reportDisplay').DataTable( {
            "aaSorting": [[0, 'asc'], [1,'asc'], [5,'asc']]
        });
        
        $.fn.dataTable.Buttons.swfPath = "/dspResources/js/dataTables/extensions/buttons/swf/flashExport.swf"; 
        $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

        new $.fn.dataTable.Buttons( myTable, {
                buttons: [
                  {
                    "extend": "print",
                    "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                    "className": "btn btn-white btn-primary btn-bold",
                    autoPrint: true,
                    message: ''
                  }/*,
                  {
                    "extend": "csv",
                    "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                    "className": "btn btn-white btn-primary btn-bold",
                    "title": "participantExport"
                  },
                  {
                    "extend": "excel",
                    "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                    "className": "btn btn-white btn-primary btn-bold",
                    "title": "participantExport"
                  }*/
                ]
        } );
        myTable.buttons().container().appendTo( $('.tableTools-container') );
        
        
        
});


