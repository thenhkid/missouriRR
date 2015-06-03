<%-- 
    Document   : calendar
    Created on : May 18, 2015, 9:59:52 AM
    Author     : chadmccue
--%>

<div class="page-header" style="margin: 0; padding-bottom: 0; border-bottom: 0; height: 52px;">
    <div class="row">
            <div class="col-md-6">
                <div class="dropdown pull-left">
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
            <div class="col-md-6">
                <a class="btn btn-default pull-right" href="#" role="button" id="categoriesToShow">Categories to Show</a>
            </div>
        </div>
</div>

<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <div class="row">
            <div class="col-sm-9">
                <div class="space"></div>

                <div id="calendar"></div>
            </div>

            <div class="col-sm-3">
                <div class="widget-box transparent">
                    <div class="widget-header">
                        <h4>Something will go here</h4>
                    </div>
                    <%--<div class="widget-header">
                        <h4>Draggable events</h4>
                    </div>

                    <div class="widget-body">
                        <div class="widget-main no-padding">
                            <div id="external-events">
                                <div class="external-event label-grey" data-class="label-grey">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 1
                                </div>

                                <div class="external-event label-success" data-class="label-success">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 2
                                </div>

                                <div class="external-event label-danger" data-class="label-danger">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 3
                                </div>

                                <div class="external-event label-purple" data-class="label-purple">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 4
                                </div>

                                <div class="external-event label-yellow" data-class="label-yellow">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 5
                                </div>

                                <div class="external-event label-pink" data-class="label-pink">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 6
                                </div>

                                <div class="external-event label-info" data-class="label-info">
                                    <i class="ace-icon fa fa-arrows"></i>
                                    My Event 7
                                </div>

                                <label>
                                    <input type="checkbox" class="ace ace-checkbox" id="drop-remove" />
                                    <span class="lbl"> Remove after drop</span>
                                </label>
                            </div>
                        </div>
                    </div>--%>
                </div>
            </div>
        </div>

        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->