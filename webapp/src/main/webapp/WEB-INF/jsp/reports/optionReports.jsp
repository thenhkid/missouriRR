<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
 <%-- this needs to be rewritten so that it is more efficient and reuses more codes --%>
 <%--  need to make all actually select all --%>
 <select name="selectedReports" class="multiselect form-control" id="reportIds" multiple="">
        <c:forEach items="${reportList}" var="report">
        <option value="${report.id}">${report.reportName} ${report.reportDesc}</option>
        </c:forEach>            
</select>
<div id="errorMsg_reports" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div> 