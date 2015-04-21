<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header id="header" class="header" role="banner">
    <!-- Primary Nav -->
    <!--role="navigation" used for accessibility -->
    <nav class="navbar primary-nav" role="navigation">
        <div class="contain">
            <div class="navbar-header">
                <a href="<c:url value='/clients' />" class="navbar-brand" title="Family Planning Registry">
                    <!--
                            <img src="<%=request.getContextPath()%>/dspResources/img/health-e-link/img-health-e-link-logo.png" class="logo" alt="Health-e-Link Logo"/>
                            Required logo specs:
                            logo width: 125px
                            logo height: 30px

                            Plain text can be used without image logo

                            sprite can be used with class="logo":
                    -->
                    <span alt="MO Healthy Schools Healthy Communities Monitoring System">MO Healthy Schools Healthy Communities Monitoring System</span>
                </a>
                 <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav navbar-right">
                    <li class="active">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);" style="background-color:rgb(72, 112, 144);">
                           <i class="glyphicon glyphicon-th-large"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="<c:url value='/patientPortal/settings/personalInfo' />"><i class="fa fa-user fa-fw"></i>Settings</a>
                            </li>
                            <li>
                                <a href="<c:url value='/logout' />"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                            </li>
                            <c:if test="${not empty sessionScope.availPrograms}">
                                <li class="divider"></li>
                                <c:forEach var="program" items="${sessionScope.availPrograms}">
                                    <li>
                                        <a href="http://${program[0]}" title="${program[1]}" target="_blank">${program[1]}</a>
                                    </li>
                                </c:forEach>
                            </c:if>
                        </ul>
                    </li>
                </ul>
            </div>
            <div class="collapse navbar-collapse navbar-ex1-collapse" style="background-color:#587e81; border-top: solid 1px #4a7b8b;">
                <ul class="nav navbar-nav" role="menu">
                    <li role="menuitem" class="${param['sect'] == 'districts' ? 'active' : 'none'}"><a href="<c:url value='/districts' />" title="Districts">Districts</a><c:if test="${param['sect'] == 'districts'}"><span class="indicator-active arrow-up"></span></c:if></li>
                    <c:forEach var="module" items="${sessionScope.availModules}">
                        <li role="menuitem" class="${param['sect'] == module[0] ? 'active' : 'none'}"><a href="<c:url value='/${module[0]}' />" title="${module[1]}">${module[1]}</a><c:if test="${param['sect'] == module[0]}"><span class="indicator-active arrow-up"></span></c:if></li>
                    </c:forEach>
                </ul>
            </div>                
        </div>
    </nav>
    <!-- // End Primary Nav -->
</header>