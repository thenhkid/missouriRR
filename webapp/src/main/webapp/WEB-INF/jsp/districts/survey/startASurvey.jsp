<%-- 
    Document   : startASurvey
    Created on : Mar 5, 2015, 11:41:21 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="panel-title">Start A Survey</h3>
        </div>
        <div class="modal-body">
            <div class="form-container">
                <div class="form-group">
                    <label class="control-label" for="state">Surveys *</label>
                    <select name="survey" class="form-control startSurvey">
                        <option value="">- Select A Survey -</option>
                        <c:forEach var="survey" items="${availableSurveys}">
                            <option value="${survey.id}" rel="${survey.requireEngagement}"  rel2="${survey.allowEngagement}" rel3="${survey.duplicatesAllowed}">${survey.title}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <input style="display:none;" type="button" role="button" class="btn btn-primary startSurveyBtn" value="Start Survey"/>
                </div>
            </div>
        </div> 
    </div>
</div>
