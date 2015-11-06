<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="/dspResources/js/document/folderForm.js"></script>

<div>
    <form:form id="folderForm" modelAttribute="folderDetails" action="/documents/saveFolderForm.do" role="form" class="form" method="post" >
        <form:hidden path="id" id="folderId"/>
        <form:hidden path="dateCreated" />
        <form:hidden path="systemUserId" />
        <form:hidden path="currentFolderName" />
        <form:hidden path="parentFolderId" id="parentFolderId"/>
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
                <div class="form-group">
                    <label for="readOnly" class="control-label">Permissions *</label>
                    <div>
                        <label class="radio-inline">
                            <form:radiobutton path="readOnly"  value="1"/> User Read Only
                        </label>
                        <label class="radio-inline">
                            <form:radiobutton path="readOnly" value="0"/> User Read / Write
                        </label>
                    </div>
                </div>
            </c:when>
            <c:otherwise><form:hidden path="adminOnly" /><form:hidden path="readOnly" /></c:otherwise>
        </c:choose>

        <div class="form-group" id="folderNameDiv">
            <label  class="control-label" for="title">Folder Name *</label>
            <form:input path="folderName" class="form-control" id="folderName" maxlength="45" />
            <span id="folderNameMsg" class="control-label"></span>  
        </div>
        <%-- only if not a sub folder --%>    
        <c:choose>
            <c:when test="${sessionScope.userDetails.roleId == 2 && folderDetails.entityId == 0}">
                <div class="form-group">
                    <label for="countyFolder" class="control-label">Is this a County Folder? *</label>
                    <div>
                        <label class="radio-inline">
                            <form:radiobutton path="countyFolder" id="isCountyFolder" class="countyRadio" value="1"/> Yes
                        </label>
                        <label class="radio-inline">
                            <form:radiobutton path="countyFolder" id="isNotCountyFolder" class="countyRadio" value="0"/> No
                        </label>
                    </div>
                </div>
                <%-- if yes we show this drop down --%>
                <div class="form-group" style="display:none;" id="entityDropDown">
                        <label for="entityId" class="control-label">Which county is folder associated with:</label>
                        <form:select path="entityId" id="entityId" class="form-control" >
                            <c:forEach items="${countyList}" var="county">
                                <option value="${county.id}" <c:if test="${county.id == folderDetails.entityId}">selected</c:if>>${county.name}</option>                               
                            </c:forEach>
                        </form:select>
                </div>
                
            </c:when>
            <c:otherwise>
                <form:hidden path="countyFolder" />
                <form:hidden path="entityId" />
            </c:otherwise>
        </c:choose>    
            
    </form:form>
</div>
