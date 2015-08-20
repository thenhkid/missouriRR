<%-- 
    Document   : completedSurvey
    Created on : Mar 11, 2015, 8:58:34 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h4>Completed Activity Log</h4>
            </div>
            <div class="panel-body pageQuestionsPanel">
                You have completed the ${surveyDetails.title} activity log.
                <div class="space-12"></div>
                <div class="hr hr-dotted hr-16"></div>
                <div class="col-sm-2">
                    <div>
                        <div class="pull-left">
                            <a href="<c:url value="/surveys?i=${i}&v=${v}" />"><button class="btn">Return to Activity Log</button></a>
                        </div>
                        <div class="pull-right">
                            <form method="POST" action="/surveys/startSurvey?i=${i}&v=${v}">
                                <input type="hidden" name="selectedEntities" value="${selectedEntities}" />
                                <button class="btn btn-success">Add another Entry</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

