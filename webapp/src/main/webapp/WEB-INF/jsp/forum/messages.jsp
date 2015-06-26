<%-- 
    Document   : messages
    Created on : Jun 26, 2015, 12:47:35 PM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" pattern="yyyy-MM-dd" var="todayDate" />

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
                                <a href="#" class="reply" title="Reply to this post" rel="${messageData.id}">
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

                                            <a href="#" class="editPost" rel="${messageData.id}">
                                                <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                            </a>

                                            <a href="#" class="deletePost" rel="${messageData.id}">
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

                                                        <a href="#" class="editPost" rel="${reply.id}">
                                                            <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                                        </a>

                                                        <a href="#" class="deletePost" rel="${reply.id}">
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
