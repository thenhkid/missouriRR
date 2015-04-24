
<%-- 
    Document   : header
    Created on : Mar 14, 2014, 2:14:45 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Header -->
<header id="header" class="header" role="banner">
    <!-- Primary Nav -->
    <!--role="navigation" used for accessibility -->
    <nav class="navbar primary-nav" role="navigation">
        <div class="navbar-header" style="padding-left:5px; padding-top:8px;">
            <h4><strong>MO Healthy Schools Monitoring System</strong></h4>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav" role="menu" style="padding-left:10px;">
                <li role="menuitem" class="${param['sect'] == 'districts' ? 'active' : 'none'}">
                    <a href="<c:url value='/districts' />" title="Districts">
                        <i class="fa fa-building-o fa-fw"></i> Districts
                    </a>
                </li>
                <c:forEach var="module" items="${sessionScope.availModules}">
                    <li role="menuitem" class="${param['sect'] == module[0] ? 'active' : 'none'}">
                        <a href="<c:url value='/${module[0]}' />" title="${module[1]}">
                            <i class="fa fa-2x ${module[2]} fa-fw"></i>${module[1]}
                        </a>
                    </li>
                </c:forEach>
            </ul>
            <ul class="nav navbar-nav navbar-right" id="secondary-nav">
                <li>
                    <ul class="nav navbar-nav navbar-right" id="secondary-nav">
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <i class="fa fa-gear fa-fw" style="padding-left: 15px; padding-right: 30px;"></i></i>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                                <li>
                                    <a href="<c:url value='/logout' />"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
    <!-- // End Primary Nav -->
</header>
<!-- End Header -->
