<%-- 
    Document   : userDetails
    Created on : Sep 21, 2015, 11:31:23 AM
    Author     : chadmccue
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="row">

    <c:if test="${not empty savedStatus}" >
        <div class="col-md-12">
            <div class="alert alert-success" role="alert">
                <strong>Success!</strong> 
                The staff member has been successfully updated!
            </div>
        </div>
    </c:if>
    <c:if test="${not empty param.msg}" >
        <div class="col-md-12">
            <div class="alert alert-success">
                <strong>Success!</strong> 
                <c:choose>
                    <c:when test="${param.msg == 'moduleAdded'}">The module(s) have been saved to the selected user!</c:when>
                    <c:when test="${param.msg == 'entityAdded'}">The entity has been saved to the selected user!</c:when>
                    <c:when test="${param.msg == 'entityRemoved'}">The entity has been successfully removed from the selected user!</c:when>
                </c:choose>
            </div>
        </div>
    </c:if>
    
    <div class="col-md-12">
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
                            <form:form id="userDetais" commandName="userDetais"  method="post" role="form">
                                <form:hidden path="roleId" />
                                <form:hidden path="id" />
                                <form:hidden path="createdBy" />
                                <form:hidden path="dateCreated" />
                                <div class="form-group">
                                    <label for="status">Status *</label>
                                    <div>
                                        <label class="radio-inline">
                                            <form:radiobutton id="status" path="status" value="true" /> Active
                                        </label>
                                        <label class="radio-inline">
                                            <form:radiobutton id="status" path="status" value="false" /> Inactive
                                        </label>
                                    </div>
                                </div>
                                <spring:bind path="firstName">
                                    <div class="form-group ${status.error ? 'has-error' : '' }">
                                        <label class="control-label" for="firstName">First Name *</label>
                                        <form:input path="firstName" id="firstName" class="form-control" type="text" maxLength="55" />
                                        <form:errors path="firstName" cssClass="control-label" element="label" />
                                    </div>
                                </spring:bind>
                                <spring:bind path="lastName">
                                    <div class="form-group ${status.error ? 'has-error' : '' }">
                                        <label class="control-label" for="lastName">Last Name *</label>
                                        <form:input path="lastName" id="lastName" class="form-control" type="text" maxLength="55" />
                                        <form:errors path="lastName" cssClass="control-label" element="label" />
                                    </div>
                                </spring:bind>
                                <spring:bind path="email">
                                    <div class="form-group ${status.error || not empty existingUser ? 'has-error' : '' }">
                                        <label class="control-label" for="email">Email *</label>
                                        <form:input path="email" id="email" class="form-control" type="text"  maxLength="255" />
                                        <form:errors path="email" cssClass="control-label" element="label" />
                                        <c:if test="${not empty existingUser}"><span class="control-label has-error">${existingUser}</span></c:if>
                                    </div>
                                </spring:bind>
                                <spring:bind path="password">
                                    <div id="passwordDiv" class="form-group ${status.error ? 'has-error' : '' }">
                                        <label class="control-label" for="password">Password</label><br/><i>Leave blank if not changing</i>
                                        <form:input path="password" id="password" class="form-control" type="password" maxLength="15" autocomplete="off"  />
                                        <form:errors path="password" cssClass="control-label" element="label" />
                                        <span id="passwordMsg" class="control-label"></span>
                                    </div>
                                </spring:bind>
                                <div id="confirmPasswordDiv" class="form-group">
                                    <label class="control-label" for="confirmPassword">Confirm Password</label>
                                    <input id="confirmPassword" name="confirmpassword" class="form-control" maxLength="15" autocomplete="off" type="password" value="${staffdetails.getPassword()}" />
                                    <span id="confirmPasswordMsg" class="control-label"></span>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hr hr-dotted"></div>
            <div>
                <button type="button" class="btn btn-primary" id="saveUser">
                    <i class="ace-icon fa fa-save bigger-120 white"></i>
                    Save
                </button>
            </div>
        </div>
        <div class="col-md-6">
            <div class="widget-box">
                <div class="widget-header widget-header-blue widget-header-flat">
                    <h4 class="smaller">
                       Associated Programs
                    </h4>
                </div>
                <div class="widget-body">
                    <div class="widget-main scrollable" id="associatedPrograms"></div>
                </div>
            </div>
        </div>
    </div>
    
</div>

            
