<%-- 
    Document   : forgotPassword
    Created on : Mar 13, 2014, 1:16:39 PM
    Author     : chadmccue
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="login-container">

    <div class="space-6"></div>
    <div class="center">
        <h4 class="blue" id="id-company-text">MO Healthy Schools Monitoring System</h4>
    </div>

    <div class="space-6"></div>

    <div class="position-relative">
        <div id="login-box" class="login-box visible widget-box no-border">
            <div class="widget-body">
                <div class="widget-main">
                    <h4 class="header red lighter bigger">
                        <i class="ace-icon fa fa-key"></i>
                        Reset Password
                    </h4>

                    <div class="space-6"></div>

                    <ul class="list-unstyled spaced2 passwordMsgContainer">
                        <li class="text-warning bigger-110 orange">
                            <i class="ace-icon fa fa-exclamation-triangle"></i>
                            <span id="newPasswordMsg"></span>
                        </li>
                    </ul>

                    <p>
                        Enter your new password below.
                    </p>

                    <form:form id="resetPassword" method="post" role="form">
                        <input type="hidden" name="resetCode" value="${resetCode}" />
                        <fieldset>
                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="password" class="form-control" placeholder="New Password" name="newPassword" id="newPassword" maxLength="15" autofocus="true" autocomplete="off" />
                                    <i class="ace-icon fa fa-lock"></i>
                                </span>
                            </label>

                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="password" class="form-control" placeholder="Confirm Password" name="confirmPassword" id="confirmPassword" maxLength="15" autofocus="true" autocomplete="off" />
                                    <i class="ace-icon fa fa-lock"></i>
                                </span>
                            </label>

                            <div class="clearfix">
                                <button type="button" class="width-35 pull-right btn btn-sm btn-danger resetPassword">
                                    <i class="ace-icon fa fa-lightbulb-o"></i>
                                    <span class="bigger-110">Continue!</span>
                                </button>
                            </div>
                        </fieldset>
                    </form:form>
                </div><!-- /.widget-main -->

            </div><!-- /.widget-body -->
        </div><!-- /.forgot-box -->
    </div>
</div>



