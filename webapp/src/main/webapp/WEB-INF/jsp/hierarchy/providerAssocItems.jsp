<%-- 
    Document   : providerAssocItems
    Created on : Dec 30, 2014, 1:28:03 PM
    Author     : chadmccue
--%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<table class="table table-striped table-hover responsive">
    <thead>
        <tr>
            <th scope="col">Name</th>
            <th scope="col" class="center-text">Date Associated</th>
            <th scope="col"></th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${associatedItems.size() > 0}">
                <c:forEach items="${associatedItems}" var="item" varStatus="iStatus">
                    <tr>
                        <td scope="row">
                            ${item.assocName}
                        </td>
                        <td class="center-text"><fmt:formatDate value="${item.dateCreated}" type="date" pattern="M/dd/yyyy" /> @ <fmt:formatDate value="${item.dateCreated}" type="time" pattern="h:mm a" /></td>
                        <td class="center-text">
                            <a href="javascript:void(0)" class="btn btn-link deleteAssoc" rel="${item.id}" title="Delete this Item">
                                <span class="glyphicon glyphicon-trash"></span>
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise><tr><td scope="row" colspan="3" style="text-align:center">No ${assocHierarchyName} Found</td></c:otherwise>
            </c:choose>
    </tbody>
</table>
