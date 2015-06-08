<%-- 
    Document   : eventDetailsModal
    Created on : Jun 2, 2015, 10:55:11 AM
    Author     : Jim
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .ellipsis {
        display: inline-block;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;     /** IE6+, Firefox 7+, Opera 11+, Chrome, Safari **/
        -o-text-overflow: ellipsis;  /** Opera 9 & 10 **/
        width: 200px; 
    }
</style>

<div>
    <div>
        <p><div style="width:20px; height:20px; background-color:${calendarEvent.eventColor}"></div></p>
        <p>${calendarEvent.eventTitle}</p>
        <p>${calendarEvent.eventLocation}</p>
        <hr>
        <p><fmt:formatDate value="${calendarEvent.eventStartDate}" type="date" pattern="MMM dd, yyyy" /> ${calendarEvent.eventStartTime} - ${calendarEvent.eventEndTime}</p>
        <p>${calendarEvent.eventNotes}</p>
        <p></p>
        <c:if test="${not empty calendarEvent.existingDocuments}">
            <hr>
            <h5>Event Documents</h5>
            <c:forEach var="document" items="${calendarEvent.existingDocuments}">
                <p class="ellipsis"> <i class="fa fa-file bigger-110 orange"></i> <a href="" title="${document.documentTitle}">${document.documentTitle}</a></p>

            </c:forEach>
        </c:if>
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