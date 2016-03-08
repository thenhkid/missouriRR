<%-- 
    Document   : postFormModal
    Created on : Jun 26, 2015, 11:09:32 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="page-content" style="padding:0;max-height: 500px; overflow: auto">
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
                                        <c:if test="${not empty subfolder.subfolders}">
                                            <c:forEach items="${subfolder.subfolders}" var="subsubfolder">
                                                <option value="${subsubfolder.id}" style="padding-left:25px" <c:if test="${documentDetails.folderId == subsubfolder.id}">selected</c:if>>${subsubfolder.folderName}</option>
                                            </c:forEach>
                                        </c:if>
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
        <c:if test="${not empty documentFiles}">
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="document1">Uploaded Documents</label>
                        <c:forEach var="document" items="${documentFiles}">
                            <div class="input-group uploadedDocuments" id="docDiv_${document.id}">
                                <span class="input-group-addon">
                                    <c:choose>
                                        <c:when test="${document.fileExt == 'pdf'}"><i class="fa fa-file-pdf-o bigger-110 orange"></i></c:when>
                                        <c:when test="${document.fileExt == 'doc' || document.fileExt == 'docx'}"><i class="fa fa-file-word-o bigger-110 orange"></i></c:when>
                                        <c:when test="${document.fileExt == 'xls' || document.fileExt == 'xlsx'}"><i class="fa fa-file-excel-o bigger-110 orange"></i></c:when>
                                        <c:when test="${document.fileExt == 'txt'}"><i class="fa fa-file-text-o bigger-110 orange"></i></c:when>
                                        <c:when test="${document.fileExt == 'jpg' || document.fileExt == 'gif' || document.fileExt == 'jpeg'}"><i class="fa fa-file-image-o bigger-110 orange"></i></c:when>
                                    </c:choose>
                                </span>
                                <c:choose>
                                    <c:when test="${fn:length(document.uploadedFile) > 20}">
                                        <c:set var="index" value="${document.uploadedFile.lastIndexOf('.')}" />
                                        <c:set var="trimmedDocumentExtension" value="${fn:substring(document.uploadedFile,index+1,fn:length(document.uploadedFile))}" />
                                        <c:set var="trimmedDocumentTitle" value="${fn:substring(document.uploadedFile, 0, 20)}...${trimmedDocumentExtension}" />

                                        <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" placeholder="${trimmedDocumentTitle}"></input>
                                    </c:when>
                                    <c:otherwise>
                                         <c:set var="trimmedDocumentTitle" value="${document.uploadedFile}" />
                                        <input id="" readonly="" class="form-control active" type="text" name="date-range-picker"  placeholder="${trimmedDocumentTitle}"></input>
                                    </c:otherwise>
                                </c:choose>
                                <span class="input-group-addon">
                                    <a href="javascript:void(0)" class="removeFile" rel="${document.id}"><i class="fa fa-times bigger-110 red"></i></a>
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </div>     
            </div>
        </c:if>
        <div class="form-group" id="docDiv">
            <hr/>
            <label class="control-label" for="question">Associated Document</label>
            <input multiple="" name="postDocuments" type="file" id="id-input-file-2" />
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
                                <c:choose>
                                    <c:when test="${documentDetails.countyFolder == true}">
                                         <input type="radio" name="alertUsers" value="1" checked> Send email regarding this new document to users of the selected county?<br />
                                         <input type="radio" name="alertUsers" value="2"> Send email regarding this new document to all users?
                                     </c:when>
                                     <c:otherwise>
                                         <input type="checkbox" name="alertUsers" value="2" checked> Send email regarding this new document to all users?
                                     </c:otherwise>
                                </c:choose>
                            </label>
                        </div>
                    </div>
                </div>    
            </div> 
        </c:if>
    </form:form>
</div>
