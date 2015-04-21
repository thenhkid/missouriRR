<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
                <c:choose>
                   <c:when test="${param['page'] == 'import'}">
                        <a href="javascript:void(0);" title="Data Import Tool" class="unstyled-link">Data Import Tool</a>
                    </c:when>
                    <c:when test="${param['page'] == 'export'}">
                        <a href="javascript:void(0);" title="Data Export Tool" class="unstyled-link">Data Export Tool</a>
                    </c:when>  
                </c:choose>
            </h1>
        </div>
    </div>
</nav>
