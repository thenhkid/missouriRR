<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'updated'}">The client engagement has been successfully updated!</c:when>
                        <c:when test="${param.msg == 'created'}">The client engagement has been successfully created!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        
        <c:if test="${not empty summary}">
           <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="pull-right">
                        <a href="/clients/details?i=${iparam}&v=${vparam}" class="btn btn-primary btn-xs btn-action" title="View Client Details">View Client Details</a>
                    </div>
                    <h3 class="panel-title">Client Summary</h3>
                </div>
                <div class="panel-body">
                    <div class="row" style="height:25px;">
                        <div class="col-md-4">
                            Patient Id: ${summary.sourcePatientId}
                        </div>
                    </div>
                 </div>
            </div> 
        </c:if>
        

        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Engagements</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable" id="clientList">
                    <table class="table table-striped table-hover table-default" <c:if test="${not empty engagements}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col">Date/Time Entered</th>
                                <th scope="col">Entered By</th>
                                <th scope="col" class="center-text"></th>
                            </tr>
                        </thead>
                       <tbody>
                        <c:choose>
                            <c:when test="${not empty engagements}">
                                <c:forEach var="engagement" items="${engagements}">
                                    <tr>
                                        <td>
                                            <fmt:formatDate value="${engagement.dateCreated}" type="both" pattern="M/dd/yyyy h:mm a" />
                                        </td>
                                        <td>
                                            ${engagement.enteredBy}
                                        </td>
                                        <td class="actions-col">
                                            <a href="engagements/details?i=${iparam}&e=${engagement.id}&v=${vparam}" class="btn btn-link" title="View Engagement" role="button">
                                                <span class="glyphicon glyphicon-edit"></span>
                                                View Details
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="center-text">There are currently no engagements for this client.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                </div>
            </div>
        </section>
    </div>
</div>



