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
                            <div class="widget-main" id="reportTypeDiv">
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
                            <h4 class="widget-title">Reports</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div id="selectReportDiv">
                                <%@ include file="optionReports.jsp" %>                             
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
                            <div class="widget-main" id="startDateDiv">
                                <div class="input-group">
                                    <input class="form-control date-picker required Date" id="startDate" type="text" name="startDate"  data-date-format="yyyy-mm-dd" value="" />
                                    <span class="input-group-addon"><i class="fa fa-calendar bigger-110"></i></span>
                               </div>   
                                <div id="errorMsg_startDate" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
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
                                <div class="input-group" id="endDateDiv">
                                    <input class="form-control date-picker required Date" id="endDate" type="text" name="endDate" data-date-format="yyyy-mm-dd" value="" />
                                    <span class="input-group-addon"><i class="fa fa-calendar bigger-110"></i></span>
                               </div> 
                               <div id="errorMsg_endDate" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of row for start /end dates --%>
            
            <%-- start of counties, this should be closed & selected if user only has one county --%>
           <div class="row" id="entity1Div">
           <c:if test="${fn:length(entity1List) > 1}">
            	<div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                        <h4 class="widget-title">${orgHierarchyList[0].name} (s)</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up inactive"></i>
                                </a>
                            </div>
                        </div>
						
                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                <select name="selectedEntities" class="multiselect form-control" id="entity1Ids" multiple="">
                                            <c:forEach items="${entity1List}" var="entity">
                                                    <option value="${entity.id}">${entity.name}</option>
                                            </c:forEach>
                                    </select>
                                    <div id="errorMsg_entity1" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                                <div>
               					<button class="btn btn-success btn-next showEntity2" id="showEntity2" data-last="Show ${orgHierarchyList[1].name}" rel="${orgHierarchyList[0].name}">
                                                       Show ${orgHierarchyList[1].name} (s)
                                </button>
                                <button class="btn btn-success btn-next changeEntity1" id="changeEntity1" data-last="Change ${orgHierarchyList[0].name}" style="display: none;">
                                                       Change ${orgHierarchyList[0].name} (s)
                                </button>
                			</div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </c:if>
            <c:if test="${fn:length(entity1List) == 1}">
                        	<input type="hidden" name="entit1Ids" value="${entity1List[0].id}"/>
            </c:if>
            </div><!-- /.row -->
            <%-- start of entity 2 --%>
            
            <div class="row" id="entity2Div" <c:if test="${fn:length(entity1List) != 1}">style="display: none"</c:if>>
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">${orgHierarchyList[1].name} (s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div id="entity2SelectDiv">
                                    <jsp:include page="optionEntities.jsp"/>                                           
                                </div>
                                <button class="btn btn-success btn-next showEntity3" id="showEntity3" data-last="Show ${orgHierarchyList[2].name} (s)" rel="${orgHierarchyList[1].name}">
                                                       Show ${orgHierarchyList[2].name} (s)
                                </button>
                                <button class="btn btn-success btn-next changeEntity2" id="changeEntity2" data-last="Change ${orgHierarchyList[1].name} (s)" style="display: none;">
                                                       Change ${orgHierarchyList[1].name} (s)
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
                            <h4 class="widget-title">${orgHierarchyList[2].name} (s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <div id="entity3SelectDiv">
                                    <jsp:include page="optionEntities.jsp"/>                                      
                                </div>
                                </div>
                                <button class="btn btn-success btn-next showCodes" id="showCodes" data-last="Show ${orgHierarchyList[2].name} (s)" rel="${orgHierarchyList[2].name}">
                                                       Show Content Area & Criteria
                                </button>
                                <button class="btn btn-success btn-next changeEntity3" id="changeEntity3" data-last="Change ${orgHierarchyList[1].name} (s)" style="display: none;">
                                                       Change ${orgHierarchyList[2].name} (s)
                                </button>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            
            <%-- discuss how to handle this section because it doesn't apply to Maine --%>
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
                                <div class="codesSelectDiv">
                                <jsp:include page="optionCodes.jsp"/>
                             	</div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
           
               <%-- buttons --%>
               <%-- this button should only be highlighted if there are surveys in the
               system fitting info --%>
                <div class="wizard-actions" style="display: none" id="requestButton">
                <form action="saveReportRequest.do" method="post" id="requestForm">
					<input type="hidden" name="startDate" id="startDateForm" value=""/>
					<input type="hidden" name="endDate" id="endDateForm" value=""/>
					<input type="hidden" name="entity3Ids" id="entity3IdsForm" value=""/>
					<input type="hidden" name="codeIds" id="codeIdsForm" value=""/>
					<input type="hidden" name="reportIds" id="reportIdsForm" value=""/>
				
               <button class="btn btn-success btn-next nextPage" data-last="Finish" id="submitButton">
                                                        Request Report
                </button>
                </form>
                </div>
    </div>
</div>
    </div>
</div>
    </div>
</div>
