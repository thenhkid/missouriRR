<%-- 
    Document   : calendar
    Created on : May 18, 2015, 9:59:52 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="page-content">
    <div class="row">
        <div class="col-xs-12">
            <div class="clearfix">
                <div class="dropdown pull-left no-margin">
                    <button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                        Preferences
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="eventTypeManagerModel">Event Type Manager</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Event Notification Preferences</a></li>
                    </ul>
                </div>
                <div class="pull-right">
                    <div class="widget-box transparent no-margin">
                        <form class="form-search">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="ace-icon fa fa-search grey"></i></span>
                                <span class="block input-icon input-icon-right">
                                    <input type="text" placeholder="Search ..." class="width-150" id="nav-search-input" autocomplete="off" />
                                    <i id="clearSearch" class="ace-icon fa fa-times-circle red" style="cursor: pointer; display: none"></i>
                                </span>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="hr dotted"></div>

            <div>
                <!-- PAGE CONTENT BEGINS -->
                <div class="row">
                    <div class="col-sm-2">
                        <div class="space"></div>
                        <div class="widget-box transparent">
                            <div class="widget-header">
                                <h4>Categories to Show</h4>
                            </div>
                            <div class="widget-body">
                                <div class="dropdown dropdown-colorpicker open">
                                    <c:forEach var="eventType" items="${eventTypes}">
                                        <div style="padding-top:5px; cursor: pointer" class="showCategory" rel="${eventType.id}">
                                            <span class="btn-colorpicker center white" style="background-color:${eventType.eventTypeColor};">
                                                <i class="ace-icon fa fa-check" id="icon_${eventType.id}"></i>
                                            </span>
                                            ${eventType.eventType}
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="calendarDiv" class="col-sm-10">
                        <div class="space"></div>
                        <div id="calendar"></div>
                    </div>
                    <div id="searchResults" class="col-sm-2" style="display:none; background-color: #f2f2f2; height:100vh"></div>
                </div>

                <!-- PAGE CONTENT ENDS -->
            </div><!-- /.col -->
        </div>
    </div><!-- /.row -->    
</div>