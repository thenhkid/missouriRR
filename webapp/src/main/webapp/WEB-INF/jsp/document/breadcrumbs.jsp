<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'list'}">
            <li>
                <a href="/documents">Documents</a>
            </li>
            
            <c:if test="${not empty superParentFolder}">
                <li>
                    <a href="/documents/folder<c:url value="?i=${superParentFolder.encryptedId}&v=${superParentFolder.encryptedSecret}"/>">${superParentFolder.folderName}</a>
                </li>
            </c:if>
            
            <c:if test="${not empty parentFolder}">
                <li>
                    <a href="/documents/folder<c:url value="?i=${parentFolder.encryptedId}&v=${parentFolder.encryptedSecret}"/>">${parentFolder.folderName}</a>
                </li>
            </c:if>

            <li class="active">
                ${selFolderName}
            </li>
        </c:when>
    </c:choose>
</ul>