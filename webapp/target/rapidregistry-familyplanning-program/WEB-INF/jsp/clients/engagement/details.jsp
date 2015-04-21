<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'updated'}">The client engagement has been successfully updated!</c:when>
                        <c:when test="${param.msg == 'created'}">The client engagement has been successfully created!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        
        <c:if test="${not empty summary}">
           <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="pull-right">
                        <a href="/clients/details?i=${iparam}&v=${vparam}" class="btn btn-primary btn-xs btn-action" title="View Client Details">View Client Details</a>
                    </div>
                    <h3 class="panel-title">Client Summary</h3>
                </div>
                <div class="panel-body">
                    <div class="row" style="height:25px;">
                        <div class="col-md-4">
                            Patient Id: ${summary.sourcePatientId}<br/>
                        </div>
                    </div>
                 </div>
            </div> 
        </c:if>
        
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Engagement Details</h3>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-4">
                        <p><strong>Referred Date:</strong> <fmt:formatDate value="${engagement.dateCreated}" type="date" pattern="M/dd/yyyy" /></p>
                        <p><strong>Referred Time:</strong> <fmt:formatDate value="${engagement.dateCreated}" type="time" pattern="h:mm a" /></p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Entered By:</strong> ${engagement.enteredBy}</p>
                    </div>
                </div>
             </div>
        </div> 
        

        <form:form id="engagmentdetails" commandName="engagement" method="post" role="form">
            <input type="hidden" id="action" name="action" value="save" />
            <form:hidden path="id" />
            <form:hidden path="dateCreated" />
            <form:hidden path="systemUserId" />
            <form:hidden path="programId" />
            <form:hidden path="programPatientId" />
            <c:forEach items="${sections}" var="section" varStatus="sindex">
                <section class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">${section.sectionName}</h3>
                    </div>
                    <div class="panel-body">
                        <div class="form-container">
                            <div class="form-section row">
                                <div class="col-md-12">
                                    
                                    <c:forEach items="${engagement.engagementFields}" var="fieldDetails" varStatus="field">
                                        <c:if test="${section.id == fieldDetails.sectionId}">
                                            <input type="hidden" name="engagementFields[${field.index}].saveToTableCol" value="${fieldDetails.saveToTableCol}" />
                                            <input type="hidden" name="engagementFields[${field.index}].saveToTableName" value="${fieldDetails.saveToTableName}" />
                                            <input type="hidden" name="engagementFields[${field.index}].fieldId" value="${fieldDetails.fieldId}" />
                                            <c:choose>
                                                <c:when test="${fieldDetails.fieldType == 6}">
                                                    <fmt:parseDate value="${fieldDetails.fieldValue}" var="theDate" pattern="yyyy-MM-dd HH:mm:ss" />
                                                    <input type="hidden" name="engagementFields[${field.index}].currFieldValue" value="<fmt:formatDate value="${theDate}" type="date" pattern="MM/dd/yyyy" />" />
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="engagementFields[${field.index}].currFieldValue" value="${fieldDetails.fieldValue}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" name="engagementFields[${field.index}].fieldType" value="${fieldDetails.fieldType}" />
                                            <c:choose>
                                                <c:when test="${fieldDetails.hideField == true}">
                                                    <input type="hidden" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" />
                                                    
                                                    <c:if test="${section.id == 4 && fieldDetails.saveToTableCol == 'visitType'}">
                                                        <div class="form-section row">
                                                            <div class="col-md-12">
                                                                <div class="col-md-12">
                                                                    <div class="form-group" style="border-bottom: solid 1px #000000">
                                                                        <label class="control-label" >
                                                                            Office Visit
                                                                            <c:if test="${fieldDetails.modified}">
                                                                                <a style="text-decoration:none;" href="#modifiedModal" data-toggle="modal" rel="${fieldDetails.fieldId}" rel2="${engagementId}" class="modified" title="View field modification history">
                                                                                    <span class="glyphicon glyphicon-exclamation-sign" style="padding-left:5px; cursor: pointer;"></span>
                                                                                </a>
                                                                            </c:if>
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                          </div>
                                                          <div class="form-section row">
                                                            <div class="col-md-12">
                                                                <div class="col-md-6">
                                                                    <div class="form-group">
                                                                        <label class="control-label">
                                                                            New Patient
                                                                        </label>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99201 Limited / Minor" <c:if test="${fieldDetails.fieldValue == '99201 Limited / Minor'}">checked="checked"</c:if> /> 99201 Limited / Minor
                                                                          </label>
                                                                       </div>
                                                                       <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99202 Low to Moderate" <c:if test="${fieldDetails.fieldValue == '99202 Low to Moderate'}">checked="checked"</c:if> /> 99202 Low to Moderate
                                                                          </label>
                                                                       </div>
                                                                       <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99203 Moderate" <c:if test="${fieldDetails.fieldValue == '99203 Moderate'}">checked="checked"</c:if> /> 99203 Moderate
                                                                          </label>
                                                                       </div> 
                                                                       <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99204 Moderate to High" <c:if test="${fieldDetails.fieldValue == '99204 Moderate to High'}">checked="checked"</c:if> /> 99204 Moderate to High
                                                                          </label>
                                                                       </div>
                                                                       <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99205 High Complexity" <c:if test="${fieldDetails.fieldValue == '99205 High Complexity'}">checked="checked"</c:if> /> 99205 High Complexity
                                                                          </label>
                                                                       </div>  
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6 cb">
                                                                    <div class="form-group">
                                                                        <label class="control-label">
                                                                            Established Patient
                                                                        </label>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99211 Brief" <c:if test="${fieldDetails.fieldValue == '99211 Brief'}">checked="checked"</c:if> /> 99211 Brief
                                                                          </label>
                                                                        </div>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99212 Minor Complexity" <c:if test="${fieldDetails.fieldValue == '99212 Minor Complexity'}">checked="checked"</c:if> /> 99212 Minor Complexity
                                                                          </label>
                                                                        </div>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99213 Low Complexity" <c:if test="${fieldDetails.fieldValue == '99213 Low Complexity'}">checked="checked"</c:if> /> 99213 Low Complexity
                                                                          </label>
                                                                        </div> 
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99214 Moderate to High" <c:if test="${fieldDetails.fieldValue == '99214 Moderate to High'}">checked="checked"</c:if> /> 99214 Moderate to High
                                                                          </label>
                                                                        </div>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99215 High Complexity" <c:if test="${fieldDetails.fieldValue == '99215 High Complexity'}">checked="checked"</c:if> /> 99215 High Complexity
                                                                          </label>
                                                                        </div>  
                                                                    </div>
                                                                </div>
                                                            </div>
                                                          </div>
                                                          <div class="form-section row" style="padding-top:40px">
                                                            <div class="col-md-12">
                                                                <div class="col-md-6">
                                                                    <div class="form-group" style="border-bottom: solid 1px #000000">
                                                                        <label class="control-label" >
                                                                            Preventive Visit
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <div class="form-group" style="border-bottom: solid 1px #000000">
                                                                        <label class="control-label" >
                                                                            Counseling Visit
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                          </div>
                                                          <div class="form-section row" style="padding-bottom:20px">
                                                            <div class="col-md-12">
                                                                <div class="col-md-6">
                                                                    <div class="col-md-3">
                                                                        <div class="form-group">
                                                                          <label class="control-label">
                                                                              New Patients
                                                                          </label>
                                                                          <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99384 Age 12-17 Years" <c:if test="${fieldDetails.fieldValue == '99384 Age 12-17 Years'}">checked="checked"</c:if> /> 99384 Age 12-17 Years
                                                                            </label>
                                                                         </div>
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99385 Age 18-39 Years" <c:if test="${fieldDetails.fieldValue == '99385 Age 18-39 Years'}">checked="checked"</c:if> /> 99385 Age 18-39 Years
                                                                            </label>
                                                                         </div>
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99386 Age 40-64 Years" <c:if test="${fieldDetails.fieldValue == '99386 Age 40-64 Years'}">checked="checked"</c:if> /> 99386 Age 40-64 Years
                                                                            </label>
                                                                         </div> 
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99387 Age 65+ Years" <c:if test="${fieldDetails.fieldValue == '99387 Age 65+ Years'}">checked="checked"</c:if> /> 99387 Age 65+ Years
                                                                            </label>
                                                                         </div>
                                                                      </div>
                                                                    </div>
                                                                    <div class="col-md-3 cb">
                                                                        <div class="form-group">
                                                                          <label class="control-label">
                                                                              Established Patients
                                                                          </label>
                                                                          <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99394" <c:if test="${fieldDetails.fieldValue == '99394'}">checked="checked"</c:if> /> 99394
                                                                            </label>
                                                                         </div>
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99395" <c:if test="${fieldDetails.fieldValue == '99395'}">checked="checked"</c:if> /> 99395
                                                                            </label>
                                                                         </div>
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99396" <c:if test="${fieldDetails.fieldValue == '99396'}">checked="checked"</c:if> /> 99396
                                                                            </label>
                                                                         </div> 
                                                                         <div class="checkbox">
                                                                            <label>
                                                                                <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99397" <c:if test="${fieldDetails.fieldValue == '99397'}">checked="checked"</c:if> /> 99397
                                                                            </label>
                                                                         </div>
                                                                      </div>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6 cb">
                                                                    <div class="form-group">
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99401 Short" <c:if test="${fieldDetails.fieldValue == '99401 Short'}">checked="checked"</c:if> /> 99401 Short
                                                                          </label>
                                                                        </div>
                                                                        <div class="checkbox">
                                                                          <label>
                                                                              <input type="radio" name="visitType" rel="${fieldDetails.fieldId}" class="visitType" value="99402 Long" <c:if test="${fieldDetails.fieldValue == '99402 Long'}">checked="checked"</c:if> /> 99402 Long
                                                                          </label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                          </div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="col-md-6 ${(field.index mod 2) == 0 ? 'cb' : ''}">
                                                        <div id="fieldDiv_${fieldDetails.fieldId}" class="form-group">
                                                            <div>
                                                                <label class="control-label" for="${fieldDetails.fieldDisplayname}">
                                                                    ${fieldDetails.fieldDisplayname} <c:if test="${fieldDetails.requiredField == true}">&nbsp;*</c:if>
                                                                    <c:if test="${fieldDetails.modified}">
                                                                        <a style="text-decoration:none;" href="#modifiedModal" data-toggle="modal" rel="${fieldDetails.fieldId}" rel2="${engagementId}" class="modified" title="View field modification history">
                                                                            <span class="glyphicon glyphicon-exclamation-sign" style="padding-left:5px; cursor: pointer;"></span>
                                                                        </a>
                                                                    </c:if>
                                                                </label>
                                                            </div>
                                                            <c:choose>
                                                                <%-- Single Text Field --%>
                                                                <c:when test="${fieldDetails.fieldType == 3}">
                                                                    <input type="text" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                                </c:when>
                                                                <%-- Select Field --%>    
                                                                <c:when test="${fieldDetails.fieldType == 2 && fieldDetails.fieldSelectOptions.size() > 0}">
                                                                    <select id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" class="form-control half <c:if test="${fieldDetails.requiredField == true}"> required</c:if>">
                                                                        <option value="">-Choose-</option>
                                                                        <c:forEach items="${fieldDetails.fieldSelectOptions}" var="options">
                                                                            <option value="${options.optionValue}" <c:if test="${fieldDetails.fieldValue == options.optionValue}">selected</c:if>>${options.optionDesc}</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </c:when> 
                                                                <%--Checkbox Field --%>  
                                                                <c:when test="${fieldDetails.fieldType == 8}">
                                                                    <c:choose>
                                                                        <c:when test="${fieldDetails.fieldSelectOptions.size() > 0}">
                                                                            <c:choose>
                                                                                <c:when test="${fieldDetails.fieldSelectOptions.size() > 3}">
                                                                                    <c:forEach items="${fieldDetails.fieldSelectOptions}" var="options" varStatus="oField">
                                                                                        <div class="col-md-6 ${(oField.index mod 2) == 0 ? 'cb' : ''}">
                                                                                           <div class="checkbox">
                                                                                              <label>
                                                                                                  <input type="checkbox" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="${options.optionValue}" <c:if test="${fieldDetails.fieldValue == options.optionValue || fn:contains(fieldDetails.fieldValue,options.optionValue) || fn:contains(fieldDetails.fieldValue,options.optionDesc)}">checked</c:if> class="<c:if test="${fieldDetails.requiredField == true}"> required</c:if>" /> ${options.optionDesc}
                                                                                              </label>
                                                                                           </div>
                                                                                        </div>
                                                                                  </c:forEach>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach items="${fieldDetails.fieldSelectOptions}" var="options" varStatus="oField">
                                                                                        <div class="checkbox">
                                                                                           <label>
                                                                                               <input type="checkbox" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="${options.optionValue}" <c:if test="${fieldDetails.fieldValue == options.optionValue || fn:contains(fieldDetails.fieldValue,options.optionValue) || fn:contains(fieldDetails.fieldValue,options.optionDesc)}">checked</c:if> class="<c:if test="${fieldDetails.requiredField == true}"> required</c:if>" /> ${options.optionDesc}
                                                                                           </label>
                                                                                        </div>
                                                                                  </c:forEach>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="checkbox">
                                                                                <label>
                                                                                    <input type="checkbox" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="1" <c:if test="${fieldDetails.fieldValue == 1}">checked</c:if> class="<c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                                                </label>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose> 
                                                                </c:when> 
                                                                <c:otherwise>
                                                                    <c:choose>
                                                                        <c:when test="${fieldDetails.fieldType == 6}">
                                                                            <input type="text" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="<fmt:formatDate value="${theDate}" type="date" pattern="MM/dd/yyyy" />" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <input type="text" id="${fieldDetails.fieldId}" name="engagementFields[${field.index}].fieldValue" value="${fieldDetails.fieldValue}" class="form-control ${fieldDetails.validationName.replace(' ','-')} <c:if test="${fieldDetails.requiredField == true}"> required</c:if>" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <span id="errorMsg_${fieldDetails.fieldId}" class="control-label">&nbsp;</span>
                                                       </div>
                                                   </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                                 
                                </div>
                            </div>
                           
                        </div>
                    </div>
                </section>
            </c:forEach>
       </form:form>
    </div>
</div>
<!-- Program Entry Method modal -->
<div class="modal fade" id="modifiedModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>



