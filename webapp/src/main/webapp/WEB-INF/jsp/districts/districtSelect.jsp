<%-- 
    Document   : districtSelect
    Created on : May 7, 2015, 2:14:45 PM
    Created on : May 14, 2015, 10:52:34 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Select Districts for New Survey Entry</h3>
         </div>
         <div class="modal-body">
             <div class="panel-body">
                <div>
                    <c:if test="${not empty countyList}">
                        <form:form id="districtSelectForm" method="POST" action="/surveys/startSurvey" role="form">
                        <input type="hidden" name="s" id="surveyId" value="${surveyId}" />
                        <input type="hidden" name="c" value="0" />
                        <input type="hidden" name="selectedEntities" id="selDistricts" value="" />
                        <div class="form-container">
                            <c:forEach var="county" items="${countyList}">
                                <div class="panel panel-primary" >
                                    <div class="panel-heading">${county.countyName}</div>
                                     <c:if test="${not empty county.districtList}">
                                        <div class="panel-body">
                                            <c:forEach var="district" items="${county.districtList}">
                                                <div class="input-group">
                                                    <span class="input-group-addon">
                                                        <input type="checkbox" class="entitySelect"  value="${district.districtId}"  />
                                                    </span>
                                                    <input type="text" class="form-control" value="${district.districtName}" readonly="true" style="font-weight:bold">
                                               </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach> 
                            <div class="form-group">
                                <input type="button" id="submitDistrictSelect" role="button" class="btn btn-primary" value="Save"/>
                            </div>
                        </div>
                        </form:form>
                    </c:if>
                </div>
            </div>
         </div>
    </div>
</div>
 No newline at end of file

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
