<%-- 
    Document   : viewSurvey
    Created on : Mar 12, 2015, 12:31:00 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="qNum" value="0" scope="page" />
<div class="main clearfix" role="main" >
    
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
                                                                <input type="checkbox" class="selectedSchools" value="${school.schoolId}" disabled  /> ${school.schoolName}
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
