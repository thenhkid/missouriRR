/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    
     $(document).ready(function() {
        
         //Fade out the updated/created message after being displayed.
        if ($('.alert-success').length > 0) {
            $('.alert-success').delay(2000).fadeOut(1000);
        }
        
        $('#id-input-file-2').ace_file_input({
            style: 'well',
            btn_choose: 'click to upload files',
            btn_change: null,
            no_icon: 'ace-icon fa fa-cloud-upload',
            droppable: false,
            thumbnail: 'small',
            maxSize: 8000000,
            allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx', 'ppt', 'csv', 'pptx', 'wma', 'zip', 'mp3', 'mp4', 'm4a'],
            before_remove: function () {
                return true;
            },
           before_change: function() {
               $('span').removeClass("has-error");
               $('div').removeClass("has-error");
               $('#docMsg').html("");
               return true;
           }
        }).on('file.error.ace', function(event, info) {
            if(info.error_count['ext'] > 0) {
                $('#docDiv').addClass("has-error");
                $('#docMsg').addClass("has-error");
                $('#docMsg').html("There were files attached that have an invalid file extension.<br />Valid File Extension:<br /> pdf, txt, doc, docx, gif, png, jpg, jpeg, xls, xlsx, csv, ppt, pptx, wma, zip, mp3, mp4, m4a");
                event.preventDefault();
            }
            else if(info.error_count['size'] > 0) {
                $('#docDiv').addClass("has-error");
                $('#docMsg').addClass("has-error");
                $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 8MB.");
                event.preventDefault();
            }
        });
    
        $('#tree1').ace_tree({
            dataSource: availableFolders,
            loadingHTML:'<div class="tree-loading"><i class="ace-icon fa fa-refresh fa-spin blue"></i></div>',
            'open-icon' : 'ace-icon fa fa-folder-open green',
            'close-icon' : 'ace-icon fa fa-folder green',
            'itemSelect' : true,
            'folderSelect': true,
            'multiSelect': false,
            'selected-icon' : null,
            'unselected-icon' : null,
            'folder-open-icon' : 'ace-icon tree-plus',
            'folder-close-icon' : 'ace-icon tree-minus'
        });

        $('#tree1').on('selected.fu.tree', function (event, data) {
            if(data.selected[0].readOnly === false) {
                $('#otherFolder').val(data.selected[0].id);
            }
            else {
                $('#tree1').trigger('deselected.fu.tree');
            }
        });

        $('#tree1').on('deselected.fu.tree', function (event, data) {
            $('.tree-item').removeClass("tree-selected");
            $('.tree-branch').removeClass("tree-selected");
            $('#otherFolder').val(0);
        });
        
        $(document).on('click', '#uploadDocuments', function(event) {
            
            $('span').removeClass("has-error");
            $('div').removeClass("has-error");
            $('#titleMsg').html("");
            $('#docMsg').html("");

            var errorFound = false;

            if($('#otherFolder').val() === "") {
                $('#otherFolder').val(0);
            }
            if($('#documentId').val() === "") {
                $('#documentId').val(0);
            }

            /** Make sure either a document is uploaded or an external link is provided **/
            if($('#id-input-file-2').val().trim() === "") {
                $('#docDiv').addClass("has-error");
                $('#webLinkDiv').addClass("has-error");
                $('#docMsg').addClass("has-error");
                $('#docMsg').html('At least one file must be uploaded.');
                errorFound = true;
            }

            /* Check to see if the document details are displayed */
            if($('#otherFolder').val() > 0) {
                if($('#title').val() === "") {
                    $('#titleDiv').addClass("has-error");
                    $('#titleMsg').addClass("has-error");
                    $('#titleMsg').html('The document title is required.');
                    errorFound = true;
                }
                if($('#docDesc').val() === "") {
                    $('#docDescDiv').addClass("has-error");
                    $('#docDescMsg').addClass("has-error");
                    $('#docDescMsg').html('The document description is required.');
                    errorFound = true;
                }
            }

            if(errorFound == true) {
                event.preventDefault();
                return false;
            }
            else {
                
                 var box = bootbox.dialog({
                    message: "<i class='fa fa-upload bigger-210 white'></i><span class='bigger-210 white' style='padding-left:10px;'>Uploading...</span>",
                    closeButton: false,
                    size: "small"
                 });

                box.find('.modal-content').css({'background-color': '#CBCBCB'}); 
                
                setTimeout( function () { 
                   $("#surveyDocForm").submit();
                }, 300);
            }

        });
        
        /* Remove existing document */
        $(document).on('click', '.deleteDocument', function () {

            var confirmed = confirm("Are you sure you want to remove this file?");

            if (confirmed) {
                var docId = $(this).attr('rel');
                $.ajax({
                    url: '/surveys/deleteDocument.do',
                    type: 'POST',
                    data: {
                        'documentId': docId
                    },
                    success: function (data) {
                        $('#docDiv_' + docId).remove();
                    },
                    error: function (error) {

                    }
                });
            }

        });
         
     });
     
});


$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}

function availableFolders(openedParentData, callback) {
    
  var selFolderId = openedParentData.id;
  
  if(!selFolderId) {
      selFolderId = "0";
  }
  
  //Call API to get available folders
  $.ajax({
       url: '/documents/getAvailableFoldersForTree.do',
       type: 'post',
       data: {'folderId': selFolderId},
       dataType: 'json'
  }).done(function(data) {
     if(data.data.length == 0) {
         $('#folderList').hide();
     }
     else {
        callback(data);
     }
  });
  
}	
	
