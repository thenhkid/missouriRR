<%-- 
    Document   : districtSelect
    Created on : May 7, 2015, 2:14:45 PM
    Created on : May 14, 2015, 10:52:34 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<select name="selectedEntities" class="multiselect" multiple="">
    <c:forEach var="county" items="${countyList}">
        <optgroup label="${county.countyName}">
            <c:forEach var="district" items="${county.districtList}">
                <option value="${district.districtId}">${district.districtName}</option>
            </c:forEach>
        </optgroup>
    </c:forEach>
</select>
