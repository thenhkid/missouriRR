<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <li role="menuitem" ${param['page'] == 'adHoc' ? 'class="active"' : ''}><a href="/reports" title="Client Search">Ad Hoc Reporting</a></li>
            <li role="menuitem" ${param['page'] == 'custom' ? 'class="active"' : ''}><a href="/reports/custom" title="Client Details">Custom Reports</a></li>
        </ul>
    </nav>
</aside>
