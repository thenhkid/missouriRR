<%-- 
    Document   : eventDetailsModal
    Created on : Jun 2, 2015, 10:55:11 AM
    Author     : Jim
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" var="today" type="both" pattern="yyyy-MM-dd HH:mm" />

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
    <div class="row">
        <div class="col-md-12">
            <div class="pull-right">
                <div id="selectedEventColor" rel="${calendarEvent.eventColor}" style="display:inline;float:left; width:20px; height:20px; margin-bottom:20px; background-color:${calendarEvent.eventColor}"></div><div style="display:inline;">&nbsp;&nbsp;${calendarEvent.eventType}</div>
            </div>
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
                <span class="ellipsis"><i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.encodedTitle}&foldername=calendarUploadedFiles"/>" title="${document.documentTitle}">${trimmedDocumentTitle}</a></span>
            </c:forEach>
        </div>
    </c:if>
    
    <fmt:formatDate value="${calendarEvent.eventStartDate}" var="eventStartDate" type="date" pattern="yyyy-MM-dd" />
    <fmt:parseDate value="${eventStartDate} ${calendarEvent.eventStartTime}" var="eventStartDateWTime" type="date" pattern="yyyy-MM-dd hh:mma" />
    <fmt:formatDate value="${eventStartDateWTime}" var="eventStartDateWTimeFormatted" type="both" pattern="yyyy-MM-dd HH:mm" />
    
      <c:if test="${today le eventStartDateWTimeFormatted}">
        <form:form id="eventNotificationForm" modelAttribute="calendarEvent" role="form" class="form" method="post">
            <div class="space-4"></div>
            <div class="hr hr-dotted"></div>
            <div class="row">
                <div class="form-group">
                    <div class="checkbox">
                        <label>
                            <form:checkbox path="sendAlert" id="sendAlert" />  Send email notification prior to the start of this event
                        </label>
                    </div>
                </div>
            </div>
            <div class="row notificationsOptions" id="alertFrequency" <c:if test="${calendarEvent.sendAlert == false}">style="display: none;"</c:if>>
                    <div class="form-group">
                    <form:select path="emailAlertMin" class="form-control emailAlertMin">
                        <option value="">-</option>
                        <option value="0" <c:if test="${calendarEvent.emailAlertMin == 0}"> selected </c:if>>Email: At time of event</option>
                        <option value="5" <c:if test="${calendarEvent.emailAlertMin == 5}"> selected </c:if>>Email: 5 Min before event</option>
                        <option value="10" <c:if test="${calendarEvent.emailAlertMin == 10}"> selected </c:if>>Email: 10 Min before event</option>
                        <option value="15" <c:if test="${calendarEvent.emailAlertMin == 15}"> selected </c:if>>Email: 15 Min before event</option>
                        <option value="30" <c:if test="${calendarEvent.emailAlertMin == 30}"> selected </c:if>>Email: 30 Min before event</option>
                        <option value="60" <c:if test="${calendarEvent.emailAlertMin == 60}"> selected </c:if>>Email: 1 hour before event</option>
                        <option value="120" <c:if test="${calendarEvent.emailAlertMin == 120}"> selected </c:if>>Email: 2 hour before event</option>
                        <option value="1440" <c:if test="${calendarEvent.emailAlertMin == 1440}"> selected </c:if>>Email: 1 day before event</option>
                        <option value="2880" <c:if test="${calendarEvent.emailAlertMin == 2880}"> selected </c:if>>Email: 2 days before event</option>
                    </form:select>
                </div>
            </div>
        </form:form>
    </c:if>
</div>


