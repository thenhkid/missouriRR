<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <!-- use the following meta to force IE use its most up to date rendering engine -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

        <title><tiles:insertAttribute name="title" /></title>
        <meta name="description" content="page description" />
        
        <link href="<%=request.getContextPath()%>/dspResources/css/bootstrap.min.css" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/dspResources/css/font-awesome.min.css" rel="stylesheet" /><!-- only if needed -->

        <link href="<%=request.getContextPath()%>/dspResources/css/ace-fonts.min.css" rel="stylesheet" /><!-- you can also use google hosted fonts -->
        
        <link href="<%=request.getContextPath()%>/dspResources/css/datepicker.min.css" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/dspResources/css/jquery.simplecolorpicker.css" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/dspResources/css/jquery.timepicker.css" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/dspResources/css/jquery.dataTables.css" rel="stylesheet" />
        <link href="<%=request.getContextPath()%>/dspResources/css/jquery.dataTables.css" rel="stylesheet" />
        
        <tiles:useAttribute id="cssList" name="customCSS" classname="java.util.List" ignore="true" />
        <c:forEach var="cssFile" items="${cssList}">
          <link href="<%=request.getContextPath()%>${cssFile}" rel="stylesheet" />
        </c:forEach>
        

        <link href="<%=request.getContextPath()%>/dspResources/css/ace.min.css" rel="stylesheet" class="ace-main-stylesheet" />
        <!--[if lte IE 9]>
         <link href="<%=request.getContextPath()%>/dspResources/css/ace-part2.min.css" rel="stylesheet" class="ace-main-stylesheet" />
        <![endif]-->
        
        <!--[if !IE]> -->
        <script src="<%=request.getContextPath()%>/dspResources/js/jquery.min.js"></script>
        <!-- <![endif]-->
        <!--[if lte IE 9]>
         <script src="<%=request.getContextPath()%>/dspResources/js/jquery1x.min.js"></script>
        <![endif]-->

        <script src="<%=request.getContextPath()%>/dspResources/js/bootstrap.min.js"></script>
        
        <tiles:useAttribute id="list" name="headScripts" classname="java.util.List" ignore="true" />
        <c:forEach var="script" items="${list}">
          <script type="text/javascript" src="<%=request.getContextPath()%>${script}"></script>
        </c:forEach>

        <!-- ie8 canvas if required for plugins such as charts, etc -->
        <!--[if lte IE 8]>
         <script src="<%=request.getContextPath()%>/dspResources/js/excanvas.min.js"></script>
        <![endif]-->
        <script type="text/javascript" src="<%=request.getContextPath()%>/dspResources/js/ace.min.js"></script>
    </head>

    <body class="no-skin">
        <div class="navbar" id="navbar">
            <div class="navbar-container" id="navbar-container">

                <div class="navbar-header pull-left">
                    <a href="#" class="navbar-brand">
                        <small>
                            <i class="fa fa-building"></i>
                            MO Healthy Schools Monitoring System
                        </small>
                    </a>
                </div>

                <div class="navbar-buttons navbar-header pull-right" role="navigation">
                    <ul class="nav ace-nav">
                        <li class="light-blue">
                            <a data-toggle="dropdown" href="#" class="dropdown-toggle">
                                <img class="nav-user-photo" src="<%=request.getContextPath()%>/dspResources/img/avatars/avatar2.png" alt="Profile Photo" />
                                <span class="user-info">
                                    <small>Welcome,</small>
                                    <c:out value="${sessionScope.userDetails.firstName}" />
                                </span>

                                <i class="ace-icon fa fa-caret-down"></i>
                            </a>

                            <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
                                <li>
                                    <a href="#">
                                        <i class="ace-icon fa fa-cog"></i>
                                        Settings
                                    </a>
                                </li>

                                <li>
                                    <a href="#">
                                        <i class="ace-icon fa fa-user"></i>
                                        Profile
                                    </a>
                                </li>

                                <li class="divider"></li>

                                <li>
                                    <a href="<c:url value='/logout' />">
                                        <i class="ace-icon fa fa-power-off"></i>
                                        Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div><!-- /.navbar-container -->
        </div>

        <div class="main-container" id="main-container">
            <div class="sidebar responsive" id="sidebar">
                <ul class="nav nav-list">
                    <tiles:importAttribute name="submenu" toName="menu" ignore="true" />
                    <c:forEach var="module" items="${sessionScope.availModules}">
                        <li <c:if test="${fn:contains(requestScope['javax.servlet.forward.request_uri'],module[0])}">class="active open"</c:if>>
                            <a href="<c:url value='/${module[0]}' />" title="<c:choose><c:when test="${module[3] == '11'}">Activity Logs</c:when><c:otherwise>${module[1]}</c:otherwise></c:choose>">
                                <i class="menu-icon fa ${module[2]}"></i>
                                <span class="menu-text"><c:choose><c:when test="${module[3] == '11'}">Activity Logs</c:when><c:otherwise>${module[1]}</c:otherwise></c:choose></span>

                                <c:if test="${not empty menu && fn:contains(requestScope['javax.servlet.forward.request_uri'],module[0])}"> <b class="arrow fa fa-angle-down"></b></c:if>
                                </a>

                            <c:if test="${not empty menu && fn:contains(requestScope['javax.servlet.forward.request_uri'],module[0])}">

                                <b class="arrow"></b>

                                <tiles:insertAttribute name="submenu" />

                            </c:if>
                        </li>
                    </c:forEach>

                </ul><!-- /.nav-list -->

                <div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
                    <i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
                </div>

                <script type="text/javascript">
                    try {
                        ace.settings.check('sidebar', 'collapsed')
                    } catch (e) {
                    }
                </script>
            </div>

            <div class="main-content">
                <div class="breadcrumbs">
                    <tiles:insertAttribute name="breadcrumbs" ignore="true" />
                    <!-- /.breadcrumb -->
                </div>

                <div class="page-content">
                    <!-- setting box goes here if needed -->
                    <tiles:insertAttribute name="body" />
                    <!-- /.row -->

                </div><!-- /.page-content -->
            </div><!-- /.main-content -->

            <!-- footer area -->

        </div><!-- /.main-container -->

        <tiles:importAttribute name="jscript" toName="script" ignore="true" />
        <c:if test="${not empty script}">
            <script type="text/javascript" src="<%=request.getContextPath()%><tiles:getAsString name='jscript' ignore='true' />"></script>
        </c:if>
    </body>
</html>
