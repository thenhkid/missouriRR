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
       
        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">New Client Information</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable">
                    <div class="col-md-4">
                        ${clientDetails.name}<br />
                        ${clientDetails.address} ${clientDetails.address2}<br />
                        ${clientDetails.city}&nbsp;${clientDetails.state}, ${clientDetails.zip}<br />
                        <a href='mailto:${clientDetails.email}'>${clientDetails.email}</a>
                    </div>
                    <div class="col-md-4 cb">
                        DOB: <fmt:formatDate value="${clientDetails.DOB}" type="date" pattern="M/dd/yyyy" /><br />
                        Patient Id: ${clientDetails.sourcePatientId}
                    </div>
                </div>
            </div>
        </section>
        
        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Similar Matches</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable">
                    <table class="table table-striped table-hover table-default" <c:if test="${not empty similarClients}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col">Client Name <br/>(Email)</th>
                                <th scope="col">Address</th>
                                <th scope="col" class="center-text" style="width:100px">DOB</th>
                                <th scope="col" class="center-text" style="width:150px">Patient Id</th>
                                <th scope="col">Program</th>
                                <th scope="col" class="center-text" style="width:175px">Date Referred</th>
                                <th scope="col" class="center-text" style="width:250px"></th>
                                <th scope="col" class="center-text" style="width:100px"></th>
                            </tr>
                        </thead>
                       <tbody>
                        <c:choose>
                            <c:when test="${not empty similarClients}">
                                <c:forEach var="client" items="${similarClients}">
                                    <tr>
                                        <td>
                                            ${client.name}
                                            <c:if test="${client.email != ''}"><br />${client.email}</c:if>
                                        </td>
                                        <td>
                                            ${client.address} ${client.address2}<br />
                                            ${client.city}&nbsp;${client.state}, ${client.zip}
                                        </td>
                                        <td class="center-text"><fmt:formatDate value="${client.DOB}" type="date" pattern="M/dd/yyyy" /></td>
                                        <td class="center-text">${client.sourcePatientId}</td>
                                        <td></td>
                                        <td class="center-text"><fmt:formatDate value="${client.dateReferred}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                        <td>
                                            <input type="radio" name="useType" class="useType${client.clientId}" value="1" /> Use This Client Data<br />
                                            <input type="radio" name="useType" class="useType${client.clientId}" value="2" /> Use New Client Data
                                        </td>
                                        <td class="center-text">
                                            <input type="button" value="Matching Client" rel="${client.clientId}" rel2="${clientId}" class="btn btn-primary matchClient" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="center-text">There were no similar clients found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
</div>



