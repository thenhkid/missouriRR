<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="#">Home</a>
    </li>

    <c:choose>
        <c:when test="${param['page'] == 'topics'}">
            <li class="active">
                Forum Topics
            </li>
        </c:when>
        <c:otherwise>
            <li>
                <a href="<c:url value="/forum" />">Forum Topics</a>
            </li>
            <li class="active">
                ${topicTitle}
            </li>
        </c:otherwise>
    </c:choose>


</ul>