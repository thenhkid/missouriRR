/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


jQuery(function ($) {
    $("input:text,form").attr("autocomplete", "off");
        
    //clicking on add category link in dropdown
    $('#addCategory').on('click', function (event) {
        $.ajax({
            type: 'POST',
            url: '/faq/getCategoryForm.do',
            data:{'categoryId':0, 'toDo':'Add'},
            success: function(data, event) {
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
                              categoryFn("delete", event);
                            } 
                        },
                        
                    }
                });
            }
        });
    });
    
    /** this function handle category, should change alert to set text on page instead.
     * too much clicking.....
     * **/
    function categoryFn(toDo, event) {
        
        var formData = $("#categoryForm").serialize();
        /** make sure there is a category**/
       if ($('#categoryName').val().trim() == "") {
            $('#categoryNameDiv').addClass("has-error");
      	    $('#categoryNameMsg').addClass("has-error");
      	    $('#categoryNameMsg').html('Category Name is required field.');
            event.preventDefault();
            return false;
        }
        var submitURL = "/faq/saveCategory.do";
        if (toDo == 'delete') {
           submitURL = "/faq/deleteCategory.do";
        }
        
        $("#categoryForm").attr("action", submitURL);
        $("#categoryForm").submit();
        
    }
    /** end of category **/
    
    /** start of question **/
    //clicking on add question link in dropdown
    $('#addQuestion').on('click', function (event) {
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
            data:{'questionId':0, 'toDo':'Add'},
            success: function(data, event) {
                bootbox.dialog({
                    message: data,
                    title: "Add A Question",
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
        });
    });
  
    //clicking on add question link in dropdown
    $('.editQuestion').on('click', function (event) {
        var questionId = $(this).attr('rel');
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
            data:{'questionId':questionId, 'toDo':'Edit'},
            success: function(data) {
                bootbox.dialog({
                    message: data,
                    title: "Edit Question",
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
                              questionFn("delete", event);
                            } 
                        },
                        
                    }
                });
            }
        });
    });
    
    
    
    function questionFn(toDo, event) {
        
       var formData = $("#questionForm").serialize();
        /** make sure there is a category**/
       var error = 0;
        /** make sure there is a category**/
       if ($('#question').val().trim() == "") {
            $('#questionDiv').addClass("has-error");
      	    $('#questionMsg').addClass("has-error");
      	    $('#questionMsg').html('Question is required field.');
            error ++;
        }
        
        if ($('#answer').val().trim() == "") {
            $('#answerDiv').addClass("has-error");
      	    $('#answerMsg').addClass("has-error");
      	    $('#answerMsg').html('Answer is required field.');
            error ++;
        }
        
        if (error > 0) {
            event.preventDefault();
            return false;
        }
        
        var submitURL = "/faq/saveQuestion.do";
        if (toDo == 'delete') {
           submitURL = "/faq/deleteQuestion.do";
        }
        
        $("#questionForm").attr("action", submitURL);
        $("#questionForm").submit();
        
    }
    
    /** end of editing questions **/

    
});