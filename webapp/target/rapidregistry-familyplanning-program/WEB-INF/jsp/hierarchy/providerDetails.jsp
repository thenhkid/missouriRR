<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="main clearfix" role="main">

    <div class="col-md-12">
        <c:if test="${not empty savedStatus}" >
            <div class="alert alert-success" role="alert">
                <strong>Success!</strong> 
                The provider has been successfully updated!
            </div>
        </c:if>
        <div class="alert alert-success assocSuccess" style="display:none"></div>
    </div>

    <div class="col-md-6">
         <form:form id="providerDetails" commandName="providerDetails" method="post" role="form">
            <input type="hidden" id="action" name="action" value="save" />
            <form:hidden path="programId" />
            <form:hidden path="dateCreated" />
            <section class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Provider Details</h3>
                </div>
                <div class="panel-body">
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
                        <spring:bind path="agency">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="name">Agency</label>
                                <form:input path="agency" id="agency" class="form-control" type="text" maxLength="255" />
                                <form:errors path="agency" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="address">
                            <div style="padding-left:0px" class="col-md-6 cb form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="address">Address</label>
                                <form:input path="address" id="address" class="form-control" type="text" maxLength="255" />
                                <form:errors path="address" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="address2">
                            <div class="col-md-6 form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="address2">Address 2</label>
                                <form:input path="address2" id="address2" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="address2" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="city">
                            <div style="padding-left:0px" class="col-md-6 cb form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="city">City</label>
                                <form:input path="city" id="city" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="city" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="state">
                            <div class="col-md-6 form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="state">State</label>
                                <form:select id="state" path="state" cssClass="form-control half">
                                    <option value="" label=" - Select - " ></option>
                                    <form:options items="${stateList}"/>
                                </form:select>
                                <form:errors path="state" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="zipCode">
                            <div style="padding-left:0px" class="col-md-6 cb form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="zipcode">Zip Code</label>
                                <form:input path="zipCode" id="zipcode" class="form-control" type="text"  maxLength="15" />
                                <form:errors path="zipCode" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind> 
                        <spring:bind path="region">
                            <div class="col-md-6 form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="region">Region</label>
                                <form:input path="region" id="region" class="form-control" type="text"  maxLength="45" />
                                <form:errors path="region" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>        
                        <spring:bind path="phoneNumber">
                            <div style="padding-left:0px" class="col-md-6 cb form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="phoneNumber">Phone Number</label>
                                <form:input path="phoneNumber" id="phoneNumber" class="form-control" type="text"  maxLength="25" />
                                <form:errors path="phoneNumber" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="faxNumber">
                            <div class="col-md-6 form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="faxNumber">Fax Number</label>
                                <form:input path="faxNumber" id="faxNumber" class="form-control" type="text"  maxLength="25" />
                                <form:errors path="faxNumber" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind> 
                        <spring:bind path="email">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="email">Email</label>
                                <form:input path="email" id="email" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="email" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>  
                        <spring:bind path="url">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="url">URL</label>
                                <form:input path="url" id="url" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="url" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind> 
                        <spring:bind path="languages">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="languages">Languages</label>
                                <form:input path="languages" id="languages" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="languages" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>   
                        <spring:bind path="groupsServed">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="groupsServed">Groups Served</label>
                                <form:input path="groupsServed" id="groupsServed" class="form-control" type="text"  maxLength="255" />
                                <form:errors path="groupsServed" cssClass="control-label" element="label" />
                            </div>
                        </spring:bind>
                        <spring:bind path="description">
                            <div class="form-group ${status.error ? 'has-error' : '' }">
                                <label class="control-label" for="description">Description</label>
                                <form:textarea path="description" id="description" class="form-control" type="text"  maxLength="500" />
                            </div>
                        </spring:bind>         
                    </div>
                </div>
            </section>
       </form:form>
    </div>
    <div class="col-md-6">
        <section class="panel panel-default">
            <div class="panel-heading">
                <div class="pull-right">
                    <a href="#newAssocModal" data-toggle="modal" class="btn btn-primary btn-xs btn-action" id="associateNewHierarchy" rel="${providerId}" title="Associate ${assocHierarchyName}">Associate ${assocHierarchyName}</a>
                </div>
                <h3 class="panel-title">Associated ${assocHierarchyName}</h3>
            </div>
            <div class="panel-body" id="providerAssocTable"></div>
        </section>
            
        <section class="panel panel-default">
            <div class="panel-heading">
                <div class="pull-right">
                    <a href="#newAssocModal" data-toggle="modal" class="btn btn-primary btn-xs btn-action" id="associateNewService" rel="${providerId}" title="Add Services">Add Services</a>
                </div>
                <h3 class="panel-title">Associated Services</h3>
            </div>
            <div class="panel-body" id="providerServices"></div>
        </section>    
    </div>
</div>

<!-- Program Entry Method modal -->
<div class="modal fade" id="newAssocModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>
