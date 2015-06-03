<%-- 
    Document   : calendar.jsp
    Created on : Apr 24, 2015, 1:15:11 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>


<div class="main clearfix full-width" role="main">
    <div class="col-md-12">

        <div class="row" style="margin-bottom: 10px;">
            <div class="col-md-6">
                <div class="dropdown pull-left">
                    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                        Preferences
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" data-toggle="modal" data-target="#eventTypeManagerModel">Event Type Manager</a></li>
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Event Notification Preferences</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <a class="btn btn-default pull-right" href="#" role="button">Categories to Show</a>
            </div>
        </div>



        <section class="panel panel-default">
            <div class="panel-heading" style="background-color:#ffffff;">
                <h3 class="panel-title"><Strong>Calendar</Strong></h3>
            </div>
            <div class="panel-body">
                <div class="page-header">

                    <div class="pull-right form-inline">
                        <div class="btn-group">
                            <button class="btn btn-primary" data-calendar-nav="prev"><< Prev</button>
                            <button class="btn" data-calendar-nav="today">Today</button>
                            <button class="btn btn-primary" data-calendar-nav="next">Next >></button>
                        </div>
                        <div class="btn-group">
                            <button class="btn btn-warning" data-calendar-view="year">Year</button>
                            <button class="btn btn-warning active" data-calendar-view="month">Month</button>
                            <button class="btn btn-warning" data-calendar-view="week">Week</button>
                            <button class="btn btn-warning" data-calendar-view="day">Day</button>
                        </div>
                    </div>

                    <h3></h3>
                    <small>To see example with events navigate to march 2013</small>
                </div>

                <div class="form-container scrollable" id="calendar"></div>
            </div>
        </section>
    </div>

    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-body">
                <dl class="dl-horizontal colorLegend">
                    <dt>Blue</dt>
                    <dd>Event description goes here</dd>
                    <dt>Blue</dt>
                    <dd>Event description goes here</dd>
                    <dt>Blue</dt>
                    <dd>Event description goes here</dd>
                    <dt>Blue</dt>
                    <dd>Event description goes here</dd>
                    <dt>Blue</dt>
                    <dd>Event description goes here</dd>
                </dl>
            </div>
        </div>
    </div>
</div>

<!-- Event Type Manager Modal -->
<div class="modal fade" id="eventTypeManagerModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>--%>
                <button type="button" id="addNewEventTypeButton" class="btn btn-default pull-right">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                </button>
                <h4 class="modal-title" id="myModalLabel">Event Types</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <div id="eventTypesTable"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <form id="newEventTypeForm" style="display:none;">
                            <h4>New Event Type</h4>
                            <hr />
                            <div class="form-group">
                                <label for="hexColor">Hex Color</label>
                                <input type="text" class="form-control" name="hexColor" placeholder="ex. #FFFFFF" />
                            </div>
                            <div class="form-group">
                                <label for="eventCategory">Event Type Category</label>
                                <input type="text" class="form-control" name="eventCategory" placeholder="Category Name" />
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox"> Admin Only Event
                                </label>
                            </div>
                            <hr />
                            <button type="submit" class="btn btn-primary">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>