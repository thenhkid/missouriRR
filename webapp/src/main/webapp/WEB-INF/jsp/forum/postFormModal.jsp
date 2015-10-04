<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
    <form:form id="postForm" modelAttribute="forumMessage" role="form" class="form" method="post" enctype="multipart/form-data">
        <form:hidden path="id" />
        <form:hidden path="topicId" />
        <form:hidden path="parentMessageId" />
        <div class="form-group" id="messageDiv">
            <label  class="control-label" for="message">Message *</label>
            <form:textarea path="message" class="form-control" id="message" rows="10" />
            <span id="messageMsg" class="control-label"></span>  
        </div>
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
            <input  multiple="" name="postDocuments" type="file" id="id-input-file-2" />
        </div>     
    </form:form>
</div>
