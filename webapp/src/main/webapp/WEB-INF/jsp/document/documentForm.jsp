<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
    <form:form id="documentForm" modelAttribute="documentDetails" action="/documents/saveDocuemntForm.do" role="form" class="form" method="post" enctype="multipart/form-data">
        <form:hidden path="id" id="documentId" />
        <form:hidden path="dateCreated" />
        <form:hidden path="systemUserId" />
        <form:hidden path="uploadedFile" id="uploadedFile" />
        <c:choose>
            <c:when test="${sessionScope.userDetails.roleId == 2}">

                <c:if test="${not empty documentfolder}">
                    <div class="form-group">
                        <label for="folderId" class="control-label">Save this document to the following folder:</label>
                        <form:select path="folderId" class="form-control" >
                            <c:forEach items="${documentfolder}" var="folders">
                                <option value="${folders.id}" <c:if test="${documentDetails.folderId == folders.id}">selected</c:if>>${folders.folderName}</option>
                                <c:if test="${not empty folders.subfolders}">
                                    <c:forEach items="${folders.subfolders}" var="subfolder">
                                        <option value="${subfolder.id}" style="padding-left:15px" <c:if test="${documentDetails.folderId == subfolder.id}">selected</c:if>>${subfolder.folderName}</option>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                        </form:select>
                    </div>
                </c:if>

                <div class="form-group">
                    <label for="adminOnly" class="control-label">Admin Only Document? *</label>
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
            <c:otherwise><form:hidden path="folderId" /><form:hidden path="adminOnly" /></c:otherwise>
        </c:choose>
        
        <div class="form-group">
            <label for="privateDoc" class="control-label">Is this document private to you? *</label>
            <div>
                <label class="radio-inline">
                    <form:radiobutton path="privateDoc"  value="1"/> Yes
                </label>
                <label class="radio-inline">
                    <form:radiobutton path="privateDoc" value="0"/> No
                </label>
            </div>
        </div>
        <div class="form-group" id="titleDiv">
            <label  class="control-label" for="title">Document Title *</label>
            <form:input path="title" class="form-control" id="title" maxlength="255" />
            <span id="titleMsg" class="control-label"></span>  
        </div>
        <div class="form-group" id="docDescDiv">
            <label  class="control-label" for="message">Document Description *</label>
            <form:textarea path="docDesc" class="form-control" id="docDesc" rows="10" />
            <span id="docDescMsg" class="control-label"></span>  
        </div>
        <div class="form-group" id="webLinkDiv">
            <label  class="control-label" for="webLink">External Web Link</label>
            <form:input path="externalWebLink" class="form-control" id="webLink" maxlength="255" />
            <span id="webLinkMsg" class="control-label"></span>  
        </div>
        <c:if test="${not empty documentDetails.uploadedFile}">
            <div>
                <hr/>
                <div class="form-group">
                    <label for="document1">Uploaded Document</label>
                    <div class="input-group" id="docDiv">
                        <span class="input-group-addon">
                            <c:choose>
                                <c:when test="${documentDetails.fileExt == 'pdf'}"><i class="fa fa-file-pdf-o bigger-110 orange"></i></c:when>
                                <c:when test="${documentDetails.fileExt == 'doc' || documentDetails.fileExt == 'docx'}"><i class="fa fa-file-word-o bigger-110 orange"></i></c:when>
                                <c:when test="${documentDetails.fileExt == 'xls' || documentDetails.fileExt == 'xlsx'}"><i class="fa fa-file-excel-o bigger-110 orange"></i></c:when>
                                <c:when test="${documentDetails.fileExt == 'txt'}"><i class="fa fa-file-text-o bigger-110 orange"></i></c:when>
                                <c:when test="${documentDetails.fileExt == 'jpg' || documentDetails.fileExt == 'gif' || documentDetails.fileExt == 'jpeg'}"><i class="fa fa-file-image-o bigger-110 orange"></i></c:when>
                            </c:choose>
                        </span>
                        <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${documentDetails.title}" placeholder="${documentDetails.title}"></input>
                    </div>
                </div>
            </div>
        </c:if>
        <div class="form-group" id="docDiv">
            <hr/>
            <label class="control-label" for="question">Associated Document</label>
            <input name="postDocuments" type="file" id="id-input-file-2" />
            <span id="docMsg" class="control-label"></span>
        </div>     
        <c:if test="${documentDetails.id == 0}">
            <hr/>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label">New Document Email Alert</label>
                        <div class="checkbox">
                            <label>
                                <c:if test="${documentDetails.countyFolder == true}">
                                    <input type="radio" name="alertUsers" value="1"> Send email regarding this new document to users of the selected county?<br />
                                </c:if>
                                <input type="radio" name="alertUsers" value="2"> Send email regarding this new document to all users?
                            </label>
                        </div>
                    </div>
                </div>    
            </div> 
        </c:if>
    </form:form>
</div>
