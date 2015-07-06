<%-- 
    Document   : completedSurvey
    Created on : Mar 11, 2015, 8:58:34 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main" rel="${iparam}" rel2="${vparam}">
    <div class="col-md-12">
        
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4>Completed Activity Log</h4>
            </div>
             <div class="panel-body pageQuestionsPanel">
                 You have completed the ${surveyDetails.title} activity log.
             </div>
        </div>
    </div>
</div>

