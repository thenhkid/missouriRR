<%-- 
    Document   : calendar.jsp
    Created on : Apr 24, 2015, 1:15:11 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>


<div class="main clearfix full-width" role="main">
    <div class="col-md-12">
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
</div>

<div id="createEventForm" style="display:none;">
    <div style="width:240px;">
        <form>
            <div class="form-group">
                <label class="sr-only" for="eventName">Event Name</label>
                <input type="text" class="form-control" name="eventName" placeholder="New Event" />
            </div>
            <div class="form-group">
                <label class="sr-only" for="eventLocation">Event Location</label>
                <input type="text" class="form-control" name="eventLocation" placeholder="Event Location" />
            </div>
            <hr />
            <div class="form-group">
                <label class="sr-only" for="eventDate">Event Date</label>
                <input type="text" class="form-control eventDate" name="eventDate" placeholder="Event Date" />
            </div>
            <div class="form-group">
                <div class="row clearfix">
                    <div class="col-md-5">
                        <select class="form-control"></select>
                    </div>
                    <div class="col-md-2">
                        to
                    </div>
                    <div class="col-md-5">
                        <select class="form-control"></select>
                    </div>
                </div>
            </div>
            <hr />
            <div class="form-group">
                <label for="eventNotes">Notes</label>
                <textarea type="text" class="form-control" name="eventNotes"></textarea>
            </div>
            <hr />
            <div class="form-group">
                <label for="document1">Documents</label>
                <input type="text" class="form-control" name="document1" placeholder="Attachment Name" />
                <input type="file" id="exampleInputFile">
            </div>
            <hr />
            <div class="checkbox">
                <label>
                    <input type="checkbox"> Alert all users of this new event?
                </label>
            </div>
            <hr />
            <button type="submit" class="btn btn-primary">Create</button>
        </form>
    </div>
</div>