

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="submenu">
    <c:forEach var="survey" items="${surveys}">
    <li ${selSurvey == survey.id ? 'class="active"' : ''}>
        <a href="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}">
            <i class="menu-icon fa fa-caret-right"></i>
            ${survey.title}
        </a>

        <b class="arrow"></b>
    </li>
    </c:forEach>
</ul>
