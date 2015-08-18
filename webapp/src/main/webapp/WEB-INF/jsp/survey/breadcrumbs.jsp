<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'list'}">
            <li>
                <a href="#">Activity Logs</a>
            </li>

            <li class="active">
                ${surveyName}
            </li>
        </c:when>
        <c:when test="${param['page'] == 'start'}">
            <li>
                <a href="<c:url value="/surveys" />">Activity Logs</a>
            </li>
            <li>
                <a href="<c:url value="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}" />"> ${survey.surveyTitle}</a>
            </li>
            <li class="active">
               Activity Log Details
            </li>
        </c:when> 
        <c:when test="${param['page'] == 'view'}">
            <li>
                <a href="<c:url value="/surveys" />">Activity Logs</a>
            </li>
            <li>
                <a href="<c:url value="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}" />"> ${survey.title}</a>
            </li>
            <li class="active">
              Activity Log Details
            </li>
        </c:when>   
        <c:when test="${param['page'] == 'complete'}">
            <li>
                <a href="<c:url value="/surveys" />">Activity Logs</a>
            </li>
            <li>
                <a href="<c:url value="/surveys?i=${i}&v=${v}" />"> ${surveyDetails.title}</a>
            </li>
            <li class="active">
              Activity Log Complete
            </li>
        </c:when>        
    </c:choose>
</ul>