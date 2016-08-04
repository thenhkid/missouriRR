<%-- 
    Document   : topics
    Created on : Jun 19, 2015, 9:45:33 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="col-sm-12">
    <div class="row">
        <div class="clearfix">
            <div class="dropdown pull-left no-margin col-md-10">
                <button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Preferences
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="forumNotificationManagerModel">Forum Notification Preferences</a></li>
                </ul>
            </div>
            <c:if test="${allowCreate == true}">
                <div class="pull-right no-margin">
                    <button class="btn btn-success btn-xs" type="button" id="newTopic">
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        New Topic
                    </button>
                </div>
            </c:if>
        </div>
    </div>
    <div class="hr dotted"></div>
    <c:if test="${not empty regularTopics || not empty announcementTopics}">
    <div class="row">
        <div class="clearfix">
            <div class="pull-right no-margin col-md-2">
                <div class="widget-box transparent">
                    <form class="form-search">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="ace-icon fa fa-search grey"></i></span>
                            <span class="block input-icon input-icon-right">
                                <input type="text" placeholder="Search ..." class="width-100" id="nav-search-input" autocomplete="off" />
                                <i id="clearSearch" class="ace-icon fa fa-times-circle red" style="cursor: pointer; display: none"></i>
                                <i id="searchSpinner" class="ace-icon fa fa-spinner fa-spin red bigger-120"  style="display: none"></i>
                            </span>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="hr dotted"></div>
    </div>
    </c:if>
    <div id="topicsDiv" class="col-sm-12">
        <c:if test="${empty regularTopics && empty announcementTopics}">
            <div class="row">
                <div>
                    <table class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col" class="center">Views</th>
                                <th scope="col" class="center">Replies</th>
                                <th scope="col">Last Post</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="center" colspan="4">
                                    There are currently no active forum topics.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty announcementTopics && sessionScope.userDetails.roleId != 2}">
            <div class="row">
                <div class="table-header">
                    Announcements
                </div>
                <div>
                    <table class="dynamic-table table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col" class="center">Views</th>
                                <th scope="col" class="center">Replies</th>
                                <th scope="col">Last Post</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="topic" items="${announcementTopics}">
                                <tr>
                                    <td class="col-md-6">
                                        <a href="/forum/${topic.topicURL}">${topic.title}</a>
                                        <br />
                                        by ${topic.postedByName} <i class="ace-icon fa fa-angle-double-right"></i> <fmt:formatDate value="${topic.postedOn}" type="both" pattern="E MMM dd, yyyy h:mm a" />
                                        <c:if test="${(sessionScope.userDetails.id == topic.postedBy) || sessionScope.userDetails.roleId == 2}">
                                            <div class="pull-right action-buttons">

                                                <a href="#" class="editTopic" rel="${topic.id}">
                                                    <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                                </a>

                                                <a href="#" class="deleteTopic" rel="${topic.id}">
                                                    <i class="ace-icon fa fa-times red bigger-125"></i>
                                                </a>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td class="center col-md-2">
                                        ${topic.totalViews}
                                    </td>
                                    <td class="center col-md-2">
                                        ${topic.totalReplies}
                                    </td>
                                    <td class="col-md-2">
                                        ${topic.lastPostByName}
                                        <br />
                                        <fmt:formatDate value="${topic.lastPostOn}" type="both" pattern="E MMM dd, yyyy h:mm a" />
                                    </td>
                                    <td><fmt:formatDate value="${topic.lastPostOn}" type="both" pattern="E MMM dd, yyyy h:mm a" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty regularTopics && not empty announcementTopics}"><br /></c:if>
        <c:if test="${not empty regularTopics}">
            <div class="row">
                <div class="table-header">
                    Topics
                </div>
                <div>
                    <table class="dynamic-table table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col" class="center">Views</th>
                                <th scope="col" class="center">Replies</th>
                                <th scope="col">Last Post</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:forEach var="topic" items="${regularTopics}">
                                <tr>
                                    <td class="col-md-6">
                                        <a href="/forum/${topic.topicURL}">${topic.title}</a>
                                        <br />
                                        by ${topic.postedByName} &Gt; <fmt:formatDate value="${topic.postedOn}" type="both" pattern="E MMM dd, yyyy h:mm a" />
                                        <c:if test="${(sessionScope.userDetails.id == topic.postedBy) || sessionScope.userDetails.roleId == 2}">
                                            <div class="pull-right action-buttons">

                                                <a href="#" class="editTopic" rel="${topic.id}">
                                                    <i class="ace-icon fa fa-pencil blue bigger-125"></i>
                                                </a>

                                                <a href="#" class="deleteTopic" rel="${topic.id}">
                                                    <i class="ace-icon fa fa-times red bigger-125"></i>
                                                </a>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td class="center col-md-2">
                                        ${topic.totalViews}
                                    </td>
                                    <td class="center col-md-2">
                                        ${topic.totalReplies}
                                    </td>
                                    <td class="col-md-2">
                                        ${topic.lastPostByName}
                                        <br />
                                        <fmt:formatDate value="${topic.lastPostOn}" type="both" pattern="E MMM dd, yyyy h:mm a" />
                                    </td>
                                    <td><fmt:formatDate value="${topic.lastPostOn}" type="both" pattern="E MMM dd, yyyy h:mm a" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
    <div id="searchResults" class="col-sm-2" style="display:none; background-color: #f2f2f2; height:100vh; overflow: auto"></div>
</div>
