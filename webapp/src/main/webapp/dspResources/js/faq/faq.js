/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    $("input:text,form").attr("autocomplete", "off");
    
    var onCategory = 0;
    //set active cat so we can load up correct cat on drop down when questions are added
   
    $('.categoryNav').on('click', function () {
        onCategory = $(this).attr('rel');
    });
   
   //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }
   
    //clicking on add category link in dropdown
    $('#addCategory').on('click', function (event) {
        $.ajax({
            type: 'POST',
            url: '/faq/getCategoryForm.do',
            data:{'categoryId':0, 'toDo':'Add'},
            success: function(data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        message: data,
                        title: "Add A Category",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {

                                } 
                            },
                            success: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function() {
                                  categoryFn("add", event);
                                } 
                            },

                        }
                    });
                }
                
            }
        });
    });
  
    //clicking on add category link in dropdown
    $('.editCategory').on('click', function (event) {
        var categoryId = $(this).attr('rel');
        $.ajax({
            type: 'POST',
            url: '/faq/getCategoryForm.do',
            data:{'categoryId':categoryId, 'toDo':'Edit'},
            success: function(data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    bootbox.dialog({
                        message: data,
                        title: "Edit Category",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {

                                } 
                            },
                            success: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function() {
                                  categoryFn("edit", event);
                                } 
                            },
                            delete: {
                                label: "Delete",
                                className: "btn-danger",
                                callback: function() {
                                  //add confirm box
                                  deleteCategory ($("#id").val());
                                } 
                            },

                        }
                    });
                }
            }
        });
    });
    
    /** this function handle category, should change alert to set text on page instead.
     * too much clicking.....
     * **/
    function categoryFn(toDo, event) {
        
       if ($('#categoryName').val().trim() == "") {
            $('#categoryNameDiv').addClass("has-error");
      	    $('#categoryNameMsg').addClass("has-error");
      	    $('#categoryNameMsg').html('Category Name is required field.');
            event.preventDefault();
            return false;
        }
        var submitURL = "/faq/saveCategory.do";
        
        
        $("#categoryForm").attr("action", submitURL);
        $("#categoryForm").serialize();
        $("#categoryForm").submit();
        
    }
    
    function deleteCategory (categoryId) {
        bootbox.confirm({
            size: 'small',
            message: "Are you sure you want to delete this category?  All associated questions and documents will be deleted.",
            callback: function (result) {
                if (result == true) {
                    $("#deleteCategory").attr("action", "/faq/deleteCategory.do");
                    $("#deleteCategoryId").val(categoryId);
                    $("#deleteCategory").submit();
                }
            }
        });
     }
    /** end of category **/
    
    /** start of question **/
    //clicking on add question link in dropdown
    $('#addQuestion').on('click', function (event) {
        /** need to figure out which active category we are on **/
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
            data:{'questionId':0, 'toDo':'Add', 'onCategory':onCategory},
            success: function(data, event) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                    /* File input */
                    data.find('#id-input-file-2').ace_file_input({
                       style: 'well',
                       btn_choose: 'click to upload files',
                       btn_change: null,
                       no_icon: 'ace-icon fa fa-cloud-upload',
                       droppable: false,
                       thumbnail: 'small',
                       maxSize: 4000000,
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
                            $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 4MB.");
                            event.preventDefault();
                        }
                    });


                    bootbox.dialog({
                        message: data,
                        title: "Add an Announcement",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {

                                } 
                            },
                            success: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function() {
                                  questionFn("add", event);
                                } 
                            },

                        }
                    });
                    
                }
            }
        });
    });
  
    //clicking on add question link in dropdown
    $('.editQuestion').on('click', function (event) {
        var questionId = $(this).attr('rel');
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
            data:{'questionId':questionId, 'toDo':'Edit', 'onCategory':0},
            success: function(data) {
                
                data = $(data);
                
                //Check if the session has expired.
                if(data.find('.username').length > 0) {
                   top.location.href = '/login?expired';
                }
                else {
                   /* File input */
                    data.find('#id-input-file-2').ace_file_input({
                       style: 'well',
                       btn_choose: 'click to upload files',
                       btn_change: null,
                       no_icon: 'ace-icon fa fa-cloud-upload',
                       droppable: false,
                       thumbnail: 'small',
                       maxSize: 4000000,
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
                            $('#docMsg').html("There were files attached that exceed the maximum file size.<br />Files must be less than 4MB.");
                            event.preventDefault();
                        }
                    });

                    bootbox.dialog({

                        message: data,
                        title: "Edit Announcement",
                        buttons: {
                            cancel: {
                                label: "Cancel",
                                className: "btn-default",
                                callback: function() {

                                } 
                            },
                            success: {
                                label: "Save",
                                className: "btn-primary",
                                callback: function() {
                                  questionFn("edit", event);
                                } 
                            },
                            delete: {
                                label: "Delete",
                                className: "btn-danger",
                                callback: function() {
                                  //add confirm box
                                  //questionFn("delete", event); 
                                  deleteQuestion ($("#id").val());
                                } 
                            },

                        }
                    }); 
                    
                }
                  
            }
        });
    });
    
    function deleteQuestion (questionId) {
        bootbox.confirm({
            size: 'small',
            message: "Are you sure you want to delete this question?  All associated documents will be deleted.",
            callback: function (result) {
                if (result == true) {
                    $("#deleteQuestion").attr("action", "/faq/deleteQuestion.do");
                    $("#deleteQuestionId").val(questionId);
                    $("#deleteQuestion").submit();
                }
            }
        });
     }
    function questionFn(toDo, event) {
       /** make sure there is a category**/
       var error = 0;
        /** make sure there is a question**/
       if ($('#question').val().trim() == "") {
            $('#questionDiv').addClass("has-error");
      	    $('#questionMsg').addClass("has-error");
      	    $('#questionMsg').html('Question is required field.');
            error ++;
        }
        
        /*if ($('#answer').val().trim() == "") {
            $('#answerDiv').addClass("has-error");
      	    $('#answerMsg').addClass("has-error");
      	    $('#answerMsg').html('Answer is required field.');
            error ++;
        }*/
        
        if (error > 0) {
            event.preventDefault();
            return false;
        }
        
        var submitURL = "/faq/saveQuestion.do";
        $("#questionForm").attr("action", submitURL);
        $("#questionForm").submit();
        
    }
    
    
    function questionRefreshFn() {
        
        var formData = $("#questionForm").serialize();
       
        var submitURL = "/faq/refreshQ.do";
        $("#questionForm").attr("action", submitURL);
        $("#questionForm").submit();
        
    }
    
    /** end of editing questions **/

    
});