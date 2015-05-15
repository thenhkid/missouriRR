<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <c:if test="${allowCreate == true}">
                    <div class="pull-right">
                        <a href="#districtSelectModal" data-toggle="modal" class="btn btn-primary btn-xs btn-action" rel="${selSurvey}" id="createNewEntry" title="Associate another Program">New Entry</a>
                    </div>
                </c:if>
                <h3 class="panel-title" style="color: #FFF">${surveyName} Activity Logs</h3>
            </div>
            <div class="panel-body">
                <table class="table table-striped table-hover table-default" <c:if test="${not empty submittedSurveys}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col" class="center-text">Date Submitted</th>
                                <th scope="col" >Submitted By</th>
                                <th scope="col" class="center-text">Submitted</th>
                                <th scope="col">School(s)</th>
                                <th scope="col">Content Area - Criteria</th>
                                <th scope="col" class="center-text"></th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty submittedSurveys}">
                                <c:forEach var="submittedSurvey" items="${submittedSurveys}">
                                    <tr>
                                        <td class="center-text"><fmt:formatDate value="${submittedSurvey.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                        <td>
                                            ${submittedSurvey.staffMember}
                                        </td>
                                        <td class="center-text">
                                            <c:choose>
                                                <c:when test="${submittedSurvey.submitted == true}"><span class="glyphicon glyphicon-ok"></span></c:when>
                                                <c:otherwise><span class="glyphicon glyphicon-remove"></span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not empty submittedSurvey.selectedEntities}">
                                                <c:forEach var="entity" items="${submittedSurvey.selectedEntities}">
                                                    <div class="col-md-4">
                                                        <label>
                                                            <span class="glyphicon glyphicon-home"></span> ${entity}
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </td>
                                        <td></td>
                                        <td class="actions-col"  class="center-text">
                                            <c:choose>
                                                <c:when test="${submittedSurvey.submitted == true}">
                                                    <c:if test="${allowEdit == true}">
                                                        <a href="surveys/editSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" class="btn btn-link" title="" role="button">Edit Entry <span class="glyphicon glyphicon-edit"></span></a>
                                                    </c:if>
                                                    <a href="surveys/viewSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" class="btn btn-link" title="" role="button">View Entry <span class="glyphicon glyphicon-edit"></span></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="surveys/editSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" class="btn btn-link" title="" role="button">Edit Entry <span class="glyphicon glyphicon-edit"></span></a>
                                                </c:otherwise>
                                            </c:choose>
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
            </div>
        </div> 
    </div>
</div>
<!-- Activity Code Details modal -->
<div class="modal fade" id="districtSelectModal" role="dialog" tabindex="-1" aria-labeledby="" aria-hidden="true" aria-describedby=""></div>
