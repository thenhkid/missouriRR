<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${fn:length(codeList) > 0}">
<select name="selectedCodes" class="multiselect form-control" id="codeIds" multiple="">
<c:forEach items="${codeList}" var="code">
	<option value="${code.id}">${code.code}:${code.codeDesc}</option>
</c:forEach>        
</select>
<div id="errorMsg_codes" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
 </c:if>
<c:if test="${fn:length(codeList) < 1}">
There are no reports fitting the above criteria.  Please change your selections.
</c:if>
