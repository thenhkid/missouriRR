<%-- 
    Document   : searchResults
    Created on : Jun 11, 2015, 12:18:31 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="page-content" style="background-color: #f2f2f2;">
    <div class="row">
        <ul class="list-unstyled spaced2">
            <c:choose>
                <c:when test="${not empty foundEvents}">
                    <c:forEach var="event" items="${foundEvents}">
                        <li>
                            <div class="row">
                                <div class="col-sm-1">
                                    <span class="btn-colorpicker center white" style="background-color:${event.eventColor}; height:15px; width: 15px;"></span>
                                </div>
                                <div class="col-sm-10">
                                    <a style="text-decoration:none" class="loadeventfound" href="javascript:void(0)" start="<fmt:formatDate value="${event.eventStartDate}" type="date" pattern="yyyy-MM-dd" /> " end="<fmt:formatDate value="${event.eventStartDate}" type="date" pattern="yyyy-MM-dd" />">
                                    <strong>${event.eventTitle}</strong>
                                    <br />
                                    <c:choose>
                                        <c:when test="${event.eventStartDate == event.eventEndDate}">
                                            <fmt:formatDate value="${event.eventStartDate}" type="date" pattern="E, MMM dd, yyyy" /> 
                                            <br />
                                            ${event.eventStartTime} to ${event.eventEndTime}
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${event.eventStartDate}" type="date" pattern="E, MMM dd, yyyy" /> ${event.eventStartTime}
                                        to <fmt:formatDate value="${event.eventEndDate}" type="date" pattern="E, MMM dd, yyyy" /> ${event.eventEndTime}
                                        </c:otherwise>
                                    </c:choose>
                                    </a>   
                                </div>
                            </div>
                        </li>
                        <li style="border-bottom: 1px dotted #000"></li>
                    </c:forEach> 
                </c:when>
                <c:otherwise>
                    <li class="center"><strong>No Results</strong></li>
               </c:otherwise>
            </c:choose>
        </ul>
    </div>
</div>
