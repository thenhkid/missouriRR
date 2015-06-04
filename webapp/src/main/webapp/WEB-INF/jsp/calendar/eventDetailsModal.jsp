<%-- 
    Document   : eventDetailsModal
    Created on : Jun 2, 2015, 10:55:11 AM
    Author     : Jim
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div>
    <div>
        <p><div style="width:20px; height:20px; background-color:${event.eventColor}"></div></p>
        <p>${event.eventTitle}</p>
        <p>${event.eventLocation}</p>
        <hr>
        <p><fmt:formatDate value="${event.eventStartDate}" type="date" pattern="MMM dd, yyyy" /> ${event.eventStartTime} - ${event.eventEndTime}</p>
        <p>${event.eventNotes}</p>
        <p></p>
        <hr>
        <h5>Documents</h5>
        <p>Document<a href="">Document Link</a></p>
        <p>Document<a href="">Document Link</a></p>
        <hr>
        <h5>Notification Alerts</h5>
        <form>
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
        </form>
    </div>
</div>