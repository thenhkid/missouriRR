<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
    <form:form id="postForm" modelAttribute="forumMessage" role="form" class="form" method="post">
       <form:hidden path="id" />
       <form:hidden path="topicId" />
       <form:hidden path="parentMessageId" />
       <div class="form-group" id="messageDiv">
            <label  class="control-label" for="message">Message *</label>
            <form:textarea path="message" class="form-control" id="message" rows="10" />
            <span id="messageMsg" class="control-label"></span>  
       </div>
    </form:form>
</div>
