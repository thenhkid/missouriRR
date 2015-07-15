<%-- 
    Document   : eventDetailsModal
    Created on : Jun 2, 2015, 10:55:11 AM
    Author     : Jim
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .ellipsis {
        display: inline-block;
        //white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;     /** IE6+, Firefox 7+, Opera 11+, Chrome, Safari **/
        -o-text-overflow: ellipsis;  /** Opera 9 & 10 **/
        width: 200px; 
    }
</style>

<div class="page-content">
    <div class="row">
        <div class="pull-right">
            <div id="selectedEventColor" rel="${calendarEvent.eventColor}" style="width:15px; height:15px; background-color:${calendarEvent.eventColor}"></div>
        </div>
    </div>
    <div class="row">
        ${calendarEvent.eventTitle}
    </div>    
    <c:if test="${not empty calenderEvent.eventLocation}">
        <div class="row">
            ${calendarEvent.eventLocation}
        </div>
    </c:if>
    <div class="row"><hr></div>
    <div class="row">
        <strong><fmt:formatDate value="${calendarEvent.eventStartDate}" type="date" pattern="MMM dd, yyyy" /> ${calendarEvent.eventStartTime} - ${calendarEvent.eventEndTime}</strong>
    </div>
    <c:if test="${not empty calenderEvent.eventNotes}">
        <div class="row">
            ${calendarEvent.eventNotes}
        </div>
    </c:if>
    <c:if test="${not empty calendarEvent.existingDocuments}">
        <div class="row"><hr></div>
        <div class="row">
            <h5>Documents</h5>
            <c:forEach var="document" items="${calendarEvent.existingDocuments}">
                <c:if test="${fn:length(document.documentTitle) > 20}">
                    <c:set var="index" value="${document.documentTitle.lastIndexOf('.')}" />
                    <c:set var="trimmedDocumentExtension" value="${fn:substring(document.documentTitle,index+1,fn:length(document.documentTitle))}" />
                    <c:set var="trimmedDocumentTitle" value="${fn:substring(document.documentTitle, 0, 20)}...${trimmedDocumentExtension}" />
                </c:if>
                <c:if test="${fn:length(document.documentTitle) <= 20}">
                    <c:set var="trimmedDocumentTitle" value="${document.documentTitle}" />
                </c:if>
                <span class="ellipsis"><i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.documentTitle}&foldername=calendarUploadedFiles"/>" title="${document.documentTitle}">${trimmedDocumentTitle}</a></span>
            </c:forEach>
        </div>
    </c:if>
    <div class="row"><hr></div> 
    <div class="row">
        <h5>Notification Alerts</h5>
        <div class="form-group">
            <select name="" class="">
                <option value="">None</option>
                <option value="">Email: At time of event</option>
                <option value="">Email: 5 Min before event</option>
                <option value="">Email: 10 Min before event</option>
                <option value="">Email: 15 Min before event</option>
                <option value="">Email: 30 Min before event</option>
                <option value="">Email: 1 Hour before event</option>
                <option value="">Email: 2 Hour before event</option>
                <option value="">Email: 1 Day before event</option>
            </select>
        </div>
    </div>
</div>


