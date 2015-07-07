<%-- 
    Document   : topics
    Created on : Jun 19, 2015, 9:45:33 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="page-header">
    <h1>
        Export
        <small>
            <i class="ace-icon fa fa-angle-double-right"></i>
            export activity log responses
        </small>
    </h1>
</div><!-- /.page-header -->

<div class="col-xs-12">
    
    <div id="topicsDiv" class="col-sm-12">
        <c:if test="${not empty surveys}">
            <div class="row">
                <div class="table-header">
                    Activity Logs
                </div>
                <div>
                    <table class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col" class="center">Responses</th>
                                <th scope="col" class="center"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="survey" items="${surveys}">
                                <tr>
                                    <td class="col-md-9">
                                        ${survey.title}
                                    </td>
                                    <td class="center col-md-1">
                                        ${survey.timesTaken}
                                    </td>
                                    <td class="${survey.timesTaken > 0 ? 'col-md-2' : 'col-md-1' } center">
                                        <c:if test="${survey.timesTaken > 0}">
                                         <div class="pull-left">
                                            <a href="#" class="exportSurveyResponses" rel="${survey.id}" title="Export the activity log responses" style="text-decoration: none;">
                                                <i class="menu-icon fa fa-download green bigger-125"></i>
                                                <span class="menu-text green"><strong>Responses</strong></span>
                                            </a>
                                        </div>
                                        </c:if>       
                                        <div  <c:if test="${survey.timesTaken > 0}">class="pull-right"</c:if>>
                                            <a href="#" class="exportSurveyQuestions" rel="${survey.id}" title="Export the activity log questions" style="text-decoration: none;">
                                                <i class="menu-icon fa fa-download blue bigger-125"></i>
                                                <span class="menu-text blue"><strong>Questions</strong></span>
                                            </a>
                                        </div>        
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
</div>
