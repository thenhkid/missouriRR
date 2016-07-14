<%-- 
    Document   : missouriHome
    Created on : Aug 18, 2015, 8:15:46 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${not empty announcements}">
    <h2>Announcements</h2>
    <div class="col-sm-12">
        <c:if test="${not empty error}" >
            <div class="alert alert-danger" role="alert">
                The selected file was not found.
            </div>
        </c:if>
        <div class="row">
            <c:forEach var="announcement" items="${announcements}">
            <div class="well">
                <c:if test="${not empty announcement.announcementTitle}"><h4 class="green smaller lighter bolder">${announcement.announcementTitle}</h4></c:if>
                <h4 class="grey smaller-90 bolder"><fmt:formatDate pattern="MMM d, yyyy" value="${announcement.dateCreated}" /></h4>
                ${announcement.announcement}
                <c:if test="${not empty announcement.documents}">
                    <div class="space-10"></div>
                    <div class="row">
                        <div class="col-sm-6">
                            <h6>Relevant Documents</h6>
                             <c:forEach var="document" items="${announcement.documents}">
                                <div class="clearfix">
                                    <i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.encodedTitle}&foldername=announcementUploadedFiles"/>" title="${document.documentTitle}">
                                        <c:choose><c:when test="${not empty document.documentTitle}">${document.documentTitle}</c:when><c:otherwise>${document.uploadedFile}</c:otherwise></c:choose>
                                    </a>
                                </div>
                             </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
            </c:forEach>
        </div>
    </div>
</c:if>

<div class="row">
    <div class="col-xs-7 center">
        <img src="../../dspResources/images/HSHC_Map_2015-16.jpg" style="max-width: 100%; max-height: 100%;" alt=""/>
    </div>
    <div class="col-xs-5 center">
        <img src="../../dspResources/images/HSHC_Circles.png" style="max-width: 100%; max-height: 100%;" alt=""/>
    </div>
</div>
<div class="row">
    <div class="col-xs-12">
        <p>Grantees: To share an event, program, or meeting, please add the activity to the Calendar page. To share materials, please add them to one of the public folders available to you under the Documents tab. To share thoughts, questions, or comments with other grantees, please use the Forum page.</p>
    </div>
</div>

<script>
 jQuery(function ($) {
    
    //Fade out the updated/created message after being displayed.
    if ($('.alert').length > 0) {
        $('.alert').delay(2000).fadeOut(1000);
    }
});
</script>