<%-- 
    Document   : clientList
    Created on : Dec 2, 2014, 1:49:51 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<table class="table table-striped table-hover table-default" <c:if test="${not empty clients}">id="dataTable"</c:if>>
        <thead>
            <tr>
                <th scope="col">Client Name <br/>(Email)</th>
                <th scope="col">Client Number</th>
                <th scope="col">Address</th>
                <th scope="col" class="center-text">Date Registered</th>
                <th scope="col" class="center-text">Last Engagement</th>
                <th scope="col" class="center-text"></th>
                <th scope="col" class="center-text"></th>
            </tr>
        </thead>
       <tbody>
        <c:choose>
            <c:when test="${not empty clients}">
                <c:forEach var="client" items="${clients}">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${not empty client.name}">
                                    <a href="clients/details?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn-link" title="View this Client" role="button">${client.name}</a>
                                    <c:if test="${client.email != ''}"><br />${client.email}</c:if>
                                </c:when>
                                <c:otherwise>
                                    <a href="clients/details?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn-link" title="View this Client" role="button">View Client</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                               <c:when test="${not empty client.sourcePatientId}">
                                    ${client.sourcePatientId}
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            ${client.address} ${client.address2}<br />
                            ${client.city}&nbsp;${client.state}, ${client.zip}
                        </td>
                        <td class="center-text"><fmt:formatDate value="${client.dateReferred}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                        <td class="center-text"><fmt:formatDate value="${client.dateReferred}" type="Both" pattern="M/dd/yyyy h:mm a" /></td>
                        <td class="actions-col">
                            <a href="clients/details?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn btn-link" title="Edit this Staff Member" role="button">
                                <span class="glyphicon glyphicon-calendar"></span>
                                Logged Events
                            </a>
                        </td>
                        <td class="actions-col">
                            <a href="clients/details?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn btn-link" title="View this Client" role="button">
                                <span class="glyphicon glyphicon-edit"></span>
                                View Client
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="8" class="center-text">There are currently no clients.</td></tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

        
<script>

    $('#dataTable').dataTable({
    "sPaginationType": "bootstrap",
    "oLanguage": {
        "sSearch": "_INPUT_",
        "sLengthMenu": '<select class="form-control" style="width:150px">' +
                '<option value="10">10 Records</option>' +
                '<option value="20">20 Records</option>' +
                '<option value="30">30 Records</option>' +
                '<option value="40">40 Records</option>' +
                '<option value="50">50 Records</option>' +
                '<option value="-1">All</option>' +
                '</select>'
    }
});
</script>