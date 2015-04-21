<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main" rel="${iparam}" rel2="${vparam}">
    <div class="col-md-12">
        
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
        
        
        <c:if test="${not empty completedSurveys}">
           <div class="panel panel-default">
                <div class="panel-heading" style="background-color: #5F8484">
                    <h3 class="panel-title" style="color: #FFF">Completed Surveys not associated with any Engagement</h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped table-hover table-default" <c:if test="${not empty completedSurveys}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col">Survey Title</th>
                                <th scope="col" class="center-text">Date Started</th>
                                <th scope="col" class="center-text">Date Completed</th>
                                <th scope="col">Staff Member</th>
                                <th scope="col" class="center-text">Completed</th>
                                <th scope="col" class="center-text"></th>
                                <th scope="col" class="center-text"></th>
                            </tr>
                        </thead>
                       <tbody>
                        <c:choose>
                            <c:when test="${not empty completedSurveys}">
                                <c:forEach var="survey" items="${completedSurveys}">
                                    <tr>
                                        <td>
                                           ${survey.surveyTitle}
                                        </td>
                                        <td class="center-text"><fmt:formatDate value="${survey.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                        <td class="center-text"><fmt:formatDate value="${survey.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                        <td>
                                            ${survey.staffMember}
                                        </td>
                                        <td class="center-text">Yes</td>
                                        <td class="actions-col">
                                            <a href="/clients/surveys/viewSurvey?i=${iparam}&s=${survey.id}&v=${vparam}" class="btn btn-link" title="View this Survey" role="button">
                                                <span class="glyphicon glyphicon-eye-open"></span>
                                                View
                                            </a>
                                            |
                                             <a href="/clients/surveys/takeSurvey?i=${iparam}&c=${survey.id}&s=${survey.surveyId}&v=${vparam}" class="btn btn-link" title="Edit this Survey" role="button">
                                               <span class="glyphicon glyphicon-edit"></span>
                                                Edit
                                            </a>    
                                        </td>
                                        <td class="actions-col">
                                            <a href="/clients/details?i=${client.encryptedId}&v=${client.encryptedSecret}" class="btn btn-link" title="View this Client" role="button">
                                                <span class="glyphicon glyphicon-remove-circle"></span>
                                                Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="center-text">There are currently no completed surveys for this client.</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                 </div>
            </div> 
        </c:if>
        
    </div>
</div>



