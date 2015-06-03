<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div id="createEventForm">
    <div>
        <form>
            <div class="form-group">
                <select name="newEventColor" class="newEventColor">
                    <c:forEach var="eventType" items="${eventTypes}">
                        <option value="${eventType.eventTypeColor}" ${eventType.selectedColor}>${eventType.eventType}</option>
                    </c:forEach>
                </select>
                <input type="hidden" name="hiddenEventTypeId" id="hiddenEventTypeId" value="${event.eventTypeId}" />
            </div>
            <div class="form-group">
                <label class="sr-only" for="eventName">Event Name</label>
                <input type="text" class="form-control eventName" name="eventName" placeholder="Event Name" value="${event.eventTitle}" />
            </div>
            <div class="form-group">
                <label class="sr-only" for="eventLocation">Event Location</label>
                <input type="text" class="form-control eventLocation" name="eventLocation" placeholder="Event Location" value="${event.eventLocation}" />
            </div>
            <hr />
            <div class="form-group">
                <div class="row clearfix">
                    <div class="col-md-6">
                        <label for="eventDate">Start Date</label>
                        <input type="text" class="form-control eventStartDate" name="eventStartDate" placeholder="Start Date" value="<fmt:formatDate value="${event.eventStartDate}" type="date" pattern="MM/dd/yyyy" />" />
                    </div>
                    <div class="col-md-6">
                        <label for="eventDate">End Date</label>
                        <input type="text" class="form-control eventEndDate" name="eventEndDate" placeholder="End Date" value="<fmt:formatDate value="${event.eventEndDate}" type="date" pattern="MM/dd/yyyy" />" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="row clearfix">
                    <div class="col-md-6">
                        <label for="timeFrom">Start Time</label>
                        <input type="text" class="form-control timeFrom" name="timeFrom" placeholder="Start Time" value="${event.eventStartTime}" />
                    </div>
                    <div class="col-md-6">
                        <label for="timeFrom">End Time</label>
                        <input type="text" class="form-control timeTo" name="timeTo" placeholder="End Time" value="${event.eventEndTime}" />
                    </div>
                </div>
            </div>
            <hr />
            <div class="form-group">
                <label for="eventNotes">Notes</label>
                <textarea type="text" class="form-control eventNotes" name="eventNotes" placeholder="Notes">${event.eventNotes}</textarea>
            </div>
            <hr />
            <div class="form-group">
                <label for="document1">Documents</label>
                <input type="text" class="form-control" name="document1" placeholder="Attachment Name" />
                <input type="file" id="exampleInputFile">
            </div>
            <hr />
            <div class="checkbox">
                <label>
                    <input type="checkbox"> Alert all users of this new event?
                </label>
            </div>
            <hr />
            <button type="submit" class="btn btn-primary eventSave">Create</button>
        </form>
    </div>
</div>