<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div>
    <form:form id="topicForm" modelAttribute="forumTopic" role="form" class="form" method="post">
        <form:hidden path="id" id="topicId" />
        <form:hidden path="totalViews" />
        <form:hidden path="topicURL" />
        <div class="form-group" id="entityDiv">
            <label for="whichEntity" class="control-label">Select the ${topLevelName} this topic will be posted to *</label>
            <div>
                <label class="radio-inline">
                    <form:radiobutton path="whichEntity"  value="1" class="whichEntity" />All Counties
                </label>
                <label class="radio-inline">
                    <form:radiobutton path="whichEntity" value="2" class="whichEntity" />Select County
                </label>
            </div>
            <span id="entityMsg" class="control-label"></span>
        </div>
        <div class="form-group" id="entitySelectList" <c:if test="${forumTopic.whichEntity == 1}">style="display:none;"</c:if>>
           <select name="selectedEntities" class="multiselect form-control" id="entityIds" multiple="">
                <c:forEach items="${countyList}" var="county">
                    <option value="${county.id}" <c:if test="${fn:contains(forumTopic.forumTopicEntities, county.id)}">selected</c:if>>${county.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="timeFrom" class="control-label">Topic Type *</label>
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
