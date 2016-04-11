<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="/dspResources/js/reports/reportDiv.js"></script>

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
			    	<select name="selectedReports" class="multiselect form-control" id="reportIds" <c:if test="${reportType.allowMultiples}">multiple=""</c:if><c:if test="${!reportType.allowMultiples}">size="4"</c:if>>
				   		<c:forEach items="${reportList}" var="report">
				   			<option value="${report.id}"<c:if test="${fn:length(reportList) == 1}"> selected</c:if>>${report.reportName} ${report.reportDesc}</option>
				   		</c:forEach>  
					</select>
					<div id="errorMsg_reports" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
					<div id="reportButtons">  
						
							<button class="btn btn-success btn-next showEntity1RepButton" id="showEntity1RepButton" data-last="Show ${orgHierarchyList[0].name}" rel="${orgHierarchyList[0].name}">
							   Show ${orgHierarchyList[0].name}
							</button>
						<%-- 
							<button class="btn btn-success btn-next showEntity2RepButton" id="showEntity2RepButton" data-last="Show ${orgHierarchyList[1].name}" rel="${orgHierarchyList[1].name}" <c:if test="${entity1ListSize > 1}">style="display: none"</c:if>>
							   Show ${orgHierarchyList[1].name}
							</button>
						--%>
						<button class="btn btn-success btn-next changeRepButton" id="changeRepButton" data-last="Change ${orgHierarchyList[0].name}" style="display: none">
						   Change Reports
						</button>
						<button class="btn btn-success btn-next submitRepButton" id="submitRepButton" data-last="Submit Report" style="display: none">
						   Request Report
						</button>
						
					</div>
				</div>
			</div>   
		</div>
	</div>   
</div>


 