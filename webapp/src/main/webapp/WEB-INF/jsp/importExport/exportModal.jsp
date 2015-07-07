<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="page-content">
    <form:form id="exportForm" modelAttribute="exportDetails" role="form" class="form" method="post">
        <form:hidden path="surveyId" />
        <form:hidden path="exportName" />
        <form:hidden path="questionOnly" />
        
        <c:if test="${noresults}"><div class="alert alert-danger">No results were found based on your date range selected.</div></c:if>

        <div class="form-group">
            <label class="control-label" for="exportType">Export File Type</label>
            <form:select path="exportType" class="form-control">
                <option value="1">csv</option>
                <option value="2">Comma Delimited txt</option>
                <option value="3">Pipe Delimited txt</option>
                <option value="4">Tab Delimited txt</option>
            </form:select>
        </div>
        <%--<div id="exportNameDiv" class="form-group">
            <label class="control-label" for="exportName">Export File Name:</label>
            <form:input path="exportName" id="exportName" class="form-control" placeholder="Export Name" />
            <div id="errorMsg_exportName" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
        </div>--%>
        <c:if test="${showDateRange == true}">
            <div class="form-group">
                <div class="row clearfix">
                    <div id="exportStartDateDiv" class="col-md-6">
                        <label class="control-label" for="eventDate">Start Date</label>
                        <fmt:formatDate value="${exportDetails.exportStartDate}" var="dateStartString" pattern="MM/dd/yyyy" />
                        <form:input path="startDate" class="form-control exportStartDate" placeholder="Start Date" value="${dateStartString}" />
                        <div id="errorMsg_exportStartDate" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                    </div>
                    <div id="exportEndDateDiv"  class="col-md-6">
                        <label class="control-label" for="eventDate">End Date</label>
                        <fmt:formatDate value="${exportDetails.exportEndDate}" var="dateEndString" pattern="MM/dd/yyyy" />
                        <form:input path="endDate" class="form-control exportEndDate" placeholder="End Date"  value="${dateEndString}"  />
                        <div id="errorMsg_exportEndDate" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                    </div>
                </div>
            </div>
        </c:if>
        <div class="form-group">
            <button type="button" class="btn btn-mini btn-primary createSurveyExport">
                <i class="ace-icon fa fa-download bigger-120 white"></i>
                Create Export
            </button>
        </div>
    </form:form>
</div>