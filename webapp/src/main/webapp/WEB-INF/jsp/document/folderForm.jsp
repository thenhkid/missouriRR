<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
    <form:form id="folderForm" modelAttribute="folderDetails" action="/documents/saveFolderForm.do" role="form" class="form" method="post" >
        <form:hidden path="id" />
        <form:hidden path="dateCreated" />
        <form:hidden path="systemUserId" />
        <form:hidden path="parentFolderId" />
        <form:hidden path="countyFolder" />
        <c:choose>
            <c:when test="${sessionScope.userDetails.roleId == 2}">
                <div class="form-group">
                    <label for="adminOnly" class="control-label">Admin Only Folder? *</label>
                    <div>
                        <label class="radio-inline">
                            <form:radiobutton path="adminOnly"  value="1"/> Yes
                        </label>
                        <label class="radio-inline">
                            <form:radiobutton path="adminOnly" value="0"/> No
                        </label>
                    </div>
                </div>
            </c:when>
            <c:otherwise><form:hidden path="adminOnly" /></c:otherwise>
        </c:choose>

        <div class="form-group" id="folderNameDiv">
            <label  class="control-label" for="title">Folder Name *</label>
            <form:input path="folderName" class="form-control" id="folderName" maxlength="45" />
            <span id="folderNameMsg" class="control-label"></span>  
        </div>
        
    </form:form>
</div>
