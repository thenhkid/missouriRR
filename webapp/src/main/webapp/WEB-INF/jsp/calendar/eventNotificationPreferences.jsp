<%-- 
    Document   : eventNotificationPreferences
    Created on : Jun 23, 2015, 11:37:37 AM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="page-content">
    <form:form id="notificationPreferencesForm" modelAttribute="notificationPreferences" role="form" class="form" method="post">
        <form:hidden path="id" />

        <div class="row">
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <form:checkbox path="newEventNotifications"   />  Stop all notifications for new events
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
                        <form:checkbox path="alwaysCreateAlert"   />  Always create an alert
                    </label>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-group">
                <form:select path="emailAlertMin" class="form-control">
                    <option value="">-</option>
                    <option value="0" <c:if test="${notificationPreferences.emailAlertMin == 0}"> selected </c:if>>Email: At time of event</option>
                    <option value="5" <c:if test="${notificationPreferences.emailAlertMin == 5}"> selected </c:if>>Email: 5 Min before event</option>
                    <option value="10" <c:if test="${notificationPreferences.emailAlertMin == 10}"> selected </c:if>>Email: 10 Min before event</option>
                    <option value="15" <c:if test="${notificationPreferences.emailAlertMin == 15}"> selected </c:if>>Email: 15 Min before event</option>
                    <option value="30" <c:if test="${notificationPreferences.emailAlertMin == 30}"> selected </c:if>>Email: 30 Min before event</option>
                    <option value="60" <c:if test="${notificationPreferences.emailAlertMin == 60}"> selected </c:if>>Email: 1 hour before event</option>
                    <option value="120" <c:if test="${notificationPreferences.emailAlertMin == 120}"> selected </c:if>>Email: 2 hour before event</option>
                    <option value="1440" <c:if test="${notificationPreferences.emailAlertMin == 1440}"> selected </c:if>>Email: 1 day before event</option>
                    <option value="2880" <c:if test="${notificationPreferences.emailAlertMin == 2880}"> selected </c:if>>Email: 2 days before event</option>
                </form:select>
            </div>
        </div>
        <div class="space-4"></div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <div class="form-group">
                <label for="notificationEmail">Notification & Alert Email Address</label>
                <form:input path="notificationEmail" class="form-control" placeholder="Notification & Alert Email Address" />
            </div>
        </div>
        <div class="space-4"></div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <button type="submit" class="btn btn-primary" id="saveNotificationPreferences">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
        </div>
    </form:form>

</div>
