<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="page-content" id="createEventForm" style="width:500px;padding:0;">

    <c:if test="${not empty survey.existingDocuments}">
        <div class="row">
            <div class="form-group">
                <label for="document1">Uploaded Documents</label>
                <c:forEach var="document" items="${survey.existingDocuments}">
                    <div class="input-group" id="suveyDiv_${document.id}">
                        <span class="input-group-addon">
                            <i class="fa fa-file bigger-110 orange"></i>
                        </span>
                        <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${document.documentTitle}"></input>
                        <span class="input-group-addon">
                            <a href="javascript:void(0)" class="removeAttachment" rel="${document.id}"><i class="fa fa-times bigger-110 red"></i></a>
                        </span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
    <div class="row">
        <div class="col-md-12">
            <div class="form-group">         
                <label for="document1">Documents</label>
                <div class="form-group">
                    <input  multiple="" name="surveyDocuments" type="file" id="id-input-file-2" />
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <button type="submit" class="btn btn-mini btn-primary eventSave">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
        </div>
    </div>
</div>
