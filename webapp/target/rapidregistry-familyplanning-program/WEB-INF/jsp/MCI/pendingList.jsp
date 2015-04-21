<%-- 
    Document   : pendingList
    Created on : Jan 6, 2015, 11:32:27 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix full-width" role="main">
    <div class="col-md-12">
        <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'created'}">The new client was created and a new engagement was created!</c:when>
                        <c:when test="${param.msg == 'matched'}">A new engagement has been entered for the selected similar client!</c:when>
                        <c:when test="${param.msg == 'merged'}">The selected similar client has been merged into the new client and a new engagement was entered!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        
        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Pending Clients</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable" id="clientList">
                    <table class="table table-striped table-hover table-default" <c:if test="${not empty pending}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col">Client Name <br/>(Email)</th>
                                <th scope="col">Address</th>
                                <th scope="col" class="center-text">Date Referred</th>
                                <th scope="col" class="center-text">Similar Matches</th>
                                <th scope="col" class="center-text"></th>
                            </tr>
                        </thead>
                       <tbody>
                        <c:choose>
                            <c:when test="${not empty pending}">
                                <c:forEach var="client" items="${pending}">
                                    <tr>
                                        <td>
                                            <a href="MCI/review?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn-link" title="View Matches" role="button">${client.name}</a>
                                            <c:if test="${client.email != ''}"><br />${client.email}</c:if>
                                        </td>
                                        <td>
                                            ${client.address} ${client.address2}<br />
                                            ${client.city}&nbsp;${client.state}, ${client.zip}
                                        </td>
                                        <td class="center-text"><fmt:formatDate value="${client.dateReferred}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                        <td  class="center-text">${client.similarMatches}</td>
                                        <td class="actions-col">
                                            <a href="MCI/review?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn btn-link" title="View Matches" role="button">
                                                <span class="glyphicon glyphicon-search"></span>
                                                View Matches
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="center-text">There are currently no pending clients.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
</div>



