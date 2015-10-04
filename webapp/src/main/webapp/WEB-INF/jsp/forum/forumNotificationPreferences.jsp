<%-- 
    Document   : forumNotificationPreferences
    Created on : Aug 10, 2015, 7:47:37 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="page-content">
    <div class="alert alert-block alert-success successAlert" style="display:none;">
        <button type="button" class="close" data-dismiss="alert">
            <i class="ace-icon fa fa-times"></i>
        </button>

        <p><strong><i class="ace-icon fa fa-check"></i></strong>
            You successfully updated your forum notification settings.
        </p>
    </div>

    <form:form id="notificationPreferencesForm" modelAttribute="notificationPreferences" role="form" class="form" method="post">
        <form:hidden path="id" />
        <form:hidden path="programId" />

        <div class="row">
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <form:checkbox path="newTopicsNotifications" />  Receive email notifications when new topics are added to my counties.
                    </label>
                </div>
            </div>
        </div>
        <div class="space-4"></div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <form:checkbox path="repliesTopicsNotifications" />  Receive email notifications when posts/comments are made to my topics.
                    </label>
                </div>
            </div>
        </div>
        <div class="space-4"></div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <form:checkbox path="myPostsNotifications" />  Receive email notifications when posts/comments are made to topics I have posted to.
                    </label>
                </div>
            </div>
        </div>            
        <div class="space-4"></div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <div class="form-group" id="notificationEmailGroup">
                <label for="notificationEmail">Notification & Alert Email Address</label>
                <form:input path="notificationEmail" class="form-control" placeholder="Notification & Alert Email Address" />
                <span id="notificationEmailMessage" class="control-label"></span>  
            </div>
        </div>

        <div class="hr hr-dotted"></div>
        <div class="row">
            <button type="submit" class="btn btn-primary" id="saveNotificationPreferences">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
        </div>
    </form:form>

</div>
