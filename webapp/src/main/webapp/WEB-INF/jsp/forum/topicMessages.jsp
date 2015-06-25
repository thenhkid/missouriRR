<%-- 
    Document   : forum
    Created on : Jun 1, 2015, 10:42:48 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" var="todayDate" />

<div class="page-header">
    <h1>
        Topic Messages
    </h1>
</div><!-- /.page-header -->
<div class="row">

    <div id="timeline-1">
        <div class="row">
            <div class="col-xs-12 col-sm-10 col-sm-offset-1">
                <c:forEach var="message" items="${topicMessages}">
                    <fmt:formatDate value="${message.messageDate}" type="date" pattern="yyyy-MM-dd" var="messageDateCheck" />
                    <div class="timeline-container">
                        <div class="timeline-label">
                            <c:choose>
                                <c:when test="${todayDate == messageDateCheck}">
                                    <span class="label label-success arrowed-in-right label-lg"><b>Today</b></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="label label-primary arrowed-in-right label-lg"><b><fmt:formatDate value="${message.messageDate}" type="both" pattern="MMM dd" /></b></span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="timeline-items">
                            <c:forEach var="messageData" items="${message.messages}">
                                <div class="timeline-item clearfix">
                                    <div class="timeline-info">
                                        <img alt="Susan't Avatar" src="<%=request.getContextPath()%>/dspResources/img/avatars/avatar2.png" />
                                        <span class="label label-info label-sm"><fmt:formatDate value="${messageData.dateCreated}" type="time" pattern="h:mm" /></span>
                                    </div>

                                    <div class="widget-box transparent">
                                        <div class="widget-header widget-header-small">
                                            <h5 class="widget-title smaller">
                                                <span class="grey">Posted By: </span>
                                                <span class="blue">${messageData.postedBy}</span>
                                            </h5>

                                            <span class="widget-toolbar no-border">
                                                <i class="ace-icon fa fa-clock-o bigger-110"></i>
                                                <fmt:formatDate value="${messageData.dateCreated}" type="time" pattern="h:mm" />
                                            </span>

                                            <span class="widget-toolbar">
                                                <a href="#" data-action="reload" title="Reply to this post" rel="${messageData.id}">
                                                    <i class="ace-icon fa fa-reply"></i>
                                                </a>
                                            </span>
                                        </div>

                                        <div class="widget-body">
                                            <div class="widget-main">
                                                ${messageData.message}

                                                <c:if test="${sessionScope.userDetails.id == messageData.systemUserId}">
                                                    <div class="space-6"></div>

                                                    <div class="widget-toolbox clearfix">

                                                        <div class="pull-right action-buttons">

                                                            <a href="#">
                                                                <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                                            </a>

                                                            <a href="#">
                                                                <i class="ace-icon fa fa-times red bigger-125"></i>
                                                            </a>
                                                        </div>
                                                    </div>

                                                </c:if>

                                                <c:if test="${not empty messageData.replies}">
                                                    <c:forEach var="reply" items="${messageData.replies}">
                                                        <div class="space-8"></div>
                                                        <div class="hr hr-dotted"></div>
                                                        <div class="space-2"></div>
                                                        <div style="padding-left:30px;">
                                                            ${reply.message}

                                                            <div class="widget-toolbox clearfix">

                                                                <div class="pull-left">
                                                                    <h6>by <strong>${reply.postedBy}</strong> <i class="ace-icon fa fa-angle-double-right"></i> <fmt:formatDate value="${reply.dateCreated}" type="both" pattern="E MMM dd, yyyy h:mm a" /></h6>
                                                                </div>
                                                                <c:if test="${sessionScope.userDetails.id == reply.systemUserId}">
                                                                    <div class="pull-right action-buttons">

                                                                        <a href="#">
                                                                            <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                                                        </a>

                                                                        <a href="#">
                                                                            <i class="ace-icon fa fa-times red bigger-125"></i>
                                                                        </a>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:forEach> 
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>


                        </div><!-- /.timeline-items -->
                    </div><!-- /.timeline-container -->
                </c:forEach>


                <!--<div class="timeline-container">
                    <div class="timeline-label">
                        <span class="label label-success arrowed-in-right label-lg">
                            <b>Yesterday</b>
                        </span>
                    </div>

                    <div class="timeline-items">
                        <div class="timeline-item clearfix">
                            <div class="timeline-info">
                                <i class="timeline-indicator ace-icon fa fa-beer btn btn-inverse no-hover"></i>
                            </div>

                            <div class="widget-box transparent">
                                <div class="widget-header widget-header-small">
                                    <h5 class="widget-title smaller">Haloween party</h5>

                                    <span class="widget-toolbar">
                                        <i class="ace-icon fa fa-clock-o bigger-110"></i>
                                        1 hour ago
                                    </span>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main">
                                        <div class="clearfix">
                                            <div class="pull-left">
                                                Lots of fun at Haloween party.
                                                <br />
                                                Take a look at some pics:
                                            </div>

                                            <div class="pull-right">
                                                <i class="ace-icon fa fa-chevron-left blue bigger-110"></i>

                                                &nbsp;
                                                <img alt="Image 4" width="36" src="dist/images/gallery/thumb-4.jpg" />
                                                <img alt="Image 3" width="36" src="dist/images/gallery/thumb-3.jpg" />
                                                <img alt="Image 2" width="36" src="dist/images/gallery/thumb-2.jpg" />
                                                <img alt="Image 1" width="36" src="dist/images/gallery/thumb-1.jpg" />
                                                &nbsp;
                                                <i class="ace-icon fa fa-chevron-right blue bigger-110"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item clearfix">
                            <div class="timeline-info">
                                <i class="timeline-indicator ace-icon fa fa-trophy btn btn-pink no-hover green"></i>
                            </div>

                            <div class="widget-box transparent">
                                <div class="widget-header widget-header-small">
                                    <h5 class="widget-title smaller">Lorum Ipsum</h5>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main">
                                        Anim pariatur cliche reprehenderit, enim eiusmod
                                        <span class="green bolder">high life</span>
                                        accusamus terry richardson ad squid &hellip;
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item clearfix">
                            <div class="timeline-info">
                                <i class="timeline-indicator ace-icon fa fa-cutlery btn btn-success no-hover"></i>
                            </div>

                            <div class="widget-box transparent">
                                <div class="widget-body">
                                    <div class="widget-main"> Going to cafe for lunch </div>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item clearfix">
                            <div class="timeline-info">
                                <i class="timeline-indicator ace-icon fa fa-bug btn btn-danger no-hover"></i>
                            </div>

                            <div class="widget-box widget-color-red2">
                                <div class="widget-header widget-header-small">
                                    <h5 class="widget-title smaller">Critical security patch released</h5>

                                    <span class="widget-toolbar no-border">
                                        <i class="ace-icon fa fa-clock-o bigger-110"></i>
                                        9:15
                                    </span>

                                    <span class="widget-toolbar">
                                        <a href="#" data-action="reload">
                                            <i class="ace-icon fa fa-refresh"></i>
                                        </a>

                                        <a href="#" data-action="collapse">
                                            <i class="ace-icon fa fa-chevron-up"></i>
                                        </a>
                                    </span>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main">
                                        Please download the new patch for maximum security.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="timeline-container">
                    <div class="timeline-label">
                        <span class="label label-grey arrowed-in-right label-lg">
                            <b>May 17</b>
                        </span>
                    </div>

                    <div class="timeline-items">
                        <div class="timeline-item clearfix">
                            <div class="timeline-info">
                                <i class="timeline-indicator ace-icon fa fa-leaf btn btn-primary no-hover green"></i>
                            </div>

                            <div class="widget-box transparent">
                                <div class="widget-header widget-header-small">
                                    <h5 class="widget-title smaller">Lorum Ipsum</h5>

                                    <span class="widget-toolbar no-border">
                                        <i class="ace-icon fa fa-clock-o bigger-110"></i>
                                        10:22
                                    </span>

                                    <span class="widget-toolbar">
                                        <a href="#" data-action="reload">
                                            <i class="ace-icon fa fa-refresh"></i>
                                        </a>

                                        <a href="#" data-action="collapse">
                                            <i class="ace-icon fa fa-chevron-up"></i>
                                        </a>
                                    </span>
                                </div>

                                <div class="widget-body">
                                    <div class="widget-main">
                                        Anim pariatur cliche reprehenderit, enim eiusmod
                                        <span class="blue bolder">high life</span>
                                        accusamus terry richardson ad squid &hellip;
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> -->
            </div>
        </div>
    </div>

    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->
</div><!-- /.row -->