<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="row">
    <div class="col-xs-12">

        <h3 class="header smaller lighter blue">Activity Logs</h3>

        <div class="clearfix">
            <div class="pull-right">
                <a href="#districtSelectModal" id="createNewEntry" role="button" data-toggle="modal" class="btn btn-danger btn-xs">
                    <i class="ace-icon fa fa-plus-square align-top bigger-150"></i>
                    <strong>New Entry</strong>
                </a>    
            </div>
            <div class="pull-left tableTools-container"></div>
        </div>
        <div class="table-header">
            Results for "Latest ${surveyName} Activity Logs"
        </div>


        <div>
            <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th scope="col" class="center"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Submitted</th>
                        <th scope="col" >Submitted By</th>
                        <th scope="col" class="center  hidden-480">Submitted</th>
                        <th scope="col">School(s)</th>
                        <th scope="col">Content Area - Criteria</th>
                        <th scope="col" class="center"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty submittedSurveys}">
                            <c:forEach var="submittedSurvey" items="${submittedSurveys}">
                                <tr>
                                    <td class="center"><fmt:formatDate value="${submittedSurvey.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                    <td>
                                        ${submittedSurvey.staffMember}
                                    </td>
                                    <td class="center hidden-480">
                                        <c:choose>
                                            <c:when test="${submittedSurvey.submitted == true}"><span class="fa fa-check"></span></c:when>
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
                                    <td>
                                        <div class="hidden-sm hidden-xs action-buttons">
                                            <c:choose>
                                                <c:when test="${submittedSurvey.submitted == true}">
                                                    <c:if test="${allowEdit == true}">
                                                        <a href="surveys/editSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" title="" role="button">
                                                            <button class="btn btn-xs btn-success">
                                                                <i class="ace-icon fa fa-pencil bigger-120"></i>
                                                            </button>
                                                        </a>
                                                    </c:if>
                                                    <a href="surveys/viewSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" title="" role="button">
                                                        <button class="btn btn-xs btn-info">
                                                            <i class="ace-icon fa fa-search-plus bigger-120"></i>
                                                        </button>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="surveys/editSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" title="" role="button">
                                                        <button class="btn btn-xs btn-success">
                                                            <i class="ace-icon fa fa-pencil bigger-120"></i>
                                                        </button>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
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

    </div><!-- /.col -->
</div>

<!-- Activity Code Details modal -->
<div id="districtSelectModal" class="modal fade" tabindex="-1"></div>
