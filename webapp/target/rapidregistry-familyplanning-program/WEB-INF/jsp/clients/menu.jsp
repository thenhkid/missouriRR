<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <li role="menuitem" ${param['page'] == 'list' ? 'class="active"' : ''}><a href="/clients" title="Client Search">Client Search</a></li>
            <li role="menuitem" ${param['page'] == 'details' ? 'class="active"' : ''}><a href="/clients/details?i=${iparam}&v=${vparam}" title="Client Details">Client Details</a></li>
            <li role="menuitem" ${param['page'] == 'enagement' ? 'class="active"' : ''}><a href="/clients/engagements?i=${iparam}&v=${vparam}" title="Engagement Info">Engagement Info</a></li>
            <li role="menuitem" ${param['page'] == 'surveys' ? 'class="active"' : ''}><a href="/clients/surveys?i=${iparam}&v=${vparam}" title="Surveys">Surveys</a></li>
            <li role="menuitem" ${param['page'] == 'activity' ? 'class="active"' : ''}><a href="/clients/client-activity?i=${iparam}&v=${vparam}" title="Engagement Info">Client Activity</a></li>
        </ul>
    </nav>
</aside>
