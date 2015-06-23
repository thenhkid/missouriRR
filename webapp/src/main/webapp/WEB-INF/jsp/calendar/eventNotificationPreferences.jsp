<%-- 
    Document   : eventNotificationPreferences
    Created on : Jun 23, 2015, 11:37:37 AM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div id="" class="row">
    <div class="col-sm-12">
        <form:form id="notificationPreferencesForm" modelAttribute="notificationPreferences" role="form" class="form" method="post">

            <form:input type="text" path="id" />

            <div class="checkbox">
                <label>
                    <input type="checkbox" id="stopAllAlerts" name="stopAllAlerts" value="1" /> Stop all notifications for new events
                </label>
            </div>

            <hr />

            <div id="notificationDiv" <c:if test="${calendarNotificationPreferences.newEventNotifications == true}">style="display:none;"</c:if>>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="alwaysCreateAlert" name="alwaysCreateAlert" value="1" <c:if test="${calendarNotificationPreferences.alwaysCreateAlert == true}">checked="checked"</c:if> /> Always create an alert
                    </label>
                </div>

                <div>
                    <select id="notificationFrequency" name="notificationFrequency" class="form-control">
                        <option value="">-</option>
                        <option value="0">Email: At time of event</option>
                        <option value="5">Email: 5 Min before event</option>
                        <option value="10">Email: 10 Min before event</option>
                        <option value="15">Email: 15 Min before event</option>
                        <option value="30">Email: 30 Min before event</option>
                        <option value="60">Email: 1 hour before event</option>
                        <option value="120">Email: 2 hour before event</option>
                        <option value="1440">Email: 1 day before event</option>
                        <option value="2880">Email: 2 days before event</option>
                    </select>
                </div>

                <hr />

                <div class="form-group">
                    <label for="notificationEmail" class="control-label">Notification & Alert Email Address</label>
                    <form:input path="notificationEmail" class="form-control" placeholder="Email Address" />
                    <div id="error_alertEmailAddress" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                </div>
            </div>
                
            <button type="submit" class="btn btn-primary" id="saveNotificationPreferences" name="saveNotificationPreferences">Save</button>
        </form:form>

    </div>
</div>
