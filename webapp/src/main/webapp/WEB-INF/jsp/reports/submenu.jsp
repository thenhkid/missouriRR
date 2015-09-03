

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="submenu">
    <c:if test="${1==1}">
        <li ${selSurvey == survey.id ? 'class="active"' : ''}>
        <a href="/reports/">
            <i class="menu-icon fa fa-caret-right"></i>
            Request Report
        </a>

        <b class="arrow"></b>
    </li>
    </c:if>
    <c:if test="${2 == 2}">
        <li ${selSurvey == survey.id ? 'class="active"' : ''}>
            <a href="/reports/list">
            <i class="menu-icon fa fa-caret-right"></i>
            Requested Reports
        </a>

        <b class="arrow"></b>
    </li>
    </c:if>
</ul>
