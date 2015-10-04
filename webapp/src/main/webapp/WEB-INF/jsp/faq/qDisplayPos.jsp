<%-- 
    Document   : qdisplayPos
    Created on : Jun 14, 2015, 4:33:33 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="form-group" id="displayPosDiv">
    <label for="timeFrom">Display Position</label>
    <form:select path="displayPos" class="form-control" name="displayPos" id="displayPos">
        <c:forEach  var="displayPosition" begin="1" end="${maxPos}" >
            <option value="${displayPosition}" <c:if test="${displayPosition == displayPos}"> selected </c:if>>${displayPosition}</option>
        </c:forEach>
    </form:select>
</div> 