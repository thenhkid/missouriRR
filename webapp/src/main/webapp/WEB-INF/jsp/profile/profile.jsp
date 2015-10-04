<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->

        <div >
            <div id="user-profile-3" class="user-profile row">
                <div class="col-sm-offset-1 col-sm-10">

                    <div class="space"></div>

                    <form id="profileForm" class="form-horizontal" method="post"  enctype="multipart/form-data">
                        <input type="hidden" id="avatar" src="/profilePhotos/${userDetails.profilePhoto}" />
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
                                            <div class="form-group" id="emailDiv">
                                                <label class="col-sm-4 control-label no-padding-right" for="email">Email</label>

                                                <div class="col-sm-8">
                                                    <input class="col-xs-12 col-sm-10" name="email" type="text" id="email" placeholder="Email" value="${userDetails.email}" />
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