<%-- 
    Document   : surveyDocuments
    Created on : Mar 10, 2016, 9:24:33 PM
    Author     : chadmccue
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="row">
    
    <c:if test="${not empty message}" >
        <div class="col-md-12">
            <div class="alert alert-success" role="alert">
                <strong>Success!</strong> 
                The file(s) have been successfully uploaded.
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty surveyDocuments}">
        <div class="col-md-12">
            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                       Relevant Documents
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main">
                        <div class="form-container">
                            <c:set var="docCounter" value="0" scope="page"/>
                            <c:forEach var="documentDetails" items="${surveyDocuments}" varStatus="loop">
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
                                <c:choose>
                                    <c:when test="${not empty uploadedPaths && documentDetails.documentId == 0}">
                                        <div class="space-8"></div>
                                    </c:when>
                                    <c:when test="${not empty uploadedPaths && !loop.last && (documentDetails.documentId > 0 && documentDetails.documentId != surveyDocuments[loop.index+1].documentId)}">
                                        <div class="alert alert-warning smaller" role="alert">
                                           <strong>The above file(s) have also been uploaded to: </strong>${uploadedPaths[docCounter][1]} 
                                       </div>
                                       <c:set var="docCounter" value="${docCounter + 1}" scope="page"/>
                                    </c:when> 
                                    <c:when test="${not empty uploadedPaths && loop.last && uploadedPaths[docCounter][0] > 0}">
                                        <div class="alert alert-warning smaller" role="alert">
                                            <strong>The above file(s) have also been uploaded to: </strong>${uploadedPaths[docCounter][1]} 
                                        </div>
                                    </c:when>    
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            <div class="space-20 hr hr-dotted"></div>
        </div>
    </c:if>
    
    <form:form id="surveyDocForm" role="form" class="form" method="post" enctype="multipart/form-data">
        <input type="hidden" id="otherFolder" name="otherFolder" value="0" />
        <div class="col-md-12">
            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                        Upload <c:if test="${not empty surveyDocuments}">More</c:if> Documents
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main">
                        <div class="form-container">
                            <div class="form-group" id="docDiv"> 
                                <div class="form-group">
                                    <input  multiple="" name="surveyDocuments" type="file" id="id-input-file-2" />
                                    <span id="docMsg" class="control-label"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="space-20 hr hr-dotted"></div>
        </div>
        <div class="col-md-12">
            <div class="col-md-6">
                <div class="widget-box">
                    <div class="widget-header widget-header-blue widget-header-flat">
                        <h4 class="smaller">
                           Also save the files to:
                        </h4>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main scrollable">
                            <ul id="tree1"></ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="widget-box">
                    <div class="widget-header widget-header-blue widget-header-flat">
                      <h4 class="smaller">Document Details:</h4>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main scrollable">
                            <div class="form-group" id="titleDiv">
                                <label  class="control-label" for="title">Document Title</label>
                                <input type="text" name="title" class="form-control" value="" id="title" maxlength="255" />
                                <span id="titleMsg" class="control-label"></span>  
                            </div>
                            <div class="form-group" id="docDescDiv">
                                <label  class="control-label" for="message">Document Description</label>
                                <textarea name="docDesc" class="form-control" id="docDesc" rows="3"></textarea>
                                <span id="docDescMsg" class="control-label"></span>  
                            </div>
                        </div>
                    </div>
                 </div> 
            </div>
        </div>
        <div class="col-md-12">
            <div class="space-10 hr hr-dotted"></div>
            <div class="pull-right">
                <button type="button" class="btn btn-primary" id="uploadDocuments">
                    <i class="ace-icon fa fa-save bigger-120 white"></i>
                    Upload Document(s)
                </button>
            </div>
        </div>
    </form:form>
        <div class="col-md-12">
            <div class="space-10"></div>
            <div class="pull-right">
                <a href="<c:url value="/surveys?i=${i}&v=${v}" />">
                <button class="btn">Return to Activity Log</button>
                </a><div class="pull-right" style="padding-left:10px">
                <form method="POST" action="/surveys/startSurvey?i=${i}&v=${v}">
                    <input type="hidden" name="selectedEntities" value="${selectedEntities}" />
                    <button class="btn btn-success">Add another Entry</button>
                </form></div>
            </div>
        </div>
</div>
