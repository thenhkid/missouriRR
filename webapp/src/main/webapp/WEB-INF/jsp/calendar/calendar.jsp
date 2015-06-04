<%-- 
    Document   : calendar
    Created on : May 18, 2015, 9:59:52 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="page-header" style="margin: 0; padding-bottom: 0; border-bottom: 0; height: 52px;">
    <div class="row">
        <div class="col-md-12">
            <div class="dropdown pull-right">
                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Preferences
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="eventTypeManagerModel">Event Type Manager</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Event Notification Preferences</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <div class="row">
            <div class="col-sm-2">
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
            <div class="col-sm-8">
                <div class="space"></div>

                <div id="calendar"></div>
            </div>
            <div class="col-sm-2">
                <div class="widget-box transparent">
                    <div class="widget-header">
                        <h4>Something will go here</h4>
                    </div>
                </div>
            </div>
        </div>

        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->