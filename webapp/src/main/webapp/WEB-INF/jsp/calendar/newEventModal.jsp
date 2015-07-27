<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" var="today" type="both" pattern="yyyy-MM-dd HH:mm" />

<div class="page-content" id="createEventForm">
    <form:form id="eventForm" modelAttribute="calendarEvent" role="form" class="form" method="post" enctype="multipart/form-data">
        <form:hidden path="eventTypeId" id="hiddenEventTypeId" value="${calendarEvent.eventTypeId}" />
        <form:hidden path="id" />
        <form:hidden path="programId" />
        <form:hidden path="systemUserId" />
        <form:hidden path="eventStartDate" />
        <form:hidden path="eventEndDate" />

        <div class="row">
            <div class="form-group pull-right">
                <select name="newEventColor" id="simple-colorpicker-1" class="hide" rel="${selectedEventTypeColor}">
                    <c:forEach var="eventType" items="${eventTypes}">
                        <c:if test="${eventType.adminOnly == false || (eventType.adminOnly == true && sessionScope.userDetails.roleId == 2)}">
                            <option value="${eventType.eventTypeColor}" <c:if test="${eventType.eventTypeColor == selectedEventTypeColor}">selected</c:if>>${eventType.eventType}</option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="form-group" id="eventTitleDiv">
                <label class="sr-only" for="eventName">Event Name</label>
                <form:input path="eventTitle" class="form-control eventName" placeholder="Event Name" maxlength="55" />
                <span id="eventTitleMessage" class="control-label"></span>
            </div>
        </div>            
        <div class="row">
            <div class="form-group">
                <label class="sr-only" for="eventLocation">Event Location</label>
                <form:input path="eventLocation" class="form-control eventLocation" placeholder="Event Location" maxlength="255" />
            </div>
        </div>
        <div class="row">
            <div class="form-group">
                <div class="row clearfix">
                    <div class="col-md-6">
                        <label for="eventDate">Start Date</label>
                        <fmt:formatDate value="${calendarEvent.eventStartDate}" var="dateStartString" pattern="MM/dd/yyyy" />
                        <form:input path="startDate" class="form-control eventStartDate" placeholder="Start Date" value="${dateStartString}" />
                    </div>
                    <div class="col-md-6">
                        <label for="eventDate">End Date</label>
                        <fmt:formatDate value="${calendarEvent.eventEndDate}" var="dateEndString" pattern="MM/dd/yyyy" />
                        <form:input path="endDate" class="form-control eventEndDate" placeholder="End Date" value="${dateEndString}" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-group" id="eventTimeDiv">
                <div class="row clearfix">
                    <div class="col-md-6">
                        <label for="timeFrom">Start Time</label>
                        <form:input path="eventStartTime" class="form-control timeFrom" placeholder="Start Time"  />
                        <span id="eventStartTimeMessage" class="control-label"></span>
                    </div>
                    <div class="col-md-6">
                        <label for="timeFrom">End Time</label>
                        <form:input path="eventEndTime" class="form-control timeTo" name="timeTo" placeholder="End Time" />
                        <span id="eventEndTimeMessage" class="control-label"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-group">
                <label for="eventNotes">Notes</label>
                <form:textarea path="eventNotes" class="form-control eventNotes" placeholder="Notes" maxlength="255"/>
            </div>
            
        </div>

        <c:if test="${not empty calendarEvent.existingDocuments}">
            <div class="row">
                <div class="form-group">
                    <label for="document1">Uploaded Documents</label>
                    <c:forEach var="document" items="${calendarEvent.existingDocuments}">
                        <div class="input-group" id="docDiv_${document.id}">
                            <span class="input-group-addon">
                                <i class="fa fa-file bigger-110 orange"></i>
                            </span>
                            <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${document.documentTitle}"></input>
                            <span class="input-group-addon">
                                <a href="javascript:void(0)" class="removeAttachment" rel="${document.id}"><i class="fa fa-times bigger-110 red"></i></a>
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        <div class="row">
            <div class="form-group">         
                <label for="document1">Documents</label>
                <div class="form-group">
                    <div class="col-lg-12">
                        <input  multiple="" name="eventDocuments" type="file" id="id-input-file-2" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <c:choose>
                            <c:when test="${calendarEvent.id > 0}">
                                <input type="checkbox" name="alertAllUsers" value="1"> Send email notification to users regarding this change?
                            </c:when>
                            <c:otherwise>
                                <input type="checkbox" name="alertAllUsers" value="1"> Send email notification to users regarding this new event?
                            </c:otherwise>
                        </c:choose>
                    </label>
                </div>
            </div>    
            <%--<div class="space-4"></div>
            <div class="hr hr-dotted"></div>--%>
        </div>
        <c:if test="${calendarEvent.id > 0}">
            <fmt:formatDate value="${calendarEvent.eventStartDate}" var="eventStartDate" type="date" pattern="yyyy-MM-dd" />
            <fmt:parseDate value="${eventStartDate} ${calendarEvent.eventStartTime}" var="eventStartDateWTime" type="date" pattern="yyyy-MM-dd hh:mma" />
            <fmt:formatDate value="${eventStartDateWTime}" var="eventStartDateWTimeFormatted" type="both" pattern="yyyy-MM-dd HH:mm" />

            <c:if test="${today le eventStartDateWTimeFormatted}">
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
                <div class="space-4"></div>
                <div class="hr hr-dotted"></div>
            </c:if>
        </c:if>
        <div class="row">
            <button type="submit" class="btn btn-mini btn-primary eventSave">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
            <c:if test="${calendarEvent.id > 0}">
                <button type="submit" class="btn btn-mini btn-danger deleteEvent" rel="${calendarEvent.id}">
                    <i class="ace-icon fa fa-trash bigger-120 white"></i>
                    Delete
                </button>
            </c:if>
        </div>

    </form:form>
</div>
