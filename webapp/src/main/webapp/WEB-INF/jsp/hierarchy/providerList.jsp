<%-- 
    Document   : itemlist
    Created on : Dec 23, 2014, 10:43:07 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<table class="table table-striped table-hover table-default" <c:if test="${not empty providers}">id="dataTable"</c:if>>
        <thead>
            <tr>
                <th scope="col">Name</th>
                <th scope="col">Address</th>
                <th scope="col" class="center-text">Date Created</th>
                <th scope="col" class="center-text"></th>
            </tr>
        </thead>
       <tbody>
        <c:choose>
            <c:when test="${not empty providers}">
                <c:forEach var="provider" items="${providers}">
                    <tr>
                        <td>
                            ${provider.name}
                            <br />
                            (Status: <c:choose><c:when test="${provider.status == true}">Active</c:when><c:otherwise>Inactive</c:otherwise></c:choose>)
                        </td>
                        <td>
                            ${provider.address}&nbsp;${provider.address2}<br />
                            ${provider.city}&nbsp;${provider.state},&nbsp;${provider.zipCode}
                        </td>
                        <td class="center-text">
                            <fmt:formatDate value="${provider.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" />
                        </td>
                        <td class="actions-col">
                            <a style="text-decoration:none;" href="hierarchy/provider/details?i=${provider.encryptedId}&v=${provider.encryptedSecret}"  class="btn btn-link" title="Edit" role="button">
                                <span class="glyphicon glyphicon-edit"></span>
                                Edit
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="4" class="center-text">There are currently no providers set up.</td></tr>
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