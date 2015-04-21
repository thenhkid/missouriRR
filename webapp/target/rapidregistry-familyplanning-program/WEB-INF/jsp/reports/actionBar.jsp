<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
                <c:choose>
                   <c:when test="${param['page'] == 'adHoc'}">
                        <a href="javascript:void(0);" title="Ad Hoc Reporting" class="unstyled-link">Ad Hoc Reporting</a>
                    </c:when>
                    <c:when test="${param['page'] == 'custom'}">
                        <a href="javascript:void(0);" title="Custom Reports" class="unstyled-link">Custom Reports</a>
                    </c:when>  
                    <c:when test="${param['page'] == 'engagement'}">
                        <a href="javascript:void(0);" title="Client Engagements" class="unstyled-link">Client Engagements</a>
                    </c:when> 
                    <c:when test="${param['page'] == 'engagementDetails'}">
                        <a href="javascript:void(0);" title="Engagement Details" class="unstyled-link">Engagement Details</a>
                    </c:when> 
                    <c:when test="${param['page'] == 'surveys'}">
                        <a href="javascript:void(0);" title="Client Surveys" class="unstyled-link">Client Surveys</a>
                    </c:when>    
                </c:choose>
            </h1>
        </div>
    </div>
</nav>
