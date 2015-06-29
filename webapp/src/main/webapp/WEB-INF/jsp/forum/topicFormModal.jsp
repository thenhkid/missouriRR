<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
    <form:form id="topicForm" modelAttribute="forumTopic" role="form" class="form" method="post">
        <form:hidden path="id" id="topicId" />
        <form:hidden path="totalViews" />
        <form:hidden path="topicURL" />
        <div class="form-group">
            <label for="timeFrom">Topic Type *</label>
            <form:select path="type" class="form-control" >
                <c:if test="${sessionScope.userDetails.roleId == 2}"><option value="1" <c:if test="${1 == forumTopic.type}"> selected </c:if>>Announcement</option></c:if>
                <option value="2" <c:if test="${2 == forumTopic.type}"> selected </c:if>>Regular Topic</option>
            </form:select>
        </div> 
        <div class="form-group" id="titleDiv">
            <label  class="control-label" for="title">Topic Title *</label>
            <form:input path="title" class="form-control" id="title" maxlength="50" />
            <span id="titleMsg" class="control-label"></span>  
        </div>
        <c:if test="${forumTopic.id == 0}">
            <div class="form-group" id="messageDiv">
                <label  class="control-label" for="message">Message *</label>
                <form:textarea path="initialMessage" class="form-control" id="message" rows="10" />
                <span id="messageMsg" class="control-label"></span>  
            </div>
        </c:if>
    </form:form>
</div>
