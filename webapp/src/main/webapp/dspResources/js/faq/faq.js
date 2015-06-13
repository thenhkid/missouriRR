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
    
    //clicking on add question link in dropdown
    $('#addQuestion').on('click', function () {
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
            success: function(data) {
                bootbox.dialog({
                    message: data,
                    title: "Add A Question",
                    buttons: {
                        success: {
                            label: "Add",
                            className: "btn-primary",
                            callback: function() {
                              questionFn("add");
                            } 
                        },
                    }
                });
            }
        });
    });
  
    //clicking on add category link in dropdown
    $('.editQuestion').on('click', function () {
        $.ajax({
            type: 'POST',
            url: '/faq/getQuestionForm.do',
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
    
    //clicking on add document link in dropdown
    $('#addDocument').on('click', function () {
        $.ajax({
            type: 'POST',
            url: '/faq/getDocumentForm.do',
            success: function(data) {
                bootbox.dialog({
                    message: data,
                    title: "Add A Document",
                    buttons: {
                        success: {
                            label: "Add",
                            className: "btn-primary",
                            callback: function() {
                              documentFn("add");
                            } 
                        },
                    }
                });
            }
        });
    });
  
    //clicking on add category link in dropdown
    $('.editDocument').on('click', function () {
        $.ajax({
            type: 'POST',
            url: '/faq/getDocumentForm.do',
            success: function(data) {
                bootbox.dialog({
                    message: data,
                    title: "Edit Document",
                    buttons: {
                        success: {
                            label: "Edit",
                            className: "btn-primary",
                            callback: function() {
                              documentFn("edit");
                            } 
                        },
                        delete: {
                            label: "Delete",
                            className: "btn-danger",
                            callback: function() {
                              //add confirm box
                              documentFn("delete");
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
        var submitURL = "/faq/addCategory.do";
        if (toDo == 'edit') {
           submitURL = "/faq/addCategory.do";
        } else if (toDo == 'delete') {
           submitURL = "/faq/deleteCategory.do";
        }
        $.ajax({
            type: 'POST',
            url: submitURL,
            data:formData, // need to replace
            
            success: function(data) {
                var responseData = ("Category Added");
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
    
  
    /** this function uses ajax to handle questions, need to submit question object **/
    function questionFn(toDo) {
        var submitURL = "/faq/addQuestion.do";
        if (toDo == 'edit') {
           submitURL = "/faq/editQuestion.do";
        } else if (toDo == 'delete') {
           submitURL = "/faq/deleteQuestion.do";
        }
        $.ajax({
            type: 'POST',
            url: submitURL,
            data:{'questionId':'1'}, // need to replace
            
            success: function(data) {
                var responseData = ("Added " + data);
                if (data == "2") {
                  responseData = ("Edit " + data); 
                } else if (data == "3"){
                   responseData = ("Deleted " + data);
                } 
                    bootbox.alert(responseData, function() {
                });
                 
            }
        });
    }
    
    /** this function uses ajax to handle documents, need to submit document object **/
    function documentFn(toDo) {
        var submitURL = "/faq/addDocument.do";
        if (toDo == 'edit') {
           submitURL = "/faq/editDocument.do";
        } else if (toDo == 'delete') {
           submitURL = "/faq/deleteDocument.do";
        }
        $.ajax({
            type: 'POST',
            url: submitURL,
            data:{'documentId':'1'}, // need to replace
            
            success: function(data) {
                var responseData = ("Added " + data);
                if (data == "2") {
                  responseData = ("Edit " + data); 
                } else if (data == "3"){
                   responseData = ("Deleted " + data);
                } 
                    bootbox.alert(responseData, function() {
                });
                 
            }
        });
    }
    
    
});