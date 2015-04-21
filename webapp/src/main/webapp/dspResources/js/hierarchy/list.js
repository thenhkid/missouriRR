/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

require(['./main'], function () {
    require(['jquery'], function($) {

        //Fade out the updated/created message after being displayed.
        if ($('.alert').length > 0) {
            $('.alert').delay(2000).fadeOut(1000);
        }
        
        hierarchyItems(0);

        //Clear search fields
       $(document).on('click', '.hierarchyMenu', function() {
           $('.nav-stacked li').removeClass();
           
           if($(this).attr('rel') == 'providers') {
               loadProviders();
           }
           else {
               hierarchyItems($(this).attr('rel'));
           }
           
           $(this).parent().addClass("active");
       });
       
       $(document).on('click','#newHierarchyItem', function() {
            var itemId = 0;
            var hierarchyId = $(this).attr('rel');
            
            $.ajax({
                url: 'hierarchy/getHierarchyItemDetails',
                type: "GET",
                data: {'hierarchyId': hierarchyId, 'itemId': itemId},
                success: function(data) {
                    $("#itemFormModal").html(data);
                }
            });
       });
       
       //Show the modification field modal
       $(document).on('click', '.editItem', function() {
            
            var itemId = $(this).attr('rel');
            var hierarchyId = $(this).attr('rel2');
            
            $.ajax({
                url: 'hierarchy/getHierarchyItemDetails',
                type: "GET",
                data: {'hierarchyId': hierarchyId, 'itemId': itemId},
                success: function(data) {
                    $("#itemFormModal").html(data);
                }
            });
            
        });
        
        //Button to submit the hierarchy item changes
        $(document).on('click','#submitButton', function(event) {
            var formData = $("#hierarchyItemdetailsform").serialize();
            
            var hierarchyId = $('#hierarchyId').val();

            $.ajax({
                url: 'hierarchy/saveHierarchyItem',
                data: formData,
                type: "POST",
                async: false,
                success: function(data) {
                    
                    hierarchyItems(hierarchyId);
                    $("#itemFormModal").modal('hide');

                    if (data.indexOf('itemUpdated') != -1) {
                        $('.itemSuccess').html('<strong>Success!</strong> The hierarchy item has been successfully updated!');
                    }
                    else if (data.indexOf('itemCreated') != -1) {
                        $('.itemSuccess').html('<strong>Success!</strong> The hierarchy item has been successfully created!');
                    }
                    
                    $('.itemSuccess').show();
                    $('.alert').delay(2000).fadeOut(1000);
                }
            });
            event.preventDefault();
            return false;
        });
        
        
        //Click to launch the edit provider form
        $(document).on('click', '#editProvider', function(event) {
            var providerId = $(this).attr('rel');
            
            $.ajax({
                url: 'hierarchy/getProviderDetails',
                type: "GET",
                data: {'providerId': providerId},
                success: function(data) {
                    $("#itemFormModal").html(data);
                }
            });
        });
        
        
        //Click to launch the edit provider form
        $(document).on('click', '#newProvider', function(event) {
            
            $.ajax({
                url: 'hierarchy/newProvider',
                type: "GET",
                success: function(data) {
                    $("#itemFormModal").html(data);
                }
            });
        });
        
        
        //Button to submit the provider form
        $(document).on('click','#submitProviderButton', function(event) {
            var formData = $("#providerdetailsform").serialize();
            
            $.ajax({
                url: 'hierarchy/saveNewProvider',
                data: formData,
                type: "POST",
                async: false,
                success: function(data) {
                    //send to the provider details page
                    if (data.indexOf('?i=') != -1) {
                        var url = $(data).find('#encryptedURL').val();
                        window.location.href = "hierarchy/provider/details"+url;
                    }
                    else {
                        $("#itemFormModal").html(data);
                    }
                }
            });
            event.preventDefault();
            return false;
        });
       
        
    });
});

function loadProviders() {
    $.ajax({
        url: 'hierarchy/getProviders',
        type: "GET",
        success: function(data) {
            
            $('.section-title').html("Providers");
            $('.panel-title').html("Providers");
            $('#newHierarchyItem').html('<span class="glyphicon glyphicon-plus-sign icon-stacked"></span> Create New Provider');
            
            $('.newItem').attr('id', 'newProvider');
            $('#hierarchyItemList').html(data);
        }
   }); 
}

function hierarchyItems(selId) {
    
    $.ajax({
        url: 'hierarchy/gethierarchyItemList',
        data: {'hierarchyId':selId},
        type: "GET",
        success: function(data) {
            
            var hierarchyName = $(data).filter(".hierarchyName").html();
            
            $('.section-title').html(hierarchyName+"s");
            $('.panel-title').html(hierarchyName+"s");
            $('#newHierarchyItem').html('<span class="glyphicon glyphicon-plus-sign icon-stacked"></span> Create New ' + hierarchyName);
            
            if(selId > 0) {
                $('.newItem').attr('id', 'newHierarchyItem');
                $('.newItem').attr('rel', selId);
            }
            
            $('#hierarchyItemList').html(data);
        }
   }); 
}