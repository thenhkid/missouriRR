<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>

    <c:choose>
        <c:when test="${param['page'] == 'export'}">
            <li>
                <a href="/import-export">Import / Export</a>
            </li>
            <li class="active">
                Export
            </li>
        </c:when>
    </c:choose>


</ul>