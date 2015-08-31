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

    <c:if test="${not empty surveyDocuments}">
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <label for="document1">Uploaded Files</label>
                    <c:forEach var="documentDetails" items="${surveyDocuments}">
                         <div class="input-group" id="docDiv_${documentDetails.id}">
                            <span class="input-group-addon">
                                <c:choose>
                                    <c:when test="${documentDetails.fileExt == 'pdf'}"><i class="fa fa-file-pdf-o bigger-110 orange"></i></c:when>
                                    <c:when test="${documentDetails.fileExt == 'doc' || documentDetails.fileExt == 'docx'}"><i class="fa fa-file-word-o bigger-110 orange"></i></c:when>
                                    <c:when test="${documentDetails.fileExt == 'xls' || documentDetails.fileExt == 'xlsx'}"><i class="fa fa-file-excel-o bigger-110 orange"></i></c:when>
                                    <c:when test="${documentDetails.fileExt == 'txt'}"><i class="fa fa-file-text-o bigger-110 orange"></i></c:when>
                                    <c:when test="${documentDetails.fileExt == 'jpg' || documentDetails.fileExt == 'gif' || documentDetails.fileExt == 'jpeg'}"><i class="fa fa-file-image-o bigger-110 orange"></i></c:when>
                                </c:choose>
                            </span>
                            <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${documentDetails.uploadedFile}" placeholder="${documentDetails.uploadedFile}"></input>
                            <span class="input-group-addon">
                                <a href="<c:url value="/FileDownload/downloadFile.do?filename=${documentDetails.uploadedFile}&foldername=surveyUploadedFiles"/>" title="Download File"  rel="${documentDetails.id}"><i class="fa fa-download bigger-110 blue"></i></a>
                            </span>
                            <span class="input-group-addon">
                                <a href="javascript:void(0)" class="deleteDocument" title="Delete File" rel="${documentDetails.id}"><i class="fa fa-times bigger-110 red"></i></a>
                            </span>
                         </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="row"><hr></div>
    </c:if>
    <form:form id="surveyDocForm" role="form" class="form" method="post" enctype="multipart/form-data">
        <input type="hidden" name="surveyId" value="${surveyId}" />
        <input type="hidden" name="completed" value="0" />
        <div class="row">
            <div class="col-md-12">
                <div class="form-group" id="docDiv"> 
                    <div class="form-group">
                        <input  multiple="" name="surveyDocuments" type="file" id="id-input-file-2" />
                        <span id="docMsg" class="control-label"></span>
                    </div>
                </div>
            </div>
        </div>
    </form:form>
</div>
