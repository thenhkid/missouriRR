<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
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
                        <a href="/reports/request" class="newReport" title="Create New Report">
                            <button type="button" class="btn btn-success btn-sm">
                                <span class="ace-icon fa fa-download icon-on-right bigger-110"></span>
                                Request New Report
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
                    <table <c:if test="${not empty reportRequestList}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">Status</th>
                                    <th scope="col">Date Submitted</th>
                                    <th scope="col">Report Type</th>                 
                                    <th scope="col">Activity Logs Requested</th>
                                    <th scope="col">Date Range</th>
                                    <th scope="col">School(s) / ECC</th>
                                    <th scope="col" class="center">Requested By</th>
                                    <th scope="col" class="center"></th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty reportRequestList}">
                                    <c:forEach var="rrd" items="${reportRequestList}">
                                        <tr class="clientRow" id="reportRow_${rrd.reportRequestId}">
                                            <td>
                                                ${rrd.statusDisplay}
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${rrd.dateSubmitted}" type="date" pattern="M/dd/yyyy h:mm a" />
                                            </td>
                                            <td>
                                                 ${rrd.reportType}
                                            </td>
                                            <td>
                                                ${rrd.reportNames}
                                            </td>
                                            <td>
                                                ${rrd.datesRequested}
                                            </td>
                                            <td>
                                                ${rrd.entity3Names}
                                            </td>

                                            <td class="center">
                                                ${rrd.firstName} ${rrd.lastName}
                                            </td>
                                            <td class="actions-col center">
                                                <c:if test="${rrd.statusId == 3 || rrd.statusId == 4}">
                                                    <a href="/reports/DLReport?i=${rrd.encryptedId}&v=${rrd.encryptedSecret}"  title="View this report" role="button">
                                                        <button class="btn btn-xs btn-success">
                                                            <i class="ace-icon fa fa-download bigger-120"></i>
                                                        </button>
                                                    </a>
                                                </c:if>
                                                <c:if test="${allowDelete == true}">
                                                    <a href="javascript:void(0);" class="deleteReport" rel="${rrd.reportRequestId}"  reli="${rrd.encryptedId}" relv="${rrd.encryptedSecret}" title="Delete This Report" role="button">
                                                        <button class="btn btn-xs btn-danger">
                                                            <i class="ace-icon fa fa-trash bigger-120"></i>
                                                        </button>
                                                    </a>
                                                </c:if>  
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="8" class="center">There are currently no saved reports.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div><!-- /.col -->
</div>


