<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="main clearfix" role="main">

    <div class="col-md-12">
        <c:if test="${not empty savedStatus}" >
            <div class="alert alert-success" role="alert">
                <strong>Success!</strong> 
                The client has been successfully updated!
            </div>
        </c:if>
        <div class="alert alert-danger" style="display:none;">
            <strong>An error has occurred in one of the below fields!</strong>
        </div>
    </div>

    <div class="col-md-12">
         <form:form id="clientdetails" commandName="client" method="post" role="form">
            <input type="hidden" id="action" name="action" value="save" />
            <c:forEach items="${sections}" var="section" varStatus="sindex">
                <section class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">${section.sectionName}</h3>
                    </div>
                    <div class="panel-body">
                        <div class="form-container">
                            <c:forEach items="${client.clientFields}" var="fieldDetails" varStatus="field">
                                <c:if test="${section.id == fieldDetails.sectionId}">
                                    <input type="hidden" name="clientFields[${field.index}].saveToTableCol" value="${fieldDetails.saveToTableCol}" />
                                    <input type="hidden" name="clientFields[${field.index}].saveToTableName" value="${fieldDetails.saveToTableName}" />
                                    <input type="hidden" name="clientFields[${field.index}].fieldId" value="${fieldDetails.fieldId}" />
                                    <input type="hidden" name="clientFields[${field.index}].fieldType" value="${fieldDetails.fieldType}" />
                                    <c:choose>
                                        <c:when test="${fieldDetails.fieldType == 6}">
                                            <fmt:parseDate value="${fieldDetails.fieldValue}" var="theDate" pattern="yyyy-MM-dd HH:mm:ss" />
                                            <input type="hidden" name="clientFields[${field.index}].currFieldValue" value="<fmt:formatDate value="${theDate}" type="date" pattern="MM/dd/yyyy" />" />
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="clientFields[${field.index}].currFieldValue" value="${fieldDetails.fieldValue}" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div id="fieldDiv_${fieldDetails.fieldId}" class="form-group ${status.error ? 'has-error' : '' }">
                                        <label class="control-label" for="${fieldDetails.fieldDisplayname}">
                                            ${fieldDetails.fieldDisplayname} <c:if test="${fieldDetails.requiredField == true}">&nbsp;*</c:if>
                                            <c:if test="${fieldDetails.modified}">
                                                <a style="text-decoration:none;" href="#modifiedModal" data-toggle="modal" rel="${fieldDetails.fieldId}" rel2="${clientId}" class="modified" title="View field modification history">
                                                    <span class="glyphicon glyphicon-exclamation-sign" style="padding-left:5px; cursor: pointer;"></span>
                                                </a>
                                            </c:if>
                                        </label>
                                        <c:choose>
                                            <c:when test="${fieldDetails.fieldType == 3}">
                                                <input type="text" id="${fieldDetails.fieldId}" name="clientFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                            </c:when>
                                            <c:when test="${fieldDetails.fieldType == 2 || fieldDetails.fieldSelectOptions.size() > 0}">
                                                <c:choose>
                                                    <c:when test="${fieldDetails.fieldSelectOptions.size() > 0}">
                                                        <select id="${fieldDetails.fieldId}" name="clientFields[${field.index}].fieldValue" class="form-control half <c:if test="${fieldDetails.requiredField == true}"> required</c:if>">
                                                            <option value="">-Choose-</option>
                                                            <c:forEach items="${fieldDetails.fieldSelectOptions}" var="options">
                                                                <option value="${options.optionValue}" <c:if test="${fieldDetails.fieldValue == options.optionValue}">selected</c:if>>${options.optionDesc}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="text" id="${fieldDetails.fieldId}" name="clientFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>   
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${fieldDetails.fieldType == 6}">
                                                        <input type="text" id="${fieldDetails.fieldId}" name="clientFields[${field.index}].fieldValue" value="<fmt:formatDate value="${theDate}" type="date" pattern="MM/dd/yyyy" />" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="text" id="${fieldDetails.fieldId}" name="clientFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise> 
                                        </c:choose>
                                        <span id="errorMsg_${fieldDetails.fieldId}" class="control-label"></span>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </section>
            </c:forEach>
       </form:form>
    </div>
</div>

<!-- Program Entry Method modal -->
<div class="modal fade" id="modifiedModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>
