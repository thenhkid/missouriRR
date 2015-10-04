<%-- 
    Document   : eventTypesColumn
    Created on : Jun 23, 2015, 11:11:02 AM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:forEach var="eventType" items="${eventTypes}">
    <c:if test="${eventType.adminOnly == false || (eventType.adminOnly == true && sessionScope.userDetails.roleId == 2)}">
        <div style="padding-top:5px; cursor: pointer" class="showCategory" rel="${eventType.id}">
            <span class="btn-colorpicker center white" style="background-color:${eventType.eventTypeColor};">
                <i class="ace-icon fa fa-check" id="icon_${eventType.id}"></i>
            </span>
            ${eventType.eventType}
        </div>
    </c:if>
</c:forEach>