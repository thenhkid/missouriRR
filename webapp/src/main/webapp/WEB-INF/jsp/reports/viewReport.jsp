<%-- 
    Document   : viewReport
    Created on : Dec 3, 2015, 9:18:43 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="clearfix">
   <div class="pull-left tableTools-container"></div>
</div>

<table id="reportDisplay" class="display" cellspacing="0" width="100%">
    <thead>
        <tr>
	        <c:if test="${reportId == 34}">
	        <%--- need to get this from db --%>
	            <th>ORGCODE</th>
	            <th>PARTICIP</th>
	            <th>STATE</th>
	            <th>GLUCTEST</th>
	            <th>GDM</th>
	            <th>RISKTEST</th>
	            <th>AGE</th>
	            <th>ETHNIC</th>
	            <th>AIAN</th>
	            <th>ASIAN</th>
	            <th>BLACK</th>
	            <th>NHOPI</th>
	            <th>WHITE</th>
	            <th>SEX</th>
	            <th>HEIGHT</th>
	            <th>DATE</th>
	            <th>WEIGHT</th>
	            <th>PA</th>
	        </c:if>
	        <c:if test="${reportId == 35}">
	            <th>CLASS ID</th>
	            <th>ORGCODE</th>
	            <th>PARTICIP</th>
	            <th>ENTERED BY</th>
	            <th>LOCATION</th>
	            <th>GLUCTEST</th>
	            <th>GDM</th>
	            <th>RISKTEST</th>
	            <th>AGE</th>
	            <th>ETHNIC</th>
	            <th>AIAN</th>
	            <th>ASIAN</th>
	            <th>BLACK</th>
	            <th>NHOPI</th>
	            <th>WHITE</th>
	            <th>SEX</th>
	            <th>HEIGHT</th>
	            <th>DATE</th>
	            <th>WEIGHT</th>
	            <th>PA</th>
	        </c:if>
	        <c:if test="${reportId == 36}">
	            <th>Name</th>
	            <th>Participant Id</th>
	            <th>Starting Weight</th>
	            <th>Weight at last session</th>
	            <th>% + or - : "-X%"</th>
	            <th>Date Weight recorded</th>
	            <th>Weight</th>
	            <th>Average PA Minutes</th>
	            <th>Date PA minutes recorded</th>
	            <th>PA Minutes</th>
	            <th># of sessions attended</th>	            
	        </c:if>
	        
        </tr>
    </thead>
    <tbody>
        ${reportHTML}
    </tbody>
</table>



