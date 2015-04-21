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
            <h3 class="panel-title">Select ${assocHierarchyName}</h3>
        </div>
        <div class="modal-body">
            <form id="assocItemForm" method="post" role="form">
                <div class="form-container">
                     <div class="form-group ${status.error ? 'has-error' : '' }">
                        <label class="control-label" for="item">${assocHierarchyName}</label>
                        
                        <c:choose>
                            <c:when test="${not empty availableItems}">
                                <select name="selItems" id="selItems" class="form-control" multiple="true">
                                    <c:forEach items="${availableItems}" var="item">
                                        <option value="${item.id}">${item.name}</option>
                                    </c:forEach>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <p>There are no available ${assocHierarchyName} to select</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty availableItems}">
                    <div class="form-group">
                        <input type="button" id="submitItemAssoc" role="button" class="btn btn-primary" value="Save"/>
                    </div>  
                </c:if>
            </form>
        </div>
    </div>
</div>
