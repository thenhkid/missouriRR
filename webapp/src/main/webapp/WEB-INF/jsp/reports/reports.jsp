<%-- 
    Document   : topics
    Created on : Jun 19, 2015, 9:45:33 AM
    Author     : chadmccue
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">
    <div class="col-xs-12">
        <div class="row">
            <div class="clearfix col-xs-12">
                <div class="pull-right">
                   <span class="input-group-btn" style="padding-right:10px;">
                        <a href="javascript:void(0);" class="newReport" title="Create New Report">
                            <button type="button" class="btn btn-success btn-sm">
                                <span class="ace-icon fa fa-download icon-on-right bigger-110"></span>
                                New Report
                            </button>
                        </a>
                    </span>
                </div>
            </div>
        </div>
        <div class="hr dotted"></div>
        <div class="row reportRemoveMsg" style="display:none;">
            <div class="col-md-12">
                <div class="alert alert-remove alert-success" role="alert">
                    <strong>Success!</strong> 
                        The report has been successfully deleted!
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <div id="savedExportList" class="col-sm-12">
                    <table <c:if test="${not empty savedReports}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                               <th scope="col">Selected Date Range</th>
                               <th scope="col">Selected Sites</th>
                               <th scope="col" class="center">Total Records</th>
                               <th scope="col" class="center">Date Created</th>
                               <th scope="col" class="center">Created By</th>
                               <th scope="col" class="center"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty savedReports}">
                                    <c:forEach var="report" items="${savedReports}">
                                        <tr class="clientRow">
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty report.startDate && not empty report.endDate}">
                                                        ${report.startDate} - ${report.endDate}
                                                    </c:when>
                                                    <c:when test="${not empty report.startDate && empty report.endDate}">
                                                        > ${report.startDate}
                                                    </c:when>  
                                                    <c:when test="${empty report.startDate && not empty report.endDate}">
                                                        < ${report.endDate}
                                                    </c:when>  
                                                    <c:otherwise>All Sessions</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                ${fn:replace(report.selectedSites,'|', '<br />')}
                                            </td>
                                            <td class="center">
                                                ${report.totalRecords}
                                            </td>
                                            <td class="center"><fmt:formatDate value="${report.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                            <td class="center">
                                                ${report.createdBy}
                                            </td>
                                            <td class="actions-col center">
                                                <c:if test="${not empty report.reportFileName}">
                                                    <a href="reports/viewReport?i=${report.encryptedId}&v=${report.encryptedSecret}" title="View Report" role="button" target="_blank">
                                                       <button class="btn btn-xs btn-info">
                                                           <i class="ace-icon fa fa-file-o  bigger-120"></i>
                                                       </button>
                                                   </a> 
                                                    <a class="btn btn-xs btn-success" href="<c:url value="/FileDownload/downloadFile.do?filename=${report.reportFileName}&foldername=reports"/>" title="Download Report">
                                                        <i class="ace-icon fa fa-download bigger-120"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${allowDelete == true}">    
                                                    <a href="javascript:void(0);" class="deleteReport" rel="${report.id}"  title="Delete Report" role="button">
                                                       <button class="btn btn-xs btn-danger">
                                                           <i class="ace-icon fa fa-trash  bigger-120"></i>
                                                       </button>
                                                   </a> 
                                                </c:if>   
                                            </td>
                                        </tr>
                                    </c:forEach>
                                  </c:when>
                                <c:otherwise>
                                    <tr><td colspan="6" class="center">There are currently no saved reports.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>