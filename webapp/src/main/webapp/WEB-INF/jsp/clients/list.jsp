<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>


<div class="main clearfix full-width" role="main">
    <div class="col-md-12">
        <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'updated'}">The client has been successfully updated!</c:when>
                        <c:when test="${param.msg == 'created'}">The client has been successfully added!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        
        <c:if test="${not empty searchFields}">
           <section class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Client Search</h3>
                </div>
                <div class="panel-body">
                    <form id="searchForm" action="" method="get">
                        <input type="hidden" id="fieldList" value="<c:forEach items="${searchFields}" var="searchField" varStatus="field">${searchField.fieldId}:</c:forEach>" />
                        <div class="form-container">
                            <c:forEach items="${searchFields}" var="searchField" varStatus="field">
                                <div class="col-md-6 ${(field.index mod 2) == 0 ? 'cb' : ''}">
                                    <div class="form-group">
                                        <div>
                                            <label class="control-label" for="${searchField.fieldId}">${searchField.fieldName}</label>
                                            <c:choose>
                                                <c:when test="${searchField.fieldSelectOptions.size() > 0}">
                                                    <select id="${searchField.fieldId}" rel="${searchField.saveToTableCol}" class="form-control half">
                                                        <option value="">-Choose-</option>
                                                        <c:forEach items="${searchField.fieldSelectOptions}" var="options">
                                                            <option value="${options.optionValue}" <c:if test="${searchField.fieldVal == options.optionValue}">selected</c:if>>${options.optionDesc}</option>
                                                        </c:forEach>
                                                    </select>
                                                </c:when>
                                                <c:otherwise>
                                                    <input id="${searchField.fieldId}" rel="${searchField.saveToTableCol}" value="${searchField.fieldVal}" class="form-control" type="text">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <div class="col-md-12" style="clear:both;">
                              <input type="button" id="submitButton" role="button" class="btn btn-primary" value="Search"/>
                              <input type="button" id="clearButton" role="button" class="btn btn-primary" value="Clear"/>
                           </div>
                        </div>
                    </form>
                </div>
            </section> 
        </c:if>
        

        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Clients</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable" id="clientList"></div>
            </div>
        </section>
    </div>
</div>
<!-- Client number modal -->
<div class="modal fade" id="newClientNumber" role="dialog" tabindex="-1" aria-labeledby="Enter New Client Number" aria-hidden="true" aria-describedby="Enter New Client Number"></div>



