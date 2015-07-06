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
                                    <td class="col-md-10">
                                        ${survey.title}
                                    </td>
                                    <td class="center col-md-1">
                                        10
                                    </td>
                                    <td class="col-md-1 center">
                                         <div class="action-buttons">
                                            <a href="#" class="exportSurvey" rel="${survey.id}">
                                                <i class="ace-icon fa fa-download blue bigger-125"></i>
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
