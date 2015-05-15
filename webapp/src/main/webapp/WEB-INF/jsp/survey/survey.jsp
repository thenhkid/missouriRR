<%-- 
    Document   : survey
    Created on : Mar 5, 2015, 1:10:08 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="main clearfix" role="main">
    
    <form:form id="survey" modelAttribute="survey" method="post" action="submitSurvey" role="form">
       <input type="hidden" name="submittedSurveyId" value="${survey.submittedSurveyId}" />
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
       <input type="hidden" name="entityIds" value="${survey.entityIds}" id="entityList" />
       <input type="hidden" name="selectedDistricts" value="${selectedEntities}" />
       
       <div class="col-md-12 col-md-offset-1">
          
           <div class="content">
               <div class="row">
                   <div class="col-md-5">
                        <section class="panel panel-default">

                            <div class="panel-body">
                                <h4>What school(s) / Districts were involved?</h4>
                                <div id="errorMsg_schools" style="display:none;" class="alert alert-danger" role="alert"></div>
                                <div style="height:150px; overflow: auto;">
                                    <c:forEach items="${selDistricts}" var="district">
                                        <div class="form-group">
                                            <div class="row" style="margin-left:20px;"><span class="text-warning">${district.districtName}</span></div>
                                            
                                            <c:if test="${not empty district.schoolList}">
                                                <div class="row">
                                                    <c:forEach items="${district.schoolList}" var="school">
                                                        <div class="col-md-4">
                                                            <label class="radio">
                                                                <input type="checkbox" class="selectedSchools" value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">checked="checked"</c:if> /> ${school.schoolName}
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                     </c:forEach> 
                                </div>
                            </div>
                        </section>
                    </div>
           
                    <div class="col-md-5">
                        <section class="panel panel-default">

                            <div class="panel-body">
                                <h4>Content Area & Criteria</h4>
                            </div>

                        </section>
                    </div>
               </div>
           </div>
            
       </div>

        <div class="col-md-12">
            <section class="panel panel-default">
                <div class="panel-heading">
                    <h4>${survey.pageTitle}</h4>
                </div>
                <div class="panel-body pageQuestionsPanel">
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
                                                    <input type="text" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="3" name="surveyPageQuestions[${q.index}].questionValue" class="form-control ${question.validation.replace(' ','-')}  ${question.required == true ? ' required' : '' }" type="text" maxLength="255" value="${question.questionValue}" />
                                                </div>
                                            </c:when>
                                            <c:when test="${question.answerTypeId == 5}">
                                                <div class="form-group">
                                                    <textarea class="form-control ${question.validation.replace(' ','-')}  ${question.required == true ? ' required' : '' }" name="surveyPageQuestions[${q.index}].questionValue" rows="8" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="5" style="background-color:#ffffff; width: 750px;">${question.questionValue}</textarea>
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
                                                                <div class="row" style="width:750px;">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <div class="col-md-4">
                                                                            <label class="radio">
                                                                                <input type="radio" value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
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
                                        <c:if test="${question.otherOption == true && question.otherDspChoice == 2}">
                                            <div class="form-group" ${question.answerTypeId == 1 ? 'style="margin-left:22px; padding-top:10px;"' : ''}>
                                                <p>${question.otherLabel}</p>
                                                <input type="text" class="form-control"  name="surveyPageQuestions[${q.index}].questionOtherValue" value="${question.questionOtherValue}" style="background-color:#ffffff; width:500px;" />
                                            </div>
                                        </c:if>                 
                                        <div id="errorMsg_${question.id}" style="display:none;" class="alert alert-danger" role="alert"></div> 
                                    </div>
                                </div> 
                            </c:forEach>
                        </c:when>
                    </c:choose>   
                </div>
            </section>
        </div>

        <div class="col-md-12">
            <div style="padding-bottom: 20px; ">
                <div class="well well-sm text-center" style="border-style: dashed">
                    <div class="row center-block" style="width:500px;">
                        <div class="col-md-4">
                            <button type="button" class="btn btn-primary saveSurvey">
                                <strong>Save</strong> <span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span> 
                            </button>
                        </div>
                        <c:choose>
                            <c:when test="${survey.currentPage == survey.totalPages}">
                                <c:if test="${survey.currentPage != 1}">
                                    <div class="col-md-4">
                                        <button type="button" class="btn btn-primary prevPage">
                                            <span class="glyphicon glyphicon-backward" aria-hidden="true"></span> <strong>${survey.prevButton}</strong>
                                        </button>
                                    </div>
                                 </c:if>   
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-primary completeSurvey">
                                        <strong>${survey.saveButton}</strong> <span class="glyphicon glyphicon-ok-sign" aria-hidden="true"></span>
                                    </button>
                                </div>
                            </c:when>
                            <c:when test="${survey.currentPage > 1}">
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-primary prevPage">
                                        <span class="glyphicon glyphicon-backward" aria-hidden="true"></span> <strong>${survey.prevButton}</strong>
                                    </button>
                                </div>
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-primary nextPage">
                                        <strong>${survey.nextButton}</strong> <span class="glyphicon glyphicon-forward" aria-hidden="true"></span> 
                                    </button>
                                </div>    
                            </c:when>
                            <c:otherwise>
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-primary nextPage">
                                        <strong>${survey.nextButton}</strong> <span class="glyphicon glyphicon-forward" aria-hidden="true"></span> 
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
             </div>
        </div>

    </form:form>
</div>