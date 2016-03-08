<%-- 
    Document   : multiDocumentFiles
    Created on : Mar 7, 2016, 1:02:21 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .ellipsis {
        display: inline-block;
        overflow: hidden;
        text-overflow: ellipsis;     /** IE6+, Firefox 7+, Opera 11+, Chrome, Safari **/
        -o-text-overflow: ellipsis;  /** Opera 9 & 10 **/
        width: 200px; 
    }
</style>

<div class="page-content">
    <c:if test="${not empty documentFiles}">
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <c:forEach var="document" items="${documentFiles}">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-file bigger-110 orange"></i>
                            </span>
                            <c:choose>
                                <c:when test="${fn:length(document.uploadedFile) > 20}">
                                    <c:set var="index" value="${document.uploadedFile.lastIndexOf('.')}" />
                                    <c:set var="trimmedDocumentExtension" value="${fn:substring(document.uploadedFile,index+1,fn:length(document.uploadedFile))}" />
                                    <c:set var="trimmedDocumentTitle" value="${fn:substring(document.uploadedFile, 0, 20)}...${trimmedDocumentExtension}" />

                                    <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${trimmedDocumentTitle}"></input>
                                </c:when>
                                <c:otherwise>
                                     <c:set var="trimmedDocumentTitle" value="${document.uploadedFile}" />
                                    <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${trimmedDocumentTitle}"></input>
                                </c:otherwise>
                            </c:choose>
                            <span class="input-group-addon">
                                <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.uploadedFile}&foldername=documents/${document.downloadLink}"/>"  title="${document.documentTitle}"><i class="fa fa-download bigger-110 green"></i></a>
                            </span> 
                        </div>
                    </c:forEach>
                </div>
            </div>     
        </div> 
    </c:if>
</div>



