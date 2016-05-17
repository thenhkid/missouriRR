<%-- 
    Document   : reportRequest
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty(reportTypes)}">
	No reports are available.
</c:if>

<c:if test="${!empty(reportTypes)}">

<div class="row">
    <div class="col-xs-12">
<div class="row">
     <div class="col-sm-12">
    Reporting Criteria:
    <hr/>
     </div>
</div>


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
                                                    <option value="${reportType.id}">${reportType.reportType}<c:if test="${fn:length(reportDesc) > 0}"> (${reportType.reportDesc})</c:if></option>
                                            </c:forEach>
                                            
                                    </select>
                                    <div id="errorMsg_reportType" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
               <%-- end of report types --%>
               
           <%-- start of available reports --%>
            <div class="row" id="reportDiv">
                 <jsp:include page="reportDiv.jsp"/>  
            </div>
            <%-- end of  available reports --%>
           
           
            
            <%-- start of counties, this should be closed & selected if user only has one county --%>
          
				<div class="row" id="entity1Div" style="display: none">
					<jsp:include page="entity1Div.jsp"/> 
				</div><!-- /.row --> 
           
           <%-- start of entity 2 --%>
            <div class="row" id="entity2Div" style="display: none">
                <jsp:include page="entity2Div.jsp"/>
            </div><!-- /.row -->
            
            <div class="row" style="display: none" id="entity3Div">
                <jsp:include page="entity3Div.jsp"/>
            </div><!-- /.row -->
            
            <div class="row" style="display: none"  id="criteriaDiv">
                <jsp:include page="criteriaDiv.jsp"/>
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
					<input type="hidden" name="reportCriteriaId" id="reportCriteriaIdForm" value=""/>
					<input type="hidden" name="criteriaValues" id="criteriaValuesForm" value=""/>
					<input type="hidden" name="reportIds" id="reportIdsForm" value=""/>
					<input type="hidden" name="reportTypeId" id="reportTypeIdForm" value=""/>
					<input type="hidden" name="selectedSites" id="selectedSitesForm" value=""/>
					<input type="hidden" name="entity1ListSize" id="entity1ListSize" value="${fn:length(entity1List)}"/>
				</form>
                </div>
    </div>
</div>
    </div>
</div>
</c:if>
