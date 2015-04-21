<%-- 
    Document   : survey
    Created on : Mar 5, 2015, 1:10:08 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        
        <div class="col-md-12">
            <c:if test="${not empty savedStatus}" >
                <div class="alert alert-success" role="alert">
                    <strong>Success!</strong> 
                    The client has been successfully updated!
                </div>
            </c:if>
        </div>
        
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
        <form:form id="survey" modelAttribute="survey" method="post" role="form">
           <input type="hidden" name="completedSurveyId" value="${survey.completedSurveyId}" />
           <input type="hidden" name="surveyId" value="${survey.surveyId}" /> 
           <input type="hidden" name="engagementId" value="${survey.engagementId}" /> 
           <input type="hidden" name="clientId" value="${survey.clientId}" /> 
           <input type="hidden" name="currentPage" value="${survey.currentPage}" />
           <input type="hidden" name="lastQNumAnswered" id="lastQNumAnswered" value="" />
           <input type="hidden" name="totalPages" value="${survey.totalPages}" />
           <input type="hidden" name="surveyTitle" value="${survey.surveyTitle}" />
           <input type="hidden" name="prevButton" value="${survey.prevButton}" />
           <input type="hidden" name="nextButton" value="${survey.nextButton}" />
           <input type="hidden" name="saveButton" value="${survey.saveButton}" />
           <input type="hidden" name="action" value="" id="action" />
           <input type="hidden" name="goToPage" value="0" id="goToPage" />
           
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4>${survey.pageTitle}</h4>
                </div>
                 <div class="panel-body pageQuestionsPanel">
                     <section>
                    <c:choose>
                        <c:when test="${not empty survey.surveyPageQuestions}">
                            <c:forEach var="question" items="${survey.surveyPageQuestions}" varStatus="q">
                                <input type="hidden" name="surveyPageQuestions[${q.index}].id" value="${question.id}" />
                                <input type="hidden" name="surveyPageQuestions[${q.index}].answerTypeId" value="${question.answerTypeId}" />
                                <input type="hidden" name="surveyPageQuestions[${q.index}].saveToFieldId" value="${question.saveToFieldId}" />
                                <input type="hidden" name="surveyPageQuestions[${q.index}].surveyPageId" value="${question.surveyPageId}" />
                                <input type="hidden" id="requiredMsg${question.id}" value="${question.requiredResponse}" />

                                <div class="questionDiv row form-group ${status.error ? 'has-error' : '' }" id="questionDiv${question.id}" rel="${question.id}" style="width: 98%; padding: 5px; margin-left: 5px; margin-bottom: 30px;">
                                    <div class="row" id="qNum${question.id}" style="width: 98%; padding: 5px; margin-left: 5px;">
                                        <c:if test="${question.answerTypeId != 7}"><c:set var="qNum" value="${qNum + 1}" scope="page"/>
                                           <h4 class="qNumber control-label" rel="${qNum}"><c:if test="${question.required == true}">*&nbsp;</c:if>${qNum}.&nbsp; ${question.question}</h4>
                                        </c:if>
                                    </div>
                                    <div class="row" style="width: 98%; padding: 5px; margin-left: 5px;">
                                        <c:choose>
                                            <c:when test="${question.answerTypeId == 7}">
                                                <div class="form-group">
                                                 ${question.question}
                                                </div>
                                            </c:when>
                                            <c:when test="${question.answerTypeId == 3}">
                                                <div class="form-group" >
                                                    <input type="text" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="3" name="surveyPageQuestions[${q.index}].questionValue" class="form-control ${question.validation.replace(' ','-')}  <c:if test="${question.required == true}">required</c:if>" type="text" maxLength="255" value="${question.questionValue}" />
                                                </div>
                                            </c:when>
                                            <c:when test="${question.answerTypeId == 1}">
                                                <c:choose>
                                                    <c:when test="${not empty question.questionChoices}">
                                                        <c:choose>
                                                            <c:when test="${question.choiceLayout == '1 Column'}">
                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                    <div class="form-group">
                                                                        <label class="radio">
                                                                            <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                        </label>
                                                                    </div>
                                                                 </c:forEach>   
                                                            </c:when>
                                                            <c:when test="${question.choiceLayout == '2 Columns'}">
                                                                <div class="row" style="width:500px;">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <div class="col-md-6">
                                                                            <label class="radio">
                                                                                <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                            </label>
                                                                        </div>
                                                                     </c:forEach>   
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${question.choiceLayout == '3 Columns'}">
                                                                <div class="row" style="width:650px;">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <div class="col-md-4">
                                                                            <label class="radio">
                                                                                <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                            </label>
                                                                        </div>
                                                                     </c:forEach>   
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${question.choiceLayout == 'Horizontal'}">
                                                                <div class="form-inline">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <label class="radio">
                                                                            <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                        </label>
                                                                     </c:forEach>   
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="form-group">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <label class="radio">
                                                                            <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                        </label>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>No Question Choices have been set up.</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                        </c:choose>
                                        <div id="errorMsg_${question.id}" style="display:none;" class="alert alert-danger" role="alert"></div> 
                                    </div>
                                </div> 
                            </c:forEach>
                        </c:when>
                    </c:choose>   
                     </section>
                </div>
            </div>
             <div style="padding-bottom: 20px; ">
                <div class="well well-sm text-center" style="border-style: dashed">
                    <div class="row center-block" style="width:500px;">
                        <c:choose>
                            <c:when test="${survey.currentPage == survey.totalPages}">
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-primary prevPage">
                                        <span class="glyphicon glyphicon-backward" aria-hidden="true"></span> <strong>${survey.prevButton}</strong>
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-primary completeSurvey">
                                        <strong>${survey.saveButton}</strong> <span class="glyphicon glyphicon-ok-sign" aria-hidden="true"></span>
                                    </button>
                                </div>
                            </c:when>
                            <c:when test="${survey.currentPage > 1}">
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-primary prevPage">
                                        <span class="glyphicon glyphicon-backward" aria-hidden="true"></span> <strong>${survey.prevButton}</strong>
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-primary nextPage">
                                        <strong>${survey.nextButton}</strong> <span class="glyphicon glyphicon-forward" aria-hidden="true"></span> 
                                    </button>
                                </div>    
                            </c:when>
                            <c:otherwise>
                                <div class="col-md-12">
                                    <button type="button" class="btn btn-primary nextPage">
                                        <strong>${survey.nextButton}</strong> <span class="glyphicon glyphicon-forward" aria-hidden="true"></span> 
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div> 
        </form:form>     
    </div>
</div>