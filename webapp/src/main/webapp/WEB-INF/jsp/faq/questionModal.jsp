<%-- 
    Document   : questionModal
    Created on : Jun 14, 2015, 4:33:33 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="/dspResources/js/faq/question.js"></script>

<div class="popover-content">
    <div id="questionFormDiv" class="page-content">
        <div>
            <form:form id="questionForm" modelAttribute="question" role="form" class="form" method="post"  enctype="multipart/form-data">
                <form:hidden path="id"/>
                <div class="form-group" id="cateogryIdDiv">
                    <label for="timeFrom">Select a Category</label>
                    <form:select path="categoryId" class="form-control" name="categoryId" id="categoryId" rel="${question.id}">
                        <c:forEach  var="category" items="${categories}">
                            <option value="${category.id}" <c:if test="${category.id == activeCat}"> selected </c:if>>${category.categoryName}</option>
                        </c:forEach>
                    </form:select>
                </div>  

                <div class="form-group" id="questionDiv">
                    <label  class="control-label" for="question">Question*</label>
                    <form:input id="question" path="question" class="form-control" placeholder="Question" />
                    <span id="questionMsg" class="control-label"></span>  
                </div>
                <div class="form-group" id="answerDiv">
                    <label  class="control-label" for="answer">Answer*</label>
                    <form:textarea id="answer" path="answer" class="form-control" placeholder="Answer" />
                    <span id="answerMsg" class="control-label"></span>  
                </div> 
                <c:import url="qDisplayPos.jsp"></c:import> 
                <c:if test="${not empty documentList}">
                    <div>
                        <hr/>
                        <div class="form-group">
                            <label for="document1">Uploaded Documents</label>
                            <c:forEach var="document" items="${documentList}">
                                <div class="input-group" id="docDiv_${document.id}">
                                    <span class="input-group-addon">
                                        <i class="fa fa-file bigger-110 orange"></i>
                                    </span>
                                    <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${document.documentTitle}"></input>
                                    <span class="input-group-addon">
                                        <a href="javascript:void(0)" class="deleteDocument" rel="${document.id}"><i class="fa fa-times bigger-110 red"></i></a>
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <div class="form-group">
                    <hr/>
                    <label  class="control-label" for="question">Associated Documents</label>
                    <input  multiple="" name="faqDocuments" type="file" id="id-input-file-2" />
                </div>
            </form:form>
        </div>
    </div>
</div>