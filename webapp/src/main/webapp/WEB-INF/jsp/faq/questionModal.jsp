<%-- 
    Document   : questionModal
    Created on : Jun 14, 2015, 4:33:33 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="/dspResources/js/faq/question.js"></script>

<div id="questionFormDiv">
    <div>
        <form:form id="questionForm" modelAttribute="question" role="form" class="form" method="post">
            <form:hidden path="id"/>
           <div class="form-group" id="cateogryIdDiv">
                <label for="timeFrom">Category</label>
                <form:select path="categoryId" class="form-control" name="categoryId" id="categoryId">
                        <c:forEach  var="category" items="${categories}">
                            <option value="${category.id}" <c:if test="${category.id == question.categoryId}"> selected </c:if>>${category.categoryName}</option>
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
        </form:form>
    </div>
</div>
