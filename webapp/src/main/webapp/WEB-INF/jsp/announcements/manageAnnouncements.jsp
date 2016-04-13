<%-- 
    Document   : manageAnnouncements
    Created on : Apr 11, 2016, 10:58:30 AM
    Author     : chadmccue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .ellipsis {
        display: inline-block;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;     /** IE6+, Firefox 7+, Opera 11+, Chrome, Safari **/
        -o-text-overflow: ellipsis;  /** Opera 9 & 10 **/
        width: 570px; /* note that this width will have to be smaller to see the effect */
    }
</style>

<div class="col-sm-12">
    <c:if test="${allowCreate == true}">
        <div class="row">
            <div class="clearfix">
                <div class="pull-right no-margin">
                    <a href="details">
                    <button class="btn btn-success btn-xs" type="button" id="newTopic">
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        New Announcement 
                    </button></a>
                </div>
            </div>
        </div>
        <div class="hr dotted"></div>
    </c:if>
   <c:if test="${not empty savedStatus}" >
        <div class="row">
           <div class="col-md-12">
               <div class="alert alert-update alert-success" role="alert">
                   <strong>Success!</strong> 
                   <c:choose>
                       <c:when test="${savedStatus == 'deleted'}">The announcement has been successfully removed!</c:when>
                   </c:choose>
               </div>
           </div>
       </div>
   </c:if>        
    <div class="row">
        <table <c:if test="${not empty announcements}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th scope="col" class="col-md-7">Announcement</th>
                    <th scope="col" class="center col-md-1">Status</th>
                    <th scope="col" class="center col-md-1">Sort Order</th>
                    <th scope="col" class="center col-md-2"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Created</th>
                    <th scope="col" class="center col-md-2"></th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty announcements}">
                    <c:forEach var="announcement" items="${announcements}">
                        <tr>
                            <td>
                                <c:if test="${not empty announcement.announcementTitle}"><h4 class="green smaller lighter bolder">${announcement.announcementTitle}</h4></c:if>
                                <span class="ellipsis">${announcement.announcement}</span>
                                <c:if test="${announcement.isOnHomePage}"><h4 class="grey smaller-90 bolder"><i class="fa fa-icon fa-home smaller-90"></i>&nbsp;On Home Page</h4></c:if>
                                <h4 class="${announcement.isAdminOnly ? 'red' : 'green'} smaller-90 bolder"><i class="fa fa-icon ${announcement.isAdminOnly ? 'fa-lock' : 'fa-unlock'} smaller-90"></i>&nbsp;<c:choose><c:when test="${announcement.isAdminOnly}">Admin Only</c:when><c:otherwise>Public</c:otherwise></c:choose></h4>
                            </td>
                            <td class="center">
                                <c:choose>
                                    <c:when test="${announcement.isActive == true}">Active</c:when>
                                    <c:otherwise>Inactive</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="center">
                                <table>
                                    <tr>
                                        <td><span id="currDspOrder_${announcement.id}">${announcement.dspOrder}</span></td>
                                        <td><input maxlength="3" size="4" class="dspOrder" rel="${announcement.id}" type="text" name="dspOrder" value="${announcement.dspOrder}" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="center">
                                <fmt:formatDate value="${announcement.dateCreated}" type="date" pattern="M/dd/yyyy h:mm a" />
                                <br />Created By:  ${announcement.createdBy}
                            </td>
                            <td class="center">
                                <div class="hidden-sm hidden-xs btn-group">
                                    <c:if test="${allowEdit == true}">
                                        <a href="details?i=${announcement.encryptedId}&v=${announcement.encryptedSecret}" title="Modify this User" role="button">
                                            <button class="btn btn-xs btn-success">
                                                    <i class="ace-icon fa fa-pencil bigger-120"></i>
                                             </button>
                                        </a>
                                    </c:if>
                                    <c:if test="${allowDelete == true}">
                                        <a href="delete?i=${announcement.encryptedId}&v=${announcement.encryptedSecret}" title="Modify this User" role="button">
                                          <button class="btn btn-xs btn-danger deleteAnnouncement"><i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="center">
                            There have been no announcements created.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>