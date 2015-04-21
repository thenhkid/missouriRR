<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
               <c:choose>
                   <c:when test="${page == 'providerDetails'}">
                       Edit Provider
                   </c:when>
                   <c:otherwise>
                       ${hierarchyName}s
                   </c:otherwise>
                </c:choose>
            </h1>
        </div>
        <ul class="nav navbar-nav navbar-right navbar-actions" role="menu">
            <c:choose>
                <c:when test="${page == 'providerDetails'}">
                    <li role="menuitem"><a href="javascript:void(0);" id="saveDetails" title="Save Form" role="button"><span class="glyphicon glyphicon-ok icon-stacked"></span> Save </a></li>
                    <li role="menuitem"><a href="javascript:void(0);" id="saveCloseDetails" title="Save &amp; Close" role="button"><span class="glyphicon glyphicon-floppy-disk icon-stacked"></span> Save &amp; Close</a></li>
                </c:when>
                <c:otherwise>
                    <li role="menuitem"><a href="#itemFormModal" data-toggle="modal" class="newItem" id="newHierarchyItem" title="Save Form" rel="${selectedId}" role="button"><span class="glyphicon glyphicon-plus-sign icon-stacked"></span> Create New ${hierarchyName}</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>
