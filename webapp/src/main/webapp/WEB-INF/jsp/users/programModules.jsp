<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="page-content">
    <div class="row">
        <form id="moduleForm" method="post" role="form">
            <input type="hidden" name="i" value="${userId}" />
            <input type="hidden" name="v" value="${v}" />
            <input type="hidden" id="encryptedURL" value="${encryptedURL}" />
            <input type="hidden" name="selProgramModules" id="selProgramModules" value="" />
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col" class="center">Allow Access</th>
                        <th scope="col" class="center">Create</th>
                        <th scope="col" class="center">Edit</th>
                        <th scope="col" class="center">Delete</th>
                        <th scope="col" class="center">Level 1</th>
                        <th scope="col" class="center">Level 2</th>
                        <th scope="col" class="center">Level 3</th>
                        <th scope="col" class="center">Reconcile</th>
                        <th scope="col" class="center">Import</th>
                        <th scope="col" class="center">Export</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="module" items="${programModules}">
                        <tr>
                            <td><c:choose><c:when test="${module.moduleId == '11'}">Activity Logs</c:when><c:when test="${module.moduleId == '8'}">Announcements</c:when><c:otherwise>${module.displayName}</c:otherwise></c:choose></td>
                            <td class="center"><input class="programModules" name="programModules" type="checkbox" value="${module.moduleId}" <c:if test="${module.useModule == true}">checked="checked"</c:if> /></td>
                            <td class="center"><input name="create_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowCreate == true}">checked="checked"</c:if> ${module.moduleId == 3 || module.moduleId == 2 || module.moduleId == 4 ? 'disabled="disabled"' : ''} /></td>
                            <td class="center"><input name="edit_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowEdit == true}">checked="checked"</c:if> ${module.moduleId == 3 || module.moduleId == 2 || module.moduleId == 4 ? 'disabled="disabled"' : ''} /></td>
                            <td class="center"><input name="delete_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowDelete == true}">checked="checked"</c:if> ${module.moduleId == 3 || module.moduleId == 2 || module.moduleId == 4 ? 'disabled="disabled"' : ''} /></td>
                            <td class="center"><input name="level1_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowLevel1 == true}">checked="checked"</c:if> ${module.moduleId == 3 ? '' : 'disabled="disabled"'} /></td>
                            <td class="center"><input name="level2_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowLevel2 == true}">checked="checked"</c:if> ${module.moduleId == 3 ? '' : 'disabled="disabled"'} /></td>
                            <td class="center"><input name="level3_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowLevel3 == true}">checked="checked"</c:if> ${module.moduleId == 3 ? '' : 'disabled="disabled"'} /></td>
                            <td class="center"><input name="reconcile_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowReconcile == true}">checked="checked"</c:if> ${module.moduleId == 2 ? '' : 'disabled="disabled"'} /></td>
                            <td class="center"><input name="import_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowImport == true}">checked="checked"</c:if> ${module.moduleId == 4 ? '' : 'disabled="disabled"'} /></td>
                            <td class="center"><input name="export_${module.moduleId}" type="checkbox" value="1" <c:if test="${module.allowExport == true}">checked="checked"</c:if> ${module.moduleId == 4 ? '' : 'disabled="disabled"'} /></td>
                            </tr>
                    </c:forEach>
                </tbody>
            </table>
        </form>
    </div>
    <div class="hr hr-dotted"></div>
    <div class="row">
        <button type="button" class="btn btn-primary" id="submitModuleButton">
            <i class="ace-icon fa fa-save bigger-120 white"></i>
            Save
        </button>
    </div>       
</div>
