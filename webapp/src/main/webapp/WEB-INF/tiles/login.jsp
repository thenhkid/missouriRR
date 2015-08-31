<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
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

        <!-- ie8 canvas if required for plugins such as charts, etc -->
        <!--[if lte IE 8]>
         <script src="<%=request.getContextPath()%>/dspResources/js/excanvas.min.js"></script>
        <![endif]-->
        <script type="text/javascript" src="<%=request.getContextPath()%>/dspResources/js/ace.min.js"></script>
    </head>
    <body class="login-layout" style="background: transparent url('../../dspResources/images/Health-e-link_CoverPage.jpg') no-repeat; -webkit-background-size: contain; -moz-background-size: contain;    
    -o-background-size: contain;   
    background-size: contain;">

        <div class="main-container" >
            <div class="main-content">
               <div class="row">
                    <div class="col-sm-10 col-sm-offset-4">
                        <tiles:insertAttribute name="body" />
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.main-content -->
        </div><!-- /.main-container -->
    </body>
    <tiles:importAttribute name="jscript" toName="script" ignore="true" />
    <c:if test="${not empty script}">
        <script type="text/javascript" src="<%=request.getContextPath()%><tiles:getAsString name='jscript' ignore='true' />"></script>
    </c:if>
</html>
