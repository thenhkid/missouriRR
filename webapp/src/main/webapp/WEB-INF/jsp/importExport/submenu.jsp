

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="submenu">
    <c:if test="${allowImport == true}">
        <li ${selSurvey == survey.id ? 'class="active"' : ''}>
        <a href="/import">
            <i class="menu-icon fa fa-caret-right"></i>
            Import
        </a>

        <b class="arrow"></b>
    </li>
    </c:if>
    <c:if test="${allowExport == true}">
        <li ${selSurvey == survey.id ? 'class="active"' : ''}>
        <a href="/export">
            <i class="menu-icon fa fa-caret-right"></i>
            Export
        </a>

        <b class="arrow"></b>
    </li>
    </c:if>
</ul>
