

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <c:choose>
                <c:when test="${param['page'] == 'districtlist'}">
                    <c:forEach var="entity" items="${entities}">
                        <li role="menuitem" ${selEntity == entity.id ? 'class="active entity"' : 'class="entity"'}>
                            <a href="javascript:void(0);" class="loadDistricts" rel="${entity.id}" title="${entity.name}">${entity.name}</a>
                        </li>
                    </c:forEach>
                </c:when>
            </c:choose>
            
        </ul>
    </nav>
</aside>
