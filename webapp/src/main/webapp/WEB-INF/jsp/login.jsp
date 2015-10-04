<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<div class="login-container" style="height:100%">

    <div class="space-6"></div>

    <div class="position-relative"  >
        <div id="login-box" class="login-box visible widget-box no-border">
            <div class="widget-body">
                <div class="widget-main">
                    <h4 class="header blue lighter bigger">
                        <i class="ace-icon fa fa-coffee green"></i>
                        Please Enter Your Information
                    </h4>
                    
                    <c:choose>
                        <c:when test="${not empty error}">
                            <ul class="list-unstyled spaced2">
                                <li class="text-warning bigger-110 orange">
                                    <i class="ace-icon fa fa-exclamation-triangle"></i>
                                   ${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message} 
                                </li>
                            </ul>
                        </c:when>
                        <c:otherwise><div class="space-6"></div></c:otherwise>
                    </c:choose>
                        
                    <%
                        if (request.getParameter("expired") != null) {
                            out.println("<ul class=\"list-unstyled spaced2\"><li class=\"text-warning bigger-110 orange\"><i class=\"ace-icon fa fa-exclamation-triangle\"></i>Your session has expired.</li></ul>");
                        } 
                    %>    
                    
                    <form role="form" id="form-admin-login" name='f' action="<c:url value='j_spring_security_check' />" method='POST'>
                        <fieldset>
                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="text" class="form-control username" placeholder="Username" name="j_username" value="" autofocus="true" autocomplete="off" />
                                    <i class="ace-icon fa fa-user"></i>
                                </span>
                            </label>

                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="password" class="form-control" placeholder="Password" name="j_password" value="" autocomplete="off" />
                                    <i class="ace-icon fa fa-lock"></i>
                                </span>
                            </label>

                            <div class="space"></div>

                            <div class="clearfix">
                               <!-- <label class="inline">
                                    <input type="checkbox" class="ace" />
                                    <span class="lbl"> Remember Me</span>
                                </label>-->

                                <button type="submit" class="width-35 pull-right btn btn-sm btn-primary">
                                    <i class="ace-icon fa fa-key"></i>
                                    <span class="bigger-110">Login</span>
                                </button>
                            </div>

                            <div class="space-4"></div>
                        </fieldset>
                    </form>


                </div><!-- /.widget-main -->

                <div class="toolbar clearfix">
                    <div>
                        <a href="#" data-target="#forgot-box" class="forgot-password-link">
                            <i class="ace-icon fa fa-arrow-left"></i>
                            I forgot my password
                        </a>
                    </div>

                    <!--<div>
                        <a href="#" data-target="#signup-box" class="user-signup-link">
                            I want to register
                            <i class="ace-icon fa fa-arrow-right"></i>
                        </a>
                    </div>-->
                </div>
            </div><!-- /.widget-body -->
        </div><!-- /.login-box -->

        <div id="forgot-box" class="forgot-box widget-box no-border">
            <div class="widget-body">
                <div class="widget-main">
                    <h4 class="header red lighter bigger">
                        <i class="ace-icon fa fa-key"></i>
                        Retrieve Password
                    </h4>

                    <div class="space-6"></div>
                    
                    <ul class="list-unstyled spaced2" id="retrievePasswordMsg">
                        <li class="text-warning bigger-110 green" id="passwordFound">
                           <i class="ace-icon fa fa-check"></i>
                           An email has been sent that will contain a link to reset your password.
                        </li>
                        <li class="text-warning bigger-110 orange" id="passwordNotFound">
                           <i class="ace-icon fa fa-exclamation-triangle"></i>
                           Your search did not return any results. Please try again with other information.
                        </li>
                    </ul>

                    <p>
                        Enter your email and to receive instructions
                    </p>

                    <form>
                        <fieldset>
                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="email" id="email" class="form-control" placeholder="Email" />
                                    <i class="ace-icon fa fa-envelope"></i>
                                </span>
                            </label>

                            <div class="clearfix">
                                <button type="button" class="width-35 pull-right btn btn-sm btn-danger sendPasswordEmail">
                                    <i class="ace-icon fa fa-lightbulb-o"></i>
                                    <span class="bigger-110">Send Me!</span>
                                </button>
                            </div>
                        </fieldset>
                    </form>
                </div><!-- /.widget-main -->

                <div class="toolbar center">
                    <a href="#" data-target="#login-box" class="back-to-login-link">
                        Back to login
                        <i class="ace-icon fa fa-arrow-right"></i>
                    </a>
                </div>
            </div><!-- /.widget-body -->
        </div><!-- /.forgot-box -->

        <div id="signup-box" class="signup-box widget-box no-border">
            <div class="widget-body">
                <div class="widget-main">
                    <h4 class="header green lighter bigger">
                        <i class="ace-icon fa fa-users blue"></i>
                        New User Registration
                    </h4>

                    <div class="space-6"></div>
                    <p> Enter your details to begin: </p>

                    <form>
                        <fieldset>
                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="email" class="form-control" placeholder="Email" />
                                    <i class="ace-icon fa fa-envelope"></i>
                                </span>
                            </label>

                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="text" class="form-control" placeholder="Username" />
                                    <i class="ace-icon fa fa-user"></i>
                                </span>
                            </label>

                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="password" class="form-control" placeholder="Password" />
                                    <i class="ace-icon fa fa-lock"></i>
                                </span>
                            </label>

                            <label class="block clearfix">
                                <span class="block input-icon input-icon-right">
                                    <input type="password" class="form-control" placeholder="Repeat password" />
                                    <i class="ace-icon fa fa-retweet"></i>
                                </span>
                            </label>

                            <label class="block">
                                <input type="checkbox" class="ace" />
                                <span class="lbl">
                                    I accept the
                                    <a href="#">User Agreement</a>
                                </span>
                            </label>

                            <div class="space-24"></div>

                            <div class="clearfix">
                                <button type="reset" class="width-30 pull-left btn btn-sm">
                                    <i class="ace-icon fa fa-refresh"></i>
                                    <span class="bigger-110">Reset</span>
                                </button>

                                <button type="button" class="width-65 pull-right btn btn-sm btn-success">
                                    <span class="bigger-110">Register</span>

                                    <i class="ace-icon fa fa-arrow-right icon-on-right"></i>
                                </button>
                            </div>
                        </fieldset>
                    </form>
                </div>

                <div class="toolbar center">
                    <a href="#" data-target="#login-box" class="back-to-login-link">
                        <i class="ace-icon fa fa-arrow-left"></i>
                        Back to login
                    </a>
                </div>
            </div><!-- /.widget-body -->
        </div><!-- /.signup-box -->
    </div><!-- /.position-relative -->


</div>
