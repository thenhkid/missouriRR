<%-- 
    Document   : documentSearchResults
    Created on : Mar 18, 2016, 9:46:07 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="table-header">
    Document Search Results
</div>

<table <c:if test="${not empty documents}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
    <thead>
        <tr>
            <th scope="col" class="center col-md-1"></th>
            <th scope="col" class="col-md-4">Document</th>
            <th scope="col" class="col-md-3">Location</th>
            <th scope="col" class="center col-md-2"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Last Modified</th>
            <th scope="col" class="center col-md-2"></th>
        </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty documents}">
            <c:forEach var="document" items="${documents}">
                <tr>
                    <td class="center" style="vertical-align: middle; ">
                       <c:choose>
                            <c:when test="${document.totalFiles > 1}">
                                <div class="infobox infobox-orange multipleFileDownload" docid="${document.id}" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none; cursor: pointer">
                                    <div class="infobox-icon">
                                        <i class="ace-icon fa fa-download"></i>
                                    </div>
                                </div>
                            </c:when> 
                            <c:otherwise>
                                <c:if test="${not empty document.downloadLink}">
                                    <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.uploadedFile}&foldername=documents/${document.downloadLink}"/>" title="${document.title}">
                                    <c:choose>
                                        <c:when test="${document.fileExt == 'jpg' || document.fileExt == 'gif' || document.fileExt == 'jpeg' || document.fileExt == 'png'}">
                                            <div class="infobox infobox-orange" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                <div class="infobox-icon">
                                                    <i class="ace-icon fa fa-file-image-o"></i>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${document.fileExt == 'wmv'}">
                                            <div class="infobox infobox-red" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                <div class="infobox-icon">
                                                    <i class="ace-icon fa fa-file-video-o"></i>
                                                </div>
                                            </div>
                                        </c:when> 
                                        <c:otherwise>
                                            <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                <div class="infobox-icon">
                                                    <c:choose>
                                                        <c:when test="${document.fileExt == 'pdf'}"><i class="ace-icon fa fa-file-pdf-o"></i></c:when>
                                                        <c:when test="${document.fileExt == 'doc' || document.fileExt == 'docx'}"><i class="ace-icon fa fa-file-word-o"></i></c:when>
                                                        <c:when test="${document.fileExt == 'xls' || document.fileExt == 'xlsx'}"> <i class="ace-icon fa fa-file-excel-o"></i></c:when>
                                                        <c:when test="${document.fileExt == 'txt' || document.fileExt == 'csv'}"><i class="ace-icon fa fa-file-text-o"></i></c:when>
                                                        <c:when test="${document.fileExt == 'zip'}"><i class="ace-icon fa fa-file-zip-o"></i></c:when>
                                                        <c:when test="${document.fileExt == 'ppt' || document.fileExt == 'pptx'}"><i class="ace-icon fa fa-file-powerpoint-o"></i></c:when>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    </a> 
                                    </c:if>
                            </c:otherwise>
                        </c:choose>
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
                        <br /><br />
                        Last Modified By: ${document.createdBy}
                    </td>
                    <td>
                        <c:set var="downloadLink" value="documents/${document.folderLocation}" />${fn:replace(downloadLink,'/',' /')}
                    </td>
                    <td class="center">
                        <fmt:formatDate value="${document.dateModified}" type="date" pattern="M/dd/yyyy h:mm a" />
                    </td>
                    <td class="center">
                        <div class="hidden-sm hidden-xs btn-group">
                            <c:choose>
                                <c:when test="${document.totalFiles > 1}">
                                    <a class="btn btn-xs btn-success multipleFileDownload" docid="${document.id}" title="${document.title}">
                                        <i class="ace-icon fa fa-download bigger-120"></i>
                                    </a>
                                </c:when>
                                <c:when test="${not empty document.downloadLink and not empty document.foundFile}">
                                    <a class="btn btn-xs btn-success" href="<c:url value="/FileDownload/downloadFile.do?filename=${document.uploadedFile}&foldername=documents/${document.downloadLink}"/>" title="${document.title}">
                                        <i class="ace-icon fa fa-download bigger-120"></i>
                                    </a>
                                </c:when>
                            </c:choose>
                            <c:if test="${sessionScope.userDetails.roleId != 3 || (allowEdit == true && sessionScope.userDetails.id == document.createdById)}">
                                <button class="btn btn-xs btn-info editDocument" rel="${document.id}"><i class="ace-icon fa fa-pencil bigger-120"></i></button>
                            </c:if>
                            <c:if test="${sessionScope.userDetails.roleId != 3 || (allowDelete == true && sessionScope.userDetails.id == document.createdById)}">
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