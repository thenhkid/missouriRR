/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {


    $(document).ready(function () {
        
        $("input:text,form").attr("autocomplete", "off");

        $(function(){
            $('.datepicker').datepicker({
               format: 'mm-dd-yyyy',
               autoclose: true,
               todayHighlight: true
             });
        });
        
    });
});