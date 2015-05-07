<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<table class="table table-striped table-hover table-default" <c:if test="${not empty activityLogs}">id="dataTable"</c:if>>
    <thead>
        <tr>
            <th scope="col" class="center-text">Date Submitted</th>
            <th scope="col" class="center-text">Submitted By</th>
            <th scope="col" class="center-text">Submitted</th>
            <th scope="col">School(s)</th>
            <th scope="col">Content Area - Criteria</th>
            <th scope="col" class="center-text"></th>
        </tr>
    </thead>
   <tbody>
    <c:choose>
        <c:when test="${not empty activityLogs}">
            <c:forEach var="activityLog" items="${activityLogs}">
                <tr>
                    <td class="center-text"><fmt:formatDate value="${activityLog.dateSubmitted}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                    <td>
                        ${activityLog.submittedBy}
                    </td>
                    <td class="center-text"></td>
                    <td></td>
                    <td></td>
                    <td class="actions-col"  class="center-text">
                        <a href="" class="btn btn-link" title="" role="button">
                            View Entry
                            <span class="glyphicon glyphicon-play-circle"></span>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr><td colspan="8" class="center-text">There have been no entries for the selected survey.</td></tr>
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

