<%-- 
    Document   : exportDownloadModal
    Created on : Jul 7, 2015, 11:02:30 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="page-content">
    <div class="row">
        <c:choose>
            <c:when test="${not empty exportFileName}">
                <i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${reportFileName}&foldername=reports"/>" title="${reportFileName}">${reportFileName}</a>
            </c:when>
        </c:choose>
    </div>
</div>

