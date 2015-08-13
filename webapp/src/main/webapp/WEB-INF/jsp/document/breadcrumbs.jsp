<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="#">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'list'}">
            <li>
                <a href="/documents">Documents</a>
            </li>
            
            <c:if test="${not empty selParentFolderName}">
                <li>
                    <a href="/documents/${selParentFolderName}">${selParentFolderName}</a>
                </li>
            </c:if>

            <li class="active">
                ${selFolderName}
            </li>
        </c:when>
    </c:choose>
</ul>