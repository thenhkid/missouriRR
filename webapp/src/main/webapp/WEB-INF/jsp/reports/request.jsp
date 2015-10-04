<%-- 
    Document   : survey
    Created on : Mar 5, 2015, 1:10:08 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="row">
    <div class="col-xs-12">
<div class="row">
     <div class="col-sm-12">
    Please select reporting criteria:
    <hr/>
     </div>
</div>
        <form class="form-horizontal" id="newReport" method="post" action="/reports" role="form">
            <%-- row for start /end dates --%>
            <div class="row">
                <div class="col-sm-6">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Start Date</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <div class="input-group">
                                        <input class="form-control datepicker required" id="id-date-picker-1" type="text" name="startDate" data-date-format="mm/dd/yyyy" value="" autocomplete="off">
                                        <span class="input-group-addon">
                                            <i class="fa fa-calendar bigger-110"></i>
                                        </span>
                                    </div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->

                <div class="col-sm-6">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">End Date</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <div class="input-group">
                                        <input class="form-control datepicker required" id="id-date-picker-1" type="text" name="endDate" data-date-format="mm/dd/yyyy" value="" autocomplete="off">
                                        <span class="input-group-addon">
                                            <i class="fa fa-calendar bigger-110"></i>
                                        </span>
                                    </div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of row for start /end dates --%>
            <%-- start of hierarchies 
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">County / District / Schools</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <c:forEach items="${selDistricts}" var="district">
                                            <optgroup label="${district.districtName}">
                                                <c:forEach items="${district.schoolList}" var="school">
                                                    <option value="${school.schoolId}" <c:if test="${fn:contains(survey.entityIds, school.schoolId)}">selected</c:if>>${school.schoolName}</option>
                                                </c:forEach>
                                            </optgroup>
                                        </c:forEach>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            --%>
            <%-- end of hierarchies --%>
            
            <%-- hard coded for now --%>
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Please select county / counties </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option value="">County 1</option>
                                        <option value="">County 2</option>
                                        <option value="">County 3</option>         
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Please select district(s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option value="">Campbell</option>
                                        <option value="">Green Forest</option>
                                        <option value="">Houston</option>         
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Please select school(s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option value="">Campbell Elementary</option>
                                        <option value="">Campbell High</option>
                                        <option value="">Green Forest Elementary</option> 
                                        <option value="">Houston Elementary</option>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of hard coded for now --%>
            
            
            <%-- start of content and criteria --%>
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Content Area & Criteria</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option>School Health, Safety Policies & Environment</option>
                                            <option>Health Education</option>
                                            <option>Physical Education & Physical Activity Programs</option>
                                            <option>Nutrition Services</option>
                                            <option>Health Promotion for Staff</option>
                                            <option>Family and Community Involvement</option>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of content and criteria --%>
            
            <%-- start of surveys --%>
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Surveys</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option>Resources Leveraged/Grant Proposals</option>
                                            <option>Resources / Tools Used</option>
                                            <option>Meetings</option>
                                            <option>Media/Promotions</option>
                                            <option>Events/Programs</option>
                                            <option>Successes/Challenges/Other Info</option>
                                            <option>Practice, Policy,  Environmental Change</option>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
                <%-- end of surveys --%>
                
                <%-- start of report types --%>
                <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Report Type</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option>Summary Counts</option>
                                            <option>Qualitative Detail</option>
                                            
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
               <%-- end of report types --%>
               <%-- buttons --%>
                <div class="wizard-actions">
               <button class="btn btn-success btn-next nextPage" data-last="Finish">
                                                        Request Report
                                                        
                                                    </button>
                </div>
        </form>
    </div>
</div>

