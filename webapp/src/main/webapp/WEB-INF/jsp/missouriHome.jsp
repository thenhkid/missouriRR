<%-- 
    Document   : missouriHome
    Created on : Aug 18, 2015, 8:15:46 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:if test="${not empty error}" >
    <div class="alert alert-danger" role="alert">
        The selected file was not found.
    </div>
</c:if>

<c:if test="${not empty announcements}">
    <div class="row">
        <div class="col-xs-12">	
            <div class="widget-box transparent" >
                <div class="widget-header widget-header-small">
                    <h4 class="widget-title blue smaller">
                        <i class="ace-icon fa fa-bullhorn orange"></i>
                        Recent Announcements
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main padding-8">
                        <div>
                            <c:forEach items="${announcements}" var="announcement">
                                <div class="profile-activity clearfix">
                                    <c:choose>
                                        <c:when test="${empty announcement.answer}">
                                            ${announcement.question}
                                        </c:when>
                                        <c:otherwise>
                                            ${announcement.answer}
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty announcement.faqQuestionDocuments}">
                                        <div>
                                            <h6><strong>Documents</strong></h6>
                                            <c:forEach var="document" items="${announcement.faqQuestionDocuments}">
                                                <div class="clearfix">
                                                    <i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.documentTitle}&foldername=faqUploadedFiles"/>" title="${document.documentTitle}">${document.documentTitle}</a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>

<div class="row">
    <div class="col-xs-5 center">
        <img src="../../dspResources/images/HSHC_Circles.png" style="max-width: 100%; max-height: 100%;" alt=""/>
    </div>
    <div class="col-xs-7 center">
        <img src="../../dspResources/images/HSHC_Map_2015-16.jpg" style="max-width: 100%; max-height: 100%;"  alt=""/>
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