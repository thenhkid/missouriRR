<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
                <c:choose>
                   <c:when test="${param['page'] == 'districtlist'}">
                        <a href="javascript:void(0);" title="County District List" class="unstyled-link">County Districts</a>
                    </c:when>
                </c:choose>
            </h1>
        </div>
        <ul class="nav navbar-nav navbar-right navbar-actions" role="menu">
           
        </ul>
    </div>
</nav>
<!-- Hierarchy Item Edit/Create modal -->
<div class="modal fade" id="surveyModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>
