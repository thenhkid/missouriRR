<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>
    
    <c:choose>
        <c:when test="${param['page'] == 'edit'}">
            <li>
                <a href="<c:url value="/users" />">User List</a>
            </li>
            <li class="active">
               User Details
            </li>
        </c:when> 
        <c:otherwise>
            <li class="active">
              User List
            </li>
        </c:otherwise>
    </c:choose>
</ul>