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

<div class="row">
    <div class="col-xs-12">

        <form:form class="form-horizontal" id="survey" modelAttribute="survey" method="post" action="submitSurvey" role="form">
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
            <input type="hidden" name="disabled" value="${disabled}" />


            <div class="row">
                <div class="col-sm-5">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">What school(s) were involved?</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div id="errorMsg_schools" style="display:none;" class="alert alert-danger" role="alert"></div>   
                            <div class="widget-main">
                                <div>
                                    <div class="row" style="max-height:200px; overflow: auto">
                                        <c:forEach items="${selDistricts}" var="district">
                                            <div class="col-xs-12 col-sm-5">
                                                <div class="control-group">
                                                    <label class="control-label bolder blue">${district.districtName}</label>

                                                    <c:if test="${not empty district.schoolList}">
                                                        <c:forEach items="${district.schoolList}" var="school">
                                                            <div class="checkbox">
                                                                <label>
                                                                    <input class="selectedSchools" name="form-field-checkbox" type="checkbox" class="ace" value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">checked="checked"</c:if> <c:if test="${disabled == true}">disabled</c:if>  />
                                                                    <span class="lbl"> ${school.schoolName}</span>
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </c:if>

                                                </div>
                                            </div>
                                        </c:forEach>  
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div><!-- /.span -->

                <div class="col-sm-7">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Content Area & Criteria</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->

            <div class="hr hr-24"></div>

            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">

                </div>

                <div class="widget-body">
                    <div class="widget-main">
                        <div id="fuelux-wizard-container">
                            <c:if test="${fn:length(surveyPages) > 1}">
                                <div>
                                    <ul class="steps">
                                        <c:forEach var="page" items="${surveyPages}">
                                            <li ${currentPage == page.pageNum? 'class="active"' : ''}>
                                                <span class="step">${page.pageNum}</span>
                                                <span class="title">${page.pageTitle}</span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>

                                <hr />
                            </c:if>

                            <div class="step-content pos-rel">
                                <div class="step-pane active">
                                    <c:choose>
                                        <c:when test="${not empty survey.surveyPageQuestions}">
                                            <c:forEach var="question" items="${survey.surveyPageQuestions}" varStatus="q">
                                                <input type="hidden" name="surveyPageQuestions[${q.index}].id" value="${question.id}" />
                                                <input type="hidden" name="surveyPageQuestions[${q.index}].answerTypeId" value="${question.answerTypeId}" />
                                                <input type="hidden" name="surveyPageQuestions[${q.index}].saveToFieldId" value="${question.saveToFieldId}" />
                                                <input type="hidden" name="surveyPageQuestions[${q.index}].surveyPageId" value="${question.surveyPageId}" />
                                                <input type="hidden" id="requiredMsg${question.id}" value="${question.requiredResponse}" />

                                                <div>
                                                    <c:if test="${question.answerTypeId != 7}">
                                                        <c:set var="qNum" value="${qNum + 1}" scope="page"/>
                                                        <label for="surveyPageQuestions[${q.index}].questionValue"><h5><c:if test="${question.required == true}">*&nbsp;</c:if>${qNum}.&nbsp; ${question.question}</h5></label>
                                                    </c:if>
                                                    <c:choose>
                                                        <c:when test="${question.answerTypeId == 7}">
                                                            ${question.question}
                                                        </c:when>
                                                        <c:when test="${question.answerTypeId == 3}">
                                                            <input type="text" <c:if test="${disabled == true}">readonly</c:if> rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="3" name="surveyPageQuestions[${q.index}].questionValue" class="form-control ${question.validation.replace(' ','-')}  ${question.required == true ? ' required' : '' }" type="text" maxLength="255" value="${question.questionValue}" />
                                                        </c:when>
                                                        <c:when test="${question.answerTypeId == 5}">
                                                            <textarea <c:if test="${disabled == true}">readonly</c:if> class="form-control ${question.validation.replace(' ','-')}  ${question.required == true ? ' required' : '' }" name="surveyPageQuestions[${q.index}].questionValue" rows="8" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="5" style="background-color:#ffffff; width: 750px;">${question.questionValue}</textarea>
                                                        </c:when> 
                                                        <c:when test="${question.answerTypeId == 1}">
                                                            <c:choose>
                                                                <c:when test="${not empty question.questionChoices}">
                                                                    <c:choose>
                                                                        <c:when test="${question.choiceLayout == '1 Column'}">
                                                                            <div class="row">
                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                    <div class="col-md-12">
                                                                                        <label>
                                                                                            <input type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                            </label>
                                                                                        </div>
                                                                                </c:forEach> 
                                                                            </div>    
                                                                        </c:when>
                                                                        <c:when test="${question.choiceLayout == '2 Columns'}">
                                                                            <div class="row">
                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                    <div class="col-md-2">
                                                                                        <label>
                                                                                            <input type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                            </label>
                                                                                        </div>
                                                                                </c:forEach>   
                                                                            </div>
                                                                        </c:when>
                                                                        <c:when test="${question.choiceLayout == '3 Columns'}">
                                                                            <div class="row">
                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                    <div class="col-md-4">
                                                                                        <label>
                                                                                            <input type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                            </label>
                                                                                        </div>
                                                                                </c:forEach>   
                                                                            </div>
                                                                        </c:when>
                                                                        <c:when test="${question.choiceLayout == 'Horiztonal'}">
                                                                            <div class="form-inline">
                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                    <label style="padding-right:10px;">
                                                                                        <input type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                        </label>
                                                                                </c:forEach>   
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="row">
                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                    <div class="col-md-12">
                                                                                        <label>
                                                                                            <input type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                            </label>
                                                                                        </div>
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
                                                </div>
                                                <c:if test="${question.otherOption == true && question.otherDspChoice == 2}">
                                                    <div  ${question.answerTypeId == 1 ? 'style="padding-top:10px;"' : ''}>
                                                        <p>${question.otherLabel}</p>
                                                        <input type="text" class="form-control" <c:if test="${disabled == true}">readonly</c:if> name="surveyPageQuestions[${q.index}].questionOtherValue" value="${question.questionOtherValue}" style="background-color:#ffffff; width:500px;" />
                                                        </div>
                                                </c:if>      
                                                <div id="errorMsg_${question.id}" style="display:none;" class="alert alert-danger" role="alert"></div>   
                                                <hr />
                                            </c:forEach>
                                        </c:when>
                                    </c:choose>

                                    <div class="wizard-actions">
                                        <c:if test="${disabled == false}">
                                            <button class="btn btn-prev saveSurvey">
                                                <i class="ace-icon fa fa-save"></i>
                                                Save
                                            </button>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${survey.currentPage == survey.totalPages}">
                                                <c:if test="${survey.currentPage != 1}">
                                                    <button class="btn btn-prev prevPage">
                                                        <i class="ace-icon fa fa-arrow-left"></i>
                                                        ${survey.prevButton}
                                                    </button>
                                                </c:if>  
                                                <c:if test="${disabled == false}">
                                                    <button class="btn btn-success completeSurvey" data-last="Finish">
                                                        ${survey.saveButton}
                                                        <i class="ace-icon fa fa-check-circle icon-on-right"></i>
                                                    </button>
                                                </c:if>    
                                            </c:when>
                                            <c:when test="${survey.currentPage > 1}">
                                                <button class="btn btn-prev prevPage">
                                                    <i class="ace-icon fa fa-arrow-left"></i>
                                                    ${survey.prevButton}
                                                </button>
                                                <button class="btn btn-success btn-next nextPage" data-last="Finish">
                                                    ${survey.nextButton}
                                                    <i class="ace-icon fa fa-arrow-right icon-on-right"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-success btn-next nextPage" data-last="Finish">
                                                    ${survey.nextButton}
                                                    <i class="ace-icon fa fa-arrow-right icon-on-right"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
</div>

