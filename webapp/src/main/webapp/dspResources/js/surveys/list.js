/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    
    /* Populate the district drop down */
    $.ajax({
        url: '/districts/getDistrictList.do',
        data: {'surveyId': $('#surveyId').val()},
        type: "GET",
        success: function (data) {
            $('#districtList').html(data);
            
             $('.multiselect').multiselect({
                enableFiltering: true,
                buttonClass: 'btn btn-white btn-primary',
                enableClickableOptGroups: true,
                enableCaseInsensitiveFiltering: true,
                disableIfEmpty: true,
                nonSelectedText: 'Select your Districts / CBO',
                numberDisplayed: 2,
                templates: {
                    button: '<button type="button" class="multiselect dropdown-toggle" data-toggle="dropdown"></button>',
                    ul: '<ul class="multiselect-container dropdown-menu"></ul>',
                    filter: '<li class="multiselect-item filter"><div class="input-group"><span class="input-group-addon"><i class="fa fa-search"></i></span><input class="form-control multiselect-search" type="text"></div></li>',
                    filterClearBtn: '<span class="input-group-btn"><button class="btn btn-default btn-white btn-grey multiselect-clear-filter" type="button"><i class="fa fa-times-circle red2"></i></button></span>',
                    li: '<li><a href="javascript:void(0);"><label></label></a></li>',
                    divider: '<li class="multiselect-item divider"></li>',
                    liGroup: '<li class="multiselect-item group"><label class="multiselect-group" style="padding-left:5px; font-weight:bold;"></label></li>'
                }
            });
        }
    });
    
    /* Submit the district selection */
    $(document).on('click', '#createNewEntry', function () {
        
        if($('.multiselect').val() != null) {
            $('#districtSelectForm').submit();
        }
        else {
            $.gritter.add({
                    title: 'Missing District!',
                    text: 'Please select at least one district to start a survey.',
                    class_name: 'gritter-error gritter-light'
            });
        }

    });


    //initiate dataTables plugin
    var oTable1 =
            $('#dynamic-table')
            .dataTable({
                bAutoWidth: false,
                "aoColumns": [
                    null, null, null, null,
                    {"bSortable": false},
                    {"bSortable": false}
                ],
                "aaSorting": []
            });
 


    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }
    
    //Delete Survey
    $(document).on('click', '.deleteSurvey', function() {
        
        var confirmed = confirm("Are you sure you want to remove this activity log?");

        if (confirmed) {
            $.ajax({
                type: 'POST',
                url: '/surveys/removeEntry.do',
                data: {'i': $(this).attr('rel')},
                success: function (data) {
                   location.reload();
                }
            });
        }
    });

    
});