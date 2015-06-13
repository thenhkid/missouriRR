<%-- 
    Document   : categoryModal
    Created on : Jun 9, 2015, 4:33:33 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div id="addCategoryForm">
    <div>
        <form:form id="categoryForm" modelAttribute="category" role="form" class="form" method="post">
            <form:hidden path="id" />
            <form:hidden path="programId" />
           <div class="form-group" id="categoryNameDiv">
                <label  class="control-label" for="categoryName">Category Name*</label>
                <form:input id="categoryName" path="categoryName" class="form-control" placeholder="Category Name" />
                <span id="categoryNameMsg" class="control-label"></span>  
           </div>
            
            <div class="form-group">
                 <label for="timeFrom">Display Position</label>
                <form:select path="displayPos" class="form-control" name="displayPos" id="displayPos">
                        <c:forEach  var="displayPosition" begin="1" end="${maxPos}" >
                            <option value="${displayPosition}" <c:if test="${displayPosition == category.displayPos}"> selected </c:if>>${displayPosition}</option>
                        </c:forEach>
                </form:select>
            </div>           
        </form:form>
    </div>
</div>
