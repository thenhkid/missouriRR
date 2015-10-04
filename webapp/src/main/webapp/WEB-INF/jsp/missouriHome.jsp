<%-- 
    Document   : missouriHome
    Created on : Aug 18, 2015, 8:15:46 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->	
        <c:choose>
            <c:when test="${not empty announcements}">
                <div class="widget-box transparent">
                    <div class="widget-header widget-header-small">
                        <h4 class="widget-title blue smaller">
                            <i class="ace-icon fa fa-bullhorn orange"></i>
                            Recent Announcements
                        </h4>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main padding-8">
                            <div>
                                <c:forEach items="${announcements}" var="announcement">
                                    <div class="profile-activity clearfix">
                                        ${announcement.answer}
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-sm-6">
                        <h4>Welcome</h4>

                        <h2>Some heading</h2>
                        <p>
                            Home page content will go here. This can be text, links, images, etc.
                        </p>
                    </div><!-- /.col -->
                </div>
            </c:otherwise>
        </c:choose>

        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->
