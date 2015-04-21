<%-- 
    Document   : uploadForm
    Created on : Jan 21, 2014, 11:15:37 AM
    Author     : chadmccue
--%>

<head>
    <meta http-equiv="Content-Language" content="en">
</head>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Upload Import File</h3>
        </div>
        <div class="modal-body">
            <form:form id="fileUploadForm" action="/import-export/submitFileUpload" enctype="multipart/form-data" method="post" role="form">
                <input type="hidden" name="importTypeId" value="${importTypeDetails.id}" />
                <div class="form-group">
                    Upload your CSV file for the <label>${importTypeDetails.name}</label>
                </div>
                <div id="uploadedFileDiv" class="form-group ${status.error ? 'has-error' : '' }">
                    <label for="uploadedFile">File *</label>
                    <input id="uploadedFile" name="uploadedFile" class="form-control" type="file" />
                    <span id="uploadedFileMsg" class="control-label"></span>
                </div>

                <div class="form-group">
                    <input class="btn btn-primary btn-sm" id="submitFileImport" type="submit" value="Upload"/>
                    <a data-dismiss="modal" class="btn btn-secondary btn-sm" data-toggle="tab">
                        Cancel
                    </a>
                </div>
           </form:form>
        </div>
    </div>
</div>
