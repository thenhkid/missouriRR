<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <c:forEach var="p" items="${surveyPages}">
                <li role="menuitem" ${survey.currentPage == p.pageNum ? 'class="active"' : ''}>
                    <a href="javascript:void(0);" title="${p.pageTitle}" <c:choose><c:when test="${p.pageNum > survey.currentPage}">style="color: #999" class="goToPage" rel2="${survey.currentPage}" rel="${p.pageNum}"</c:when><c:otherwise>class="goToPage" rel2="${survey.currentPage}" rel="${p.pageNum}"</c:otherwise></c:choose>>Page ${p.pageNum}</a>
                </li>
            </c:forEach>
            <%--<li role="menuitem" ${param['page'] == 'list' ? 'class="active"' : ''}>
                <a href="/clients" title="Client Search">Client Search</a>
            </li>--%>
        </ul>
    </nav>
</aside>
