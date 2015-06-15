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
                        success: {
                            label: "Add",
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
    $('.editCategory').on('click', function () {
        var categoryId = $(this).attr('rel');
        $.ajax({
            type: 'POST',
            url: '/faq/getCategoryForm.do',
            data:{'categoryId':categoryId, 'toDo':'Edit'},
            success: function(data) {
                bootbox.dialog({
                    message: data,
                    title: "Edit Category",
                    buttons: {
                        success: {
                            label: "Edit",
                            className: "btn-primary",
                            callback: function() {
                              categoryFn("edit");
                            } 
                        },
                        delete: {
                            label: "Delete",
                            className: "btn-danger",
                            callback: function() {
                              //add confirm box
                              categoryFn("delete");
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
        $.ajax({
            type: 'POST',
            url: submitURL,
            data:formData, // need to replace
            
            success: function(data) {
                var responseData = ("Category Added");
                //TODO 
                /** need to make sure we have some sort of status messages **/
                if (data == "2"){
                    responseData = ("Category Edited");
                } else if (data == "3"){
                    responseData = ("Category Deleted");
                }
                //TODO this should refresh the correct cat, q, or document div
                window.location.replace("/faq");  
            }
        });
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
                        success: {
                            label: "Add",
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
    $('.editQuestion').on('click', function () {
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
                        success: {
                            label: "Edit",
                            className: "btn-primary",
                            callback: function() {
                              questionFn("edit");
                            } 
                        },
                        delete: {
                            label: "Delete",
                            className: "btn-danger",
                            callback: function() {
                              //add confirm box
                              questionFn("delete");
                            } 
                        },
                    }
                });
            }
        });
    });
    
    /** this function handle question, should change alert to set text on page instead.
     * too much clicking.....
     * **/
    function questionFn(toDo, event) {
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
        
        var formData = $("#questionForm").serialize();
        var submitURL = "/faq/saveQuestion.do";
        if (toDo == 'delete') {
           submitURL = "/faq/deleteQuestion.do";
        }
        $.ajax({
            type: 'POST',
            url: submitURL,
            data:formData, // need to replace
            
            success: function(data) {
                var responseData = ("Question Added");
                //TODO 
                /** need to make sure we have some sort of status messages **/
                if (data == "2"){
                    responseData = ("Question Edited");
                } else if (data == "3"){
                    responseData = ("Question Deleted");
                }
                //TODO this should refresh the correct cat, q, or document div
                window.location.replace("/faq");  
            }
        });
    }
    
});