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
                <c:when test="${not empty foundMessages}">
                    <c:forEach var="message" items="${foundMessages}">
                        <li>
                            <div class="row">
                                <div class="col-sm-10">
                                    <a href="/forum/${message.topicURL}">${message.topicTitle}</a>
                                    <br />
                                    ${message.message}
                                    <br />
                                    by ${message.postedBy} &Gt; <fmt:formatDate value="${message.dateCreated}" type="both" pattern="E MMM dd, yyyy h:mm a" />
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
