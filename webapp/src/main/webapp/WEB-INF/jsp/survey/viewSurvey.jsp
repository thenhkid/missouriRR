<%-- 
    Document   : viewSurvey
    Created on : Mar 12, 2015, 12:31:00 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">
    <div class="col-xs-12">
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
                                                                <input class="selectedSchools" name="form-field-checkbox" type="checkbox" class="ace" value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">checked="checked"</c:if> />
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
    </div>
</div>

<c:set var="qNum" value="0" scope="page" />
<div class="main clearfix" role="main" >

    <div class="col-md-12">

        <c:forEach var="page" items="${surveyPages}">
            <section class="panel panel-default">
                <div class="panel-heading">
                    <h4>${page.pageTitle}</h4>
                </div>
                <div class="panel-body pageQuestionsPanel">
                    <c:choose>
                        <c:when test="${not empty page.surveyQuestions}">
                            <c:forEach var="question" items="${page.surveyQuestions}" >
                                <div class="questionDiv row form-group" style="width: 98%; padding: 5px; margin-left: 5px; margin-bottom: 30px;">
                                    <div class="row" style="width: 98%; padding: 5px; margin-left: 5px;">

                                        <div class="pull-left">
                                            <c:if test="${question.answerTypeId != 7}">
                                                <c:set var="qNum" value="${qNum + 1}" scope="page"/>
                                                <h4 class="qNumber control-label" rel="${qNum}"><c:if test="${question.required == true}">*&nbsp;</c:if>${qNum}.&nbsp; ${question.question}</h4>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="row" style="width: 98%; padding: 5px; margin-left: 5px;">
                                        <c:choose>
                                            <c:when test="${question.answerTypeId == 7}">
                                                <div class="form-group">
                                                    ${question.question}
                                                </div>
                                            </c:when>
                                            <c:when test="${question.answerTypeId == 3}">
                                                <div class="form-group">
                                                    <input type="text" value="${question.questionValue}" class="form-control" type="text" maxLength="255" disabled style="background-color:#ffffff; width:750px;" />
                                                </div>
                                            </c:when>
                                            <c:when test="${question.answerTypeId == 5}">
                                                <div class="form-group">
                                                    <textarea class="form-control" disabled rows="8" style="background-color:#ffffff; width: 750px;">${question.questionValue}</textarea>
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
                                                                            <input type="radio" disabled="disabled" <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                    </label>
                                                                                </div>
                                                                </c:forEach>   
                                                            </c:when>
                                                            <c:when test="${question.choiceLayout == '2 Columns'}">
                                                                <div class="row" style="width:500px;">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <div class="col-md-4">
                                                                            <label class="radio">
                                                                                <input type="radio" disabled="disabled" <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
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
                                                                                <input type="radio" disabled="disabled" <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                        </label>
                                                                                    </div>
                                                                    </c:forEach>   
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${question.choiceLayout == 'Horizontal'}">
                                                                <div class="form-inline">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <label class="radio">
                                                                            <input type="radio" disabled="disabled" <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
                                                                                    </label>
                                                                    </c:forEach>   
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="form-group">
                                                                    <c:forEach items="${question.questionChoices}" var="choiceDetails">
                                                                        <label class="radio">
                                                                            <input type="radio" disabled="disabled" <c:choose><c:when test="${choiceDetails.choiceValue > 0}"><c:if test="${choiceDetails.choiceValue == question.questionValue}">checked="true"</c:if></c:when><c:otherwise><c:if test="${choiceDetails.choiceText == question.questionValue}">checked="true"</c:if></c:otherwise></c:choose> /> ${choiceDetails.choiceText}
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
                                                <c:if test="${question.otherOption == true && question.otherDspChoice == 2}">
                                                    <div class="form-group" ${question.answerTypeId == 1 ? 'style="margin-left:22px; padding-top:10px;"' : ''}>
                                                        <p>${question.otherLabel}</p>
                                                        <input type="text" class="form-control" value="${question.questionOtherValue}" disabled style="background-color:#ffffff; width:500px;" />
                                                    </div>
                                                </c:if> 
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>    
                            </c:forEach>
                        </c:when>
                    </c:choose>
                </div>
            </section>
        </c:forEach>
    </div>
</div>
