<%-- 
    Document   : completedSurvey
    Created on : Mar 11, 2015, 8:58:34 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="main clearfix" role="main">
    <div class="col-md-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h4>Completed Activity Log</h4>
            </div>
            <div class="panel-body pageQuestionsPanel">
                You have completed the ${surveyDetails.title} activity log.
                <div class="space-12"></div>
                <div class="hr hr-dotted hr-16"></div>
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
                                        <c:choose>
                                            <c:when test="${documentDetails.shortenedTitle != ''}">
                                                <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${documentDetails.uploadedFile}" placeholder="${documentDetails.shortenedTitle}"></input>
                                            </c:when>
                                            <c:otherwise>
                                                <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${documentDetails.uploadedFile}" placeholder="${documentDetails.uploadedFile}"></input>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="input-group-addon">
                                            <a href="<c:url value="/FileDownload/downloadFile.do?filename=${documentDetails.encodedTitle}&foldername=surveyUploadedFiles"/>" title="Download File"  rel="${documentDetails.id}"><i class="fa fa-download bigger-110 blue"></i></a>
                                        </span>
                                        <span class="input-group-addon">
                                            <a href="javascript:void(0)" class="deleteDocument" title="Delete File" rel="${documentDetails.id}"><i class="fa fa-times bigger-110 red"></i></a>
                                        </span>
                                     </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>
                <div class="col-sm-12">
                    <form:form id="surveyDocForm" role="form" class="form" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="surveyId" value="${submittedSurveyId}" />
                        <input type="hidden" name="completed" value="1" />
                        <input type="hidden" name="selectedEntities" value="${selectedEntities}" />
                        <div class="form-group">         
                            <label for="document1">Survey Files</label>
                            <div class="form-group">
                                <input  multiple="" name="surveyDocuments" type="file" id="id-input-file-2" />
                            </div>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="col-sm-4">
            <div>
                <div class="pull-left">
                    <a href="<c:url value="/surveys?i=${i}&v=${v}" />"><button class="btn">Return to Activity Log</button></a>
                </div>
                <div class="pull-right">
                    <form method="POST" action="/surveys/startSurvey?i=${i}&v=${v}">
                        <input type="hidden" name="selectedEntities" value="${selectedEntities}" />
                        <button class="btn btn-success">Add another Entry</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

