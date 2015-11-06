<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
 <%-- this needs to be rewritten so that it is more efficient and reuses more codes --%>
 <%--  need to make all actually select all --%>
 <select name="selected${tier}Entities" class="multiselect form-control" id="entity${tier}Ids" multiple="">
        <c:forEach items="${entityList}" var="entity">
        <option value="${entity.id}">${entity.name}</option>
        </c:forEach>            
</select>
<div id="errorMsg_entity${tier}" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>