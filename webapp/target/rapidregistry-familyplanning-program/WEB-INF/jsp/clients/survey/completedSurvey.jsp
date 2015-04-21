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
        
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4>Completed Survey</h4>
            </div>
             <div class="panel-body pageQuestionsPanel">
                 You have completed the ${surveyDetails.title} survey.
             </div>
        </div>
    </div>
</div>

