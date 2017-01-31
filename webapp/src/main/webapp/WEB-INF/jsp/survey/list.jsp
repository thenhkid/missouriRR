<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">
    <div class="col-xs-12">

        <%--<h3 class="header smaller lighter blue">Activity Logs</h3>--%>
        
        <div class="clearfix">
            <c:if test="${not empty message}" >
                <div class="pull-left">
                    <div class="alert alert-success">
                        <strong>Success!</strong> 
                        <c:choose>
                            <c:when test="${message == 'fileUploaded'}">The file has been successfully uploaded!</c:when>
                        </c:choose>
                    </div>
                </div>
            </c:if>
            <c:if test="${allowCreate == true}">
            <div class="pull-right">
                <form:form id="districtSelectForm" method="POST" action="/surveys/startSurvey" role="form">
                    <input type="hidden" name="s" id="surveyId" value="${selSurvey}" />
                    <ul class="list-unstyled spaced2">
                        <li>
                            <span id="districtList"></span>
                            <a href="javascript:void(0);" id="createNewEntry" role="button" rel="${selSurvey}" class="btn btn-success">
                                <i class="ace-icon fa fa-plus-square align-top bigger-150"></i>
                                <strong>Start Activity Log</strong>
                            </a>
                        </li>
                    </ul>
                </form:form>  
            </div>
            </c:if>
        </div>

        <div class="table-header">
            Submissions for "Latest ${surveyName} Activity Logs"
        </div>

        <div>
            <table <c:if test="${not empty submittedSurveys}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th scope="col" class="center">Entry Id</th>
                        <c:if test="${not empty summaryColumns}">
                            <c:choose>
                                <c:when test="${surveyTag == 'eventsprograms' || surveyTag == 'practice'}">
                                    <c:forEach varStatus="i" items="${summaryColumns}" var="col">
                                        <c:if test="${i.index == 0 || i.index == 1}"><th scope="col" >${col}</th></c:if>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${surveyTag == 'resourcesLeveraged'}">
                                   <th scope="col" >Entry Description</th>
                                   <th scope="col" >Estimated $ Value</th>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach varStatus="i" items="${summaryColumns}" var="col">
                                        <th scope="col" >${col}</th>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <th scope="col" class="center"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Submitted</th>
                        <th scope="col" class="center"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Modified</th>
                        <th scope="col" >Submitted By</th>
                        <th scope="col">School(s) / ECC</th>
                        <th scope="col" class="center  hidden-480">Submitted</th>
                        <th scope="col" class="center"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty submittedSurveys}">
                            <c:forEach var="submittedSurvey" items="${submittedSurveys}">
                                 <tr>
                                    <td class="center">${submittedSurvey.id}</td>
                                    <c:if test="${not empty summaryColumns}">
                                        <c:choose>
                                            <c:when test="${surveyTag == 'resourcesLeveraged'}">
                                                <c:if test="${not empty submittedSurvey.summaryCols}">
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${fn:length(fn:split(submittedSurvey.summaryCols,'|')[1]) > 100}">
                                                                ${fn:substring(fn:split(submittedSurvey.summaryCols,'|')[1], 0, 100)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:split(submittedSurvey.summaryCols,'|')[1]}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                       <c:choose>
                                                            <c:when test="${fn:length(fn:split(submittedSurvey.summaryCols,'|')[0]) > 100}">
                                                                ${fn:substring(fn:split(submittedSurvey.summaryCols,'|')[0], 0, 100)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${fn:split(submittedSurvey.summaryCols,'|')[0]}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${surveyTag == 'eventsprograms' || surveyTag == 'practice'}">
                                                <c:choose>
                                                    <c:when test="${not empty submittedSurvey.summaryCols}">
                                                        <c:set var="tdVal" value="" />
                                                        <c:forTokens varStatus="i" var="colData" items="${submittedSurvey.summaryCols}" delims="|">
                                                            <c:choose>
                                                                <c:when test="${i.index == 0}">
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${fn:length(colData.replace('^^^^^','-')) > 100}">
                                                                                ${fn:substring(colData.replace("^^^^^","-"), 0, 100)}...
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${colData.replace("^^^^^","-")}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>         
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:if test="${colData.replace('^^^^^','-') != 'Not Answered'}">
                                                                        <c:set var="tdVal" value="${colData.replace('^^^^^','-')}" />
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                       </c:forTokens>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${fn:length(tdVal.replace('^^^^^','-')) > 100}">
                                                                        ${fn:substring(tdVal.replace("^^^^^","-"), 0, 100)}...
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${tdVal.replace("^^^^^","-")}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>         
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach varStatus="i" items="${summaryColumns}" var="col">
                                                           <c:if test="${i.index == 0 || i.index == 1}"><td></td></c:if>
                                                       </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${not empty submittedSurvey.summaryCols}">
                                                        <c:forTokens var="colData" items="${submittedSurvey.summaryCols}" delims="|">
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${fn:length(colData.replace('^^^^^','-')) > 100}">
                                                                        ${fn:substring(colData.replace("^^^^^","-"), 0, 100)}...
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${colData.replace("^^^^^","-")}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td> 
                                                       </c:forTokens>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach varStatus="i" items="${summaryColumns}" var="col">
                                                            <td></td>
                                                       </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                   </c:if>
                                    <td class="center"><fmt:formatDate value="${submittedSurvey.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                    <td class="center"><fmt:formatDate value="${submittedSurvey.dateModified}" type="date" pattern="M/dd/yyyy h:mm a" /></td>
                                    <td>
                                        ${submittedSurvey.staffMember}
                                    </td>
                                    <td>
                                        <c:if test="${not empty submittedSurvey.selectedEntities}">
                                            <ul class="list-unstyled spaced">
                                                <c:forEach var="entity" items="${submittedSurvey.selectedEntities}">
                                                    <li>
                                                        <i class="ace-icon fa fa-building bigger-110 purple"></i>
                                                        ${entity}
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                    </td>
                                    <td class="center hidden-400">
                                        <c:choose>
                                            <c:when test="${submittedSurvey.submitted == true}">
                                                <i class="ace-icon fa fa-check bigger-110 green icon-only"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="ace-icon fa fa-close bigger-110 red icon-only"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <div class="hidden-sm hidden-xs">
                                            <div class="center">
                                                <c:choose>
                                                    <c:when test="${hasDocumentModule == true}">
                                                        <a href="surveys/viewSurveyDocuments?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}"  title="Upload Relevant Documents" role="button">   
                                                            <button class="btn btn-xs btn-info">
                                                                <i class="ace-icon fa fa-upload bigger-120"></i>
                                                                Relevant Documents
                                                            </button>
                                                        </a> 
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="javascript:void(0);" class="surveyDocuments" rel="${submittedSurvey.id}"  title="Upload Relevant Documents" role="button">   
                                                            <button class="btn btn-xs btn-info">
                                                                <i class="ace-icon fa fa-upload bigger-120"></i>
                                                                Relevant Documents
                                                            </button>
                                                        </a> 
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="center" style="padding-top:10px">
                                            <c:choose>
                                                <c:when test="${allowEdit == true || sessionScope.userDetails.roleId == 2}">
                                                    <a href="surveys/editSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" title="Edit This Survey" role="button">
                                                        <button class="btn btn-xs btn-success">
                                                            <i class="ace-icon fa fa-pencil bigger-120"></i>
                                                            Edit
                                                        </button>
                                                    </a>
                                                    <c:if test="${allowDelete == true}">
                                                        <a href="javascript:void(0);" class="deleteSurvey" rel="${submittedSurvey.id}"  title="Delete This Survey" role="button">
                                                            <button class="btn btn-xs btn-danger">
                                                                <i class="ace-icon fa fa-close bigger-120"></i>
                                                                Delete
                                                            </button>
                                                        </a>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="surveys/viewSurvey?i=${submittedSurvey.encryptedId}&v=${submittedSurvey.encryptedSecret}" title="Edit This Survey" role="button">
                                                        <button class="btn btn-xs btn-info">
                                                            <i class="ace-icon fa fa-search-plus bigger-120"></i>
                                                            View
                                                        </button>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                             </div>   
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="7" class="center-text">There have been no entries for the selected survey.</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div><!-- /.col -->
</div>


