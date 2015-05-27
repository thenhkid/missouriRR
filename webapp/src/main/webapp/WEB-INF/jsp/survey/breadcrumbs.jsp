<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="#">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'list'}">
            <li>
                <a href="#">Surveys</a>
            </li>

            <li class="active">
                ${surveyName}
            </li>
        </c:when>
        <c:when test="${param['page'] == 'start'}">
            <li>
                <a href="<c:url value="/surveys" />">Surveys</a>
            </li>
            <li>
                <a href="<c:url value="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}" />"> ${survey.surveyTitle}</a>
            </li>
            <li class="active">
               Start Survey
            </li>
        </c:when> 
        <c:when test="${param['page'] == 'view'}">
            <li>
                <a href="<c:url value="/surveys" />">Surveys</a>
            </li>
            <li>
                <a href="<c:url value="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}" />"> ${survey.title}</a>
            </li>
            <li class="active">
               View Survey
            </li>
        </c:when>    
    </c:choose>
</ul>