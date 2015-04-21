<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<table class="table table-striped table-hover table-default" <c:if test="${not empty districts}">id="dataTable"</c:if>>
    <thead>
        <tr>
            <th scope="col">District Name</th>
            <th scope="col" class="center-text">Last Survey Taken</th>
            <th scope="col" class="center-text">Taken On</th>
            <th scope="col" class="center-text"></th>
        </tr>
    </thead>
   <tbody>
    <c:choose>
        <c:when test="${not empty districts}">
            <c:forEach var="district" items="${districts}">
                <tr>
                    <td>
                        ${district.districtName}
                    </td>
                    <td>
                        ${district.lastSurveyTaken}
                    </td>
                    <td class="center-text"><fmt:formatDate value="${district.lastSurveyTakenOn}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                    <td class="actions-col">
                        <a href="/districts/activitylog?i=${district.encryptedId}&v=${district.encryptedSecret}" class="btn btn-link" title="View this District Activity Log" role="button">
                            Go to District Activity Log
                            <span class="glyphicon glyphicon-play-circle"></span>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr><td colspan="8" class="center-text">There are currently no districts set up for this county.</td></tr>
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

