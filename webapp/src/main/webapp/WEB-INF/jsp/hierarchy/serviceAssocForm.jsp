<%-- 
    Document   : hierarchyAssocForm
    Created on : Dec 30, 2014, 11:59:10 AM
    Author     : chadmccue
--%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Available Services</h3>
        </div>
        <div class="modal-body">
            <form id="assocItemForm" method="post" role="form">
                <input type="hidden" name="providerId" id="providerId" value="${providerId}" />
                <div class="form-container">
                     <div id="serviceDiv" class="form-group ${status.error ? 'has-error' : '' }">
                        <label class="control-label" for="item">Service</label>
                        
                        <c:choose>
                            <c:when test="${not empty availableServices}">
                                <select name="selItems" id="selItems" class="form-control" multiple="true">
                                    <c:forEach items="${availableServices}" var="service">
                                        <option value="${service.id}">${service.serviceName}</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <p>There are no available services to select</p>
                            </c:otherwise>
                        </c:choose>
                        <span id="serviceMsg" class="control-label" ></span>            
                    </div>
                </div>
                <c:if test="${not empty availableServices}">
                    <div class="form-group">
                        <input type="button" id="submitServiceAssoc" role="button" class="btn btn-primary" value="Save"/>
                    </div>  
                </c:if>
            </form>
        </div>
    </div>
</div>
