<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
 <%-- this needs to be rewritten so that it is more efficient and reuses more codes --%>
 <%--  need to make all actually select all --%>

<select name="selectedCodes" class="multiselect form-control" id="codeIds" multiple="">
<c:forEach items="${codeList}" var="code">
	<option value="${code.id}">${code.code}:${code.codeDesc}</option>
</c:forEach>        
</select>
<div id="errorMsg_codes" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                    
                               