<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        
         <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'providerupdated'}">The provider has been successfully updated!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        <div class="alert alert-success itemSuccess" style="display:none"></div>
        
        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"></h3>
            </div>
            <div class="panel-body">
                <div class="form-container scrollable" id="hierarchyItemList"></div>
            </div>
        </section>
    </div>
</div>
<!-- Hierarchy Item Edit/Create modal -->
<div class="modal fade" id="itemFormModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>



