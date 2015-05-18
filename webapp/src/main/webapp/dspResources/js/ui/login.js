/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function($) {
    
    $("input:text,form").attr("autocomplete", "off");
    
    $('#retrievePasswordMsg').hide();
    
    $(document).on('click', '.toolbar a[data-target]', function(e) {
       e.preventDefault();
       var target = $(this).data('target');
       $('.widget-box.visible').removeClass('visible');//hide others
       $(target).addClass('visible');//show target
    });
    
    $('.sendPasswordEmail').click(function() {
        $('#passwordFound').hide();
        $('#passwordNotFound').hide();
        $.ajax({
          url: '/forgotPassword.do',
          type: "Post",
          data: {'identifier': $('#email').val()},
          success: function(data) {
              $('#retrievePasswordMsg').show();
              if(data > 0) {
                  $('#passwordFound').show();
                  $.ajax({
                    url: '/sendPassword.do',
                    type: "Post",
                    data: {'userId': data}
                  });
              }
              else {
                  $('#passwordNotFound').show();
              }
          }
      });
   });
})