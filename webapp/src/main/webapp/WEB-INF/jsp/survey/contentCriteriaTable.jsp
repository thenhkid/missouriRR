<%-- 
    Document   : contentCriteriaTable
    Created on : Jun 2, 2015, 12:35:17 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<table class="table table-striped table-bordered table-hover">
    <thead class="thin-border-bottom">
        <tr>
            <th></th>
            <th>
                <i class="ace-icon fa fa-building"></i>
                School
            </th>
            <th>Content Area</th>
            <th>Criteria</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty contentCriteria}">
                <c:forEach var="content" items="${contentCriteria}">
                    <tr>
                        <td class="center">
                            <input type="checkbox" class="contentSel" rel="${content.schoolId}" value="${content.codeId}" <c:if test="${content.checked == true}">checked="checked"</c:if> />
                        </td>
                        <td>
                            ${content.schoolName}
                        </td>
                        <td>
                            ${content.codeDesc}
                        </td>
                        <td>
                            ${content.codeValue}
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
        </c:choose>
    </tbody>
</table>
