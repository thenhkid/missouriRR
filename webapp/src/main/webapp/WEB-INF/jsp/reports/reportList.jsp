<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div class="row">
    <div class="col-xs-12">

        <%--<h3 class="header smaller lighter blue">Activity Logs</h3>--%>
        
        <div class="clearfix">
            <c:if test="${allowCreate == true}">
            <div class="pull-right">
                <form:form id="newReport" method="POST" action="/reports/request" role="form">
                    <ul class="list-unstyled spaced2">
                        <li>
                            <span id="districtList"></span>
                            <a href="/reports/request" id="createNewEntry" role="button" class="btn btn-success">
                                <i class="ace-icon fa fa-plus-square align-top bigger-150"></i>
                                <strong>Request new report</strong>
                            </a>
                        </li>
                    </ul>
                </form:form>  
            </div>
            </c:if>
        </div>

        <div class="table-header">
            Requested Reports
        </div>

        <div>
            <table <c:if test="${not empty reportRequestList}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th scope="col" class="center">Status</th>
                            <th scope="col" class="center"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Submitted</th>
                            <th scope="col" >Report Type</th>
                            <th scope="col" >Activity Logs Requested</th>
                            <th scope="col" >Date Range</th>
                            <th scope="col">School(s) / ECC</th>
                            <th scope="col">Requested By</th>
                        <th scope="col" class="center"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty reportRequestList}">
                            <c:forEach var="rr" items="${reportRequestList}">
                                <tr id="reportRow_${rr.id}">
                                    <td class="center">${rr.statusDisplay}</td>
                                    <td class="center"><fmt:formatDate value="${rr.dateSubmitted}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                    <td>
                                        ${rr.reportType}
                                    </td>
                                    <td>
                                         ${rr.reportNames}
                                    </td>
                                    <td>
                                        ${rr.datesRequested}
                                    </td>
                                     <td>
                                        ${rr.entity3Names}
                                    </td>
                                    <td>
                                        ${rr.firstName} ${rr.lastName}
                                    </td>
                                    <td class="center">
                                        <div class="hidden-sm hidden-xs action-buttons">
                                            <c:if test="${rr.statusId == 3 || rr.statusId == 4}">
	                                           	<a href="reports/viewReport?i=${rr.encryptedId}&v=${rr.encryptedSecret}"  title="View this report" role="button">
	                                                <button class="btn btn-xs btn-success">
	                                                    <i class="ace-icon fa fa-download bigger-120"></i>
	                                                </button>
	                                            </a>
                                            </c:if>
                                            <a href="javascript:void(0);" class="deleteReport" rel="${rr.id}"  title="Delete This Report" role="button">
                                                <button class="btn btn-xs btn-danger">
                                                    <i class="ace-icon fa fa-close bigger-120"></i>
                                                </button>
                                            </a>
                                                
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="8" class="center-text">There are no reports requested.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
		<form action="#" method="Post" name="delRepReq" id="delRepReq">
			<input type="hidden" name="delRRId" id="delRRId"/>
		</form>
    </div><!-- /.col -->
</div>


