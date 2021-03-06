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
            <input type="hidden" name="submittedSurveyId" id="submittedSurveyId" value="${survey.submittedSurveyId}" />
            <input type="hidden" name="surveyId" value="${survey.surveyId}" /> 
            <input type="hidden" name="engagementId" value="${survey.engagementId}" /> 
            <input type="hidden" name="clientId" value="${survey.clientId}" /> 
            <input type="hidden" name="currentPage" id="currentPage" value="${survey.currentPage}" />
            <input type="hidden" name="lastQNumAnswered" id="lastQNumAnswered" value="1" />
            <input type="hidden" name="totalPages" value="${survey.totalPages}" />
            <input type="hidden" name="surveyTitle" value="${survey.surveyTitle}" />
            <input type="hidden" name="prevButton" value="${survey.prevButton}" />
            <input type="hidden" name="nextButton" value="${survey.nextButton}" />
            <input type="hidden" name="saveButton" value="${survey.saveButton}" />
            <input type="hidden" name="action" value="" id="action" />
            <input type="hidden" name="goToPage" value="0" id="goToPage" />
            <input type="hidden" name="selectedEntities" value="${selectedEntities}" />
            <input type="hidden" id="disabled" name="disabled" value="${disabled}" />
            <input type="hidden" name="pageId" value="${survey.pageId}" />
            <input type="hidden" name="currPageNum" value="${currPageNum}" />

            <div class="row">
                <div class="col-sm-5">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">What school(s) / ECC were involved?</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <%--<select id="schoolSelect" name="entityIds" class="multiselect form-control <c:if test="${disabled == true}">disabled</c:if>" multiple="">
                                        <c:forEach items="${selDistricts}" var="district">
                                            <optgroup label="${district.districtName}">
                                                <c:forEach items="${district.schoolList}" var="school">
                                                    <option value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">selected</c:if>>${school.schoolName}</option>
                                                </c:forEach>
                                            </optgroup>
                                        </c:forEach>
                                    </select>--%>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <c:forEach items="${selDistricts}" var="district">
                                            <optgroup label="${district.districtName}">
                                                <c:forEach items="${district.schoolList}" var="school">
                                                    <option value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">selected</c:if>>${school.schoolName}</option>
                                                </c:forEach>
                                            </optgroup>
                                        </c:forEach>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
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
                            <div class="widget-main no-padding" id="contentAndCriteriaDiv" style="max-height:200px; overflow: auto">
                                <table class="table table-striped table-bordered table-hover">
                                    <thead class="thin-border-bottom">
                                        <tr>
                                            <th></th>
                                            <th>
                                                <i class="ace-icon fa fa-building"></i>
                                                School / ECC
                                            </th>
                                            <th>Content Area</th>
                                            <th>Criteria</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div id="errorMsg_content" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
                </div><!-- /.span -->
            </div><!-- /.row -->

            <div class="hr hr-24"></div>

            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                        ${survey.pageTitle}
                    </h4>
                    <h6 class="smaller">
                        ${survey.pageDesc}
                    </h6>
                </div>

                <div class="widget-body">
                    <div class="widget-main">
                        <div id="fuelux-wizard-container">

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
                                                <input type="hidden" name="surveyPageQuestions[${q.index}].relatedQuestionId" value="${question.relatedQuestionId}" />

                                                <div id="questionOuterDiv_${question.id}">
                                                    <c:choose>
                                                        <c:when test="${question.answerTypeId != 7}">
                                                            <c:set var="qNum" value="${qNum + 1}" scope="page"/>
                                                            <div class="row">
                                                                <div class="qNumber pull-left col-xs-pull-0" rel="${qNum}">${qNum}.&nbsp;</div>
                                                                <div class="pull-left col-xs-11">
                                                                    <div class="row">
                                                                       ${question.question}<c:if test="${question.required == true}">&nbsp;*&nbsp;</c:if><c:if test="${question.answerTypeId == 1 && question.allowMultipleAns == true}"> (Check all that apply)</c:if>
                                                                    </div>
                                                                    <div class="row" style="margin-top:5px;">
                                                                        <c:choose>
                                                                            <%-- Text Box --%>
                                                                            <c:when test="${question.answerTypeId == 3}">
                                                                                <input qnum="${qNum}" type="text" <c:if test="${disabled == true}">readonly</c:if> rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="3" name="surveyPageQuestions[${q.index}].questionValue" class="form-control ${question.validation.replace(' ','-')}  ${question.required == true ? ' required' : '' }" type="text" maxLength="255" value="${question.questionValue}" />
                                                                            </c:when>
                                                                            <%-- Comment Box --%>    
                                                                            <c:when test="${question.answerTypeId == 5}">
                                                                                <textarea qnum="${qNum}" <c:if test="${disabled == true}">readonly</c:if> class="form-control ${question.validation.replace(' ','-')} ${question.required == true ? ' required' : '' }" name="surveyPageQuestions[${q.index}].questionValue" rows="8" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="5" style="background-color:#ffffff; width: 750px;">${question.questionValue}</textarea>
                                                                            </c:when>  
                                                                            <%-- Select Box --%>    
                                                                            <c:when test="${question.answerTypeId == 2}">
                                                                                <select qnum="${qNum}" <c:if test="${disabled == true}">disabled</c:if> rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="2" class="form-control ${question.required == true ? ' required' : '' }" name="surveyPageQuestions[${q.index}].questionValue" style="background-color:#ffffff; width: 750px;">
                                                                                    <option value="">- Select an Answer -</option>
                                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                        <option value="${choiceDetails.id}" <c:choose><c:when test="${choiceDetails.choiceValue > 0 && question.questionValue.matches('[0-9]+')}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">selected="selected"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">selected="selected"</c:if></c:otherwise></c:choose>>${choiceDetails.choiceText}</option>
                                                                                    </c:forEach>
                                                                                </select>
                                                                            </c:when> 
                                                                            <%-- Date/Time Field --%>    
                                                                            <c:when test="${question.answerTypeId == 6}">
                                                                                <c:choose>
                                                                                    <%-- Single Date --%>
                                                                                    <c:when test="${question.dateType == 1}">
                                                                                        <div class="input-group">
                                                                                            <input qnum="${qNum}" <c:if test="${disabled == true}">readonly</c:if> class="form-control ${disabled == false ? ' date-picker' : '' } ${question.required == true ? ' required' : '' } Date" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="6" id="id-date-picker-1" type="text" name="surveyPageQuestions[${q.index}].questionValue" data-date-format="${question.dateFormatType == 2 ? 'dd/mm/yyyy' : 'mm/dd/yyyy' }" value="${question.questionValue}" />
                                                                                            <span class="input-group-addon">
                                                                                                <i class="fa fa-calendar bigger-110"></i>
                                                                                            </span>
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <%-- Date Range --%>
                                                                                    <c:when test="${question.dateType == 2}">
                                                                                        <input type="hidden" ${question.required == true ? 'class="required"' : '' } rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="6" id="multiAns_${question.id}" name="surveyPageQuestions[${q.index}].questionValue" value="${question.questionValue}" />
                                                                                        <c:set var="dateParts" value="${fn:split(question.questionValue,'^^^^^')}" />
                                                                                        <div class="input-daterange input-group">
                                                                                            <input qnum="${qNum}" type="text" <c:if test="${disabled == true}">readonly</c:if> class="multiAns input-sm form-control" rel="${question.id}" value="${dateParts[0]}" />
                                                                                            <span class="input-group-addon">
                                                                                                <i class="fa fa-arrow-right"></i>
                                                                                            </span>
                                                                                            <input type="text" <c:if test="${disabled == true}">readonly</c:if> class="multiAns input-sm form-control" rel="${question.id}" value="${dateParts[1]}" />
                                                                                        </div>
                                                                                    </c:when>     
                                                                                    <%-- Time Only --%>    
                                                                                    <c:otherwise>            
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:when> 
                                                                            <%-- Multiple Choice Box --%>
                                                                            <c:when test="${question.answerTypeId == 1}">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty question.questionChoices}">
                                                                                        <c:choose>
                                                                                            <c:when test="${question.choiceLayout == 'Horizontal'}">
                                                                                                <div class="form-inline">
                                                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                                        <label style="padding-right:10px;">
                                                                                                            <c:choose>
                                                                                                                <c:when test="${question.allowMultipleAns == true}">
                                                                                                                    <input qnum="${qNum}" type="checkbox" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0 && fn:split(question.questionValue,',')[0].matches('[0-9]+')}"><c:if test="${fn:contains(question.questionValue, choiceDetails.choiceValue)}">checked="true"</c:if></c:when><c:otherwise><c:if test="${fn:contains(question.questionValue, choiceDetails.choiceText)}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                 <input qnum="${qNum}" type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0 && fn:split(question.questionValue,',')[0].matches('[0-9]+')}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </label>
                                                                                                    </c:forEach>   
                                                                                                </div>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                                                    <div class="col-xs-12 col-sm-6" style="margin-bottom:3px;">
                                                                                                        <div class="pull-left col-xs-pull-0">
                                                                                                            <c:choose>
                                                                                                                <c:when test="${question.allowMultipleAns == true}">
                                                                                                                 <input qnum="${qNum}" type="checkbox" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0 && fn:split(question.questionValue,',')[0].matches('[0-9]+')}"><c:if test="${fn:contains(question.questionValue, choiceDetails.choiceValue)}">checked="true"</c:if></c:when><c:otherwise><c:if test="${fn:contains(question.questionValue, choiceDetails.choiceText)}">checked="true"</c:if></c:otherwise></c:choose> />
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <input qnum="${qNum}" type="radio" <c:if test="${disabled == true}">disabled</c:if> value="${choiceDetails.id}" rel="${question.id}" rel2="surveyPageQuestions[${q.index}].questionValue" rel3="1" name="surveyPageQuestions[${q.index}].questionValue" <c:if test="${question.required == true}">class="required"</c:if> <c:choose><c:when test="${choiceDetails.choiceValue > 0 && fn:split(question.questionValue,',')[0].matches('[0-9]+')}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> />
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </div>
                                                                                                        <div class="pull-left col-xs-11">
                                                                                                            ${choiceDetails.choiceText}
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </c:forEach> 
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
                                                                        <div class="row" style="margin-top:5px;">
                                                                            <p>${question.otherLabel}</p>
                                                                            <input qnum="${qNum}" type="text" class="form-control" <c:if test="${disabled == true}">readonly</c:if> name="surveyPageQuestions[${q.index}].questionOtherValue" value="${question.questionOtherValue}" style="background-color:#ffffff; width:500px;" />
                                                                        </div>
                                                                    </c:if> 
                                                                 </div>
                                                            </div>
                                                            <div id="errorMsg_${question.id}" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                                                            <div class="row pull-left col-xs-12 hr"></div>
                                                        </c:when>
                                                        <c:when test="${question.answerTypeId == 7}">
                                                            <div class="row col-xs-12">
                                                                 ${question.question}
                                                            </div>
                                                            <div class="row pull-left col-xs-12 space-10"></div>  
                                                        </c:when>    
                                                    </c:choose>
                                                </div>
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
                                                <c:when test="${survey.pageId == survey.lastPageId}">
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

