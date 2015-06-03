<%-- 
    Document   : eventCategories
    Created on : Jun 3, 2015, 11:36:18 AM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="list-unstyled">
    <c:forEach var="eventType" items="${eventTypes}">
        <li>
            <input type="checkbox" name="eventTypeIdFilter" value="${eventType.id}" /><div style="width:20px; height:20px; background-color:${eventType.eventTypeColor}"></div> ${eventType.eventType}
        </li>
    </c:forEach>
</ul>