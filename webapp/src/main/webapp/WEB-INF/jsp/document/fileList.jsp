<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div class="col-sm-12">
    <div class="row">
        <div class="clearfix">
            <div class="dropdown pull-left no-margin">
                <button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Preferences
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="documentNotificationManagerModel">Document Notification Preferences</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="hr dotted"></div>
    <div class="row">
        <div class="clearfix">
            <c:if test="${sessionScope.userDetails.roleId == 2 && (selParentFolder == 0 || folderCount < 3)}">
                <div class="pull-left no-margin col-md-6">
                    <button class="btn btn-info btn-xs" type="button" id="newSubfolder">
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        Create Subfolder
                    </button>
                </div>
            </c:if>
            <c:if test="${sessionScope.userDetails.roleId == 2 || (allowCreate == true && readOnly == false)}">
                <div class="pull-right no-margin col-md-6">
                    <button class="btn btn-success btn-xs pull-right" type="button" id="newDocument" >
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        Upload New Document
                    </button>
                </div>
            </c:if>
        </div>
        <div class="hr dotted"></div>
    </div>
    <div class="col-sm-12">

        <div class="row">
            <div class="table-header">
                Documents uploaded to the ${selFolderName} folder
            </div>

            <table <c:if test="${not empty documents}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th scope="col" class="center col-md-1"></th>
                            <th scope="col" class="col-md-5">Document</th>
                            <th scope="col" class="center col-md-2"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Submitted</th>
                            <th scope="col" class="col-md-2">Submitted By</th>
                            <th scope="col" class="center col-md-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty documents}">
                            <c:forEach var="document" items="${documents}">
                                <tr>
                                    <td class="center" style="vertical-align: middle; ">
                                        <c:if test="${not empty document.uploadedFile}">
                                            <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.uploadedFile}&foldername=documents/${document.downloadLink}"/>" title="${document.title}">
                                            <c:choose>
                                                <c:when test="${document.fileExt == 'pdf'}">
                                                    <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                        <div class="infobox-icon">
                                                            <i class="ace-icon fa fa-file-pdf-o"></i>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${document.fileExt == 'doc' || document.fileExt == 'docx'}">
                                                    <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                        <div class="infobox-icon">
                                                            <i class="ace-icon fa fa-file-word-o"></i>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${document.fileExt == 'xls' || document.fileExt == 'xlsx'}">
                                                    <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                        <div class="infobox-icon">
                                                            <i class="ace-icon fa fa-file-excel-o"></i>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${document.fileExt == 'txt'}">
                                                    <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                        <div class="infobox-icon">
                                                            <i class="ace-icon fa fa-file-text-o"></i>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${document.fileExt == 'jpg' || document.fileExt == 'gif' || document.fileExt == 'jpeg' || document.fileExt == 'png'}">
                                                    <div class="infobox infobox-orange" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                        <div class="infobox-icon">
                                                            <i class="ace-icon fa fa-file-image-o"></i>
                                                        </div>
                                                    </div>
                                                </c:when>
                                            </c:choose>
                                            </a> 
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${document.privateDoc == true}">
                                             <i class="ace-icon fa fa-lock red"></i>
                                        </c:if>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty document.title}">${document.title}</c:when>
                                                <c:otherwise>${document.uploadedFile}</c:otherwise>
                                            </c:choose>
                                        </strong>
                                            <c:if test="${not empty document.externalWebLink}">
                                                <br />
                                                URL: <a href="${document.externalWebLink}" target="_blank">Click to visit site</a>
                                            </c:if>
                                            <c:if test="${not empty document.docDesc}">
                                                <br />
                                                ${document.docDesc}
                                            </c:if>
                                    </td>
                                    <td class="center">
                                        <fmt:formatDate value="${document.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" />
                                    </td>
                                    <td>
                                        ${document.createdBy}
                                    </td>
                                    <td  class="center">
                                        <div class="hidden-sm hidden-xs btn-group">
                                            <c:if test="${not empty document.uploadedFile}">
                                                <a class="btn btn-xs btn-success" href="<c:url value="/FileDownload/downloadFile.do?filename=${document.uploadedFile}&foldername=documents/${document.downloadLink}"/>" title="${document.title}">
                                                <i class="ace-icon fa fa-download bigger-120"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${sessionScope.userDetails.roleId != 3 || (allowEdit == true && sessionScope.userDetails.id == document.systemUserId)}">
                                                <button class="btn btn-xs btn-info editDocument" rel="${document.id}"><i class="ace-icon fa fa-pencil bigger-120"></i></button>
                                            </c:if>
                                            <c:if test="${sessionScope.userDetails.roleId != 3 || (allowDelete == true && sessionScope.userDetails.id == document.systemUserId)}">
                                                <button class="btn btn-xs btn-danger deleteDocument" rel="${document.id}"><i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="center">
                                    There have been no documents uploaded to this folder.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div><!-- /.col -->
</div>


