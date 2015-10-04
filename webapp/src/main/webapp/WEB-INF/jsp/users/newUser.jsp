<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="page-content">

    <form:form id="newuserform" commandName="userDetails" modelAttribute="userDetails"  method="post" role="form">
        <input type="hidden" id="encryptedURL" value="${encryptedURL}" />
        <div class="row">
            <div class="form-container">
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
                        <label class="control-label" for="password">Password *</label>
                        <form:input path="password" id="password" class="form-control" type="password" maxLength="15" autocomplete="off"  />
                        <form:errors path="password" cssClass="control-label" element="label" />
                        <span id="passwordMsg" class="control-label"></span>
                    </div>
                </spring:bind>
                <div id="confirmPasswordDiv" class="form-group">
                    <label class="control-label" for="confirmPassword">Confirm Password *</label>
                    <input id="confirmPassword" name="confirmpassword" class="form-control" maxLength="15" autocomplete="off" type="password" value="" />
                    <span id="confirmPasswordMsg" class="control-label"></span>
                </div>
            </div>
        </div>
        <div class="hr hr-dotted"></div>
        <div class="row">
            <button type="button" class="btn btn-primary" id="saveNewUser">
                <i class="ace-icon fa fa-save bigger-120 white"></i>
                Save
            </button>
        </div>
    </form:form>
</div>
