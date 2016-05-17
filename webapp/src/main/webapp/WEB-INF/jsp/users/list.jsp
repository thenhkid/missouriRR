
<%-- 
    Document   : list
    Created on : Sep 15, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="col-xs-12">
     <c:if test="${allowCreate == true}">
        <div class="row">
            <div class="clearfix">
                <div class="pull-right no-margin">
                     <a href="javascript:void(0);" class="newUser" title="Create New User">
                    <button class="btn btn-success btn-xs" type="button" id="newTopic">
                        <i class="ace-icon fa fa-user bigger-110"></i>
                        New User 
                    </button></a>
                </div>
            </div>
        </div>
        <div class="hr dotted"></div>
    </c:if>
    <div class="row">
        <table <c:if test="${not empty programUsers}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th scope="col">Name</th>
                    <th scope="col">Created By</th>
                    <th scope="col">Date Created</th>
                    <th scope="col">Last Logged In</th>
                    <th scope="col" class="center"></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty programUsers}">
                        <c:forEach var="user" items="${programUsers}">
                            <tr>
                                <td>
                                    ${user.firstName}&nbsp;${user.lastName}
                                </td>
                                <td>
                                    ${user.createdByName}
                                <td>
                                    <fmt:formatDate value="${user.dateCreated}" type="both" pattern="M/dd/yyyy h:mm a" />
                                </td>
                                <td>
                                    <fmt:formatDate value="${user.lastloggedIn}" type="both" pattern="M/dd/yyyy h:mm a" />
                                </td>
                                <td class="actions-col center">
                                    <c:if test="${allowEdit == true}">
                                        <a href="users/details?i=${user.encryptedId}&v=${user.encryptedSecret}" title="Modify this User" role="button">
                                            <button class="btn btn-xs btn-success">
                                                <i class="ace-icon fa fa-pencil bigger-120"></i>
                                            </button>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="8" class="center">There are currently no users set up for this program.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div><!-- /.col -->


