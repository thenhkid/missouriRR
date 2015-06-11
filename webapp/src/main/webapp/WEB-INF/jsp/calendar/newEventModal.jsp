<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="page-content" id="createEventForm">
    <form:form id="eventForm" modelAttribute="calendarEvent" role="form" class="form" method="post" enctype="multipart/form-data">
        <form:hidden path="eventTypeId" id="hiddenEventTypeId" value="${event.eventTypeId}" />
        <form:hidden path="id" />
        <form:hidden path="programId" />
        <form:hidden path="systemUserId" />
        <form:hidden path="eventStartDate" />
        <form:hidden path="eventEndDate" />

        <div class="row">
            <div class="form-group pull-right">
                <select name="newEventColor" id="simple-colorpicker-1" class="hide" rel="${selectedEventTypeColor}">
                    <c:forEach var="eventType" items="${eventTypes}">
                        <option value="${eventType.eventTypeColor}">${eventType.eventType}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="form-group">
                <label class="sr-only" for="eventName">Event Name</label>
                <form:input path="eventTitle" class="form-control eventName" placeholder="Event Name" />
            </div>
        </div>            
        <div class="row">
            <div class="form-group">
                <label class="sr-only" for="eventLocation">Event Location</label>
                <form:input path="eventLocation" class="form-control eventLocation" placeholder="Event Location"  />
            </div>
            <hr />
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
            <div class="form-group">
                <div class="row clearfix">
                    <div class="col-md-6">
                        <label for="timeFrom">Start Time</label>
                        <form:input path="eventStartTime" class="form-control timeFrom" placeholder="Start Time"  />
                    </div>
                    <div class="col-md-6">
                        <label for="timeFrom">End Time</label>
                        <form:input path="eventEndTime" class="form-control timeTo" name="timeTo" placeholder="End Time" />
                    </div>
                </div>
            </div>
            <hr />
        </div>
        <div class="row">
            <div class="form-group">
                <label for="eventNotes">Notes</label>
                <form:textarea path="eventNotes" class="form-control eventNotes" placeholder="Notes" />
            </div>
            <hr />
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
             <hr />
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="alertAllUsers" value="0"> Alert all users of this new event?
                    </label>
                </div>
            </div>    
            <hr />
        </div>
        <div class="row">
            <button type="submit" class="btn btn-mini btn-primary eventSave">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
            <c:if test="${event.id > 0}">
                <button type="submit" class="btn btn-mini btn-danger deleteEvent" rel="${event.id}">
                    <i class="ace-icon fa fa-trash bigger-120 white"></i>
                    Delete
                </button>
            </c:if>
        </div>


    </form:form>
</div>
