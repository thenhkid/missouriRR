

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<ul class="submenu" style="max-height:200px; overflow: auto">
    <c:forEach var="folder" items="${folders}">
        <li ${selFolder == folder.id || selParentFolder == folder.id || superParentFolder.id == folder.id ? 'class="active"' : ''}>
            <a href="/documents/folder?i=${folder.encryptedId}&v=${folder.encryptedSecret}">
                <i class="fa ${selFolder == folder.id || selParentFolder == folder.id || superParentFolder.id == folder.id ? 'fa-folder-open' : 'fa-folder'} green"></i>
                ${folder.folderName}
            </a>

            <b class="arrow"></b>

            <c:if test="${not empty subfolders}">
                <ul class="submenu nav-show">
                    <c:forEach var="subfolder" items="${subfolders}">
                        <li ${selFolder == subfolder.id || selParentFolder == subfolder.id ? 'class="active"' : ''}>
                            <a href="/documents/folder?i=${subfolder.encryptedId}&v=${subfolder.encryptedSecret}">
                                <i class="fa ${selFolder == subfolder.id || selParentFolder == subfolder.id ? 'fa-folder-open' : 'fa-folder'} red"></i>
                                ${subfolder.folderName}
                            </a>

                            <b class="arrow"></b>
                            
                            <c:if test="${not empty subsubfolders}">
                                <ul class="submenu nav-show">
                                    <c:forEach var="subsubfolder" items="${subsubfolders}">
                                        <li ${selFolder == subsubfolder.id ? 'class="active"' : ''}>
                                            <a href="/documents/folder?i=${subsubfolder.encryptedId}&v=${subsubfolder.encryptedSecret}">
                                                <i class="fa ${selFolder == subsubfolder.id ? 'fa-folder-open' : 'fa-folder'} blue"></i>
                                                ${subsubfolder.folderName}
                                            </a>

                                            <b class="arrow"></b>

                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                            
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </li>
    </c:forEach>
    <c:if test="${sessionScope.userDetails.roleId == 2}">
    <li>
        <a href="javascript:void(0)" id="newFolder">
            <i class="fa fa-plus orange"></i>
           Create Folder
       </a>
        <b class="arrow"></b>
    </li>
    </c:if>
</ul>
