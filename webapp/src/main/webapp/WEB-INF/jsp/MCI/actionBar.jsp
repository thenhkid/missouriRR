<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
                <c:choose>
                   <c:when test="${param['page'] == 'pendingList'}">
                        <a href="javascript:void(0);" title="Pending Client List" class="unstyled-link">Pending Clients</a>
                    </c:when>
                    <c:when test="${param['page'] == 'review'}">
                        <a href="javascript:void(0);" title="Pending Client Similar Matches" class="unstyled-link">Review Partial Matches</a>
                    </c:when>  
                </c:choose>
            </h1>
        </div>
        <ul class="nav navbar-nav navbar-right navbar-actions" role="menu">
           <c:choose>
               <c:when test="${param['page'] == 'pendingList'}">
                   <li role="menuitem"><a href="javascript:void(0);" id="printduplicateClients" title="Print Duplicate Clients" role="button"><span class="glyphicon glyphicon-print icon-stacked"></span> Print</a></li>
                   <li role="menuitem"><a href="javascript:void(0);" id="duplicateClients" title="Find Duplicate Clients" role="button"><span class="glyphicon glyphicon-search icon-stacked"></span> Find Duplicate Clients</a></li>
               </c:when>
                <c:when test="${param['page'] == 'review'}">
                    <li role="menuitem"><a href="javascript:void(0);" id="enrollClient" rel="${clientId}" title="Enroll Client" role="button"><span class="glyphicon glyphicon-ok icon-stacked"></span> Enroll Client </a></li>
                    <li role="menuitem"><a href="/MCI" title="Cancel" role="button"><span class="glyphicon glyphicon-ban-circle icon-stacked"></span> Cancel</a></li>
                </c:when>
          </c:choose>
        </ul>
    </div>
</nav>
