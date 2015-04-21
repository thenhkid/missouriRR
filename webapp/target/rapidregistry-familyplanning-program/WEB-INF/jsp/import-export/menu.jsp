<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="secondary">
    <nav class="secondary-nav" role="navigation">
        <ul class="nav nav-pills nav-stacked" role="menu">
            <li role="menuitem" ${param['page'] == 'import' ? 'class="active"' : ''}><a href="/import-export/importData" title="Data Import Tool">Data Import</a></li>
            <li role="menuitem" ${param['page'] == 'export' ? 'class="active"' : ''}><a href="/import-export/exportData" title="Data Export Tool">Data Export</a></li>
        </ul>
    </nav>
</aside>
