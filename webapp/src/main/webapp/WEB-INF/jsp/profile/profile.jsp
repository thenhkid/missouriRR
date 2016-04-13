<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->

        <div >
            <div id="user-profile-3" class="user-profile row">
                <div class="col-sm-offset-1 col-sm-10">
                    
                    <c:if test="${not empty savedStatus}" >
                        <div class="col-md-12">
                            <div class="alert alert-success" role="alert">
                                <strong>Success!</strong> 
                                Your profile has been successfully updated!
                            </div>
                        </div>
                    </c:if>

                    <div class="space"></div>

                    <form id="profileForm" class="form-horizontal" method="post"  enctype="multipart/form-data">
                        <input type="hidden" id="avatar" src="/profilePhotos/${userDetails.profilePhoto}" />
                        <input type="hidden" name="updateAllEmails" id="updateAllEmails" value="0" />
                        <input type="hidden" id="currEmail" value="${userDetails.email}" />
                        <div class="tabbable">
                            <ul class="nav nav-tabs padding-16">
                                <li class="active">
                                    <a data-toggle="tab" href="#edit-basic">
                                        <i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
                                        Basic Info
                                    </a>
                                </li>

                                <%--<li>
                                    <a data-toggle="tab" href="#edit-settings">
                                        <i class="purple ace-icon fa fa-cog bigger-125"></i>
                                        Settings
                                    </a>
                                </li>--%>

                                <li>
                                    <a data-toggle="tab" href="#edit-password">
                                        <i class="blue ace-icon fa fa-key bigger-125"></i>
                                        Password
                                    </a>
                                </li>
                                <c:if test="${showCalendarNotifications == true || showForumNotifications == true || showDocumentNotifications == true}">
                                    <li>
                                        <a data-toggle="tab" href="#edit-notifications">
                                            <i class="blue ace-icon fa fa-bell bigger-125"></i>
                                            Notifications
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${showSkillSets == true}">
                                    <li>
                                        <a data-toggle="tab" href="#edit-resources">
                                            <i class="blue ace-icon fa fa-wrench bigger-125"></i>
                                            Skills
                                        </a>
                                    </li>
                                </c:if>
                            </ul>

                            <div class="tab-content profile-edit-tab-content">
                                <div id="edit-basic" class="tab-pane in active">
                                    <h4 class="header blue bolder smaller">General</h4>

                                    <div class="row">
                                        <div class="col-xs-12 col-sm-4">
                                            <input name="profilePhoto" type="file" value="${userDetails.profilePhoto}" />
                                        </div>

                                        <div class="vspace-12-sm"></div>

                                        <div class="col-xs-12 col-sm-8">
                                            
                                            <div class="form-group">
                                                <label class="col-sm-4 control-label no-padding-right" for="privateProfile">Profile Status</label>
                                                <div class="col-sm-8">
                                                    <label class="radio-inline">
                                                        <input type="radio" name="privateProfile" value="1" <c:if test="${userDetails.privateProfile == true}">checked</c:if> /> Private
                                                    </label>
                                                    <label class="radio-inline">
                                                        <input type="radio" name="privateProfile" value="0" <c:if test="${userDetails.privateProfile == false}">checked</c:if> /> Public
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <div class="space-4"></div>
                                            
                                             <div class="form-group" id="phoneNumberDiv">
                                                <label class="col-sm-4 control-label no-padding-right" for="phoneNumber">Phone Number</label>

                                                <div class="col-sm-8">
                                                    <input class="col-xs-12 col-sm-10" name="phoneNumber" type="text" id="phoneNumber" placeholder="Phone Number" value="${userDetails.phoneNumber}" />
                                                </div>

                                            </div>
                                                
                                            <div class="space-4"></div>
                                            
                                            <div class="form-group" id="emailDiv">
                                                <label class="col-sm-4 control-label no-padding-right" for="email">Email</label>

                                                <div class="col-sm-8">
                                                    <input class="col-xs-12 col-sm-10" name="email" type="text" id="email" placeholder="Email" value="${userDetails.email}" />
                                                </div>

                                            </div>
                                                
                                            <div class="space-4"></div>
                                            
                                            <div class="form-group <c:if test="${not empty existingUser}">has-error</c:if>" id="usernameDiv">
                                                <label class="col-sm-4 control-label no-padding-right" for="email">Username</label>

                                                <div class="col-sm-8">
                                                    <input class="col-xs-12 col-sm-10" name="username" type="text" id="username" placeholder="Username" value="${userDetails.username}" />
                                                    <c:if test="${not empty existingUser}">
                                                        <br />
                                                        <span class="col-xs-10 control-label has-error">${existingUser}</span>
                                                    </c:if>
                                                </div>
                                            </div>    

                                            <div class="space-4"></div>

                                            <div class="form-group" id="nameDiv">
                                                <label class="col-sm-4 control-label no-padding-right" for="firstName">Name</label>

                                                <div class="col-sm-8">
                                                    <input class="input-small" name="firstName" type="text" id="firstName" placeholder="First Name" value="${userDetails.firstName}" />
                                                    <input class="input-small" name="lastName" type="text" id="lastName" placeholder="Last Name" value="${userDetails.lastName}" />
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <%--<div class="space"></div>
                                    <h4 class="header blue bolder smaller">Social</h4>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="form-field-facebook">Facebook</label>

                                        <div class="col-sm-9">
                                            <span class="input-icon">
                                                <input type="text" value="facebook_alexdoe" id="form-field-facebook" />
                                                <i class="ace-icon fa fa-facebook blue"></i>
                                            </span>
                                        </div>
                                    </div>--%>

                                    <div class="space-4"></div>

                                </div>

                                <%--<div id="edit-settings" class="tab-pane">
                                    <div class="space-10"></div>

                                    <div>
                                        <label class="inline">
                                            <input type="checkbox" name="form-field-checkbox" class="ace" />
                                            <span class="lbl"> Make my profile public</span>
                                        </label>
                                    </div>

                                    <div class="space-8"></div>

                                    <div>
                                        <label class="inline">
                                            <input type="checkbox" name="form-field-checkbox" class="ace" />
                                            <span class="lbl"> Email me new updates</span>
                                        </label>
                                    </div>

                                    <div class="space-8"></div>

                                    <div>
                                        <label>
                                            <input type="checkbox" name="form-field-checkbox" class="ace" />
                                            <span class="lbl"> Keep a history of my conversations</span>
                                        </label>

                                        <label>
                                            <span class="space-2 block"></span>

                                            for
                                            <input type="text" class="input-mini" maxlength="3" />
                                            days
                                        </label>
                                    </div>
                                </div>--%> 

                                <div id="edit-password" class="tab-pane">
                                    <div class="space-10"></div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="newPassword">New Password</label>

                                        <div class="col-sm-9">
                                            <input type="password" name="newPassword" id="newPassword" />
                                        </div>
                                    </div>

                                    <div class="space-4"></div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right" for="newPassword2">Confirm Password</label>

                                        <div class="col-sm-9">
                                            <input type="password" id="newPassword2" />
                                        </div>

                                    </div>

                                    <div class="space-4"></div>

                                    <div class="form-group">
                                        <label class="col-sm-3 control-label no-padding-right">&nbsp;</label>

                                        <div class="col-sm-9">
                                            <span id="newPasswordMsg" class="control-label"></span>
                                        </div>

                                    </div>

                                </div>
                                
                                <div id="edit-notifications" class="tab-pane">
                                    
                                    <c:if test="${showCalendarNotifications == true}">
                                        <input type="hidden" name="calendarNotificationId" value="${calendarNotificationPreferences.id}" />
                                        
                                        <h4 class="header blue bolder smaller">Calendar Notifications</h4>

                                        <div class="row page-content">
                                            <div class="col-xs-12">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="newEventNotifications" <c:if test="${calendarNotificationPreferences.newEventNotifications == true}">checked</c:if> />  Receive email notifications when new events are added to the calendar.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="modifyEventNotifications" <c:if test="${calendarNotificationPreferences.modifyEventNotifications == true}">checked</c:if> />  Receive email notifications when calendar events are modified.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group" id="notificationEmailGroup">
                                                        <label for="notificationEmail">Notification & Alert Email Address</label>
                                                        <input type="text" name="calendarnotificationEmail" value="${calendarNotificationPreferences.notificationEmail}" class="form-control" placeholder="Notification & Alert Email Address" />
                                                        <span id="notificationEmailMessage" class="control-label"></span>  
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                        
                                    <c:if test="${showForumNotifications == true}">
                                        <input type="hidden" name="forumNotificationId" value="${forumNotificationPreferences.id}" />
                                        <h4 class="header blue bolder smaller">Forum Notifications</h4>

                                        <div class="row page-content">
                                            <div class="col-xs-12">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="newTopicsNotifications" <c:if test="${forumNotificationPreferences.newTopicsNotifications == true}">checked</c:if> />  Receive email notifications when new topics are added.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="repliesTopicsNotifications" <c:if test="${forumNotificationPreferences.repliesTopicsNotifications == true}">checked</c:if> />  Receive email notifications when posts/comments are made to my topics.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="myPostsNotifications" <c:if test="${forumNotificationPreferences.myPostsNotifications == true}">checked</c:if> />  Receive email notifications when posts/comments are made to topics I have posted to.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>            
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group" id="notificationEmailGroup">
                                                        <label for="notificationEmail">Notification & Alert Email Address</label>
                                                        <input type="text" name="forumnotificationEmail" value="${forumNotificationPreferences.notificationEmail}" class="form-control" placeholder="Notification & Alert Email Address" />
                                                        <span id="notificationEmailMessage" class="control-label"></span>  
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="space-4"></div>
                                    </c:if>
                                        
                                    <c:if test="${showDocumentNotifications == true}">
                                        <input type="hidden" name="documentNotificationId" value="${documentNotificationPreferences.id}" />
                                        <h4 class="header blue bolder smaller">Document Notifications</h4>

                                        <div class="row page-content">
                                            <div class="col-xs-12">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="myHierarchiesOnly" <c:if test="${documentNotificationPreferences.myHierarchiesOnly == true}">checked</c:if> />  Receive email notifications for new documents for my counties only.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="allDocs" <c:if test="${documentNotificationPreferences.allDocs == true}">checked</c:if> />  Receive email notifications for all new documents.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>              
                                                <div class="space-4"></div>
                                                <div class="hr hr-dotted"></div>
                                                <div class="row">
                                                    <div class="form-group" id="notificationEmailGroup">
                                                        <label for="notificationEmail">Notification & Alert Email Address</label>
                                                        <input type="text" name="documentnotificationEmail" value="${documentNotificationPreferences.notificationEmail}" class="form-control" placeholder="Notification & Alert Email Address" />
                                                        <span id="notificationEmailMessage" class="control-label"></span>  
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="space-4"></div>
                                    </c:if>  
                                        
                                    <c:if test="${showAnnouncementNotifications == true}">
                                        <input type="hidden" name="announcementNotificationId" value="${announcementNotificationPreferences.id}" />
                                        <h4 class="header blue bolder smaller">Announcement Notifications</h4>

                                        <div class="row page-content">
                                            <div class="col-xs-12">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="announcementmyHierarchiesOnly" <c:if test="${announcementNotificationPreferences.myHierarchiesOnly == true}">checked</c:if> />  Receive email notifications for new and updated announcements for my counties only.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="space-4"></div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="checkbox">
                                                            <label>
                                                                <input type="checkbox" name="allAnnouncements" <c:if test="${announcementNotificationPreferences.allAnnouncements == true}">checked</c:if> />  Receive email notifications for all new and updated announcements.
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>              
                                                <div class="space-4"></div>
                                                <div class="hr hr-dotted"></div>
                                                <div class="row">
                                                    <div class="form-group" id="notificationEmailGroup">
                                                        <label for="notificationEmail">Notification & Alert Email Address</label>
                                                        <input type="text" name="announcementnotificationEmail" value="${announcementNotificationPreferences.notificationEmail}" class="form-control" placeholder="Notification & Alert Email Address" />
                                                        <span id="notificationEmailMessage" class="control-label"></span>  
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                        <div class="space-4"></div>
                                    </c:if> 
                                </div>
                                
                                <c:if test="${showSkillSets == true}">
                                <div id="edit-resources" class="tab-pane">
                                    <h4 class="header blue bolder smaller">Select Your Skills</h4>
                                    <div class="row">
                                        <c:choose>
                                            <c:when test="${not empty programResources}">
                                                <c:forEach items="${programResources}" var="resource">
                                                    <div class="col-xs-12 col-sm-6" style="margin-bottom:3px;">
                                                        <div>
                                                             <label class="inline">
                                                                <input type="checkbox" name="selectedResources" class="ace" value="${resource.id}" <c:if test="${resource.selected == true}">checked="true"</c:if> />
                                                                <span class="lbl"> ${resource.resource}</span>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </c:forEach> 
                                            </c:when>
                                            <c:otherwise>
                                                 <div class="col-xs-12 col-sm-6" style="margin-bottom:3px;">No skills have been set up.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>   
                                </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="space-10"></div>

                        <div class="clearfix wizard-actions">
                            <button class="btn" type="button">
                                <i class="ace-icon fa fa-save "></i>
                                Save
                            </button>
                        </div>
                    </form>
                </div><!-- /.span -->
            </div><!-- /.user-profile -->
        </div>

        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->