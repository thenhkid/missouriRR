/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function ($) {

    /* File input */
    $('.pageQuestionsPanel').find('#id-input-file-2').ace_file_input({
        style: 'well',
        btn_choose: 'click to upload the document',
        btn_change: null,
        no_icon: 'ace-icon fa fa-cloud-upload',
        droppable: false,
        thumbnail: 'small',
        allowExt: ['pdf', 'txt', 'doc', 'docx', 'gif', 'png', 'jpg', 'jpeg', 'xls', 'xlsx'],
        before_remove: function () {
            return true;
        }
    });

});