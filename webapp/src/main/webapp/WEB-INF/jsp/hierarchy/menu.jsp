<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <c:forEach var="item" items="${orgHierarchyList}" >
                <li role="menuitem" ${selectedId ==  item.id ? 'class="active"' : ''}><a ${page == 'providerDetails' ? 'href="/hierarchy"' : 'href="javascript:void(0);"  class="hierarchyMenu"'} rel="${item.id}" title="${item.name}">${item.name}</a></li>
            </c:forEach>
                 <li role="menuitem" ${page ==  'providers' || page == 'providerDetails' ? 'class="active"' : ''}><a ${page == 'providerDetails' ? 'href="/hierarchy"' : 'href="javascript:void(0);"  class="hierarchyMenu"'} rel="providers" title="Providers">Providers</a></li>
        </ul>
    </nav>
</aside>
