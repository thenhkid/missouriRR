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
    Reporting Criteria:
    <hr/>
     </div>
</div>
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
						<%--- get distinct report type ---%>
                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select name="reportTypeId" class="chosen-select form-control"  id="reportTypeId" data-placeholder="Select Report Type">
                                        	 <c:forEach items="${reportTypes}" var="reportType">
                                                    <option value="${reportType.id}">${reportType.reportType}</option>
                                            </c:forEach>
                                            
                                    </select>
                                    <div id="errorMsg_reportType" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
               <%-- end of report types --%>
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
                                        <c:forEach items="${reportList}" var="report">
                                                    <option value="${report.id}">${report.reportName}</option>
                                            </c:forEach>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
                <%-- end of surveys --%>
           
           
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
                                 <div class="input-group">
                                        <input class="form-control  date-picker  required Date" id="id-date-picker-1" type="text" name="startDate" data-date-format="mm/dd/yyyy" value="" />
                                          <span class="input-group-addon">
                                        <i class="fa fa-calendar bigger-110"></i>
                                         </span>
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
                                <div class="input-group">
                                        <input class="form-control  date-picker  required Date" id="id-date-picker-1" type="text" name="endDate" data-date-format="mm/dd/yyyy" value="" />
                                          <span class="input-group-addon">
                                        <i class="fa fa-calendar bigger-110"></i>
                                         </span>
                                  </div> 
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of row for start /end dates --%>
            
            <%-- start of counties, this should be closed & selected if user only has one county --%>
           <c:if test="${fn:length(entity1List) > 1}">
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                        <%-- hard coded because plural is not just adding (s)  --%>
                            <h4 class="widget-title">County / Counties </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up inactive"></i>
                                </a>
                            </div>
                        </div>
						
                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select name="entity1Ids" multiple="" class="chosen-select form-control" id="entity1Ids" data-placeholder="Select Counties...">
                                            <c:forEach items="${entity1List}" var="county">
                                                    <option value="${county.id}">${county.name} - ${county.id}</option>
                                            </c:forEach>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                                <div>
               					<button class="btn btn-success btn-next showEntity2" id="showEntity2" data-last="Show Districts">
                                                       Show Districts
                                </button>
                                <button class="btn btn-success btn-next changeEntity1" id="changeEntity1" data-last="Change Counties" style="display: none;">
                                                       Change Counties
                                </button>
                			</div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            </c:if>
            <c:if test="${fn:length(entity1List) == 1}">
                        	<input type="hidden" name="entit1Ids" value="${entity1List[0].id}"/>
            </c:if>
            
            <%-- start of districts --%>
            
            <div class="row" id="entity2Div" <c:if test="${fn:length(entity1List) != 1}">style="display: none"</c:if>>
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">District(s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entity2Ids" class="chosen-select form-control" id="schoolSelect" data-placeholder="Select Districts...">
                                       <c:forEach items="${entity2List}" var="entity">
                                                    <option value="${entity.id}">${entity.name}</option>
                                            </c:forEach>        
                                    </select>
                                    <div id="errorMsg_districts" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                                <button class="btn btn-success btn-next showEntity3" id="showEntity3" data-last="Show Schools">
                                                       Show Schools
                                </button>
                                <button class="btn btn-success btn-next changeEntity2" id="changeEntity2" data-last="Change Districts" style="display: none;">
                                                       Change Schools
                                </button>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            
            <div class="row" style="display: none" id="entity3Div">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">School(s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entity3Ids" class="chosen-select form-control" id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                       <c:forEach items="${entity3List}" var="entity">
                                                    <option value="${entity.id}">${entity.name}</option>
                                            </c:forEach>        
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            
            
            <div class="row" style="display: none"  id="contentDiv">
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
                                    <select multiple="" name="codeIds" class="chosen-select form-control" id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                       <c:forEach items="${codeList}" var="code">
                                                    <option value="${code.id}">${code.name}</option>
                                            </c:forEach>        
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
           
               <%-- buttons --%>
               <%-- this button should only be highlighted if there are surveys in the
               system fitting info --%>
                <div class="wizard-actions hidden">
               <button class="btn btn-success btn-next nextPage" data-last="Finish">
                                                        Request Report
                                                        
                                                    </button>
                </div>
    </div>
</div>

