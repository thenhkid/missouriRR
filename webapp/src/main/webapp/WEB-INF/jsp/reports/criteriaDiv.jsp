<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="/dspResources/js/reports/criteriaDiv.js"></script>

<div class="col-sm-12" id="criteriaDivId">
	<div class="widget-box">
		<div class="widget-header">
			<h4 class="widget-title">Content Area and Criteria</h4>
			<div class="widget-toolbar">
				<a href="#" data-action="collapse">
				<i class="ace-icon fa fa-chevron-up"></i>
				</a>
			</div>
		</div>
		<div class="widget-body">
			<div class="widget-main">
				
				<c:if test="${fn:length(codeList) < 1}">
					<div id="criteriaSelectDiv">
						There are no data fitting the above criteria.  Please change your selections.
					</div>
				</c:if>
				<c:if test="${fn:length(codeList) >= 1}">
					<div id="criteriaSelectDiv">
						<select name="selectedCriterias" class="multiselect form-control" id="criteriaValues" multiple="">
							<c:forEach items="${codeList}" var="code">
								<option value="${code.id}"<c:if test="${fn:length(codeList) == 1}"> selected</c:if>>${code.code}:${code.codeDesc}</option>
							</c:forEach> 
						</select>
						<div id="errorMsg_criteria" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
					
					</div>	
					<button class="btn btn-success btn-next criteriaDivSubmitButton" id="criteriaDivSubmitButton" data-last="Submit Report">
						Submit Report
					</button>												
				</c:if>
			</div>
		</div>
	</div>
</div><!-- /.span -->





