<%-- 
    Document   : details
    Created on : Apr 11, 2016, 11:57:44 AM
    Author     : chadmccue
--%>


<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="row">

    <c:if test="${not empty savedStatus}" >
        <div class="col-md-12">
            <div class="alert alert-success" role="alert">
                <strong>Success!</strong> 
                 <c:choose>
                    <c:when test="${savedStatus == 'created'}">The announcement has been successfully created!</c:when>
                    <c:when test="${savedStatus == 'updated'}">The announcement has been successfully updated!</c:when>
                </c:choose>
            </div>
        </div>
    </c:if>
    <div class="col-md-12">
        <form:form id="announcementDetails" commandName="announcementDetails"  method="post" role="form" enctype="multipart/form-data">
        <form:hidden path="id" />
        <form:hidden path="systemUserId" />
        <form:hidden path="dateCreated" />
        <form:hidden path="dspOrder" />
        <form:hidden path="hpdspOrder" />
        <input type="hidden" name="action" id="action" value="Save" />
        <div class="col-md-6">
            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                       Details
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main">
                        <div class="form-container">
                            <div class="form-group">
                                <label for="status">Status *</label>
                                <div>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isActive" path="isActive" value="true" /> Active
                                    </label>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isActive" path="isActive" value="false" /> Inactive
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="status">Admin Only *</label>
                                <div>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isAdminOnly" path="isAdminOnly" value="true" /> Admin Only
                                    </label>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isAdminOnly" path="isAdminOnly" value="false" /> Public
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="status">Display on Home Page *</label>
                                <div>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isOnHomePage" path="isOnHomePage" value="true" /> Yes
                                    </label>
                                    <label class="radio-inline">
                                        <form:radiobutton id="isOnHomePage" path="isOnHomePage" value="false" /> No
                                    </label>
                                </div>
                            </div>  
                             <div class="form-group" id="entityDiv">
                                 <label for="whichEntity" class="control-label">Select the <span id="topLevelName">${topLevelName}</span> this announcement will be posted to *</label>
                                <div>
                                    <label class="radio-inline">
                                        <form:radiobutton path="whichEntity"  value="1" class="whichEntity" />All ${topLevelName}
                                    </label>
                                    <label class="radio-inline">
                                        <form:radiobutton path="whichEntity" value="2" class="whichEntity" />Select ${topLevelName}
                                    </label>
                                </div>
                                <span id="entityMsg" class="control-label"></span>
                            </div>
                            <div class="form-group" id="entitySelectList" <c:if test="${announcementDetails.whichEntity == 1}">style="display:none;"</c:if>>
                               <select name="selectedEntities" class="multiselect form-control" id="entityIds" multiple="">
                                    <c:forEach items="${countyList}" var="county">
                                        <option value="${county.id}" <c:if test="${fn:contains(announcementDetails.announcementEntities, county.id)}">selected</c:if>>${county.name}</option>
                                    </c:forEach>
                                </select>
                            </div>        
                            <spring:bind path="announcementTitle">
                                <div class="form-group ${status.error ? 'has-error' : '' }">
                                    <label class="control-label" for="announcementTitle">Announcement Title</label>
                                    <form:input path="announcementTitle" id="announcementTitle" class="form-control" type="text" maxLength="255" />
                                    <form:errors path="announcementTitle" cssClass="control-label" element="label" />
                                </div>
                            </spring:bind>
                            <spring:bind path="announcement">
                                <div id="announcementDiv" class="form-group ${status.error ? 'has-error' : '' }">
                                    <label class="control-label" for="announcement">Announcement *</label>
                                    <form:textarea path="announcement" id="announcement" class="form-control" rows="15" cols="10" />
                                    <form:errors path="announcement" cssClass="control-label" element="label" />
                                    <span id="announcementMsg" class="control-label"></span>
                                </div>
                            </spring:bind>
                            <div class="form-group">
                                <div class="row clearfix">
                                    <div class="col-md-6">
                                        <label for="eventDate">Activation Date</label>
                                        <fmt:formatDate value="${announcementDetails.activateDate}" var="dateactivateDateString" pattern="MM/dd/yyyy" />
                                        <form:input path="activeDate" class="form-control activateDate" placeholder="Activate Date" value="${dateactivateDateString}" />
                                    </div>
                                    <div class="col-md-6">
                                        <label for="retirementDate">Retirement Date</label>
                                        <fmt:formatDate value="${announcementDetails.retirementDate}" var="dateretirementDateString" pattern="MM/dd/yyyy" />
                                        <form:input path="retireDate" class="form-control retirementDate" placeholder="Retirement Date" value="${dateretirementDateString}" />
                                    </div>
                                </div>
                            </div>        
                        </div>
                    </div>
                </div>
            </div>
            <div class="hr hr-dotted"></div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label">Announcement Email Alert</label>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="alertUsers" value="2"> 
                                Send email regarding <c:choose><c:when test="${announcementDetails.id == 0}">this new announcement</c:when><c:otherwise>these changes</c:otherwise></c:choose> to all users?
                            </label>
                        </div>
                    </div>
                </div>    
            </div>                   
            <div class="hr hr-dotted"></div>
            <div>
                <button type="submit" class="btn btn-primary" id="saveAnnouncement">
                    <i class="ace-icon fa fa-save bigger-120 white"></i>
                    Save
                </button>
                <button type="submit" class="btn btn-success" id="saveReturnAnnouncement">
                    <i class="ace-icon fa fa-save bigger-120 white"></i>
                    Save & Return
                </button>
                <button type="button" class="btn btn-danger exitAnnouncementForm">
                    <i class="ace-icon fa fa-close"></i>
                    Exit without Saving
                </button>
            </div>
        </div>
        <div class="col-md-6">
            <c:if test="${not empty existingDocuments}">
                <div class="widget-box">
                    <div class="widget-header widget-header-blue widget-header-flat">
                        <h4 class="smaller">
                           Associated Documents
                        </h4>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main scrollable">
                            <div class="form-group">
                                <c:forEach var="document" items="${existingDocuments}">
                                    <div class="input-group existingDocs" id="docDiv_${document.id}">
                                        <span class="input-group-addon">
                                            <i class="fa fa-file bigger-110 orange"></i>
                                        </span>
                                        <c:choose>
                                            <c:when test="${fn:length(document.uploadedFile) > 20}">
                                                <c:set var="index" value="${document.uploadedFile.lastIndexOf('.')}" />
                                                <c:set var="trimmedDocumentExtension" value="${fn:substring(document.uploadedFile,index+1,fn:length(document.uploadedFile))}" />
                                                <c:set var="trimmedDocumentTitle" value="${fn:substring(document.uploadedFile, 0, 20)}...${trimmedDocumentExtension}" />

                                                <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${trimmedDocumentTitle}"></input>
                                            </c:when>
                                            <c:otherwise>
                                                 <c:set var="trimmedDocumentTitle" value="${document.uploadedFile}" />
                                                <input id="" readonly="" class="form-control active" type="text" name="date-range-picker" title="${document.documentTitle}" placeholder="${trimmedDocumentTitle}"></input>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="input-group-addon">
                                            <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.encodedTitle}&foldername=announcementUploadedFiles"/>"  title="${document.documentTitle}"><i class="fa fa-download bigger-110 green"></i></a>
                                        </span> 
                                        <span class="input-group-addon">
                                            <a href="javascript:void(0)" class="deleteDocument" title="Delete File" rel="${document.id}"><i class="fa fa-times bigger-110 red"></i></a>
                                        </span>
                                    </div>
                                </c:forEach>
                                <span id="noDocs" style="display:none;">There are currently no more documents associated to this announcement.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                       Attach Documents
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main scrollable">
                        <div class="form-group" id="docDiv">
                            <input multiple="" name="postDocuments" type="file" id="id-input-file-2" />
                             <span id="docMsg" class="control-label"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </form:form>           
    </div>
</div>

