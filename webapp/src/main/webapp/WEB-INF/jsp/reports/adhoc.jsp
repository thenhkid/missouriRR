<%-- 
    Document   : adhock
    Created on : Mar 10, 2015, 8:58:09 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
         <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Generate A Report</h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable" id="clientList">
                    <c:forEach var="hierarchy" items="${orgHierarchyList}">
                        <div class="form-group ${status.error ? 'has-error' : '' }">
                            <label class="control-label" for="state">${hierarchy.name}</label>
                            <select id="hierarchyItem" class="form-control half">
                                <option value="0">- All - </option>
                                <c:forEach var="details" items="${hierarchy.programHierarchyDetails}" >
                                    <option value="${details.id}">${details.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
    </div>
</div>
