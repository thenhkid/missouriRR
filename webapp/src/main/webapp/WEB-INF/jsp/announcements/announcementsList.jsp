<%-- 
    Document   : announcementsList
    Created on : Apr 8, 2016, 10:02:42 AM
    Author     : chadmccue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="col-sm-12">
    <div class="row">
        <div class="clearfix">
            <div class="dropdown pull-left no-margin col-md-10">
                <button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Preferences
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="announcementNotificationManagerModel">Announcement Notification Preferences</a></li>
                </ul>
            </div>
            <c:if test="${allowCreate == true || allowEdit == true || allowDelete == true}">
                <div class="pull-right no-margin">
                    <a href="announcements/manage">
                    <button class="btn btn-success btn-xs" type="button" id="newTopic">
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        Manage Announcements
                    </button></a>
                </div>
            </c:if>
        </div>
    </div>
    <div class="hr dotted"></div>
    <c:if test="${not empty error}" >
        <div class="alert alert-danger" role="alert">
            The selected file was not found.
        </div>
    </c:if>
    <div class="row">
        <c:choose>
            <c:when test="${not empty announcements}">
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
            </c:when>
            <c:otherwise>
                <div class="well">There are currently no announcements.</div>
            </c:otherwise>
        </c:choose>
        
    </div>
</div>