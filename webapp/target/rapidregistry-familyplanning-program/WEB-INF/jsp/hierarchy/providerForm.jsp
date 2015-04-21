<%-- 
    Document   : itemForm
    Created on : Dec 23, 2014, 11:22:45 AM
    Author     : chadmccue
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Create Provider ${success}</h3>
                </div>
                <div class="modal-body">
            <form:form id="providerdetailsform" commandName="providerDetails" modelAttribute="providerDetails"  method="post" role="form">
                <input type="hidden" id="encryptedURL" value="${encryptedURL}" />
                <form:hidden path="id" id="id" />
                <form:hidden path="dateCreated" />
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
                    <spring:bind path="name">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="name">Name *</label>
                            <form:input path="name" id="name" class="form-control" type="text" maxLength="255" />
                            <form:errors path="name" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="address">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="address">Address</label>
                            <form:input path="address" id="address" class="form-control" type="text" maxLength="255" />
                            <form:errors path="address" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="address2">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="address2">Address 2</label>
                            <form:input path="address2" id="address2" class="form-control" type="text"  maxLength="255" />
                            <form:errors path="address2" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="city">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="city">City</label>
                            <form:input path="city" id="city" class="form-control" type="text"  maxLength="255" />
                            <form:errors path="city" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="state">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="state">State</label>
                            <form:select id="state" path="state" cssClass="form-control half">
                                <option value="" label=" - Select - " ></option>
                                <form:options items="${stateList}"/>
                            </form:select>
                            <form:errors path="state" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="zipCode">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="zipcode">Zip Code</label>
                            <form:input path="zipCode" id="zipcode" class="form-control" type="text"  maxLength="15" />
                            <form:errors path="zipCode" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>      
                    <spring:bind path="phoneNumber">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="phoneNumber">Phone Number</label>
                            <form:input path="phoneNumber" id="phoneNumber" class="form-control" type="text"  maxLength="25" />
                            <form:errors path="phoneNumber" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <spring:bind path="faxNumber">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="faxNumber">Fax Number</label>
                            <form:input path="faxNumber" id="faxNumber" class="form-control" type="text"  maxLength="25" />
                            <form:errors path="faxNumber" cssClass="control-label" element="label" />
                        </div>
                    </spring:bind>
                    <div class="form-group">
                        <input type="button" id="submitProviderButton" role="button" class="btn btn-primary" value="Save"/>
                    </div>
                </div>
            </form:form>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function() {
        $("input:text,form").attr("autocomplete", "off");
    });
</script>
