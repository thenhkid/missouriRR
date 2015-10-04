<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'request'}">
            <li>
                <a href="/reports">Request Report</a>
            </li>
        </c:when>
        <c:when test="${param['page'] == 'list'}">
            <li>
                <a href="/reports/list">Requested Reports</a>
            </li>
        </c:when>
    </c:choose>
</ul>