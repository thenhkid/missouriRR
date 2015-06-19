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
               <c:import url="qDocumentInc.jsp"></c:import> 
               <div class="row">
                    <hr/>
                    <label for="document1">New Documents</label>
               </div>
               <div class="row">
                <div class="form-group">         
                    <div class="form-group">
                        <div class="col-lg-12">
                            <input  multiple="" name="faqDocuments" type="file" id="id-input-file-2" />
                        </div>
                    </div>
                </div>
            </div>
            </form:form>
        </div>
    </div>
</div>